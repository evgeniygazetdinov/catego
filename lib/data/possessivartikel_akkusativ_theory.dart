/// Теория: Possessivartikel im Akkusativ (A1 / Start Deutsch 1).
class PossessivartikelAkkTheorySection {
  const PossessivartikelAkkTheorySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

const List<PossessivartikelAkkTheorySection> kPossessivartikelAkkTheorySections = [
  PossessivartikelAkkTheorySection(
    title: '1. Что такое Possessivartikel?',
    body:
        'Отвечают на Wessen? (чей, чья, чьё, чьи) и показывают принадлежность.\n\n'
        'В русском: мой, твой, его, её, наш, ваш, их, Ваш.',
  ),
  PossessivartikelAkkTheorySection(
    title: '2. Основа (Nominativ) — владелец',
    body:
        'ich → mein/meine\tdu → dein/deine\ter/es → sein/seine\n'
        'sie (f) → ihr/ihre\twir → unser/unsere\tihr → euer/eure\n'
        'sie (pl) → ihr/ihre\tSie → Ihr/Ihre\n\n'
        'euer → eure (e выпадает). Ihr (к Вам) всегда с большой буквы.',
  ),
  PossessivartikelAkkTheorySection(
    title: '3. Правило Akkusativ',
    body:
        'Только мужской род (der → den): окончание -en.\n'
        'mein Vater → meinen Vater\n\n'
        'Женский, средний и мн.ч. в Akkusativ как в Nominativ:\n'
        'meine Mutter, mein Kind, meine Kinder',
  ),
  PossessivartikelAkkTheorySection(
    title: '4. Таблица Akkusativ (кратко)',
    body:
        '\tMask.\tFem.\tNeut.\tPl.\n'
        'ich\tmeinen\tmeine\tmein\tmeine\n'
        'du\tdeinen\tdeine\tdein\tdeine\n'
        'er/es\tseinen\tseine\tsein\tseine\n'
        'sie (f)\tihren\tihre\tihr\tihre\n'
        'wir\tunseren\tunsere\tunser\tunsere\n'
        'ihr\teuren\teure\teuer\teure\n'
        'sie (pl)\tihren\tihre\tihr\tihre\n'
        'Sie\tIhren\tIhre\tIhr\tIhre',
  ),
  PossessivartikelAkkTheorySection(
    title: '5. Сравнение с артиклем',
    body:
        'meinen ≈ den / einen\tmeine ≈ die / eine\n'
        'mein ≈ das / ein\tmeine (pl.) ≈ die / keine',
  ),
  PossessivartikelAkkTheorySection(
    title: '6. Типичные ошибки A1',
    body:
        '❌ mein Vater  ✅ meinen Vater (m.)\n'
        '❌ meinen Mutter  ✅ meine Mutter (f.)\n'
        '❌ eueren Lehrer  ✅ euren Lehrer',
  ),
  PossessivartikelAkkTheorySection(
    title: '7. Итоговая шкала (150 вопросов)',
    body:
        '140–150\t⭐⭐⭐ Эксперт A1!\n'
        '130–139\t⭐⭐ Отлично!\n'
        '120–129\t⭐ Хорошо. Повторите мужской род (-en).\n'
        '105–119\t⚠️ Средне.\n'
        '90–104\t🔄 Нужно повторить.\n'
        'Меньше 90\t📖 Начните заново.',
  ),
  PossessivartikelAkkTheorySection(
    title: '8. Шпаргалка и Dativ (взгляд вперёд)',
    body:
        'Mask. Akk.: …en\tFem./Neut./Pl.: как в Nom.\n\n'
        'Dativ (кратко): meinem, meiner, meinem, meinen (+n)',
  ),
];
