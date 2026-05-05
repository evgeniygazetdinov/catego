#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Скрипт не читает ~/.bashrc — без этого flutter/gradle не видят SDK.
# Flutter сначала смотрит `flutter config --android-sdk`; если там неверный путь,
# ANDROID_HOME из окружения игнорируется — поэтому ниже вызываем flutter config.
_default_sdk="${HOME}/Android/Sdk"
if [ -z "${ANDROID_HOME:-}" ]; then
    if [ -d "${_default_sdk}/platform-tools" ] || [ -d "${_default_sdk}/licenses" ]; then
        export ANDROID_HOME="${_default_sdk}"
        export ANDROID_SDK_ROOT="$ANDROID_HOME"
    fi
fi


# Системный adb из /usr/bin (пакет Ubuntu → /usr/lib/android-sdk) часто раньше в PATH.
# Flutter ищет SDK через `which adb` — без этого берётся «пустой» /usr/lib, хотя ANDROID_HOME верный.
if [ -n "${ANDROID_HOME:-}" ]; then
    _prepend=""
    [ -d "${ANDROID_HOME}/cmdline-tools/latest/bin" ] && _prepend="${ANDROID_HOME}/cmdline-tools/latest/bin:${_prepend}"
    [ -d "${ANDROID_HOME}/platform-tools" ] && _prepend="${ANDROID_HOME}/platform-tools:${_prepend}"
    if [ -n "${_prepend}" ]; then
        export PATH="${_prepend}${PATH}"
    fi
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANDROID_LOCAL_PROPS="${ROOT_DIR}/android/local.properties"
# Gradle читает sdk.dir из local.properties — убрать типичный /usr/lib/android-sdk.
_sdk_for_props="${ANDROID_HOME:-}"
if [ -z "${_sdk_for_props}" ] && [ -d "${_default_sdk}" ]; then
    _sdk_for_props="${_default_sdk}"
fi
if [ -n "${_sdk_for_props}" ] && [ -f "$ANDROID_LOCAL_PROPS" ]; then
    if grep -q '^sdk.dir=' "$ANDROID_LOCAL_PROPS"; then
        sed -i "s|^sdk.dir=.*|sdk.dir=${_sdk_for_props}|" "$ANDROID_LOCAL_PROPS"
    else
        printf '\nsdk.dir=%s\n' "$_sdk_for_props" >> "$ANDROID_LOCAL_PROPS"
    fi
fi

if [ -d "${_default_sdk}" ] && [ ! -d "${_default_sdk}/platform-tools" ] && [ ! -d "${_default_sdk}/licenses" ]; then
    echo -e "${YELLOW}Внимание:${NC} в ${_default_sdk} нет ни platform-tools, ни licenses."
    echo -e "Flutter тогда ${YELLOW}не считает${NC} этот каталог SDK, берёт adb из PATH и показывает /usr/lib/android-sdk."
    echo -e "Установите компоненты:\n"
    echo -e "  \"${_default_sdk}/cmdline-tools/latest/bin/sdkmanager\" \"platform-tools\" \"platforms;android-35\" \"build-tools;35.0.0\""
    echo -e "  yes | \"${_default_sdk}/cmdline-tools/latest/bin/sdkmanager\" --licenses\n"
fi

echo -e "${YELLOW}Начинаем установку приложения для тренировки устного счета...${NC}\n"
if [ -n "${ANDROID_HOME:-}" ]; then
    echo -e "Android SDK: ${GREEN}${ANDROID_HOME}${NC}\n"
fi

# Проверка наличия Flutter
echo -e "Проверка Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "Flutter не установлен! Пожалуйста, установите Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

if [ -n "${ANDROID_HOME:-}" ]; then
    flutter config --android-sdk "$ANDROID_HOME" >/dev/null
fi

# Проверка зависимостей Flutter
echo -e "\n${YELLOW}Проверка зависимостей Flutter...${NC}"
flutter doctor

# Очистка проекта
echo -e "\n${YELLOW}Очистка проекта...${NC}"
flutter clean

# Получение зависимостей
echo -e "\n${YELLOW}Установка зависимостей...${NC}"
flutter pub get

# Проверка на ошибки
echo -e "\n${YELLOW}Проверка на ошибки...${NC}"
flutter analyze

# Сборка APK
echo -e "\n${YELLOW}Сборка APK...${NC}"
flutter build apk

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}Установка успешно завершена!${NC}"
    echo -e "\nДля запуска приложения выполните:"
    echo -e "${YELLOW}flutter run${NC}"
    echo -e "\nAPK файл доступен по пути:"
    echo -e "${YELLOW}build/app/outputs/flutter-apk/app-release.apk${NC}"
else
    echo -e "\nПроизошла ошибка при сборке. Пожалуйста, проверьте логи выше."
fi