import 'package:flutter_test/flutter_test.dart';

import 'package:risuem_s/main.dart';

void main() {
  testWidgets('Старт на экране рисования с заголовком и кнопкой загрузки', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Раскрасим'), findsOneWidget);
    expect(find.text('Загрузить картинку'), findsOneWidget);
    expect(find.byTooltip('Настройки'), findsOneWidget);
    expect(find.text('Цвет'), findsOneWidget);
  });
}
