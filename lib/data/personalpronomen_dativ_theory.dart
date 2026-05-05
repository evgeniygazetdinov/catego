/// Теория: Personalpronomen im Dativ (A1 / Start Deutsch 1).
class PersonalpronomenDatTheorySection {
  const PersonalpronomenDatTheorySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

const List<PersonalpronomenDatTheorySection> kPersonalpronomenDatTheorySections = [
  PersonalpronomenDatTheorySection(
    title: '1. Что такое Personalpronomen im Dativ?',
    body:
        'Личные местоимения в Dativ заменяют существительное и отвечают на:\n\n'
        '• Wem? (кому?)\n\n'
        'В русском: я даю мне, тебе, ему, ей, нам, вам, им, Вам.',
  ),
  PersonalpronomenDatTheorySection(
    title: '2. Таблица Nominativ / Akkusativ / Dativ',
    body:
        'Person\tNom.\tAkk.\tDat.\tBeispiel (Dat.)\n'
        '1 sg.\tich\tmich\tmir\tDu hilfst mir.\n'
        '2 sg.\tdu\tdich\tdir\tIch helfe dir.\n'
        '3 m\ter\tihn\tihm\tIch helfe ihm.\n'
        '3 f\tsie\tsie\tihr\tIch helfe ihr.\n'
        '3 n\tes\tes\tihm\tIch helfe ihm.\n'
        '1 pl.\twir\tuns\tuns\tEr hilft uns.\n'
        '2 pl.\tihr\teuch\teuch\tIch helfe euch.\n'
        '3 pl.\tsie\tsie\tihnen\tIch helfe ihnen.\n'
        'Höflichkeit\tSie\tSie\tIhnen\tIch helfe Ihnen.\n\n'
        'Важно: er и es → ihm. sie (она) → ihr (не путать с ihr «вы»!). '
        'sie (они) → ihnen. Sie (Вы) → Ihnen.',
  ),
  PersonalpronomenDatTheorySection(
    title: '3. Сравнение Akkusativ vs. Dativ',
    body:
        'mich ↔ mir\tdich ↔ dir\tihn ↔ ihm\n'
        'sie (f) ↔ ihr\tes ↔ ihm\twir/ihr: uns/euch совпадают\n'
        'sie (pl) ↔ ihnen\tSie ↔ Ihnen',
  ),
  PersonalpronomenDatTheorySection(
    title: '4. Глаголы с Dativ (A1)',
    body:
        'helfen, danken, gefallen, gehören, antworten, passen, schmecken, '
        'fehlen, glauben, zuhören, vertrauen, gratulieren, empfehlen, schaden …',
  ),
  PersonalpronomenDatTheorySection(
    title: '5. Предлоги с Dativ (A1)',
    body:
        'mit, bei, von, zu, aus, nach, außer, gegenüber\n\n'
        'Частые с местоимениями: mit mir/dir, bei dir, von ihm, zu uns …',
  ),
  PersonalpronomenDatTheorySection(
    title: '6. Порядок слов и типичные ошибки',
    body:
        'Часто: Verb + Dativ + Akkusativ: Ich gebe dir das Buch.\n'
        'Или: Ich gebe es dir.\n\n'
        '❌ Ich helfe mich.  ✅ Ich helfe mir.\n'
        '❌ Ich danke dich.  ✅ Ich danke dir.\n'
        '❌ mit ich  ✅ mit mir\n'
        'Ловушка: für + Akkusativ (dich), nicht dir.',
  ),
  PersonalpronomenDatTheorySection(
    title: '7. Итоговая шкала (150 вопросов)',
    body:
        'Правильных\tУровень\n'
        '140–150\t⭐⭐⭐ Эксперт A1!\n'
        '130–139\t⭐⭐ Отлично!\n'
        '120–129\t⭐ Хорошо. Повторите ihm/ihr и uns/euch/ihnen.\n'
        '105–119\t⚠️ Средне.\n'
        '90–104\t🔄 Нужно повторить.\n'
        'Меньше 90\t📖 Начните заново.',
  ),
  PersonalpronomenDatTheorySection(
    title: '8. Шпаргалка',
    body:
        'ich→mir, du→dir, er/es→ihm, sie(f)→ihr, wir→uns, ihr→euch, sie(pl)→ihnen, Sie→Ihnen',
  ),
];
