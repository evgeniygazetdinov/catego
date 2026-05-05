#!/usr/bin/env python3
"""Генерирует lib/data/possessivartikel_nominativ_questions.dart"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "lib/data/possessivartikel_nominativ_questions.dart"

# 15 Satz-Enden + Genus: m/f/n/p (Nominativ Subjekt)
SUF = [
    (" Vater arbeitet im Büro.", "m"),
    (" Mutter kocht gut.", "f"),
    (" Kind spielt im Garten.", "n"),
    (" Eltern sind im Urlaub.", "p"),
    (" Bruder ist 20 Jahre alt.", "m"),
    (" Schwester lernt Deutsch.", "f"),
    (" Hund bellt laut.", "m"),
    (" Katze schläft auf dem Sofa.", "f"),
    (" Haus ist groß.", "n"),
    (" Freunde kommen heute.", "p"),
    (" Lehrer heißt Herr Schmidt.", "m"),
    (" Lehrerin ist sehr nett.", "f"),
    (" Auto ist kaputt.", "n"),
    (" Bücher sind interessant.", "p"),
    (" Name ist Thomas.", "m"),
]
# Teil 2: Fahrrad statt Auto duplicate — user list
SUF2 = list(SUF)
SUF2[12] = (" Fahrrad ist neu.", "n")
SUF2[14] = (" Name ist schön.", "m")

# Teil 3: same as SUF but line 12 " Auto ist schnell" user has — keep SUF for er, only last name Peter
SUF3 = list(SUF)
SUF3[12] = (" Auto ist schnell.", "n")
SUF3[14] = (" Name ist Peter.", "m")

# Teil 4–8 use SUF with small tweaks per user (Handy, Name Anna, etc.)
SUF4 = list(SUF)
SUF4[12] = (" Handy ist neu.", "n")
SUF4[14] = (" Name ist Anna.", "m")

SUF5 = list(SUF)
SUF5[14] = (" Name ist Schmidt.", "m")

SUF6 = list(SUF)
SUF6[14] = (" Name ist unbekannt.", "m")

SUF7 = list(SUF)
SUF7[12] = (" Auto ist kaputt.", "n")
SUF7[14] = (" Name ist Müller.", "m")

SUF8 = list(SUF)
SUF8[14] = (" Name ist bitte?", "m")


def esc(s: str) -> str:
    return s.replace("\\", r"\\").replace("'", r"\'")


def q(nr, teil, before, after, opts, ci, sol):
    opts_s = ", ".join(f"'{esc(o)}'" for o in opts)
    return f'''    PossessivartikelNomFrage(
      nr: {nr},
      teil: PossessivartikelNomTeil.{teil},
      beforeGap: '{esc(before)}',
      afterGap: '{esc(after)}',
      options: [{opts_s}],
      correctIndex: {ci},
      solutionDe: '{esc(sol)}',
    ),'''


def idx(opts, ans):
    return opts.index(ans)


def pick(masc, fem, distr, g):
    if g in ("m", "n"):
        ans = masc
        opts = [masc, fem, distr]
    else:
        ans = fem
        opts = [fem, masc, distr]
    return ans, opts


def emit_block(chunks, start_nr, teil, masc, fem, distr, pairs):
    nr = start_nr
    for suf, g in pairs:
        ans, opts = pick(masc, fem, distr, g)
        sol = f"{ans}{suf}"
        chunks.append(q(nr, teil, "", suf, opts, idx(opts, ans), sol))
        nr += 1
    return nr


chunks = []
n = emit_block(chunks, 1, "lueckeIch", "Mein", "Meine", "Meinen", SUF)
n = emit_block(chunks, n, "lueckeDu", "Dein", "Deine", "Deinen", SUF2)
n = emit_block(chunks, n, "lueckeEr", "Sein", "Seine", "Seinen", SUF3)
n = emit_block(chunks, n, "lueckeSie", "Ihr", "Ihre", "Ihren", SUF4)
n = emit_block(chunks, n, "lueckeWir", "Unser", "Unsere", "Unseren", SUF5)
n = emit_block(chunks, n, "lueckeIhr", "Euer", "Eure", "Euren", SUF6)
n = emit_block(chunks, n, "lueckeSiePl", "Ihr", "Ihre", "Ihren", SUF7)
n = emit_block(chunks, n, "lueckeSieHoflich", "Ihr", "Ihre", "Ihren", SUF8)

# Teil 9 (121–135)
p9 = [
    ("", " Vater ist stark.", ["Mein", "Meine", "Dein"], "Mein", "Mein Vater ist stark."),
    ("", " Mutter kocht gut.", ["Dein", "Deine", "Meine"], "Deine", "Deine Mutter kocht gut."),
    ("", " Kind spielt Fußball.", ["Sein", "Seine", "Ihr"], "Sein", "Sein Kind spielt Fußball."),
    ("", " Eltern sind reich.", ["Ihr", "Ihre", "Eure"], "Ihre", "Ihre Eltern sind reich."),
    ("", " Bruder heißt Tom.", ["Unser", "Unsere", "Euer"], "Unser", "Unser Bruder heißt Tom."),
    ("", " Schwester singt schön.", ["Euer", "Eure", "Ihre"], "Eure", "Eure Schwester singt schön."),
    ("", " Hund ist groß.", ["Ihr", "Ihre", "Mein"], "Ihr", "Ihr Hund ist groß."),
    ("", " Katze schläft.", ["Ihr", "Ihre", "Deine"], "Ihre", "Ihre Katze schläft."),
    ("", " Freunde kommen heute.", ["Mein", "Meine", "Dein"], "Meine", "Meine Freunde kommen heute."),
    ("", " Buch ist interessant.", ["Dein", "Deine", "Sein"], "Dein", "Dein Buch ist interessant."),
    ("", " Auto ist kaputt.", ["Sein", "Seine", "Ihr"], "Sein", "Sein Auto ist kaputt."),
    ("", " Haus ist schön.", ["Ihr", "Ihre", "Unser"], "Ihr", "Ihr Haus ist schön."),
    ("", " Wohnung ist klein.", ["Unser", "Unsere", "Eure"], "Unsere", "Unsere Wohnung ist klein."),
    ("", " Büro ist modern.", ["Euer", "Eure", "Unser"], "Euer", "Euer Büro ist modern."),
    ("", " Name ist bekannt.", ["Ihr", "Ihre", "Sein"], "Ihr", "Ihr Name ist bekannt."),
]
for i, row in enumerate(p9, 121):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "wahl", b, a, opts, idx(opts, ans), sol))

# Teil 10 (136–150)
p10 = [
    ("", " Name ist Lisa.", ["Mein", "Meine", "Dein"], "Mein", "Mein Name ist Lisa."),
    ("", " Freund heißt Paul.", ["Dein", "Deine", "Mein"], "Dein", "Dein Freund heißt Paul."),
    ("", " Eltern sind in Italien.", ["Sein", "Seine", "Ihre"], "Seine", "Seine Eltern sind in Italien."),
    ("", " Bruder ist Arzt.", ["Ihr", "Ihre", "Sein"], "Ihr", "Ihr Bruder ist Arzt."),
    ("", " Schwester tanzt gern.", ["Unser", "Unsere", "Eure"], "Unsere", "Unsere Schwester tanzt gern."),
    ("", " Katze ist weiß.", ["Euer", "Eure", "Ihre"], "Eure", "Eure Katze ist weiß."),
    ("", " Haus ist groß.", ["Ihr", "Ihre", "Unser"], "Ihr", "Ihr Haus ist groß."),
    ("", " Hund bellt nicht.", ["Ihr", "Ihre", "Mein"], "Ihr", "Ihr Hund bellt nicht."),
    ("", " Lehrer ist streng.", ["Mein", "Meine", "Dein"], "Mein", "Mein Lehrer ist streng."),
    ("", " Lehrerin ist nett.", ["Deine", "Dein", "Meine"], "Deine", "Deine Lehrerin ist nett."),
    ("", " Kind ist klug.", ["Sein", "Seine", "Ihr"], "Sein", "Sein Kind ist klug."),
    ("", " Kinder sind laut.", ["Ihre", "Ihr", "Eure"], "Ihre", "Ihre Kinder sind laut."),
    ("", " Eltern sind jung.", ["Unser", "Unsere", "Eure"], "Unsere", "Unsere Eltern sind jung."),
    ("", " Auto ist schnell.", ["Euer", "Eure", "Ihr"], "Euer", "Euer Auto ist schnell."),
    ("", " Bücher sind neu.", ["Ihre", "Ihr", "Eure"], "Ihre", "Ihre Bücher sind neu."),
]
for i, row in enumerate(p10, 136):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "mix", b, a, opts, idx(opts, ans), sol))

assert len(chunks) == 150, len(chunks)

header = '''/// Упражнения: Possessivartikel im Nominativ (A1 / Start Deutsch 1).
enum PossessivartikelNomTeil {
  lueckeIch,
  lueckeDu,
  lueckeEr,
  lueckeSie,
  lueckeWir,
  lueckeIhr,
  lueckeSiePl,
  lueckeSieHoflich,
  wahl,
  mix,
}

class PossessivartikelNomFrage {
  const PossessivartikelNomFrage({
    required this.nr,
    required this.teil,
    required this.beforeGap,
    required this.afterGap,
    required this.options,
    required this.correctIndex,
    required this.solutionDe,
  });

  final int nr;
  final PossessivartikelNomTeil teil;
  final String beforeGap;
  final String afterGap;
  final List<String> options;
  final int correctIndex;
  final String solutionDe;
}

List<PossessivartikelNomFrage> allPossessivartikelNomFragen() {
  return [
'''

footer = '''  ];
}

String possessivartikelNomTeilLabelDe(PossessivartikelNomTeil t) {
  return switch (t) {
    PossessivartikelNomTeil.lueckeIch => 'Teil 1: ich (mein/meine)',
    PossessivartikelNomTeil.lueckeDu => 'Teil 2: du (dein/deine)',
    PossessivartikelNomTeil.lueckeEr => 'Teil 3: er (sein/seine)',
    PossessivartikelNomTeil.lueckeSie => 'Teil 4: sie (sie — она)',
    PossessivartikelNomTeil.lueckeWir => 'Teil 5: wir (unser/unsere)',
    PossessivartikelNomTeil.lueckeIhr => 'Teil 6: ihr (euer/eure)',
    PossessivartikelNomTeil.lueckeSiePl => 'Teil 7: sie (они)',
    PossessivartikelNomTeil.lueckeSieHoflich => 'Teil 8: Sie (вежл.)',
    PossessivartikelNomTeil.wahl => 'Teil 9: Wahl',
    PossessivartikelNomTeil.mix => 'Teil 10: Gemischt',
  };
}
'''

OUT.write_text(header + "\n".join(chunks) + "\n" + footer, encoding="utf-8")
print("Wrote", OUT, "questions", len(chunks))
