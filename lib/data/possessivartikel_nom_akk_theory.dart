/// Теория: Possessivartikel Nominativ vs. Akkusativ (A1 / Start Deutsch 1).
class PossessivartikelNomAkkTheorySection {
  const PossessivartikelNomAkkTheorySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

const List<PossessivartikelNomAkkTheorySection> kPossessivartikelNomAkkTheorySections = [
  PossessivartikelNomAkkTheorySection(
    title: '1. Что нужно знать?',
    body:
        'Nominativ (Wer?/Was?) — подлежащее.\n'
        'Akkusativ (Wen?/Was?) — прямое дополнение.\n\n'
        'Possessivartikel меняются вместе с падежом.',
  ),
  PossessivartikelNomAkkTheorySection(
    title: '2. Таблица: Nom. vs. Akk. (ich)',
    body:
        '\tMask.\tFem.\tNeut.\tPl.\n'
        'Nom.\tmein\tmeine\tmein\tmeine\n'
        'Akk.\tmeinen\tmeine\tmein\tmeine\n\n'
        'То же правило для dein, sein, ihr, unser, euer, ihr (они), Ihr.',
  ),
  PossessivartikelNomAkkTheorySection(
    title: '3. Главное правило',
    body:
        'Только мужской род (der) в Akkusativ: -en (meinen Vater).\n'
        'Женский, средний, мн.ч.: в Akk. как в Nom.',
  ),
  PossessivartikelNomAkkTheorySection(
    title: '4. Как определить падеж?',
    body:
        'Подлежащее → Nom. (Mein Hund schläft.)\n'
        'После sehen, lieben, haben, kaufen … → Akk. (Ich sehe meinen Hund.)\n'
        'После für, durch, ohne, gegen, um → Akk.',
  ),
  PossessivartikelNomAkkTheorySection(
    title: '5. Типичные ошибки',
    body:
        '❌ Ich sehe mein Vater.  ✅ meinen (m. Akk.)\n'
        '❌ Meinen Mutter ist nett.  ✅ Meine (f. Nom.)\n'
        '❌ Deinen Bruder kommt.  ✅ Dein (m. Nom.)',
  ),
  PossessivartikelNomAkkTheorySection(
    title: '6. Итоговая шкала (150 вопросов)',
    body:
        '140–150\t⭐⭐⭐ Отлично различаете Nom. и Akk.\n'
        '120–129\t⭐ Повторите -en в Akk. (муж. род).\n'
        'Меньше 90\t📖 Теория заново.',
  ),
  PossessivartikelNomAkkTheorySection(
    title: '7. Шпаргалка',
    body:
        'NOM: mein/meine (m+f/n+pl по правилу +e)\n'
        'AKK: meinen (только m.) · остальное как в Nom.',
  ),
];
