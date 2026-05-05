import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// По байтам фото строит PNG: чёрные контуры по рёбрам, фон прозрачный.
/// Подходит для раскраски поверх белого холста.
///
/// Пайплайн: Gaussian (лёгкий), собственный Sobel (Gx, Gy),
/// **NMS по 4 октантам**, гистерезис (в т.ч. подмога по полному градиенту mag,
/// ортогональная заделка разрывов, удаление только совсем крошечных областей шума.
Uint8List? buildOutlineColoringPng(Uint8List rawBytes, {int maxSide = 1152}) {
  final decoded = img.decodeImage(rawBytes);
  if (decoded == null) return null;

  var src = img.bakeOrientation(decoded);
  final frame = src.frames.isNotEmpty ? src.frames.first : src;

  var work = img.Image.from(frame, noAnimation: true);
  final w0 = work.width;
  final h0 = work.height;
  if (math.max(w0, h0) > maxSide) {
    final scale = maxSide / math.max(w0, h0);
    work = img.copyResize(
      work,
      width: (w0 * scale).round(),
      height: (h0 * scale).round(),
      interpolation: img.Interpolation.linear,
    );
  }

  work = work.convert(numChannels: 4);
  img.grayscale(work);
  // Слишком сильное размытие размазывает границы объекта — ослабляем, чтобы
  // основной контур не «проседал» по градиенту.
  img.gaussianBlur(work, radius: 1);

  final w = work.width;
  final h = work.height;
  final nPix = w * h;
  if (nPix == 0) return null;

  final gx = Float32List(nPix);
  final gy = Float32List(nPix);
  final mag = Float32List(nPix);

  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final i = y * w + x;
      if (x < 1 || x >= w - 1 || y < 1 || y >= h - 1) {
        continue;
      }
      final gxv = _sobelGxLum(work, x, y);
      final gyv = _sobelGyLum(work, x, y);
      gx[i] = gxv;
      gy[i] = gyv;
      mag[i] = math.sqrt(gxv * gxv + gyv * gyv);
    }
  }

  final nms = _nonMaxSuppression(w, h, mag, gx, gy);

  final sortedMag = List<double>.from(mag)..sort();
  final n = sortedMag.length;
  // Ниже перцентили — больше реальных рёбер; «подмога» по mag добирает участки,
  // где NMS обнулил ответ, но градиент по Sobel всё ещё заметный.
  var tHigh = sortedMag[(n * 0.772).floor().clamp(0, n - 1)];
  var tLow = sortedMag[(n * 0.43).floor().clamp(0, n - 1)];
  tHigh = tHigh.clamp(0.032, 0.56).toDouble();
  tLow = tLow.clamp(0.018, 0.46).toDouble();
  if (tLow >= tHigh * 0.88) {
    tLow = (tHigh * 0.45).clamp(0.02, tHigh * 0.88).toDouble();
  }

  final strong = Uint8List(nPix);
  final weak = Uint8List(nPix);
  var anyStrong = false;
  final assistFloor = (tLow * 0.32).clamp(0.01, tLow * 0.88);
  final magAssistMin = tLow * 0.84;
  for (var i = 0; i < nPix; i++) {
    final mn = nms[i];
    final mg = mag[i];
    if (mn >= tHigh) {
      strong[i] = 1;
      anyStrong = true;
    } else if (mn >= tLow || (mg >= magAssistMin && mn >= assistFloor)) {
      weak[i] = 1;
    }
  }

  final keep = Uint8List(nPix);
  final q = Queue<int>();

  if (anyStrong) {
    for (var i = 0; i < nPix; i++) {
      if (strong[i] == 1) {
        keep[i] = 1;
        q.add(i);
      }
    }
    while (q.isNotEmpty) {
      final i = q.removeFirst();
      final x = i % w;
      final y = i ~/ w;
      for (var dy = -1; dy <= 1; dy++) {
        final ny = y + dy;
        if (ny < 0 || ny >= h) continue;
        for (var dx = -1; dx <= 1; dx++) {
          if (dx == 0 && dy == 0) continue;
          final nx = x + dx;
          if (nx < 0 || nx >= w) continue;
          final j = ny * w + nx;
          if (weak[j] == 1 && keep[j] == 0) {
            keep[j] = 1;
            q.add(j);
          }
        }
      }
    }
  } else {
    final fb = sortedMag[(n * 0.755).floor().clamp(0, n - 1)].clamp(0.032, 0.48);
    for (var i = 0; i < nPix; i++) {
      if (nms[i] >= fb || mag[i] >= fb * 1.02) keep[i] = 1;
    }
  }

  final out = img.Image(width: w, height: h, numChannels: 4);
  for (var i = 0; i < nPix; i++) {
    final x = i % w;
    final y = i ~/ w;
    if (keep[i] == 1) {
      out.setPixelRgba(x, y, 0, 0, 0, 255);
    } else {
      out.setPixelRgba(x, y, 0, 0, 0, 0);
    }
  }

  _bridgeSinglePixelGaps(out, w, h, nms, gx, gy, tLow);

  // Ниже порог и мягче рост с размером кадра — сохраняем мелкие штрихи и точки.
  final minBlob = math.max(3, (nPix ~/ 22000)).clamp(3, 48);
  _removeSmallConnectedComponents(out, minBlob);

  return img.encodePng(out);
}

double _lum(img.Image im, int x, int y) {
  final cx = x.clamp(0, im.width - 1);
  final cy = y.clamp(0, im.height - 1);
  return im.getPixel(cx, cy).luminanceNormalized.toDouble();
}

double _sobelGxLum(img.Image im, int x, int y) {
  return -_lum(im, x - 1, y - 1) +
      _lum(im, x + 1, y - 1) -
      2 * _lum(im, x - 1, y) +
      2 * _lum(im, x + 1, y) -
      _lum(im, x - 1, y + 1) +
      _lum(im, x + 1, y + 1);
}

double _sobelGyLum(img.Image im, int x, int y) {
  return -_lum(im, x - 1, y - 1) -
      2 * _lum(im, x, y - 1) -
      _lum(im, x + 1, y - 1) +
      _lum(im, x - 1, y + 1) +
      2 * _lum(im, x, y + 1) +
      _lum(im, x + 1, y + 1);
}

/// Локальные максимумы вдоль **аппроксимированного** направления градиента
/// (4 октанта, как в классическом Canny) — учитываются диагонали, иначе часть
/// основных рёбер пропадала.
Float32List _nonMaxSuppression(
  int w,
  int h,
  Float32List mag,
  Float32List gx,
  Float32List gy,
) {
  final out = Float32List(mag.length);
  for (var y = 1; y < h - 1; y++) {
    for (var x = 1; x < w - 1; x++) {
      final i = y * w + x;
      final m = mag[i];
      if (m <= 0) continue;

      final gxv = gx[i];
      final gyv = gy[i];
      double q;
      double r;

      var theta = math.atan2(gyv, gxv);
      if (theta < 0) theta += math.pi;
      final tDeg = theta * 180 / math.pi;

      if (tDeg < 22.5 || tDeg >= 157.5) {
        q = mag[i - 1];
        r = mag[i + 1];
      } else if (tDeg < 67.5) {
        q = mag[i + w + 1];
        r = mag[i - w - 1];
      } else if (tDeg < 112.5) {
        q = mag[i + w];
        r = mag[i - w];
      } else {
        q = mag[i + w - 1];
        r = mag[i - w + 1];
      }

      // Лёгкая толерантность — при почти равных соседях ребро не пропадает из‑за float.
      // Чуть мягче на плато — тонкие изогнутые линии не пропадают из‑за float.
      const eps = 3e-5;
      if (m + eps >= q && m + eps >= r) {
        out[i] = m;
      }
    }
  }
  return out;
}

/// Ортогональная заделка 1px: только горизонталь или вертикаль, без диагоналей.
/// Проверка |Gy| vs |Gx| отсекает типичный случай двух близких вертикальных
/// штрихов (между ними ложное «горизонтальное» замыкание).
void _bridgeSinglePixelGaps(
  img.Image out,
  int w,
  int h,
  Float32List nms,
  Float32List gx,
  Float32List gy,
  double tLow,
) {
  final floor = (tLow * 0.58).clamp(0.012, tLow);

  bool blk(int x, int y) => out.getPixel(x, y).a > 128;

  for (var iter = 0; iter < 3; iter++) {
    final coords = <({int x, int y})>[];
    for (var y = 1; y < h - 1; y++) {
      for (var x = 1; x < w - 1; x++) {
        if (blk(x, y)) continue;
        final i = y * w + x;
        final nc = nms[i];
        final gxc = gx[i];
        final gyc = gy[i];

        final l = blk(x - 1, y);
        final r = blk(x + 1, y);
        final t = blk(x, y - 1);
        final b = blk(x, y + 1);

        if (l && r) {
          final nl = nms[i - 1];
          final nr = nms[i + 1];
          final nMin = math.min(nl, nr);
          if (nc >= floor &&
              nc >= 0.22 * nMin &&
              gyc.abs() >= gxc.abs() * 0.58) {
            coords.add((x: x, y: y));
            continue;
          }
        }

        if (t && b) {
          final nt = nms[i - w];
          final nb = nms[i + w];
          final nMin = math.min(nt, nb);
          if (nc >= floor &&
              nc >= 0.22 * nMin &&
              gxc.abs() >= gyc.abs() * 0.58) {
            coords.add((x: x, y: y));
          }
        }
      }
    }
    if (coords.isEmpty) break;
    for (final p in coords) {
      out.setPixelRgba(p.x, p.y, 0, 0, 0, 255);
    }
  }
}

/// Удаляет связные компоненты чёрного контура с площадью меньше [minArea].
void _removeSmallConnectedComponents(img.Image out, int minArea) {
  final w = out.width;
  final h = out.height;
  final n = w * h;
  final fg = Uint8List(n);
  for (var i = 0; i < n; i++) {
    final x = i % w;
    final y = i ~/ w;
    fg[i] = out.getPixel(x, y).a > 128 ? 1 : 0;
  }

  final visited = Uint8List(n);
  final q = Queue<int>();
  final component = <int>[];

  for (var start = 0; start < n; start++) {
    if (fg[start] == 0 || visited[start] == 1) continue;

    component.clear();
    q.clear();
    visited[start] = 1;
    q.add(start);
    component.add(start);

    while (q.isNotEmpty) {
      final i = q.removeFirst();
      final x = i % w;
      final y = i ~/ w;
      for (var dy = -1; dy <= 1; dy++) {
        final ny = y + dy;
        if (ny < 0 || ny >= h) continue;
        for (var dx = -1; dx <= 1; dx++) {
          if (dx == 0 && dy == 0) continue;
          final nx = x + dx;
          if (nx < 0 || nx >= w) continue;
          final j = ny * w + nx;
          if (fg[j] == 0 || visited[j] == 1) continue;
          visited[j] = 1;
          q.add(j);
          component.add(j);
        }
      }
    }

    if (component.length < minArea) {
      for (final i in component) {
        final x = i % w;
        final y = i ~/ w;
        out.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
}
