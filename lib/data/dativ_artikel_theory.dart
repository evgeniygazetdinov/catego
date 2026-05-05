/// Теория: Artikel im Dativ (A1 / Start Deutsch 1).
class DativArtikelTheorySection {
  const DativArtikelTheorySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

const List<DativArtikelTheorySection> kDativArtikelTheorySections = [
  DativArtikelTheorySection(
    title: '1. Что такое Dativ?',
    body:
        'Dativ (дательный падеж) отвечает на вопросы:\n\n'
        '• Wem? (Кому?)\n'
        '• Wo? (Где? — после некоторых предлогов)\n\n'
        'В русском: «Я даю (кому?) другу книгу». «Книга лежит (где?) на столе».',
  ),
  DativArtikelTheorySection(
    title: '2. Определённые артикли в Dativ',
    body:
        'Род\tNominativ\tAkkusativ\tDativ\tПример\n'
        'Мужской\tder\tden\tdem\tIch helfe dem Mann.\n'
        'Женский\tdie\tdie\tder\tIch helfe der Frau.\n'
        'Средний\tdas\tdas\tdem\tIch helfe dem Kind.\n'
        'Мн. ч.\tdie\tdie\tden + n\tIch helfe den Kindern.\n\n'
        'Правила: der → dem, die → der (жен. р. в Dativ!), das → dem, '
        'во мн. ч. die → den и часто окончание -n у существительного.',
  ),
  DativArtikelTheorySection(
    title: '3. Неопределённые артикли в Dativ',
    body:
        'Род\tNominativ\tAkkusativ\tDativ\tПример\n'
        'Мужской\tein\teinen\teinem\tIch helfe einem Mann.\n'
        'Женский\teine\teine\teiner\tIch helfe einer Frau.\n'
        'Средний\tein\tein\teinem\tIch helfe einem Kind.\n'
        'Мн. ч.\t—\t—\tkeinen + n\tIch helfe keinen Kindern.\n\n'
        'ein → einem (муж. и ср.), eine → einer (жен.).',
  ),
  DativArtikelTheorySection(
    title: '4. Полная таблица Nominativ → Akkusativ → Dativ',
    body:
        'Род\tNominativ\tAkkusativ\tDativ\n'
        'Мужской\tder / ein\tden / einen\tdem / einem\n'
        'Женский\tdie / eine\tdie / eine\tder / einer\n'
        'Средний\tdas / ein\tdas / ein\tdem / einem\n'
        'Мн. ч.\tdie / —\tdie / —\tden / — (+n)',
  ),
  DativArtikelTheorySection(
    title: '5. Когда Dativ? (A1) — глаголы и предлоги',
    body:
        'Глаголы: helfen, danken, gefallen, gehören, antworten, passen, schmecken, '
        'fehlen, glauben, zuhören …\n\n'
        'Предлоги с Dativ: aus, bei, mit, nach, von, zu, seit, außer, gegenüber\n\n'
        'Wechselpräpositionen: Wo? → Dativ (in, an, auf, hinter, neben, über, unter, vor, zwischen).',
  ),
  DativArtikelTheorySection(
    title: '6. Plural в Dativ (den + n)',
    body:
        'die Tische → den Tischen\tdie Frauen → den Frauen\n'
        'die Bücher → den Büchern\tdie Kinder → den Kindern\n'
        'die Autos → den Autos (окончание -s, без доп. -n)\n\n'
        'Артикль die (мн. ч.) в Dativ → den.',
  ),
  DativArtikelTheorySection(
    title: '7. Три падежа (обзор)',
    body:
        'Падеж\tВопрос\tМужской\tЖенский\tСредний\tМн. ч.\n'
        'Nominativ\tWer?/Was?\tder / ein\tdie / eine\tdas / ein\tdie\n'
        'Akkusativ\tWen?/Was?\tden / einen\tdie / eine\tdas / ein\tdie\n'
        'Dativ\tWem?\tdem / einem\tder / einer\tdem / einem\tden (+n)',
  ),
  DativArtikelTheorySection(
    title: '8. Типичные ошибки A1 (Dativ)',
    body:
        '❌ Ich helfe der Hund.  ✅ Ich helfe dem Hund.\n'
        '❌ Ich danke dem Mutter.  ✅ Ich danke der Mutter.\n'
        '❌ Das Buch gehört der Kind.  ✅ Das Buch gehört dem Kind.\n'
        '❌ Ich spiele mit die Freunde.  ✅ Ich spiele mit den Freunden.',
  ),
  DativArtikelTheorySection(
    title: '9. Итоговая шкала (150 вопросов)',
    body:
        'Правильных\tУровень\n'
        '140–150\t⭐⭐⭐ Эксперт A1! Dativ не вызывает проблем.\n'
        '130–139\t⭐⭐ Отлично! Только мелкие ошибки.\n'
        '120–129\t⭐ Хорошо. Повторите женский род (die → der).\n'
        '105–119\t⚠️ Средне. Учите таблицу и глаголы с Dativ.\n'
        '90–104\t🔄 Нужно повторить. Вернитесь к теории.\n'
        'Меньше 90\t📖 Начните заново. Выучите базовую таблицу.',
  ),
  DativArtikelTheorySection(
    title: '10. Шпаргалка перед экзаменом',
    body:
        'Dativ: der → dem, die → der, das → dem, Plural die → den (+n)\n'
        'ein → einem (муж. и ср.), eine → einer (жен.)\n\n'
        'Wem? → Dativ\tWo? (Wechselpräp.) → Dativ\n\n'
        'Предлоги: aus, bei, mit, nach, von, zu, seit, außer, gegenüber',
  ),
];
