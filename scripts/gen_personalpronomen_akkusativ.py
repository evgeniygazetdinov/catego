#!/usr/bin/env python3
"""Генерирует lib/data/personalpronomen_akkusativ_questions.dart"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "lib/data/personalpronomen_akkusativ_questions.dart"


def esc(s: str) -> str:
    return s.replace("\\", r"\\").replace("'", r"\'")


def q(nr, teil, before, after, opts, ci, sol):
    opts_s = ", ".join(f"'{esc(o)}'" for o in opts)
    return f'''    PersonalpronomenAkkFrage(
      nr: {nr},
      teil: PersonalpronomenAkkTeil.{teil},
      beforeGap: '{esc(before)}',
      afterGap: '{esc(after)}',
      options: [{opts_s}],
      correctIndex: {ci},
      solutionDe: '{esc(sol)}',
    ),'''


def idx(opts, ans):
    return opts.index(ans)


chunks = []

# Teil 1: Ersetzen (1–30)
p1 = [
    ("Ich sehe den Vater. → Ich sehe ", ".", "ihn", ["ihn", "sie", "es"], "Ich sehe ihn."),
    ("Du siehst die Mutter. → Du siehst ", ".", "sie", ["ihn", "sie", "es"], "Du siehst sie."),
    ("Er sieht das Kind. → Er sieht ", ".", "es", ["ihn", "sie", "es"], "Er sieht es."),
    ("Wir sehen die Freunde. → Wir sehen ", ".", "sie", ["ihn", "sie", "euch"], "Wir sehen sie."),
    ("Ihr seht den Lehrer. → Ihr seht ", ".", "ihn", ["ihn", "sie", "euch"], "Ihr seht ihn."),
    ("Sie sieht die Blume. → Sie sieht ", ".", "sie", ["ihn", "sie", "es"], "Sie sieht sie."),
    ("Ich liebe meine Frau. → Ich liebe ", ".", "sie", ["ihn", "sie", "es"], "Ich liebe sie."),
    ("Du kennst meinen Bruder. → Du kennst ", ".", "ihn", ["ihn", "sie", "es"], "Du kennst ihn."),
    ("Er hat das Auto. → Er hat ", ".", "es", ["ihn", "sie", "es"], "Er hat es."),
    ("Wir brauchen die Hilfe. → Wir brauchen ", ".", "sie", ["ihn", "sie", "uns"], "Wir brauchen sie."),
    ("Ihr nehmt den Kaffee. → Ihr nehmt ", ".", "ihn", ["ihn", "sie", "euch"], "Ihr nehmt ihn."),
    ("Sie kaufen die Tische. → Sie kaufen ", ".", "sie", ["ihn", "sie", "euch"], "Sie kaufen sie."),
    ("Ich verstehe den Satz. → Ich verstehe ", ".", "ihn", ["ihn", "sie", "es"], "Ich verstehe ihn."),
    ("Du fragst die Studentin. → Du fragst ", ".", "sie", ["ihn", "sie", "es"], "Du fragst sie."),
    ("Er besucht seine Eltern. → Er besucht ", ".", "sie", ["ihn", "sie", "uns"], "Er besucht sie."),
    ("Wir laden die Nachbarn ein. → Wir laden ", " ein.", "sie", ["ihn", "sie", "uns"], "Wir laden sie ein."),
    ("Ihr trefft den Arzt. → Ihr trefft ", ".", "ihn", ["ihn", "sie", "euch"], "Ihr trefft ihn."),
    ("Sie ruft ihren Freund an. → Sie ruft ", " an.", "ihn", ["ihn", "sie", "euch"], "Sie ruft ihn an."),
    ("Ich finde den Schlüssel. → Ich finde ", ".", "ihn", ["ihn", "sie", "es"], "Ich finde ihn."),
    ("Du hörst die Musik. → Du hörst ", ".", "sie", ["ihn", "sie", "es"], "Du hörst sie."),
    ("Er nimmt das Buch. → Er nimmt ", ".", "es", ["ihn", "sie", "es"], "Er nimmt es."),
    ("Wir sehen die Kinder. → Wir sehen ", ".", "sie", ["ihn", "sie", "uns"], "Wir sehen sie."),
    ("Ihr liebt eure Oma. → Ihr liebt ", ".", "sie", ["ihn", "sie", "euch"], "Ihr liebt sie."),
    ("Sie kennen den Präsidenten. → Sie kennen ", ".", "ihn", ["ihn", "sie", "euch"], "Sie kennen ihn."),
    ("Ich wasche das Auto. → Ich wasche ", ".", "es", ["ihn", "sie", "es"], "Ich wasche es."),
    ("Du putzt die Fenster. → Du putzt ", ".", "sie", ["ihn", "sie", "euch"], "Du putzt sie."),
    ("Er öffnet die Tür. → Er öffnet ", ".", "sie", ["ihn", "sie", "es"], "Er öffnet sie."),
    ("Wir schließen das Fenster. → Wir schließen ", ".", "es", ["ihn", "sie", "es"], "Wir schließen es."),
    ("Ihr macht die Hausaufgaben. → Ihr macht ", ".", "sie", ["ihn", "sie", "euch"], "Ihr macht sie."),
    ("Sie kocht die Suppe. → Sie kocht ", ".", "sie", ["ihn", "sie", "es"], "Sie kocht sie."),
]
for i, row in enumerate(p1, 1):
    b, a, ans, opts, sol = row
    chunks.append(q(i, "ersatz", b, a, opts, idx(opts, ans), sol))

# Teil 2 (31–60)
p2 = [
    ("Ich liebe ", ".", "dich", ["mich", "dich", "sie"], "Ich liebe dich."),
    ("Du siehst ", ".", "mich", ["mich", "dich", "ihn"], "Du siehst mich."),
    ("Er kennt ", ".", "sie", ["ihn", "sie", "es"], "Er kennt sie."),
    ("Wir hören ", ".", "ihn", ["ihn", "sie", "uns"], "Wir hören ihn."),
    ("Ihr versteht ", ".", "uns", ["uns", "euch", "sie"], "Ihr versteht uns."),
    ("Sie fragen ", ".", "euch", ["uns", "euch", "sie"], "Sie fragen euch."),
    ("Ich brauche ", ".", "Sie", ["Sie", "sie", "euch"], "Ich brauche Sie."),
    ("Du liebst ", ".", "mich", ["mich", "dich", "sie"], "Du liebst mich."),
    ("Er hat ", ".", "sie", ["ihn", "sie", "es"], "Er hat sie."),
    ("Wir sehen ", ".", "dich", ["mich", "dich", "euch"], "Wir sehen dich."),
    ("Ihr ruft ", " an.", "uns", ["uns", "euch", "sie"], "Ihr ruft uns an."),
    ("Sie nimmt ", ".", "ihn", ["ihn", "sie", "es"], "Sie nimmt ihn."),
    ("Ich besuche ", ".", "sie", ["ihn", "sie", "es"], "Ich besuche sie."),
    ("Du triffst ", ".", "mich", ["mich", "dich", "ihn"], "Du triffst mich."),
    ("Er findet ", ".", "ihn", ["ihn", "sie", "es"], "Er findet ihn."),
    ("Wir laden ", " ein.", "euch", ["uns", "euch", "sie"], "Wir laden euch ein."),
    ("Ihr kennt ", ".", "ihn", ["ihn", "sie", "euch"], "Ihr kennt ihn."),
    ("Sie lieben ", ".", "sie", ["ihn", "sie", "euch"], "Sie lieben sie."),
    ("Ich verstehe ", ".", "Sie", ["Sie", "sie", "mich"], "Ich verstehe Sie."),
    ("Du fragst ", ".", "mich", ["mich", "dich", "sie"], "Du fragst mich."),
    ("Er braucht ", ".", "uns", ["uns", "euch", "sie"], "Er braucht uns."),
    ("Wir hören ", ".", "dich", ["mich", "dich", "euch"], "Wir hören dich."),
    ("Ihr seht ", ".", "sie", ["ihn", "sie", "euch"], "Ihr seht sie."),
    ("Sie ruft ", " an.", "ihn", ["ihn", "sie", "es"], "Sie ruft ihn an."),
    ("Ich kenne ", ".", "sie", ["ihn", "sie", "es"], "Ich kenne sie."),
    ("Du liebst ", ".", "mich", ["mich", "dich", "ihn"], "Du liebst mich."),
    ("Er nimmt ", ".", "sie", ["ihn", "sie", "es"], "Er nimmt sie."),
    ("Wir haben ", ".", "ihn", ["ihn", "sie", "uns"], "Wir haben ihn."),
    ("Ihr versteht ", ".", "mich", ["mich", "dich", "euch"], "Ihr versteht mich."),
    ("Sie sehen ", ".", "uns", ["uns", "euch", "sie"], "Sie sehen uns."),
]
for i, row in enumerate(p2, 31):
    b, a, ans, opts, sol = row
    chunks.append(q(i, "luecke", b, a, opts, idx(opts, ans), sol))

# Teil 3 (61–90) — выбор из ключей
p3 = [
    ("Kannst du ", " hören?", ["ich", "mich", "mir"], "mich", "Kannst du mich hören?"),
    ("Ich liebe ", ".", ["du", "dich", "dir"], "dich", "Ich liebe dich."),
    ("Er sieht ", " jeden Tag.", ["er", "ihn", "ihm"], "ihn", "Er sieht ihn jeden Tag."),
    ("Wir besuchen ", " morgen.", ["sie", "ihr", "euch"], "sie", "Wir besuchen sie morgen."),
    ("Kennt ihr ", "?", ["wir", "uns", "euch"], "uns", "Kennt ihr uns?"),
    ("Ich rufe ", " an.", ["sie", "ihr", "euch"], "euch", "Ich rufe euch an."),
    ("Das Geschenk ist für ", ".", ["ich", "mich", "mir"], "mich", "Das Geschenk ist für mich."),
    ("Ich kann nicht ohne ", " leben.", ["du", "dich", "dir"], "dich", "Ich kann nicht ohne dich leben."),
    ("Der Chef ist gegen ", ".", ["er", "ihn", "ihm"], "ihn", "Der Chef ist gegen ihn."),
    ("Es geht um ", ".", ["sie", "ihr", "Sie"], "Sie", "Es geht um Sie."),
    ("Verstehst du ", "?", ["ich", "mich", "mir"], "mich", "Verstehst du mich?"),
    ("Sie liebt ", " nicht mehr.", ["er", "ihn", "ihm"], "ihn", "Sie liebt ihn nicht mehr."),
    ("Wir brauchen ", " dringend.", ["sie", "ihr", "euch"], "sie", "Wir brauchen sie dringend."),
    ("Ihr habt ", " gesehen?", ["wir", "uns", "euch"], "uns", "Ihr habt uns gesehen?"),
    ("Sie laden ", " ein.", ["wir", "uns", "euch"], "uns", "Sie laden uns ein."),
    ("Ich treffe ", " um 8 Uhr.", ["sie", "ihr", "euch"], "sie", "Ich treffe sie um 8 Uhr."),
    ("Du kennst ", " schon lange?", ["er", "ihn", "ihm"], "ihn", "Du kennst ihn schon lange?"),
    ("Er fragt ", " nach dem Weg.", ["sie", "ihr", "euch"], "sie", "Er fragt sie nach dem Weg."),
    ("Wir hören ", " gerne zu.", ["sie", "ihr", "dir"], "dir", "Wir hören dir gerne zu."),
    ("Ihr seht ", " im Spiegel.", ["wir", "uns", "euch"], "uns", "Ihr seht uns im Spiegel."),
    ("Ich wasche ", " jeden Tag.", ["er", "ihn", "es"], "ihn", "Ich wasche ihn jeden Tag."),
    ("Du putzt ", " am Wochenende.", ["sie", "ihr", "euch"], "sie", "Du putzt sie am Wochenende."),
    ("Er öffnet ", " langsam.", ["es", "ihn", "ihm"], "es", "Er öffnet es langsam."),
    ("Wir schließen ", " sofort.", ["sie", "ihr", "euch"], "sie", "Wir schließen sie sofort."),
    ("Ihr macht ", " jeden Abend.", ["sie", "ihr", "euch"], "sie", "Ihr macht sie jeden Abend."),
    ("Sie kocht ", " mit Liebe.", ["es", "ihn", "sie"], "sie", "Sie kocht sie mit Liebe."),
    ("Ich finde ", " nicht.", ["es", "ihn", "ihm"], "ihn", "Ich finde ihn nicht."),
    ("Du nimmst ", " mit.", ["sie", "ihr", "euch"], "sie", "Du nimmst sie mit."),
    ("Er hat ", " vergessen.", ["es", "ihn", "ihm"], "es", "Er hat es vergessen."),
    ("Wir kaufen ", " heute.", ["sie", "ihr", "euch"], "sie", "Wir kaufen sie heute."),
]
for i, row in enumerate(p3, 61):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "wahl", b, a, opts, idx(opts, ans), sol))

# Teil 4 (91–120) — одна реплика с пропуском по ответу
p4 = [
    ("Kannst du ", " sehen?", ["mich", "dich", "uns"], "mich", "Kannst du mich sehen?"),
    ("Ich liebe ", " sehr.", ["dich", "sie", "euch"], "dich", "Ich liebe dich sehr."),
    ("Kennst du ", "?", ["ihn", "sie", "uns"], "ihn", "Kennst du ihn?"),
    ("Besucht ihr ", " morgen?", ["uns", "euch", "sie"], "uns", "Besucht ihr uns morgen?"),
    ("Wir hören ", " gut.", ["euch", "sie", "uns"], "euch", "Wir hören euch gut."),
    ("Ich brauche ", " jetzt.", ["sie", "ihn", "euch"], "sie", "Ich brauche sie jetzt."),
    ("Verstehst du ", "?", ["sie", "ihn", "euch"], "sie", "Verstehst du sie?"),
    ("Er fragt ", " nach dem Weg.", ["mich", "dich", "uns"], "mich", "Er fragt mich nach dem Weg."),
    ("Ich lade ", " zum Essen ein.", ["dich", "sie", "euch"], "dich", "Ich lade dich zum Essen ein."),
    ("Sie trifft ", " um 5 Uhr.", ["ihn", "sie", "uns"], "ihn", "Sie trifft ihn um 5 Uhr."),
    ("Ich rufe ", " später an.", ["euch", "sie", "uns"], "euch", "Ich rufe euch später an."),
    ("Wir finden ", " nicht.", ["ihn", "sie", "es"], "ihn", "Wir finden ihn nicht."),
    ("Ich nehme ", " mit.", ["sie", "ihn", "es"], "sie", "Ich nehme sie mit."),
    ("Wir haben ", " leider nicht.", ["sie", "ihn", "es"], "sie", "Wir haben sie leider nicht."),
    ("Du wäschst ", " jeden Tag.", ["es", "ihn", "sie"], "es", "Du wäschst es jeden Tag."),
    ("Ich putze ", " am Samstag.", ["sie", "euch", "uns"], "sie", "Ich putze sie am Samstag."),
    ("Wir öffnen ", " jetzt.", ["es", "ihn", "sie"], "es", "Wir öffnen es jetzt."),
    ("Er schließt ", " sofort.", ["sie", "es", "ihn"], "sie", "Er schließt sie sofort."),
    ("Wir machen ", " zusammen.", ["sie", "euch", "uns"], "sie", "Wir machen sie zusammen."),
    ("Ich koche ", " gerne.", ["sie", "es", "ihn"], "sie", "Ich koche sie gerne."),
    ("Sie kaufen ", " für dich.", ["es", "ihn", "sie"], "es", "Sie kaufen es für dich."),
    ("Ich lese ", " jeden Abend.", ["es", "ihn", "sie"], "es", "Ich lese es jeden Abend."),
    ("Er schreibt ", " morgen.", ["ihn", "es", "sie"], "ihn", "Er schreibt ihn morgen."),
    ("Wir trinken ", " jetzt.", ["ihn", "es", "sie"], "ihn", "Wir trinken ihn jetzt."),
    ("Ich esse ", " mit euch.", ["ihn", "es", "sie"], "ihn", "Ich esse ihn mit euch."),
    ("Ich nehme ", " von dir.", ["ihn", "es", "sie"], "ihn", "Ich nehme ihn von dir."),
    ("Ich sehe ", " jeden Tag.", ["sie", "euch", "uns"], "sie", "Ich sehe sie jeden Tag."),
    ("Ich höre ", " gerne.", ["sie", "es", "ihn"], "sie", "Ich höre sie gerne."),
    ("Ich verstehe ", " perfekt.", ["ihn", "es", "sie"], "ihn", "Ich verstehe ihn perfekt."),
    ("Sie lieben ", " sehr.", ["ihn", "sie", "es"], "ihn", "Sie lieben ihn sehr."),
]
for i, row in enumerate(p4, 91):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "verben", b, a, opts, idx(opts, ans), sol))

# Teil 5 (121–135)
p5 = [
    ("Das Geschenk ist für ", ".", ["dich", "mich", "euch"], "dich", "Das Geschenk ist für dich."),
    ("Ich gehe ohne ", " nicht nach Hause.", ["dich", "mich", "sie"], "dich", "Ich gehe ohne dich nicht nach Hause."),
    ("Er geht durch ", ".", ["mich", "dich", "sie"], "mich", "Er geht durch mich."),
    ("Sie ist gegen ", ".", ["mich", "dich", "uns"], "mich", "Sie ist gegen mich."),
    ("Es geht um ", ".", ["dich", "mich", "euch"], "dich", "Es geht um dich."),
    ("Das ist alles für ", ".", ["euch", "uns", "sie"], "euch", "Das ist alles für euch."),
    ("Ich kann nicht ohne ", " leben.", ["ihn", "sie", "es"], "ihn", "Ich kann nicht ohne ihn leben."),
    ("Wir kämpfen gegen ", ".", ["sie", "euch", "uns"], "sie", "Wir kämpfen gegen sie."),
    ("Die Wahrheit ist durch ", ".", ["mich", "dich", "uns"], "mich", "Die Wahrheit ist durch mich."),
    ("Der Film handelt um ", ".", ["sie", "ihn", "es"], "sie", "Der Film handelt um sie."),
    ("Das Geld ist für ", ".", ["uns", "euch", "sie"], "uns", "Das Geld ist für uns."),
    ("Ich mache das ohne ", ".", ["Sie", "sie", "euch"], "Sie", "Ich mache das ohne Sie."),
    ("Er ist gegen ", ".", ["sie", "ihn", "es"], "sie", "Er ist gegen sie."),
    ("Es geht um ", ".", ["ihn", "sie", "es"], "ihn", "Es geht um ihn."),
    ("Das Leben ist schön ohne ", "? — Nein!", ["mich", "dich", "uns"], "mich", "Das Leben ist schön ohne mich? — Nein!"),
]
for i, row in enumerate(p5, 121):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "praeposition", b, a, opts, idx(opts, ans), sol))

# Teil 6 (136–150)
p6 = [
    ("Ich sehe den Hund. → Ich sehe ", ".", ["ihn", "sie", "es"], "ihn", "Ich sehe ihn."),
    ("Du liebst die Katze. → Du liebst ", ".", ["sie", "ihn", "es"], "sie", "Du liebst sie."),
    ("Er hat das Haus gekauft. → Er hat ", " gekauft.", ["es", "ihn", "sie"], "es", "Er hat es gekauft."),
    ("Wir besuchen die Eltern. → Wir besuchen ", ".", ["sie", "ihn", "euch"], "sie", "Wir besuchen sie."),
    ("Ihr kennt den Lehrer. → Ihr kennt ", ".", ["ihn", "sie", "euch"], "ihn", "Ihr kennt ihn."),
    ("Sie ruft ihren Freund an. → Sie ruft ", " an.", ["ihn", "sie", "es"], "ihn", "Sie ruft ihn an."),
    ("Sie sehen die Kinder. → Sie sehen ", ".", ["sie", "ihn", "euch"], "sie", "Sie sehen sie."),
    ("Kannst du ", " helfen? (helfen + Dativ)", ["ich", "mich", "mir"], "mir", "Kannst du mir helfen?"),
    ("Ich liebe ", ".", ["du", "dich", "dir"], "dich", "Ich liebe dich."),
    ("Das Buch ist für ", ".", ["er", "ihn", "ihm"], "ihn", "Das Buch ist für ihn."),
    ("Er fährt ohne ", " nach Berlin.", ["sie", "ihr", "euch"], "sie", "Er fährt ohne sie nach Berlin."),
    ("Ich verstehe ", " nicht.", ["ihr", "euch", "sie"], "euch", "Ich verstehe euch nicht."),
    ("Wir laden ", " zum Geburtstag ein.", ["sie", "ihr", "euch"], "sie", "Wir laden sie zum Geburtstag ein."),
    ("Er trifft ", " am Bahnhof.", ["wir", "uns", "euch"], "uns", "Er trifft uns am Bahnhof."),
    ("Sie hat ", " gestern gesehen.", ["er", "ihn", "ihm"], "ihn", "Sie hat ihn gestern gesehen."),
]
for i, row in enumerate(p6, 136):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "mix", b, a, opts, idx(opts, ans), sol))

header = '''/// Упражнения: Personalpronomen im Akkusativ (A1 / Start Deutsch 1).
enum PersonalpronomenAkkTeil {
  ersatz,
  luecke,
  wahl,
  verben,
  praeposition,
  mix,
}

class PersonalpronomenAkkFrage {
  const PersonalpronomenAkkFrage({
    required this.nr,
    required this.teil,
    required this.beforeGap,
    required this.afterGap,
    required this.options,
    required this.correctIndex,
    required this.solutionDe,
  });

  final int nr;
  final PersonalpronomenAkkTeil teil;
  final String beforeGap;
  final String afterGap;
  final List<String> options;
  final int correctIndex;
  final String solutionDe;
}

List<PersonalpronomenAkkFrage> allPersonalpronomenAkkFragen() {
  return const [
'''

footer = '''  ];
}

String personalpronomenAkkTeilLabelDe(PersonalpronomenAkkTeil t) {
  return switch (t) {
    PersonalpronomenAkkTeil.ersatz => 'Teil 1: Substantiv → Pronomen',
    PersonalpronomenAkkTeil.luecke => 'Teil 2: Lücken',
    PersonalpronomenAkkTeil.wahl => 'Teil 3: Wahl',
    PersonalpronomenAkkTeil.verben => 'Teil 4: Verben + Pronomen',
    PersonalpronomenAkkTeil.praeposition => 'Teil 5: Präposition + Akk.',
    PersonalpronomenAkkTeil.mix => 'Teil 6: Gemischt / Fallen',
  };
}
'''

# const list cannot use non-const - remove const from return
header = header.replace("return const [", "return [")

OUT.write_text(header + "\n".join(chunks) + "\n" + footer, encoding="utf-8")
print("Wrote", OUT, "questions", len(chunks))
