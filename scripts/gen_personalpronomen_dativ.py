#!/usr/bin/env python3
"""Генерирует lib/data/personalpronomen_dativ_questions.dart"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "lib/data/personalpronomen_dativ_questions.dart"


def esc(s: str) -> str:
    return s.replace("\\", r"\\").replace("'", r"\'")


def q(nr, teil, before, after, opts, ci, sol):
    opts_s = ", ".join(f"'{esc(o)}'" for o in opts)
    return f'''    PersonalpronomenDatFrage(
      nr: {nr},
      teil: PersonalpronomenDatTeil.{teil},
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
    ("Ich helfe dem Vater. → Ich helfe ", ".", "ihm", ["ihm", "ihr", "ihnen"], "Ich helfe ihm."),
    ("Du hilfst der Mutter. → Du hilfst ", ".", "ihr", ["ihm", "ihr", "ihnen"], "Du hilfst ihr."),
    ("Er hilft dem Kind. → Er hilft ", ".", "ihm", ["ihm", "ihr", "uns"], "Er hilft ihm."),
    ("Wir helfen den Freunden. → Wir helfen ", ".", "ihnen", ["ihm", "ihr", "ihnen"], "Wir helfen ihnen."),
    ("Ihr helft dem Lehrer. → Ihr helft ", ".", "ihm", ["ihm", "ihr", "euch"], "Ihr helft ihm."),
    ("Sie hilft der Blume. → Sie hilft ", ".", "ihr", ["ihm", "ihr", "uns"], "Sie hilft ihr."),
    ("Ich danke meiner Frau. → Ich danke ", ".", "ihr", ["ihm", "ihr", "uns"], "Ich danke ihr."),
    ("Du dankst meinem Bruder. → Du dankst ", ".", "ihm", ["ihm", "ihr", "dir"], "Du dankst ihm."),
    ("Er dankt dem Chef. → Er dankt ", ".", "ihm", ["ihm", "ihr", "ihnen"], "Er dankt ihm."),
    ("Wir danken den Eltern. → Wir danken ", ".", "ihnen", ["ihm", "ihr", "ihnen"], "Wir danken ihnen."),
    ("Ihr dankt dem Arzt. → Ihr dankt ", ".", "ihm", ["ihm", "ihr", "euch"], "Ihr dankt ihm."),
    ("Sie danken der Krankenschwester. → Sie danken ", ".", "ihr", ["ihm", "ihr", "ihnen"], "Sie danken ihr."),
    ("Das Buch gefällt dem Kind. → Das Buch gefällt ", ".", "ihm", ["ihm", "ihr", "ihnen"], "Das Buch gefällt ihm."),
    ("Das Auto gehört dem Nachbarn. → Das Auto gehört ", ".", "ihm", ["ihm", "ihr", "uns"], "Das Auto gehört ihm."),
    ("Die Blume gehört der Freundin. → Die Blume gehört ", ".", "ihr", ["ihm", "ihr", "ihnen"], "Die Blume gehört ihr."),
    ("Der Hund gehört den Kindern. → Der Hund gehört ", ".", "ihnen", ["ihm", "ihr", "ihnen"], "Der Hund gehört ihnen."),
    ("Ich antworte dem Professor. → Ich antworte ", ".", "ihm", ["ihm", "ihr", "uns"], "Ich antworte ihm."),
    ("Du antwortest der Lehrerin. → Du antwortest ", ".", "ihr", ["ihm", "ihr", "dir"], "Du antwortest ihr."),
    ("Er antwortet den Studenten. → Er antwortet ", ".", "ihnen", ["ihm", "ihr", "ihnen"], "Er antwortet ihnen."),
    ("Die Schuhe passen dem Mann. → Die Schuhe passen ", ".", "ihm", ["ihm", "ihr", "uns"], "Die Schuhe passen ihm."),
    ("Die Pizza schmeckt der Frau. → Die Pizza schmeckt ", ".", "ihr", ["ihm", "ihr", "euch"], "Die Pizza schmeckt ihr."),
    ("Das Lied gefällt dem Mädchen. → Das Lied gefällt ", ".", "ihm", ["ihm", "ihr", "ihnen"], "Das Lied gefällt ihm."),
    ("Ich glaube dem Arzt. → Ich glaube ", ".", "ihm", ["ihm", "ihr", "mir"], "Ich glaube ihm."),
    ("Du glaubst der Ärztin. → Du glaubst ", ".", "ihr", ["ihm", "ihr", "dir"], "Du glaubst ihr."),
    ("Er glaubt den Eltern. → Er glaubt ", ".", "ihnen", ["ihm", "ihr", "ihnen"], "Er glaubt ihnen."),
    ("Ich gratuliere dem Freund. → Ich gratuliere ", ".", "ihm", ["ihm", "ihr", "mir"], "Ich gratuliere ihm."),
    ("Du gratulierst der Schwester. → Du gratulierst ", ".", "ihr", ["ihm", "ihr", "dir"], "Du gratulierst ihr."),
    ("Er gratuliert den Kollegen. → Er gratuliert ", ".", "ihnen", ["ihm", "ihr", "ihnen"], "Er gratuliert ihnen."),
    ("Ich vertraue dem Anwalt. → Ich vertraue ", ".", "ihm", ["ihm", "ihr", "mir"], "Ich vertraue ihm."),
    ("Du vertraust der Polizistin. → Du vertraust ", ".", "ihr", ["ihm", "ihr", "dir"], "Du vertraust ihr."),
]
for i, row in enumerate(p1, 1):
    b, a, ans, opts, sol = row
    chunks.append(q(i, "ersatz", b, a, opts, idx(opts, ans), sol))

# Teil 2 (31–60)
p2 = [
    ("Ich helfe ", ".", "dir", ["mir", "dir", "ihm"], "Ich helfe dir."),
    ("Du hilfst ", ".", "mir", ["mir", "dir", "uns"], "Du hilfst mir."),
    ("Er hilft ", ".", "ihr", ["ihm", "ihr", "ihnen"], "Er hilft ihr."),
    ("Wir helfen ", ".", "ihm", ["ihm", "ihr", "uns"], "Wir helfen ihm."),
    ("Ihr helft ", ".", "uns", ["uns", "euch", "ihnen"], "Ihr helft uns."),
    ("Sie helfen ", ".", "euch", ["uns", "euch", "ihnen"], "Sie helfen euch."),
    ("Ich danke ", ".", "Ihnen", ["Ihnen", "ihnen", "ihr"], "Ich danke Ihnen."),
    ("Du dankst ", ".", "mir", ["mir", "dir", "ihm"], "Du dankst mir."),
    ("Er dankt ", ".", "ihr", ["ihm", "ihr", "uns"], "Er dankt ihr."),
    ("Wir danken ", ".", "dir", ["mir", "dir", "uns"], "Wir danken dir."),
    ("Ihr dankt ", ".", "ihm", ["ihm", "ihr", "euch"], "Ihr dankt ihm."),
    ("Sie dankt ", ".", "uns", ["uns", "euch", "ihnen"], "Sie dankt uns."),
    ("Das Buch gefällt ", ".", "mir", ["mir", "dir", "ihm"], "Das Buch gefällt mir."),
    ("Das Auto gehört ", ".", "dir", ["mir", "dir", "ihm"], "Das Auto gehört dir."),
    ("Die Blume gefällt ", ".", "ihr", ["ihm", "ihr", "uns"], "Die Blume gefällt ihr."),
    ("Der Hund gehört ", ".", "ihm", ["ihm", "ihr", "uns"], "Der Hund gehört ihm."),
    ("Die Schuhe passen ", ".", "uns", ["uns", "euch", "ihnen"], "Die Schuhe passen uns."),
    ("Die Pizza schmeckt ", ".", "euch", ["uns", "euch", "ihnen"], "Die Pizza schmeckt euch."),
    ("Das Lied gefällt ", ".", "ihnen", ["ihm", "ihr", "ihnen"], "Das Lied gefällt ihnen."),
    ("Ich antworte ", ".", "Ihnen", ["Ihnen", "mir", "dir"], "Ich antworte Ihnen."),
    ("Du antwortest ", ".", "mir", ["mir", "dir", "ihm"], "Du antwortest mir."),
    ("Er antwortet ", ".", "dir", ["mir", "dir", "ihm"], "Er antwortet dir."),
    ("Wir antworten ", ".", "ihr", ["ihm", "ihr", "uns"], "Wir antworten ihr."),
    ("Ihr antwortet ", ".", "ihm", ["ihm", "ihr", "euch"], "Ihr antwortet ihm."),
    ("Sie antwortet ", ".", "uns", ["uns", "euch", "ihnen"], "Sie antwortet uns."),
    ("Sie antworten ", ".", "euch", ["uns", "euch", "ihnen"], "Sie antworten euch."),
    ("Ich glaube ", ".", "Ihnen", ["Ihnen", "mir", "ihm"], "Ich glaube Ihnen."),
    ("Du glaubst ", ".", "mir", ["mir", "dir", "ihm"], "Du glaubst mir."),
    ("Er glaubt ", ".", "ihr", ["ihm", "ihr", "ihnen"], "Er glaubt ihr."),
    ("Wir glauben ", ".", "ihnen", ["ihm", "ihr", "ihnen"], "Wir glauben ihnen."),
]
for i, row in enumerate(p2, 31):
    b, a, ans, opts, sol = row
    chunks.append(q(i, "luecke", b, a, opts, idx(opts, ans), sol))

# Teil 3 (61–90)
p3 = [
    ("Kannst du ", " helfen?", ["ich", "mir", "mich"], "mir", "Kannst du mir helfen?"),
    ("Ich danke ", ".", ["du", "dich", "dir"], "dir", "Ich danke dir."),
    ("Das Buch gefällt ", ".", ["er", "ihn", "ihm"], "ihm", "Das Buch gefällt ihm."),
    ("Das Auto gehört ", ".", ["sie", "ihr", "ihnen"], "ihr", "Das Auto gehört ihr."),
    ("Die Schuhe passen ", ".", ["wir", "uns", "euch"], "uns", "Die Schuhe passen uns."),
    ("Die Pizza schmeckt ", ".", ["ihr", "euch", "sie"], "euch", "Die Pizza schmeckt euch."),
    ("Ich antworte ", ".", ["Sie", "Ihnen", "dir"], "Ihnen", "Ich antworte Ihnen."),
    ("Ich glaube ", ".", ["er", "ihn", "ihm"], "ihm", "Ich glaube ihm."),
    ("Kommst du mit ", "?", ["ich", "mich", "mir"], "mir", "Kommst du mit mir?"),
    ("Das Geschenk ist von ", ".", ["sie", "ihr", "ihnen"], "ihr", "Das Geschenk ist von ihr."),
    ("Ich wohne bei ", ".", ["du", "dich", "dir"], "dir", "Ich wohne bei dir."),
    ("Gehst du zu ", "?", ["er", "ihn", "ihm"], "ihm", "Gehst du zu ihm?"),
    ("Das ist für ", "? (für + Akkusativ)", ["du", "dich", "dir"], "dich", "Das ist für dich?"),
    ("Mir gegenüber sitzt ", ". (Nominativ!)", ["du", "dich", "dir"], "du", "Mir gegenüber sitzt du."),
    ("Außer ", " ist niemand da.", ["ich", "mich", "mir"], "mir", "Außer mir ist niemand da."),
    ("Ich gratuliere ", ".", ["du", "dich", "dir"], "dir", "Ich gratuliere dir."),
    ("Ich vertraue ", ".", ["sie", "ihr", "ihnen"], "ihr", "Ich vertraue ihr."),
    ("Rauchen schadet ", ".", ["du", "dich", "dir"], "dir", "Rauchen schadet dir."),
    ("Ich empfehle ", " dieses Hotel.", ["Sie", "Ihnen", "ihr"], "Ihnen", "Ich empfehle Ihnen dieses Hotel."),
    ("Nach ", " kommt niemand.", ["ich", "mich", "mir"], "mir", "Nach mir kommt niemand."),
    ("Das gehört ", ".", ["er", "ihn", "ihm"], "ihm", "Das gehört ihm."),
    ("Ich helfe ", ".", ["sie", "ihr", "ihnen"], "ihr", "Ich helfe ihr."),
    ("Du dankst ", ".", ["wir", "uns", "euch"], "uns", "Du dankst uns."),
    ("Er antwortet ", ".", ["sie", "ihr", "ihnen"], "ihnen", "Er antwortet ihnen."),
    ("Wir glauben ", ".", ["du", "dich", "dir"], "dir", "Wir glauben dir."),
    ("Ihr helft ", ".", ["ich", "mir", "mich"], "mir", "Ihr helft mir."),
    ("Sie hilft ", ".", ["er", "ihm", "ihn"], "ihm", "Sie hilft ihm."),
    ("Es gefällt ", ".", ["sie", "ihr", "ihnen"], "ihr", "Es gefällt ihr."),
    ("Die Tasche gehört ", ".", ["wir", "uns", "euch"], "uns", "Die Tasche gehört uns."),
    ("Der Kaffee schmeckt ", ".", ["ich", "mir", "mich"], "mir", "Der Kaffee schmeckt mir."),
]
for i, row in enumerate(p3, 61):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "wahl", b, a, opts, idx(opts, ans), sol))

# Teil 4 (91–120)
p4 = [
    ("Kannst du ", " helfen?", ["mir", "mich", "dir"], "mir", "Kannst du mir helfen?"),
    ("Ich danke ", " für deine Hilfe.", ["dir", "dich", "mir"], "dir", "Ich danke dir für deine Hilfe."),
    ("Das Buch gefällt ", " sehr.", ["ihm", "ihn", "ihr"], "ihm", "Das Buch gefällt ihm sehr."),
    ("Das Auto gehört ", " nicht.", ["uns", "ihm", "euch"], "uns", "Das Auto gehört uns nicht."),
    ("Der Lehrer antwortet ", " nicht.", ["euch", "uns", "ihnen"], "euch", "Der Lehrer antwortet euch nicht."),
    ("Die Schuhe passen ", " perfekt.", ["ihr", "ihnen", "ihm"], "ihr", "Die Schuhe passen ihr perfekt."),
    ("Die Pizza schmeckt ", " gut.", ["ihnen", "ihm", "uns"], "ihnen", "Die Pizza schmeckt ihnen gut."),
    ("", " das Geld.", ["Mir fehlt", "Ich fehle", "Mich fehlt"], "Mir fehlt", "Mir fehlt das Geld."),
    ("Ich glaube ", " nicht.", ["dir", "dich", "du"], "dir", "Ich glaube dir nicht."),
    ("Ich höre ", " zu.", ["ihm", "ihn", "ihr"], "ihm", "Ich höre ihm zu."),
    ("Ich vertraue ", " völlig.", ["euch", "uns", "ihnen"], "euch", "Ich vertraue euch völlig."),
    ("Wir gratulieren ", " zum Geburtstag.", ["euch", "uns", "ihnen"], "euch", "Wir gratulieren euch zum Geburtstag."),
    ("Das Rauchen schadet ", ".", ["ihr", "ihm", "ihnen"], "ihr", "Das Rauchen schadet ihr."),
    ("Wir helfen ", " bei der Arbeit.", ["ihnen", "ihr", "euch"], "ihnen", "Wir helfen ihnen bei der Arbeit."),
    ("Er ", " herzlich.", ["dankt mir", "danke mir", "dankt mich"], "dankt mir", "Er dankt mir herzlich."),
    ("Die Blume gefällt ", "?", ["dir", "dich", "du"], "dir", "Die Blume gefällt dir?"),
    ("Das Haus ", ".", ["gehört ihm", "gehört ihn", "gehört er"], "gehört ihm", "Das Haus gehört ihm."),
    ("Die Studentin antwortet ", " schnell.", ["uns", "euch", "ihnen"], "uns", "Die Studentin antwortet uns schnell."),
    ("Die Hose ", " gut.", ["passt euch", "passen euch", "passt ihr"], "passt euch", "Die Hose passt euch gut."),
    ("Der Kuchen ", ".", ["schmeckt ihr", "schmeckt sie", "schmeckt ihnen"], "schmeckt ihr", "Der Kuchen schmeckt ihr."),
    ("", " die Zeit.", ["Mir fehlt", "Mir fehlen", "Ich fehle"], "Mir fehlt", "Mir fehlt die Zeit."),
    ("Die Leute ", " nicht.", ["glauben dir", "glaubst dir", "glauben dich"], "glauben dir", "Die Leute glauben dir nicht."),
    ("Die Kinder hören ", " aufmerksam zu.", ["ihm", "ihn", "ihr"], "ihm", "Die Kinder hören ihm aufmerksam zu."),
    ("Die Firma vertraut ", ".", ["uns", "euch", "ihnen"], "uns", "Die Firma vertraut uns."),
    ("Die Kollegen gratulieren ", ".", ["euch", "uns", "ihnen"], "euch", "Die Kollegen gratulieren euch."),
    ("Die Lügen schaden ", ".", ["ihnen", "ihm", "ihr"], "ihnen", "Die Lügen schaden ihnen."),
    ("Hilf ", " bitte!", ["mir", "mich", "dir"], "mir", "Hilf mir bitte!"),
    ("Wir danken ", " für alles.", ["dir", "dich", "mir"], "dir", "Wir danken dir für alles."),
    ("Die Idee gefällt ", " sehr.", ["ihm", "ihr", "ihnen"], "ihm", "Die Idee gefällt ihm sehr."),
    ("Die Zukunft ", ".", ["gehört uns", "gehören uns", "gehört ihnen"], "gehört uns", "Die Zukunft gehört uns."),
]
for i, row in enumerate(p4, 91):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "verben", b, a, opts, idx(opts, ans), sol))

# Teil 5 (121–135)
p5 = [
    ("Kommst du mit ", "?", ["mir", "mich", "ich"], "mir", "Kommst du mit mir?"),
    ("Ich wohne bei ", ".", ["dir", "dich", "du"], "dir", "Ich wohne bei dir."),
    ("Das Geschenk ist von ", ".", ["ihm", "ihn", "er"], "ihm", "Das Geschenk ist von ihm."),
    ("Ich gehe zu ", ".", ["dir", "dich", "du"], "dir", "Ich gehe zu dir."),
    ("Er kommt aus ", ". (ungewöhnlich)", ["mir", "mich", "ich"], "mir", "Er kommt aus mir."),
    ("Nach ", " kommst du.", ["mir", "mich", "ich"], "mir", "Nach mir kommst du."),
    ("Außer ", " ist niemand da.", ["mir", "mich", "ich"], "mir", "Außer mir ist niemand da."),
    ("Mir gegenüber sitzt ", ". (Nominativ!)", ["du", "dir", "dich"], "du", "Mir gegenüber sitzt du."),
    ("Ich gehe mit ", " ins Kino.", ["dir", "dich", "du"], "dir", "Ich gehe mit dir ins Kino."),
    ("Das Buch ist von ", ".", ["ihr", "sie", "ihnen"], "ihr", "Das Buch ist von ihr."),
    ("Ich fahre zu ", ".", ["Ihnen", "Sie", "ihnen"], "Ihnen", "Ich fahre zu Ihnen."),
    ("Er wohnt bei ", ". (Schwester)", ["ihr", "ihnen", "sie"], "ihr", "Er wohnt bei ihr."),
    ("Kommst du von ", "? (Plural «они»)", ["ihnen", "ihr", "ihm"], "ihnen", "Kommst du von ihnen?"),
    ("Ich bin mit ", " zufrieden.", ["uns", "euch", "ihnen"], "uns", "Ich bin mit uns zufrieden."),
    ("Gehst du mit ", " nach Hause?", ["mir", "mich", "ich"], "mir", "Gehst du mit mir nach Hause?"),
]
for i, row in enumerate(p5, 121):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "praeposition", b, a, opts, idx(opts, ans), sol))

# Teil 6 (136–150)
p6 = [
    ("Ich helfe dem Mann. → Ich helfe ", ".", ["ihm", "ihr", "ihnen"], "ihm", "Ich helfe ihm."),
    ("Du dankst der Frau. → Du dankst ", ".", ["ihr", "ihm", "ihnen"], "ihr", "Du dankst ihr."),
    ("Er antwortet dem Kind. → Er antwortet ", ".", ["ihm", "ihr", "ihnen"], "ihm", "Er antwortet ihm."),
    ("Wir helfen den Kindern. → Wir helfen ", ".", ["ihnen", "ihm", "ihr"], "ihnen", "Wir helfen ihnen."),
    ("Ihr dankt dem Lehrer. → Ihr dankt ", ".", ["ihm", "ihr", "euch"], "ihm", "Ihr dankt ihm."),
    ("Das Buch gefällt der Studentin. → Das Buch gefällt ", ".", ["ihr", "ihm", "ihnen"], "ihr", "Das Buch gefällt ihr."),
    ("Das Auto gehört den Eltern. → Das Auto gehört ", ".", ["ihnen", "ihm", "ihr"], "ihnen", "Das Auto gehört ihnen."),
    ("Kannst du ", " helfen?", ["ich", "mir", "mich"], "mir", "Kannst du mir helfen?"),
    ("Ich danke ", ".", ["du", "dich", "dir"], "dir", "Ich danke dir."),
    ("Das Geschenk ist für ", "? (für + Akkusativ)", ["er", "ihn", "ihm"], "ihn", "Das Geschenk ist für ihn?"),
    ("Kommst du mit ", "?", ["ich", "mir", "mich"], "mir", "Kommst du mit mir?"),
    ("Ich wohne bei ", ". (Bruder)", ["er", "ihm", "ihn"], "ihm", "Ich wohne bei ihm."),
    ("Das gehört ", ".", ["sie", "ihr", "ihnen"], "ihr", "Das gehört ihr."),
    ("Ich gratuliere ", ".", ["du", "dich", "dir"], "dir", "Ich gratuliere dir."),
    ("Vertraust du ", "?", ["ich", "mir", "mich"], "mir", "Vertraust du mir?"),
]
for i, row in enumerate(p6, 136):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "mix", b, a, opts, idx(opts, ans), sol))

header = '''/// Упражнения: Personalpronomen im Dativ (A1 / Start Deutsch 1).
enum PersonalpronomenDatTeil {
  ersatz,
  luecke,
  wahl,
  verben,
  praeposition,
  mix,
}

class PersonalpronomenDatFrage {
  const PersonalpronomenDatFrage({
    required this.nr,
    required this.teil,
    required this.beforeGap,
    required this.afterGap,
    required this.options,
    required this.correctIndex,
    required this.solutionDe,
  });

  final int nr;
  final PersonalpronomenDatTeil teil;
  final String beforeGap;
  final String afterGap;
  final List<String> options;
  final int correctIndex;
  final String solutionDe;
}

List<PersonalpronomenDatFrage> allPersonalpronomenDatFragen() {
  return [
'''

footer = '''  ];
}

String personalpronomenDatTeilLabelDe(PersonalpronomenDatTeil t) {
  return switch (t) {
    PersonalpronomenDatTeil.ersatz => 'Teil 1: Substantiv → Pronomen (Dat.)',
    PersonalpronomenDatTeil.luecke => 'Teil 2: Lücken',
    PersonalpronomenDatTeil.wahl => 'Teil 3: Wahl',
    PersonalpronomenDatTeil.verben => 'Teil 4: Verben + Pronomen',
    PersonalpronomenDatTeil.praeposition => 'Teil 5: Präposition + Dat.',
    PersonalpronomenDatTeil.mix => 'Teil 6: Gemischt / Fallen',
  };
}
'''

OUT.write_text(header + "\n".join(chunks) + "\n" + footer, encoding="utf-8")
print("Wrote", OUT, "questions", len(chunks))
