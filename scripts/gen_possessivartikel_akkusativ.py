#!/usr/bin/env python3
"""Генерирует lib/data/possessivartikel_akkusativ_questions.dart"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "lib/data/possessivartikel_akkusativ_questions.dart"


def esc(s: str) -> str:
    return s.replace("\\", r"\\").replace("'", r"\'")


def q(nr, teil, before, after, opts, ci, sol):
    opts_s = ", ".join(f"'{esc(o)}'" for o in opts)
    return f'''    PossessivartikelAkkFrage(
      nr: {nr},
      teil: PossessivartikelAkkTeil.{teil},
      beforeGap: '{esc(before)}',
      afterGap: '{esc(after)}',
      options: [{opts_s}],
      correctIndex: {ci},
      solutionDe: '{esc(sol)}',
    ),'''


def idx(opts, ans):
    return opts.index(ans)


chunks = []

# Teil 1 (1–20): den/die/das → mein*
p1 = [
    ("Ich sehe den Bruder. → Ich sehe ", " Bruder.", "meinen", ["meinen", "meine", "mein"], "Ich sehe meinen Bruder."),
    ("Ich sehe die Schwester. → Ich sehe ", " Schwester.", "meine", ["meinen", "meine", "mein"], "Ich sehe meine Schwester."),
    ("Ich sehe das Kind. → Ich sehe ", " Kind.", "mein", ["meinen", "meine", "mein"], "Ich sehe mein Kind."),
    ("Ich sehe die Eltern. → Ich sehe ", " Eltern.", "meine", ["meinen", "meine", "mein"], "Ich sehe meine Eltern."),
    ("Ich liebe den Mann. → Ich liebe ", " Mann.", "meinen", ["meinen", "meine", "mein"], "Ich liebe meinen Mann."),
    ("Ich liebe die Frau. → Ich liebe ", " Frau.", "meine", ["meinen", "meine", "mein"], "Ich liebe meine Frau."),
    ("Ich liebe das Baby. → Ich liebe ", " Baby.", "mein", ["meinen", "meine", "mein"], "Ich liebe mein Baby."),
    ("Ich liebe die Kinder. → Ich liebe ", " Kinder.", "meine", ["meinen", "meine", "mein"], "Ich liebe meine Kinder."),
    ("Ich nehme den Kugelschreiber. → Ich nehme ", " Kugelschreiber.", "meinen", ["meinen", "meine", "mein"], "Ich nehme meinen Kugelschreiber."),
    ("Ich nehme die Tasche. → Ich nehme ", " Tasche.", "meine", ["meinen", "meine", "mein"], "Ich nehme meine Tasche."),
    ("Ich nehme das Buch. → Ich nehme ", " Buch.", "mein", ["meinen", "meine", "mein"], "Ich nehme mein Buch."),
    ("Ich nehme die Stifte. → Ich nehme ", " Stifte.", "meine", ["meinen", "meine", "mein"], "Ich nehme meine Stifte."),
    ("Ich besuche den Lehrer. → Ich besuche ", " Lehrer.", "meinen", ["meinen", "meine", "mein"], "Ich besuche meinen Lehrer."),
    ("Ich besuche die Lehrerin. → Ich besuche ", " Lehrerin.", "meine", ["meinen", "meine", "mein"], "Ich besuche meine Lehrerin."),
    ("Ich besuche das Büro. → Ich besuche ", " Büro.", "mein", ["meinen", "meine", "mein"], "Ich besuche mein Büro."),
    ("Ich besuche die Kollegen. → Ich besuche ", " Kollegen.", "meine", ["meinen", "meine", "mein"], "Ich besuche meine Kollegen."),
    ("Ich wasche den Wagen. → Ich wasche ", " Wagen.", "meinen", ["meinen", "meine", "mein"], "Ich wasche meinen Wagen."),
    ("Ich wasche die Fenster. → Ich wasche ", " Fenster.", "meine", ["meinen", "meine", "mein"], "Ich wasche meine Fenster."),
    ("Ich öffne das Fenster. → Ich öffne ", " Fenster.", "mein", ["meinen", "meine", "mein"], "Ich öffne mein Fenster."),
    ("Ich schließe die Tür. → Ich schließe ", " Tür.", "meine", ["meinen", "meine", "mein"], "Ich schließe meine Tür."),
]
for i, row in enumerate(p1, 1):
    b, a, ans, opts, sol = row
    chunks.append(q(i, "ersetzMein", b, a, opts, idx(opts, ans), sol))

# Teil 2 (21–40)
p2 = [
    ("Du siehst den Vater. → Du siehst ", " Vater.", "deinen", ["deinen", "deine", "dein"], "Du siehst deinen Vater."),
    ("Er sieht die Mutter. → Er sieht ", " Mutter.", "seine", ["seinen", "seine", "sein"], "Er sieht seine Mutter."),
    ("Sie sieht das Kind. → Sie sieht ", " Kind.", "ihr", ["ihren", "ihre", "ihr"], "Sie sieht ihr Kind."),
    ("Wir sehen die Freunde. → Wir sehen ", " Freunde.", "unsere", ["unseren", "unsere", "unser"], "Wir sehen unsere Freunde."),
    ("Ihr seht den Lehrer. → Ihr seht ", " Lehrer.", "euren", ["euren", "eure", "euer"], "Ihr seht euren Lehrer."),
    ("Sie sehen die Blume. → Sie sehen ", " Blume.", "ihre", ["ihren", "ihre", "ihr"], "Sie sehen ihre Blume."),
    ("Ich liebe die Frau. → Ich liebe ", " Frau.", "meine", ["meinen", "meine", "mein"], "Ich liebe meine Frau."),
    ("Du liebst den Mann. → Du liebst ", " Mann.", "deinen", ["deinen", "deine", "dein"], "Du liebst deinen Mann."),
    ("Er liebt das Auto. → Er liebt ", " Auto.", "sein", ["seinen", "seine", "sein"], "Er liebt sein Auto."),
    ("Sie nimmt die Tasche. → Sie nimmt ", " Tasche.", "ihre", ["ihren", "ihre", "ihr"], "Sie nimmt ihre Tasche."),
    ("Wir nehmen den Koffer. → Wir nehmen ", " Koffer.", "unseren", ["unseren", "unsere", "unser"], "Wir nehmen unseren Koffer."),
    ("Ihr nehmt das Handy. → Ihr nehmt ", " Handy.", "euer", ["euren", "eure", "euer"], "Ihr nehmt euer Handy."),
    ("Sie besuchen die Eltern. → Sie besuchen ", " Eltern.", "ihre", ["ihren", "ihre", "ihr"], "Sie besuchen ihre Eltern."),
    ("Ich wasche den Hund. → Ich wasche ", " Hund.", "meinen", ["meinen", "meine", "mein"], "Ich wasche meinen Hund."),
    ("Du putzt die Fenster. → Du putzt ", " Fenster.", "deine", ["deinen", "deine", "dein"], "Du putzt deine Fenster."),
    ("Er öffnet das Fenster. → Er öffnet ", " Fenster.", "sein", ["seinen", "seine", "sein"], "Er öffnet sein Fenster."),
    ("Wir schließen die Tür. → Wir schließen ", " Tür.", "unsere", ["unseren", "unsere", "unser"], "Wir schließen unsere Tür."),
    ("Ihr kauft den Tisch. → Ihr kauft ", " Tisch.", "euren", ["euren", "eure", "euer"], "Ihr kauft euren Tisch."),
    ("Sie kauft die Lampe. → Sie kauft ", " Lampe.", "ihre", ["ihren", "ihre", "ihr"], "Sie kauft ihre Lampe."),
    ("Sie sehen den Chef. → Sie sehen ", " Chef.", "Ihren", ["Ihren", "Ihre", "Ihr"], "Sie sehen Ihren Chef."),
]
for i, row in enumerate(p2, 21):
    b, a, ans, opts, sol = row
    chunks.append(q(i, "ersetzAlle", b, a, opts, idx(opts, ans), sol))

# Teil 3 (41–70)
p3 = [
    ("Ich liebe ", " Mutter.", "meine", ["meinen", "meine", "mein"], "Ich liebe meine Mutter."),
    ("Du liebst ", " Vater.", "deinen", ["deinen", "deine", "dein"], "Du liebst deinen Vater."),
    ("Er liebt ", " Frau.", "seine", ["seinen", "seine", "sein"], "Er liebt seine Frau."),
    ("Sie liebt ", " Mann.", "ihren", ["ihren", "ihre", "ihr"], "Sie liebt ihren Mann."),
    ("Wir lieben ", " Kinder.", "unsere", ["unseren", "unsere", "unser"], "Wir lieben unsere Kinder."),
    ("Ihr liebt ", " Eltern.", "eure", ["euren", "eure", "euer"], "Ihr liebt eure Eltern."),
    ("Sie lieben ", " Lehrer.", "ihren", ["ihren", "ihre", "ihr"], "Sie lieben ihren Lehrer."),
    ("Ich nehme ", " Tasche.", "meine", ["meinen", "meine", "mein"], "Ich nehme meine Tasche."),
    ("Du nimmst ", " Kugelschreiber.", "deinen", ["deinen", "deine", "dein"], "Du nimmst deinen Kugelschreiber."),
    ("Er nimmt ", " Buch.", "sein", ["seinen", "seine", "sein"], "Er nimmt sein Buch."),
    ("Sie nimmt ", " Schlüssel.", "ihren", ["ihren", "ihre", "ihr"], "Sie nimmt ihren Schlüssel."),
    ("Wir nehmen ", " Koffer.", "unseren", ["unseren", "unsere", "unser"], "Wir nehmen unseren Koffer."),
    ("Ihr nehmt ", " Handys.", "eure", ["euren", "eure", "euer"], "Ihr nehmt eure Handys."),
    ("Sie nehmen ", " Taschen.", "ihre", ["ihren", "ihre", "ihr"], "Sie nehmen ihre Taschen."),
    ("Ich sehe ", " Bruder.", "meinen", ["meinen", "meine", "mein"], "Ich sehe meinen Bruder."),
    ("Du siehst ", " Schwester.", "deine", ["deinen", "deine", "dein"], "Du siehst deine Schwester."),
    ("Er sieht ", " Kind.", "sein", ["seinen", "seine", "sein"], "Er sieht sein Kind."),
    ("Sie sieht ", " Freunde.", "ihre", ["ihren", "ihre", "ihr"], "Sie sieht ihre Freunde."),
    ("Wir sehen ", " Hund.", "unseren", ["unseren", "unsere", "unser"], "Wir sehen unseren Hund."),
    ("Ihr seht ", " Katze.", "eure", ["euren", "eure", "euer"], "Ihr seht eure Katze."),
    ("Sie sehen ", " Haus.", "ihr", ["ihren", "ihre", "ihr"], "Sie sehen ihr Haus."),
    ("Ich wasche ", " Auto.", "mein", ["meinen", "meine", "mein"], "Ich wasche mein Auto."),
    ("Du wäschst ", " Fahrrad.", "dein", ["deinen", "deine", "dein"], "Du wäschst dein Fahrrad."),
    ("Er wäscht ", " Hände.", "seine", ["seinen", "seine", "sein"], "Er wäscht seine Hände."),
    ("Wir putzen ", " Wohnung.", "unsere", ["unseren", "unsere", "unser"], "Wir putzen unsere Wohnung."),
    ("Ihr putzt ", " Zimmer.", "euer", ["euren", "eure", "euer"], "Ihr putzt euer Zimmer."),
    ("Sie putzt ", " Küche.", "ihre", ["ihren", "ihre", "ihr"], "Sie putzt ihre Küche."),
    ("Ich öffne ", " Fenster.", "mein", ["meinen", "meine", "mein"], "Ich öffne mein Fenster."),
    ("Du öffnest ", " Tür.", "deine", ["deinen", "deine", "dein"], "Du öffnest deine Tür."),
    ("Er öffnet ", " Geschenk.", "sein", ["seinen", "seine", "sein"], "Er öffnet sein Geschenk."),
]
for i, row in enumerate(p3, 41):
    b, a, ans, opts, sol = row
    chunks.append(q(i, "luecke", b, a, opts, idx(opts, ans), sol))

# Teil 4 (71–100)
p4 = [
    ("Ich sehe ", " Vater.", ["mein", "meine", "meinen"], "meinen", "Ich sehe meinen Vater."),
    ("Ich sehe ", " Mutter.", ["mein", "meine", "meinen"], "meine", "Ich sehe meine Mutter."),
    ("Ich sehe ", " Kind.", ["mein", "meine", "meinen"], "mein", "Ich sehe mein Kind."),
    ("Ich sehe ", " Kinder.", ["mein", "meine", "meinen"], "meine", "Ich sehe meine Kinder."),
    ("Du liebst ", " Frau.", ["dein", "deine", "deinen"], "deine", "Du liebst deine Frau."),
    ("Du liebst ", " Mann.", ["dein", "deine", "deinen"], "deinen", "Du liebst deinen Mann."),
    ("Du liebst ", " Baby.", ["dein", "deine", "deinen"], "dein", "Du liebst dein Baby."),
    ("Er nimmt ", " Kugelschreiber.", ["sein", "seine", "seinen"], "seinen", "Er nimmt seinen Kugelschreiber."),
    ("Er nimmt ", " Tasche.", ["sein", "seine", "seinen"], "seine", "Er nimmt seine Tasche."),
    ("Er nimmt ", " Buch.", ["sein", "seine", "seinen"], "sein", "Er nimmt sein Buch."),
    ("Sie sucht ", " Hund.", ["ihr", "ihre", "ihren"], "ihren", "Sie sucht ihren Hund."),
    ("Sie sucht ", " Katze.", ["ihr", "ihre", "ihren"], "ihre", "Sie sucht ihre Katze."),
    ("Sie sucht ", " Schlüssel.", ["ihr", "ihre", "ihren"], "ihren", "Sie sucht ihren Schlüssel."),
    ("Wir besuchen ", " Lehrer.", ["unser", "unsere", "unseren"], "unseren", "Wir besuchen unseren Lehrer."),
    ("Wir besuchen ", " Lehrerin.", ["unser", "unsere", "unseren"], "unsere", "Wir besuchen unsere Lehrerin."),
    ("Wir besuchen ", " Klassenzimmer.", ["unser", "unsere", "unseren"], "unser", "Wir besuchen unser Klassenzimmer."),
    ("Ihr besucht ", " Chef.", ["euer", "eure", "euren"], "euren", "Ihr besucht euren Chef."),
    ("Ihr besucht ", " Sekretärin.", ["euer", "eure", "euren"], "eure", "Ihr besucht eure Sekretärin."),
    ("Ihr besucht ", " Büro.", ["euer", "eure", "euren"], "euer", "Ihr besucht euer Büro."),
    ("Sie lieben ", " Eltern.", ["ihr", "ihre", "ihren"], "ihre", "Sie lieben ihre Eltern."),
    ("Sie lieben ", " Kinder.", ["ihr", "ihre", "ihren"], "ihre", "Sie lieben ihre Kinder."),
    ("Sie verstehen ", " Wunsch.", ["Ihr", "Ihre", "Ihren"], "Ihren", "Sie verstehen Ihren Wunsch."),
    ("Sie verstehen ", " Frage.", ["Ihr", "Ihre", "Ihren"], "Ihre", "Sie verstehen Ihre Frage."),
    ("Sie verstehen ", " Problem.", ["Ihr", "Ihre", "Ihren"], "Ihr", "Sie verstehen Ihr Problem."),
    ("Ich wasche ", " Auto.", ["mein", "meine", "meinen"], "mein", "Ich wasche mein Auto."),
    ("Du putzt ", " Fenster.", ["dein", "deine", "deinen"], "deine", "Du putzt deine Fenster."),
    ("Er öffnet ", " Geschenk.", ["sein", "seine", "seinen"], "sein", "Er öffnet sein Geschenk."),
    ("Wir schließen ", " Tür.", ["unser", "unsere", "unseren"], "unsere", "Wir schließen unsere Tür."),
    ("Ihr macht ", " Hausaufgaben.", ["euer", "eure", "euren"], "eure", "Ihr macht eure Hausaufgaben."),
    ("Sie kocht ", " Suppe.", ["ihr", "ihre", "ihren"], "ihre", "Sie kocht ihre Suppe."),
]
for i, row in enumerate(p4, 71):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "wahl", b, a, opts, idx(opts, ans), sol))

# Teil 5 (101–120)
p5 = [
    ("Ich sehe ", " Freund.", "meinen", ["meinen", "meine", "mein"], "Ich sehe meinen Freund."),
    ("Du besuchst ", " Tante.", "deine", ["deinen", "deine", "dein"], "Du besuchst deine Tante."),
    ("Er liebt ", " Arbeit.", "seine", ["seinen", "seine", "sein"], "Er liebt seine Arbeit."),
    ("Sie sucht ", " Schlüssel.", "ihren", ["ihren", "ihre", "ihr"], "Sie sucht ihren Schlüssel."),
    ("Wir machen ", " Hausaufgaben.", "unsere", ["unseren", "unsere", "unser"], "Wir machen unsere Hausaufgaben."),
    ("Ihr kauft ", " Geschenke.", "eure", ["euren", "eure", "euer"], "Ihr kauft eure Geschenke."),
    ("Sie besuchen ", " Großeltern.", "ihre", ["ihren", "ihre", "ihr"], "Sie besuchen ihre Großeltern."),
    ("Ich wasche ", " Hände.", "meine", ["meinen", "meine", "mein"], "Ich wasche meine Hände."),
    ("Du putzt ", " Wohnung.", "deine", ["deinen", "deine", "dein"], "Du putzt deine Wohnung."),
    ("Er repariert ", " Fahrrad.", "sein", ["seinen", "seine", "sein"], "Er repariert sein Fahrrad."),
    ("Wir öffnen ", " Fenster.", "unser", ["unseren", "unsere", "unser"], "Wir öffnen unser Fenster."),
    ("Ihr schließt ", " Tür.", "eure", ["euren", "eure", "euer"], "Ihr schließt eure Tür."),
    ("Sie nimmt ", " Tasche.", "ihre", ["ihren", "ihre", "ihr"], "Sie nimmt ihre Tasche."),
    ("Sie nehmen ", " Koffer.", "ihre", ["ihren", "ihre", "ihr"], "Sie nehmen ihre Koffer."),
    ("Ich verstehe ", " Problem.", "mein", ["meinen", "meine", "mein"], "Ich verstehe mein Problem."),
    ("Du verstehst ", " Idee.", "deine", ["deinen", "deine", "dein"], "Du verstehst deine Idee."),
    ("Er versteht ", " Wunsch.", "seinen", ["seinen", "seine", "sein"], "Er versteht seinen Wunsch."),
    ("Wir vergessen ", " Termin.", "unseren", ["unseren", "unsere", "unser"], "Wir vergessen unseren Termin."),
    ("Ihr findet ", " Fehler.", "euren", ["euren", "eure", "euer"], "Ihr findet euren Fehler."),
    ("Sie findet ", " Fehler.", "ihren", ["ihren", "ihre", "ihr"], "Sie findet ihren Fehler."),
]
for i, row in enumerate(p5, 101):
    b, a, ans, opts, sol = row
    chunks.append(q(i, "verben", b, a, opts, idx(opts, ans), sol))

# Teil 6 (121–135)
p6 = [
    ("Das Geschenk ist für ", " Freund.", "meinen", ["meinen", "meine", "mein"], "Das Geschenk ist für meinen Freund."),
    ("Ich gehe ohne ", " Jacke nach draußen.", "meine", ["meinen", "meine", "mein"], "Ich gehe ohne meine Jacke nach draußen."),
    ("Er geht durch ", " Leben allein.", "sein", ["seinen", "seine", "sein"], "Er geht durch sein Leben allein."),
    ("Sie ist gegen ", " Plan.", "ihren", ["ihren", "ihre", "ihr"], "Sie ist gegen ihren Plan."),
    ("Es geht um ", " Zukunft.", "unsere", ["unseren", "unsere", "unser"], "Es geht um unsere Zukunft."),
    ("Das ist für ", " Kinder.", "deine", ["deinen", "deine", "dein"], "Das ist für deine Kinder."),
    ("Ich kann nicht ohne ", " Hilfe leben.", "deine", ["deinen", "deine", "dein"], "Ich kann nicht ohne deine Hilfe leben."),
    ("Wir kämpfen für ", " Rechte.", "unsere", ["unseren", "unsere", "unser"], "Wir kämpfen für unsere Rechte."),
    ("Er fährt durch ", " Stadt.", "seine", ["seinen", "seine", "sein"], "Er fährt durch seine Stadt."),
    ("Das Geschenk ist für ", " Mutter.", "ihre", ["ihren", "ihre", "ihr"], "Das Geschenk ist für ihre Mutter."),
    ("Ich mache das ohne ", " Erlaubnis.", "deine", ["deinen", "deine", "dein"], "Ich mache das ohne deine Erlaubnis."),
    ("Sie ist gegen ", " Vorschlag.", "ihren", ["ihren", "ihre", "ihr"], "Sie ist gegen ihren Vorschlag."),
    ("Es geht um ", " Karriere.", "seine", ["seinen", "seine", "sein"], "Es geht um seine Karriere."),
    ("Das ist für ", " Freunde.", "unsere", ["unseren", "unsere", "unser"], "Das ist für unsere Freunde."),
    ("Ich gehe ohne ", " Handy nicht aus dem Haus.", "mein", ["meinen", "meine", "mein"], "Ich gehe ohne mein Handy nicht aus dem Haus."),
]
for i, row in enumerate(p6, 121):
    b, a, ans, opts, sol = row
    chunks.append(q(i, "praeposition", b, a, opts, idx(opts, ans), sol))

# Teil 7 (136–150)
p7 = [
    ("Ich sehe den Hund. → Ich sehe ", " Hund.", ["meinen", "meine", "mein"], "meinen", "Ich sehe meinen Hund."),
    ("Du liebst die Katze. → Du liebst ", " Katze.", ["deinen", "deine", "dein"], "deine", "Du liebst deine Katze."),
    ("Er nimmt das Buch. → Er nimmt ", " Buch.", ["seinen", "seine", "sein"], "sein", "Er nimmt sein Buch."),
    ("Wir besuchen die Eltern. → Wir besuchen ", " Eltern.", ["unseren", "unsere", "unser"], "unsere", "Wir besuchen unsere Eltern."),
    ("Ihr sucht den Lehrer. → Ihr sucht ", " Lehrer.", ["euren", "eure", "euer"], "euren", "Ihr sucht euren Lehrer."),
    ("Sie wäscht das Auto. → Sie wäscht ", " Auto.", ["ihren", "ihre", "ihr"], "ihr", "Sie wäscht ihr Auto."),
    ("Sie öffnen die Tür. → Sie öffnen ", " Tür.", ["ihren", "ihre", "ihr"], "ihre", "Sie öffnen ihre Tür."),
    ("Ich liebe ", " Frau.", ["mein", "meine", "meinen"], "meine", "Ich liebe meine Frau."),
    ("Du suchst ", " Schlüssel.", ["dein", "deine", "deinen"], "deinen", "Du suchst deinen Schlüssel."),
    ("Er nimmt ", " Tasche.", ["sein", "seine", "seinen"], "seine", "Er nimmt seine Tasche."),
    ("Wir machen ", " Hausaufgaben.", ["unser", "unsere", "unseren"], "unsere", "Wir machen unsere Hausaufgaben."),
    ("Ihr besucht ", " Großeltern.", ["euer", "eure", "euren"], "eure", "Ihr besucht eure Großeltern."),
    ("Sie liebt ", " Mann.", ["ihr", "ihre", "ihren"], "ihren", "Sie liebt ihren Mann."),
    ("Sie verstehen ", " Problem.", ["Ihr", "Ihre", "Ihren"], "Ihr", "Sie verstehen Ihr Problem."),
    ("Ich sehe ", " Kinder.", ["mein", "meine", "meinen"], "meine", "Ich sehe meine Kinder."),
]
for i, row in enumerate(p7, 136):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "mix", b, a, opts, idx(opts, ans), sol))

header = '''/// Упражнения: Possessivartikel im Akkusativ (A1 / Start Deutsch 1).
enum PossessivartikelAkkTeil {
  ersetzMein,
  ersetzAlle,
  luecke,
  wahl,
  verben,
  praeposition,
  mix,
}

class PossessivartikelAkkFrage {
  const PossessivartikelAkkFrage({
    required this.nr,
    required this.teil,
    required this.beforeGap,
    required this.afterGap,
    required this.options,
    required this.correctIndex,
    required this.solutionDe,
  });

  final int nr;
  final PossessivartikelAkkTeil teil;
  final String beforeGap;
  final String afterGap;
  final List<String> options;
  final int correctIndex;
  final String solutionDe;
}

List<PossessivartikelAkkFrage> allPossessivartikelAkkFragen() {
  return [
'''

footer = '''  ];
}

String possessivartikelAkkTeilLabelDe(PossessivartikelAkkTeil t) {
  return switch (t) {
    PossessivartikelAkkTeil.ersetzMein => 'Teil 1: den/die/das → mein-',
    PossessivartikelAkkTeil.ersetzAlle => 'Teil 2: alle Personen',
    PossessivartikelAkkTeil.luecke => 'Teil 3: Lücken',
    PossessivartikelAkkTeil.wahl => 'Teil 4: Wahl',
    PossessivartikelAkkTeil.verben => 'Teil 5: Verben',
    PossessivartikelAkkTeil.praeposition => 'Teil 6: Präposition + Akk.',
    PossessivartikelAkkTeil.mix => 'Teil 7: Gemischt',
  };
}
'''

OUT.write_text(header + "\n".join(chunks) + "\n" + footer, encoding="utf-8")
print("Wrote", OUT, "questions", len(chunks))
