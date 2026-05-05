#!/usr/bin/env python3
"""Генерирует lib/data/possessivartikel_nom_akk_questions.dart"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "lib/data/possessivartikel_nom_akk_questions.dart"


def esc(s: str) -> str:
    return s.replace("\\", r"\\").replace("'", r"\'")


def q(nr, teil, before, after, opts, ci, sol):
    opts_s = ", ".join(f"'{esc(o)}'" for o in opts)
    return f'''    PossessivartikelNomAkkFrage(
      nr: {nr},
      teil: PossessivartikelNomAkkTeil.{teil},
      beforeGap: '{esc(before)}',
      afterGap: '{esc(after)}',
      options: [{opts_s}],
      correctIndex: {ci},
      solutionDe: '{esc(sol)}',
    ),'''


def idx(opts, ans):
    return opts.index(ans)


def forms_ich(case, g):
    if case == "nom":
        return {"m": "Mein", "f": "Meine", "n": "Mein", "p": "Meine"}[g]
    return {"m": "meinen", "f": "meine", "n": "mein", "p": "meine"}[g]


def forms_du(case, g):
    if case == "nom":
        return {"m": "Dein", "f": "Deine", "n": "Dein", "p": "Deine"}[g]
    return {"m": "deinen", "f": "deine", "n": "dein", "p": "deine"}[g]


def forms_sein(case, g):
    if case == "nom":
        return {"m": "Sein", "f": "Seine", "n": "Sein", "p": "Seine"}[g]
    return {"m": "seinen", "f": "seine", "n": "sein", "p": "seine"}[g]


def forms_ihr_lower(case, g):  # sie sie — ihr/ihre/ihren
    if case == "nom":
        return {"m": "Ihr", "f": "Ihre", "n": "Ihr", "p": "Ihre"}[g]
    return {"m": "ihren", "f": "ihre", "n": "ihr", "p": "ihre"}[g]


def forms_unser(case, g):
    if case == "nom":
        return {"m": "Unser", "f": "Unsere", "n": "Unser", "p": "Unsere"}[g]
    return {"m": "unseren", "f": "unsere", "n": "unser", "p": "unsere"}[g]


def forms_euer(case, g):
    if case == "nom":
        return {"m": "Euer", "f": "Eure", "n": "Euer", "p": "Eure"}[g]
    return {"m": "euren", "f": "eure", "n": "euer", "p": "eure"}[g]


def forms_sie_hof(case, g):
    if case == "nom":
        return {"m": "Ihr", "f": "Ihre", "n": "Ihr", "p": "Ihre"}[g]
    return {"m": "Ihren", "f": "Ihre", "n": "Ihr", "p": "Ihre"}[g]


def three_opts(ans, case, g):
    """Drei verschiedene Formen derselben Person (Nom.: Basis, +e, +en)."""
    if case == "nom":
        if g in ("m", "n"):
            if ans == "Unser":
                return ["Unser", "Unsere", "Unseren"]
            if ans == "Euer":
                return ["Euer", "Eure", "Euren"]
            return [ans, ans + "e", ans + "en"]
        stem = {
            "Meine": "Mein",
            "Deine": "Dein",
            "Seine": "Sein",
            "Ihre": "Ihr",
            "Unsere": "Unser",
            "Eure": "Euer",
        }.get(ans, ans[:-1])
        return [ans, stem, stem + "en"]
    # Akkusativ
    if g == "m":
        base = ans.replace("en", "").rstrip("i")  # fragile
        # explizit je Besitzer
        pairs = [
            ("meinen", ["meinen", "mein", "meine"]),
            ("deinen", ["deinen", "dein", "deine"]),
            ("seinen", ["seinen", "sein", "seine"]),
            ("ihren", ["ihren", "ihr", "ihre"]),
            ("unseren", ["unseren", "unser", "unsere"]),
            ("euren", ["euren", "euer", "eure"]),
            ("Ihren", ["Ihren", "Ihr", "Ihre"]),
        ]
        for a, o in pairs:
            if ans == a:
                return o
        return [ans, "mein", "meine"]
    if g == "f":
        pairs = [
            ("meine", ["meine", "mein", "meinen"]),
            ("deine", ["deine", "dein", "deinen"]),
            ("seine", ["seine", "sein", "seinen"]),
            ("ihre", ["ihre", "ihr", "ihren"]),
            ("unsere", ["unsere", "unser", "unseren"]),
            ("eure", ["eure", "euer", "euren"]),
            ("Ihre", ["Ihre", "Ihr", "Ihren"]),
        ]
        for a, o in pairs:
            if ans == a:
                return o
    if g == "n":
        pairs = [
            ("mein", ["mein", "meine", "meinen"]),
            ("dein", ["dein", "deine", "deinen"]),
            ("sein", ["sein", "seine", "seinen"]),
            ("ihr", ["ihr", "ihre", "ihren"]),
            ("unser", ["unser", "unsere", "unseren"]),
            ("euer", ["euer", "eure", "euren"]),
            ("Ihr", ["Ihr", "Ihre", "Ihren"]),
        ]
        for a, o in pairs:
            if ans == a:
                return o
    if g == "p":
        pairs = [
            ("meine", ["meine", "mein", "meinen"]),
            ("deine", ["deine", "dein", "deinen"]),
            ("seine", ["seine", "sein", "seinen"]),
            ("ihre", ["ihre", "ihr", "ihren"]),
            ("unsere", ["unsere", "unser", "unseren"]),
            ("eure", ["eure", "euer", "euren"]),
            ("Ihre", ["Ihre", "Ihr", "Ihren"]),
        ]
        for a, o in pairs:
            if ans == a:
                return o
    return [ans, "mein", "meine"]


def sol_sentence(before, after, ans):
    return f"{before}{ans}{after}".strip()


def emit_15(chunks, start_nr, teil, rows, form_fn):
    nr = start_nr
    for case, g, b, a in rows:
        ans = form_fn(case, g)
        opts = three_opts(ans, case, g)
        if ans not in opts:
            opts[0] = ans
        sol = sol_sentence(b, a, ans)
        chunks.append(q(nr, teil, b, a, opts, idx(opts, ans), sol))
        nr += 1
    return nr


# (case, gender, beforeGap, afterGap) — 15 Zeilen wie im Aufgabenblatt
R1 = [
    ("nom", "m", "", " Vater arbeitet im Büro."),
    ("akk", "m", "Ich sehe ", " Vater."),
    ("nom", "f", "", " Mutter kocht gut."),
    ("akk", "f", "Ich liebe ", " Mutter."),
    ("nom", "n", "", " Kind spielt im Garten."),
    ("akk", "n", "Ich sehe ", " Kind."),
    ("nom", "p", "", " Eltern sind im Urlaub."),
    ("akk", "p", "Ich besuche ", " Eltern."),
    ("nom", "m", "", " Bruder ist 20 Jahre alt."),
    ("akk", "m", "Ich kenne ", " Bruder."),
    ("nom", "f", "", " Schwester lernt Deutsch."),
    ("akk", "f", "Ich liebe ", " Schwester."),
    ("nom", "m", "", " Hund bellt laut."),
    ("akk", "m", "Ich wasche ", " Hund."),
    ("nom", "n", "", " Haus ist groß."),
]

R2 = [
    ("nom", "m", "", " Vater ist Arzt."),
    ("akk", "m", "Ich sehe ", " Vater."),
    ("nom", "f", "", " Mutter ist schön."),
    ("akk", "f", "Ich liebe ", " Mutter."),
    ("nom", "n", "", " Kind ist süß."),
    ("akk", "n", "Ich sehe ", " Kind."),
    ("nom", "p", "", " Eltern wohnen in Berlin."),
    ("akk", "p", "Ich besuche ", " Eltern."),
    ("nom", "m", "", " Bruder spielt Fußball."),
    ("akk", "m", "Ich kenne ", " Bruder."),
    ("nom", "f", "", " Schwester singt gut."),
    ("akk", "f", "Ich höre ", " Schwester."),
    ("nom", "m", "", " Hund ist braun."),
    ("akk", "m", "Ich wasche ", " Hund."),
    ("nom", "n", "", " Haus ist modern."),
]

R3 = [
    ("nom", "m", "", " Vater kommt aus Berlin."),
    ("akk", "m", "Ich sehe ", " Vater."),
    ("nom", "f", "", " Mutter arbeitet im Krankenhaus."),
    ("akk", "f", "Ich besuche ", " Mutter."),
    ("nom", "n", "", " Kind geht in die Schule."),
    ("akk", "n", "Ich sehe ", " Kind."),
    ("nom", "p", "", " Eltern sind geschieden."),
    ("akk", "p", "Er besucht ", " Eltern."),
    ("nom", "m", "", " Bruder ist Student."),
    ("akk", "m", "Ich kenne ", " Bruder."),
    ("nom", "f", "", " Schwester ist noch klein."),
    ("akk", "f", "Er liebt ", " Schwester."),
    ("nom", "m", "", " Hund heißt Rex."),
    ("akk", "m", "Er wäscht ", " Hund."),
    ("nom", "n", "", " Auto ist schnell."),
]

R4 = [
    ("nom", "m", "", " Vater ist Lehrer."),
    ("akk", "m", "Ich sehe ", " Vater."),
    ("nom", "f", "", " Mutter ist Hausfrau."),
    ("akk", "f", "Ich besuche ", " Mutter."),
    ("nom", "n", "", " Kind ist drei Jahre alt."),
    ("akk", "n", "Sie sieht ", " Kind."),
    ("nom", "p", "", " Eltern sind nett."),
    ("akk", "p", "Sie besucht ", " Eltern."),
    ("nom", "m", "", " Bruder heißt Klaus."),
    ("akk", "m", "Ich kenne ", " Bruder."),
    ("nom", "f", "", " Schwester studiert Medizin."),
    ("akk", "f", "Ich liebe ", " Schwester."),
    ("nom", "m", "", " Hund ist klein."),
    ("akk", "m", "Sie wäscht ", " Hund."),
    ("nom", "n", "", " Haus ist schön."),
]

R5 = [
    ("nom", "m", "", " Vater kocht heute Abend."),
    ("akk", "m", "Wir sehen ", " Vater."),
    ("nom", "f", "", " Mutter ist Zahnärztin."),
    ("akk", "f", "Wir besuchen ", " Mutter."),
    ("nom", "n", "", " Kind lernt Deutsch."),
    ("akk", "n", "Wir sehen ", " Kind."),
    ("nom", "p", "", " Eltern sind im Kino."),
    ("akk", "p", "Wir besuchen ", " Eltern."),
    ("nom", "m", "", " Bruder ist älter als ich."),
    ("akk", "m", "Wir kennen ", " Bruder."),
    ("nom", "f", "", " Schwester tanzt gern."),
    ("akk", "f", "Wir sehen ", " Schwester."),
    ("nom", "m", "", " Hund ist ein Labrador."),
    ("akk", "m", "Wir waschen ", " Hund."),
    ("nom", "n", "", " Haus steht in der Stadt."),
]

R6 = [
    ("nom", "m", "", " Vater ist streng."),
    ("akk", "m", "Ich sehe ", " Vater."),
    ("nom", "f", "", " Mutter ist sehr nett."),
    ("akk", "f", "Ich besuche ", " Mutter."),
    ("nom", "n", "", " Kind ist sehr klug."),
    ("akk", "n", "Ich sehe ", " Kind."),
    ("nom", "p", "", " Eltern sind jung."),
    ("akk", "p", "Ich besuche ", " Eltern."),
    ("nom", "m", "", " Bruder spielt Gitarre."),
    ("akk", "m", "Ich kenne ", " Bruder."),
    ("nom", "f", "", " Schwester arbeitet als Ärztin."),
    ("akk", "f", "Ich liebe ", " Schwester."),
    ("nom", "m", "", " Hund ist laut."),
    ("akk", "m", "Ihr wascht ", " Hund."),
    ("nom", "n", "", " Haus ist sehr groß."),
]

R7 = [
    ("nom", "m", "", " Vater arbeitet in einer Firma."),
    ("akk", "m", "Ich sehe ", " Vater."),
    ("nom", "f", "", " Mutter ist Ärztin."),
    ("akk", "f", "Ich besuche ", " Mutter."),
    ("nom", "n", "", " Kind ist noch ein Baby."),
    ("akk", "n", "Ich sehe ", " Kind."),
    ("nom", "p", "", " Eltern sind im Urlaub."),
    ("akk", "p", "Ich besuche ", " Eltern."),
    ("nom", "m", "", " Bruder ist verheiratet."),
    ("akk", "m", "Ich kenne ", " Bruder."),
    ("nom", "f", "", " Schwester ist Single."),
    ("akk", "f", "Ich liebe ", " Schwester."),
    ("nom", "m", "", " Hund ist süß."),
    ("akk", "m", "Sie waschen ", " Hund."),
    ("nom", "n", "", " Haus ist neu gebaut."),
]

R8 = [
    ("nom", "m", "", " Vater ist Herr Doktor?"),
    ("akk", "m", "Ich sehe ", " Vater."),
    ("nom", "f", "", " Mutter ist zu Hause?"),
    ("akk", "f", "Ich besuche ", " Mutter."),
    ("nom", "n", "", " Kind geht in die Schule?"),
    ("akk", "n", "Ich sehe ", " Kind."),
    ("nom", "p", "", " Eltern sind gesund?"),
    ("akk", "p", "Ich besuche ", " Eltern."),
    ("nom", "m", "", " Bruder arbeitet in Berlin?"),
    ("akk", "m", "Ich kenne ", " Bruder."),
    ("nom", "f", "", " Schwester studiert noch?"),
    ("akk", "f", "Ich liebe ", " Schwester."),
    ("nom", "m", "", " Hund ist süß!"),
    ("akk", "m", "Ich wasche ", " Hund."),
    ("nom", "n", "", " Haus ist wunderschön."),
]

chunks = []
n = 1
n = emit_15(chunks, n, "teilIch", R1, forms_ich)
n = emit_15(chunks, n, "teilDu", R2, forms_du)
n = emit_15(chunks, n, "teilEr", R3, forms_sein)
n = emit_15(chunks, n, "teilSie", R4, forms_ihr_lower)
n = emit_15(chunks, n, "teilWir", R5, forms_unser)
n = emit_15(chunks, n, "teilIhr", R6, forms_euer)
n = emit_15(chunks, n, "teilSiePl", R7, forms_ihr_lower)
n = emit_15(chunks, n, "teilSieHof", R8, forms_sie_hof)

# Teil 9 (121–135)
p9 = [
    ("", " Vater ist stark.", ["Mein", "Meinen", "Meine"], "Mein", "Mein Vater ist stark."),
    ("Ich sehe ", " Vater.", ["mein", "meinen", "meine"], "meinen", "Ich sehe meinen Vater."),
    ("", " Bruder kommt heute.", ["Dein", "Deinen", "Deine"], "Dein", "Dein Bruder kommt heute."),
    ("Ich besuche ", " Bruder.", ["dein", "deinen", "deine"], "deinen", "Ich besuche deinen Bruder."),
    ("", " Hund bellt laut.", ["Sein", "Seinen", "Seine"], "Sein", "Sein Hund bellt laut."),
    ("Er wäscht ", " Hund.", ["sein", "seinen", "seine"], "seinen", "Er wäscht seinen Hund."),
    ("", " Mann arbeitet viel.", ["Ihr", "Ihren", "Ihre"], "Ihr", "Ihr Mann arbeitet viel."),
    ("Sie liebt ", " Mann.", ["ihr", "ihren", "ihre"], "ihren", "Sie liebt ihren Mann."),
    ("", " Lehrer ist gut.", ["Unser", "Unseren", "Unsere"], "Unser", "Unser Lehrer ist gut."),
    ("Wir sehen ", " Lehrer.", ["unser", "unseren", "unsere"], "unseren", "Wir sehen unseren Lehrer."),
    ("", " Chef ist streng.", ["Euer", "Euren", "Eure"], "Euer", "Euer Chef ist streng."),
    ("Ich kenne ", " Chef.", ["euer", "euren", "eure"], "euren", "Ich kenne euren Chef."),
    ("", " Vater kocht gut.", ["Ihr", "Ihren", "Ihre"], "Ihr", "Ihr Vater kocht gut."),
    ("Ich besuche ", " Vater.", ["ihr", "ihren", "ihre"], "ihren", "Ich besuche ihren Vater."),
    ("", " Wunsch ist wichtig.", ["Ihr", "Ihren", "Ihre"], "Ihr", "Ihr Wunsch ist wichtig."),
]
for i, row in enumerate(p9, 121):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "wahl", b, a, opts, idx(opts, ans), sol))

# Teil 10 (136–150)
p10 = [
    ("", " Mutter ist krank.", ["Meine", "Mein", "Meinen"], "Meine", "Meine Mutter ist krank."),
    ("Ich besuche ", " Mutter.", ["meine", "mein", "meinen"], "meine", "Ich besuche meine Mutter."),
    ("", " Bruder heißt Tom.", ["Dein", "Deine", "Deinen"], "Dein", "Dein Bruder heißt Tom."),
    ("Ich sehe ", " Bruder.", ["dein", "deinen", "deine"], "deinen", "Ich sehe deinen Bruder."),
    ("", " Auto ist kaputt.", ["Sein", "Seine", "Seinen"], "Sein", "Sein Auto ist kaputt."),
    ("Er repariert ", " Auto.", ["sein", "seine", "seinen"], "sein", "Er repariert sein Auto."),
    ("", " Schwester singt gut.", ["Ihre", "Ihr", "Ihren"], "Ihre", "Ihre Schwester singt gut."),
    ("Ich höre ", " Schwester.", ["ihre", "ihr", "ihren"], "ihre", "Ich höre ihre Schwester."),
    ("", " Lehrer ist sehr nett.", ["Unser", "Unsere", "Unseren"], "Unser", "Unser Lehrer ist sehr nett."),
    ("Wir fragen ", " Lehrer.", ["unser", "unseren", "unsere"], "unseren", "Wir fragen unseren Lehrer."),
    ("", " Haus ist sehr groß.", ["Euer", "Eure", "Euren"], "Euer", "Euer Haus ist sehr groß."),
    ("Ich sehe ", " Haus.", ["euer", "eure", "euren"], "euer", "Ich sehe euer Haus."),
    ("", " Eltern sind im Urlaub.", ["Ihre", "Ihr", "Ihren"], "Ihre", "Ihre Eltern sind im Urlaub."),
    ("Ich besuche ", " Eltern.", ["ihre", "ihr", "ihren"], "ihre", "Ich besuche ihre Eltern."),
    ("", " Hund ist süß.", ["Ihr", "Ihre", "Ihren"], "Ihr", "Ihr Hund ist süß."),
]
for i, row in enumerate(p10, 136):
    b, a, opts, ans, sol = row
    chunks.append(q(i, "mix", b, a, opts, idx(opts, ans), sol))

assert len(chunks) == 150

header = '''/// Упражнения: Possessivartikel Nominativ vs. Akkusativ (A1 / Start Deutsch 1).
enum PossessivartikelNomAkkTeil {
  teilIch,
  teilDu,
  teilEr,
  teilSie,
  teilWir,
  teilIhr,
  teilSiePl,
  teilSieHof,
  wahl,
  mix,
}

class PossessivartikelNomAkkFrage {
  const PossessivartikelNomAkkFrage({
    required this.nr,
    required this.teil,
    required this.beforeGap,
    required this.afterGap,
    required this.options,
    required this.correctIndex,
    required this.solutionDe,
  });

  final int nr;
  final PossessivartikelNomAkkTeil teil;
  final String beforeGap;
  final String afterGap;
  final List<String> options;
  final int correctIndex;
  final String solutionDe;
}

List<PossessivartikelNomAkkFrage> allPossessivartikelNomAkkFragen() {
  return [
'''

footer = '''  ];
}

String possessivartikelNomAkkTeilLabelDe(PossessivartikelNomAkkTeil t) {
  return switch (t) {
    PossessivartikelNomAkkTeil.teilIch => 'Teil 1: ich',
    PossessivartikelNomAkkTeil.teilDu => 'Teil 2: du',
    PossessivartikelNomAkkTeil.teilEr => 'Teil 3: er (sein)',
    PossessivartikelNomAkkTeil.teilSie => 'Teil 4: sie (она)',
    PossessivartikelNomAkkTeil.teilWir => 'Teil 5: wir',
    PossessivartikelNomAkkTeil.teilIhr => 'Teil 6: ihr (вы)',
    PossessivartikelNomAkkTeil.teilSiePl => 'Teil 7: sie (они)',
    PossessivartikelNomAkkTeil.teilSieHof => 'Teil 8: Sie (вежл.)',
    PossessivartikelNomAkkTeil.wahl => 'Teil 9: Nom. vs. Akk.',
    PossessivartikelNomAkkTeil.mix => 'Teil 10: Gemischt',
  };
}
'''

OUT.write_text(header + "\n".join(chunks) + "\n" + footer, encoding="utf-8")
print("Wrote", OUT, len(chunks))
