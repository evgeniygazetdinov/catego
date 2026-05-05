/// Теория: Possessivartikel im Nominativ (A1 / Start Deutsch 1).
class PossessivartikelNomTheorySection {
  const PossessivartikelNomTheorySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

const List<PossessivartikelNomTheorySection> kPossessivartikelNomTheorySections = [
  PossessivartikelNomTheorySection(
    title: '1. Что такое Possessivartikel?',
    body:
        'Отвечают на Wessen? (чей, чья, чьё, чьи) и показывают принадлежность.\n\n'
        'В Nominativ стоят перед существительным в роли подлежащего и заменяют артикль.',
  ),
  PossessivartikelNomTheorySection(
    title: '2. Таблица (Nominativ)',
    body:
        '\tMask.\tFem.\tNeut.\tPl.\n'
        'ich\tmein\tmeine\tmein\tmeine\n'
        'du\tdein\tdeine\tdein\tdeine\n'
        'er/es\tsein\tseine\tsein\tseine\n'
        'sie (f)\tihr\tihre\tihr\tihre\n'
        'wir\tunser\tunsere\tunser\tunsere\n'
        'ihr\teuer\teure\teuer\teure\n'
        'sie (pl)\tihr\tihre\tihr\tihre\n'
        'Sie\tIhr\tIhre\tIhr\tIhre\n\n'
        'euer → eure. Ihr (к Вам) с большой буквы. sein для er и es.',
  ),
  PossessivartikelNomTheorySection(
    title: '3. Главное правило',
    body:
        'Мужской (der) и средний (das): без -e (mein Vater, mein Kind).\n'
        'Женский (die) и мн.ч. (die): с -e (meine Mutter, meine Eltern).',
  ),
  PossessivartikelNomTheorySection(
    title: '4. Сравнение с ein / eine',
    body:
        'mein ≈ ein\tmeine ≈ eine (жен. и мн.ч.)\n'
        'Как у неопределённого артикля по окончанию.',
  ),
  PossessivartikelNomTheorySection(
    title: '5. Порядок слов',
    body:
        'Possessivartikel + Subjekt + Verb …\n'
        'Mein Hund schläft.\tDeine Mutter ist schön.',
  ),
  PossessivartikelNomTheorySection(
    title: '6. Типичные ошибки A1',
    body:
        '❌ mein Mutter  ✅ meine Mutter\n'
        '❌ deine Vater  ✅ dein Vater\n'
        '❌ seine Kind  ✅ sein Kind\n'
        '❌ eure Haus  ✅ euer Haus\n'
        '❌ ihr Eltern  ✅ ihre Eltern',
  ),
  PossessivartikelNomTheorySection(
    title: '7. Омоним ihr',
    body:
        'Ihr kommt. — вы (личное местоимение).\n'
        'Ihr Buch ist neu. — её книга (притяжательное).\n'
        'Контекст решает.',
  ),
  PossessivartikelNomTheorySection(
    title: '8. Итоговая шкала (150 вопросов)',
    body:
        '140–150\t⭐⭐⭐ Эксперт A1!\n'
        '130–139\t⭐⭐ Отлично!\n'
        '120–129\t⭐ Хорошо. Повторите женский род и мн.ч. (+e).\n'
        '105–119\t⚠️ Средне.\n'
        '90–104\t🔄 Нужно повторить.\n'
        'Меньше 90\t📖 Начните заново.',
  ),
  PossessivartikelNomTheorySection(
    title: '9. Шпаргалка',
    body:
        'ich→mein/meine, du→dein/deine, er/es→sein/seine, sie→ihr/ihre\n'
        'wir→unser/unsere, ihr→euer/eure, sie(pl)→ihr/ihre, Sie→Ihr/Ihre',
  ),
];
