/// Теория: Artikel im Akkusativ (A1 / Start Deutsch 1).
class AkkusativArtikelTheorySection {
  const AkkusativArtikelTheorySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

const List<AkkusativArtikelTheorySection> kAkkusativArtikelTheorySections = [
  AkkusativArtikelTheorySection(
    title: '1. Что такое Akkusativ?',
    body:
        'Akkusativ (винительный падеж) отвечает на вопросы:\n\n'
        '• Wen? (Кого?) — для одушевлённых (люди, животные)\n'
        '• Was? (Что?) — для неодушевлённых предметов\n\n'
        'В русском: «Я вижу (кого?/что?)» — стол, маму, окно.',
  ),
  AkkusativArtikelTheorySection(
    title: '2. Определённые артикли (der, die, das → Akkusativ)',
    body:
        'Род (Genus)\tNominativ\tAkkusativ\tПример (Akkusativ)\n'
        'Мужской\tder\tden\tIch sehe den Tisch.\n'
        'Женский\tdie\tdie\tIch sehe die Lampe.\n'
        'Средний\tdas\tdas\tIch sehe das Buch.\n'
        'Мн. ч.\tdie\tdie\tIch sehe die Kinder.\n\n'
        'Главное правило: в Akkusativ меняется ТОЛЬКО мужской род — der → den. '
        'die, das и die (мн. ч.) не меняются.',
  ),
  AkkusativArtikelTheorySection(
    title: '3. Неопределённые артикли (ein, eine → Akkusativ)',
    body:
        'Род\tNominativ\tAkkusativ\tПример\n'
        'Мужской\tein\teinen\tIch habe einen Hund.\n'
        'Женский\teine\teine\tIch habe eine Katze.\n'
        'Средний\tein\tein\tIch habe ein Haus.\n'
        'Мн. ч.\t— (keine)\t— (keine)\tIch habe keine Kinder.\n\n'
        'Правило: меняется только мужской род — ein → einen. '
        'eine (жен.) и ein (ср.) остаются без изменений.',
  ),
  AkkusativArtikelTheorySection(
    title: '4. Когда Akkusativ? (A1) — глаголы',
    body:
        'После глаголов с прямым дополнением (важные для A1):\n\n'
        'haben, nehmen, kaufen, sehen, essen, trinken, lieben, kennen, brauchen, '
        'machen, schreiben, lesen, hören, verstehen, öffnen, schließen …\n\n'
        'Примеры:\n'
        '• Ich habe einen Bruder. • Sie kauft das Auto. • Er sieht die Frau.\n'
        '• Wir essen einen Apfel. • Ich trinke das Wasser.',
  ),
  AkkusativArtikelTheorySection(
    title: '5. Предлоги с Akkusativ',
    body:
        'После этих предлогов всегда винительный падеж:\n\n'
        'Предлог\tЗначение\tПример\n'
        'durch\tчерез, сквозь\tdurch den Wald\n'
        'für\tдля\tfür die Mutter\n'
        'gegen\tпротив, около\tgegen das Gesetz\n'
        'ohne\tбез\tohne einen Regenschirm\n'
        'um\tвокруг, о (времени)\tum den Tisch',
  ),
  AkkusativArtikelTheorySection(
    title: '6. Сравнение: Nominativ vs. Akkusativ',
    body:
        'Падеж\tВопрос\tМужской\tЖенский\tСредний\tМн. ч.\n'
        'Nominativ\tWer?/Was?\tder / ein\tdie / eine\tdas / ein\tdie / —\n'
        'Akkusativ\tWen?/Was?\tden / einen\tdie / eine\tdas / ein\tdie / —\n\n'
        'Пары:\n'
        'Der Hund schläft. → Ich sehe den Hund.\n'
        'Ein Mann kommt. → Ich kenne einen Mann.\n'
        'Die Frau lacht. → Ich liebe die Frau.\n'
        'Das Kind spielt. → Ich rufe das Kind.\n'
        'Ein Auto ist teuer. → Ich kaufe ein Auto.',
  ),
  AkkusativArtikelTheorySection(
    title: '7. Типичные ошибки на A1',
    body:
        '❌ Ich habe der Stift.  ✅ Ich habe den Stift.\n'
        '❌ Ich sehe einer Mann.  ✅ Ich sehe einen Mann.\n'
        '❌ Sie kauft den Tasche.  ✅ Sie kauft die Tasche. (die не меняется!)\n'
        '❌ Er nimmt einen Brot.  ✅ Er nimmt ein Brot. (средний род — ein)',
  ),
  AkkusativArtikelTheorySection(
    title: '8. Шкала самопроверки (на каждые 50 заданий)',
    body:
        'Оценивайте отдельно задания 1–50 и 51–100 по этой шкале; в конце курса — '
        'бонус «Диалоги» (несколько пропусков подряд).\n\n'
        'Правильных\tУровень\tРекомендация\n'
        '46–50\tОтлично\tМожно переходить к Dativ.\n'
        '40–45\tХорошо\tПовторить мужской род (der→den, ein→einen).\n'
        '30–39\tСредне\tВыучить таблицу артиклей.\n'
        'Меньше 30\tНужно повторить\tВернуться к теории и словам с артиклями.',
  ),
  AkkusativArtikelTheorySection(
    title: '9. Шпаргалка перед экзаменом',
    body:
        'Akkusativ: der → den,  ein → einen.\n'
        'Все остальные (die, das, eine, ein ср., die мн. ч.) — без изменений!\n\n'
        'Глаголы: haben, nehmen, kaufen, sehen, essen, trinken, lieben, kennen, '
        'brauchen, machen …\n'
        'Предлоги: für, durch, ohne, gegen, um',
  ),
];
