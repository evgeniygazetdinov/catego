/// Текстовые блоки теории: bestimmter Artikel (A1 / Start Deutsch 1).
class BestimmterArtikelTheorySection {
  const BestimmterArtikelTheorySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

const List<BestimmterArtikelTheorySection> kBestimmterArtikelTheorySections = [
  BestimmterArtikelTheorySection(
    title: '1. Что такое определённый артикль?',
    body:
        'Определённый артикль указывает на конкретный предмет или лицо, о котором уже идёт речь '
        'или который известен собеседнику.\n\n'
        'Род (Genus)\tNominativ (Wer?/Was?)\tПример\n'
        'Мужской (maskulin)\tder\tder Tisch (стол), der Mann (мужчина)\n'
        'Женский (feminin)\tdie\tdie Lampe (лампа), die Frau (женщина)\n'
        'Средний (neutral)\tdas\tdas Buch (книга), das Kind (ребёнок)\n'
        'Множественное число (Plural)\tdie\tdie Tische (столы), die Frauen (женщины)\n\n'
        'Важно: во множественном числе артикль всегда die, независимо от рода в единственном числе.',
  ),
  BestimmterArtikelTheorySection(
    title: '2. Падежи для A1: Nominativ und Akkusativ',
    body:
        'На уровне A1 нужны два падежа:\n\n'
        'Падеж\tВопрос\tМужской (der)\tЖенский (die)\tСредний (das)\tМнож. (die)\n'
        'Nominativ\tWer?/Was?\tder\tdie\tdas\tdie\n'
        'Akkusativ\tWen?/Was?\tden\tdie\tdas\tdie\n\n'
        'Правило: в Akkusativ меняется только мужской род (der → den). '
        'Остальные (die, das, die мн. ч.) остаются без изменений.\n\n'
        'Примеры:\n'
        '• Nominativ: Der Hund schläft. (Собака спит.)\n'
        '• Akkusativ: Ich sehe den Hund. (Я вижу собаку.)',
  ),
  BestimmterArtikelTheorySection(
    title: '3. Когда Nominativ? (Кто/что делает?)',
    body:
        'Подлежащее — кто или что совершает действие.\n'
        'После глаголов: sein, werden, bleiben.\n\n'
        'Примеры:\n'
        '• Der Lehrer ist gut.\n'
        '• Die Blume ist schön.\n'
        '• Das Haus ist groß.\n'
        '• Die Kinder spielen.',
  ),
  BestimmterArtikelTheorySection(
    title: '4. Когда Akkusativ? (Кого/что?)',
    body:
        'Прямое дополнение — на кого или на что направлено действие.\n'
        'После глаголов: haben, nehmen, kaufen, sehen, essen, trinken, lieben, kennen, '
        'brauchen, machen, schreiben, lesen и др.\n\n'
        'Примеры:\n'
        '• Ich habe den Stift. (der → den)\n'
        '• Sie kauft die Tasche. (die → die)\n'
        '• Wir essen das Brot. (das → das)\n'
        '• Er sieht die Kinder. (die мн. ч. → die)',
  ),
  BestimmterArtikelTheorySection(
    title: '5. Предлоги с Akkusativ (A1)',
    body:
        'Пять предлогов, после которых всегда Akkusativ:\n\n'
        'Предлог\tЗначение\tПример\n'
        'durch\tчерез, сквозь\tdurch den Park\n'
        'für\tдля\tfür den Mann\n'
        'gegen\tпротив, около\tgegen die Wand\n'
        'ohne\tбез\tohne das Buch\n'
        'um\tвокруг, о (времени)\tum den Tisch\n\n'
        'Примеры:\n'
        '• Das Geschenk ist für den Vater.\n'
        '• Ich gehe ohne den Regenschirm.\n'
        '• Er läuft durch den Wald.',
  ),
  BestimmterArtikelTheorySection(
    title: '6. Как определить род (простые ориентиры A1)',
    body:
        'Род\tЧасто это…\tПримеры\n'
        'der\tмужчины, дни недели, месяцы, времена года, часть напитков, марки машин\t'
        'der Mann, der Montag, der Sommer, der Wein, der BMW\n'
        'die\tженщины, многие цвета, числа, окончания -heit, -keit, -ung, -schaft\t'
        'die Frau, die Rose, die Eins, die Freiheit, die Wohnung\n'
        'das\tдети, уменьшительные (-chen, -lein), отглагольные существительные, '
        'часть металлов, отели, кафе\tdas Kind, das Mädchen, das Essen, das Gold, das Hilton\n\n'
        'Совет: учите слова сразу с артиклем — не «Tisch», а «der Tisch».',
  ),
];
