bool get isLinuxHost => false;

/// Заглушка для web (нет dart:io).
class LinuxShellTts {
  Future<bool> speak(String text, {void Function()? onComplete}) async {
    onComplete?.call();
    return false;
  }

  Future<void> stop() async {}
}
