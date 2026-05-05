/// Теория: bestimmte Artikel im Nominativ (der, die, das) — A1.
class DerDieDasTheorySection {
  const DerDieDasTheorySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

const List<DerDieDasTheorySection> kDerDieDasTheorySections = [
  DerDieDasTheorySection(
    title: '1. Зачем нужен артикль?',
    body:
        'В немецком почти каждое существительное пишется с артиклем. Артикль показывает '
        'род слова (Genus) и число; определённый артикль (der, die, das, die) указывает '
        'на конкретный предмет или известный контекст.\n\n'
        'Учите слова сразу с артиклем: не «Tisch», а «der Tisch».',
  ),
  DerDieDasTheorySection(
    title: '2. Таблица: Nominativ (Wer? Was?)',
    body:
        'Род\tАртикль\tПримеры\n'
        'Мужской (maskulin)\tder\tder Mann, der Tisch, der Tag\n'
        'Женский (feminin)\tdie\tdie Frau, die Lampe, die Tür\n'
        'Средний (neutral)\tdas\tdas Kind, das Buch, das Fenster\n'
        'Множественное число\tdie\tdie Kinder, die Bücher\n\n'
        'Во мн. ч. всегда die — независимо от рода в ед. числе.',
  ),
  DerDieDasTheorySection(
    title: '3. Как угадать род (ориентиры A1)',
    body:
        'der\tчасто: мужчины, дни и месяцы, времена года, ветер/Regen, многие напитки\t'
        'der Vater, der Montag, der Sommer\n'
        'die\tчасто: женщины, числа, -ung, -heit, -keit, -schaft, -ion\t'
        'die Mutter, die Zeitung, die Wohnung\n'
        'das\tчасто: дети, -chen/-lein, многие страны/города в сред. р., металлы, Infinitiv als Nomen\t'
        'das Mädchen, das Gold, das Schwimmen\n\n'
        'Надёжнее всего — запоминать артикль вместе со словом.',
  ),
  DerDieDasTheorySection(
    title: '4. Исключения и «логические» роды',
    body:
        'Род в немецком часто не совпадает с русским:\n'
        '• die Sonne (солнце — ж.р.), das Messer (нож — ср.р.)\n'
        '• das Mädchen (девочка — ср.р. из-за -chen)\n\n'
        'В упражнении в скобках иногда даны подсказки (Ozean, Abend …) — чтобы не путать '
        'омонимы.',
  ),
  DerDieDasTheorySection(
    title: '5. Связь с Akkusativ (кратко)',
    body:
        'Когда существительное — прямое дополнение (кого? что?), используется винительный '
        'падеж: der → den, die/das/die мн.ч. не меняются.\n\n'
        'Сначала надёжно выучите Nominativ (этот модуль), затем — отдельный блок '
        '«Artikel im Akkusativ» в приложении.',
  ),
];
