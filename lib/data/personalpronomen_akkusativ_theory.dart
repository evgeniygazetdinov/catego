/// Теория: Personalpronomen im Akkusativ (A1 / Start Deutsch 1).
class PersonalpronomenAkkTheorySection {
  const PersonalpronomenAkkTheorySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

const List<PersonalpronomenAkkTheorySection> kPersonalpronomenAkkTheorySections = [
  PersonalpronomenAkkTheorySection(
    title: '1. Что такое Personalpronomen im Akkusativ?',
    body:
        'Личные местоимения заменяют существительные. В Akkusativ отвечают на:\n\n'
        '• Wen? (кого?)  • Was? (что?)\n\n'
        'В русском: я вижу меня, тебя, его, её, нас, вас, их.',
  ),
  PersonalpronomenAkkTheorySection(
    title: '2. Таблица (Nominativ → Akkusativ)',
    body:
        'Person\tNominativ\tAkkusativ\tBeispiel\n'
        '1 sg.\tich\tmich\tDu siehst mich.\n'
        '2 sg.\tdu\tdich\tIch sehe dich.\n'
        '3 m\ter\tihn\tIch sehe ihn.\n'
        '3 f\tsie\tsie\tIch sehe sie.\n'
        '3 n\tes\tes\tIch sehe es.\n'
        '1 pl.\twir\tuns\tDu siehst uns.\n'
        '2 pl.\tihr\teuch\tIch sehe euch.\n'
        '3 pl.\tsie\tsie\tIch sehe sie.\n'
        'Höflichkeit\tSie\tSie\tIch sehe Sie.\n\n'
        'Важно: er → ihn (+n). sie (она/они) и es не меняются по форме. Sie (Вы) всегда с большой буквы.',
  ),
  PersonalpronomenAkkTheorySection(
    title: '3. Nominativ vs. Akkusativ',
    body:
        'ich → mich\tdu → dich\ter → ihn\n'
        'sie (f) → sie\tes → es\twir → uns\n'
        'ihr → euch\tsie (pl) → sie\tSie → Sie',
  ),
  PersonalpronomenAkkTheorySection(
    title: '4. Когда Akkusativ с местоимениями?',
    body:
        'A) После глаголов: sehen, hören, lieben, haben, kennen, brauchen, nehmen, kaufen, '
        'verstehen, fragen, besuchen, einladen, treffen, anrufen, finden …\n\n'
        'B) После предлогов с Akkusativ: für, durch, ohne, gegen, um\n\n'
        'Порядок: Subjekt + Verb + Akkusativpronomen (+ Dativ) + …',
  ),
  PersonalpronomenAkkTheorySection(
    title: '5. Типичные ошибки A1',
    body:
        '❌ Ich sehe er.  ✅ Ich sehe ihn.\n'
        '❌ Das Geschenk ist für ich.  ✅ … für mich.\n'
        '❌ uns / euch путать (нас vs вас, мн.ч.)\n'
        '❌ helfen + Dativ: Kannst du mir helfen? (не mich!)',
  ),
  PersonalpronomenAkkTheorySection(
    title: '6. Местоимения vs. артикль (Akkusativ)',
    body:
        'den Tisch → ihn\tdie Lampe → sie\tdas Buch → es\tdie Bücher → sie',
  ),
  PersonalpronomenAkkTheorySection(
    title: '7. Итоговая шкала (150 вопросов)',
    body:
        'Правильных\tУровень\n'
        '140–150\t⭐⭐⭐ Эксперт A1!\n'
        '130–139\t⭐⭐ Отлично!\n'
        '120–129\t⭐ Хорошо. Повторите ihn и uns/euch.\n'
        '105–119\t⚠️ Средне.\n'
        '90–104\t🔄 Нужно повторить.\n'
        'Меньше 90\t📖 Начните заново.',
  ),
  PersonalpronomenAkkTheorySection(
    title: '8. Шпаргалка',
    body:
        'ich→mich, du→dich, er→ihn, sie→sie, es→es, wir→uns, ihr→euch, sie→sie, Sie→Sie\n\n'
        'Präpositionen: für, durch, ohne, gegen, um',
  ),
];
