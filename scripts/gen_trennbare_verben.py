#!/usr/bin/env python3
"""Генерирует lib/data/trennbare_verben_questions.dart — 150 Fragen."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "lib/data/trennbare_verben_questions.dart"


def esc(s: str) -> str:
    return s.replace("\\", r"\\").replace("'", r"\'")


def q(nr, teil, before, after, opts, ci, sol):
    opts_s = ", ".join(f"'{esc(o)}'" for o in opts)
    return f'''    const TrennbarVerbFrage(
      nr: {nr},
      teil: TrennbarVerbTeil.{teil},
      beforeGap: '{esc(before)}',
      afterGap: '{esc(after)}',
      options: [{opts_s}],
      correctIndex: {ci},
      solutionDe: '{esc(sol)}',
    ),'''


def idx(opts, ans):
    return opts.index(ans)


def row(nr, teil, b, a, ans, w1, w2, sol):
    opts = [ans, w1, w2]
    if ans not in opts:
        opts[0] = ans
    # unique order
    u = []
    for o in opts:
        if o not in u:
            u.append(o)
    while len(u) < 3:
        u.append(ans + "!")
    return q(nr, teil, b, a, u[:3], idx(u[:3], ans), sol)


chunks = []
n = 1

# Teil 1 aufstehen (1–15)
p1 = [
    ("teilAufstehen", "Ich ", "um 7 Uhr auf.", "stehe", "aufstehe", "steht", "Ich stehe um 7 Uhr auf."),
    ("teilAufstehen", "Du ", "zu spät auf.", "stehst", "steht", "aufstehst", "Du stehst zu spät auf."),
    ("teilAufstehen", "Er ", "früh auf.", "steht", "stehst", "aufsteht", "Er steht früh auf."),
    ("teilAufstehen", "Wir ", "zusammen auf.", "stehen", "steht", "aufstehen", "Wir stehen zusammen auf."),
    ("teilAufstehen", "Ihr ", "zu spät auf.", "steht", "stehst", "aufsteht", "Ihr steht zu spät auf."),
    ("teilAufstehen", "Sie ", "jeden Tag auf.", "stehen", "steht", "aufstehen", "Sie stehen jeden Tag auf."),
    ("teilAufstehen", "", "du morgen früh auf?", "Stehst", "Steht", "Stehen", "Stehst du morgen früh auf?"),
    ("teilAufstehen", "", "er immer um 6 Uhr auf?", "Steht", "Stehst", "Stehen", "Steht er immer um 6 Uhr auf?"),
    ("teilAufstehen", "", "wir zusammen auf?", "Stehen", "Steht", "Stehst", "Stehen wir zusammen auf?"),
    ("teilAufstehen", "", "ihr am Wochenende auf?", "Steht", "Stehst", "Stehen", "Steht ihr am Wochenende auf?"),
    ("teilAufstehen", "Wann ", "du auf?", "stehst", "steht", "aufstehst", "Wann stehst du auf?"),
    ("teilAufstehen", "Um wie viel Uhr ", "er auf?", "steht", "stehst", "aufsteht", "Um wie viel Uhr steht er auf?"),
    ("teilAufstehen", "", "Sie bitte auf!", "Stehen", "Steh", "Steht", "Stehen Sie bitte auf!"),
    ("teilAufstehen", "", "um 7 Uhr auf!", "Steh", "Steht", "Stehen", "Steh um 7 Uhr auf!"),
    ("teilAufstehen", "", "nicht so spät auf!", "Steht", "Steh", "Stehen", "Steht nicht so spät auf!"),
]
for teil, b, a, ans, w1, w2, sol in p1:
    chunks.append(row(n, teil, b, a, ans, w1, w2, sol))
    n += 1

# Teil 2 anrufen (16–30)
p2 = [
    ("teilAnrufen", "Ich ", "dich später an.", "rufe", "rufst", "anrufe", "Ich rufe dich später an."),
    ("teilAnrufen", "Du ", "mich an.", "rufst", "ruft", "anrufst", "Du rufst mich an."),
    ("teilAnrufen", "Er ", "seine Mutter an.", "ruft", "rufst", "anruft", "Er ruft seine Mutter an."),
    ("teilAnrufen", "Wir ", "euch an.", "rufen", "ruft", "anrufen", "Wir rufen euch an."),
    ("teilAnrufen", "Ihr ", "uns an.", "ruft", "rufst", "anruft", "Ihr ruft uns an."),
    ("teilAnrufen", "Sie ", "den Arzt an.", "rufen", "ruft", "anrufen", "Sie rufen den Arzt an."),
    ("teilAnrufen", "", "du mich heute an?", "Rufst", "Ruft", "Rufen", "Rufst du mich heute an?"),
    ("teilAnrufen", "", "er seine Freundin an?", "Ruft", "Rufst", "Rufen", "Ruft er seine Freundin an?"),
    ("teilAnrufen", "", "wir dich morgen an?", "Rufen", "Ruft", "Rufst", "Rufen wir dich morgen an?"),
    ("teilAnrufen", "", "ihr eure Eltern an?", "Ruft", "Rufst", "Rufen", "Ruft ihr eure Eltern an?"),
    ("teilAnrufen", "Wen ", "du an?", "rufst", "ruft", "anrufst", "Wen rufst du an?"),
    ("teilAnrufen", "Wann ", "er an?", "ruft", "rufst", "anruft", "Wann ruft er an?"),
    ("teilAnrufen", "", "mich bitte an!", "Ruf", "Ruft", "Rufen", "Ruf mich bitte an!"),
    ("teilAnrufen", "", "uns morgen an!", "Ruft", "Ruf", "Rufen", "Ruft uns morgen an!"),
    ("teilAnrufen", "", "mich später an!", "Rufen", "Ruf", "Ruft", "Rufen Sie mich später an!"),
]
for tup in p2:
    chunks.append(row(n, *tup))
    n += 1

# Teil 3 einkaufen (31–45)
p3 = [
    ("teilEinkaufen", "Ich ", "Brot ein.", "kaufe", "kaufst", "einkaufe", "Ich kaufe Brot ein."),
    ("teilEinkaufen", "Du ", "Milch ein.", "kaufst", "kauft", "einkaufst", "Du kaufst Milch ein."),
    ("teilEinkaufen", "Sie ", "Gemüse ein.", "kauft", "kaufst", "einkauft", "Sie kauft Gemüse ein."),
    ("teilEinkaufen", "Wir ", "heute ein.", "kaufen", "kauft", "einkaufen", "Wir kaufen heute ein."),
    ("teilEinkaufen", "Ihr ", "zu viel ein.", "kauft", "kaufst", "einkauft", "Ihr kauft zu viel ein."),
    ("teilEinkaufen", "Sie ", "im Supermarkt ein.", "kaufen", "kauft", "einkaufen", "Sie kaufen im Supermarkt ein."),
    ("teilEinkaufen", "", "du heute ein?", "Kaufst", "Kauft", "Kaufen", "Kaufst du heute ein?"),
    ("teilEinkaufen", "", "sie im Bioladen ein?", "Kauft", "Kaufst", "Kaufen", "Kauft sie im Bioladen ein?"),
    ("teilEinkaufen", "", "wir zusammen ein?", "Kaufen", "Kauft", "Kaufst", "Kaufen wir zusammen ein?"),
    ("teilEinkaufen", "", "ihr am Samstag ein?", "Kauft", "Kaufst", "Kaufen", "Kauft ihr am Samstag ein?"),
    ("teilEinkaufen", "Wo ", "du ein?", "kaufst", "kauft", "einkaufst", "Wo kaufst du ein?"),
    ("teilEinkaufen", "Was ", "ihr ein?", "kauft", "kaufst", "einkauft", "Was kauft ihr ein?"),
    ("teilEinkaufen", "", "bitte ein!", "Kauf", "Kauft", "Kaufen", "Kauf bitte ein!"),
    ("teilEinkaufen", "", "heute Abend ein!", "Kauft", "Kauf", "Kaufen", "Kauft heute Abend ein!"),
    ("teilEinkaufen", "", "Sie morgen ein!", "Kaufen", "Kauf", "Kauft", "Kaufen Sie morgen ein!"),
]
for tup in p3:
    chunks.append(row(n, *tup))
    n += 1

# Teil 4 mitkommen (46–60)
p4 = [
    ("teilMitkommen", "Ich ", "ins Kino mit.", "komme", "kommst", "mitkomme", "Ich komme ins Kino mit."),
    ("teilMitkommen", "Du ", "mit uns mit.", "kommst", "kommt", "mitkommst", "Du kommst mit uns mit."),
    ("teilMitkommen", "Er ", "zu mir mit.", "kommt", "kommst", "mitkommt", "Er kommt zu mir mit."),
    ("teilMitkommen", "Wir ", "mit euch mit.", "kommen", "kommt", "mitkommen", "Wir kommen mit euch mit."),
    ("teilMitkommen", "Ihr ", "mit uns mit.", "kommt", "kommst", "mitkommt", "Ihr kommt mit uns mit."),
    ("teilMitkommen", "Sie ", "auch mit.", "kommen", "kommt", "mitkommen", "Sie kommen auch mit."),
    ("teilMitkommen", "", "du mit?", "Kommst", "Kommt", "Kommen", "Kommst du mit?"),
    ("teilMitkommen", "", "er mit uns mit?", "Kommt", "Kommst", "Kommen", "Kommt er mit uns mit?"),
    ("teilMitkommen", "", "wir mit euch mit?", "Kommen", "Kommt", "Kommst", "Kommen wir mit euch mit?"),
    ("teilMitkommen", "", "ihr mit?", "Kommt", "Kommst", "Kommen", "Kommt ihr mit?"),
    ("teilMitkommen", "Wohin ", "du mit?", "kommst", "kommt", "mitkommst", "Wohin kommst du mit?"),
    ("teilMitkommen", "", "bitte mit!", "Komm", "Kommt", "Kommen", "Komm bitte mit!"),
    ("teilMitkommen", "", "mit uns mit!", "Kommt", "Komm", "Kommen", "Kommt mit uns mit!"),
    ("teilMitkommen", "", "Sie mit!", "Kommen", "Komm", "Kommt", "Kommen Sie mit!"),
    ("teilMitkommen", "Warum ", "du nicht mit?", "kommst", "kommt", "mitkommst", "Warum kommst du nicht mit?"),
]
for tup in p4:
    chunks.append(row(n, *tup))
    n += 1

# Teil 5 aufmachen / zumachen (61–75)
p5 = [
    ("teilAufZu", "Ich ", "das Fenster auf.", "mache", "machst", "aufmache", "Ich mache das Fenster auf."),
    ("teilAufZu", "Du ", "die Tür auf.", "machst", "macht", "aufmachst", "Du machst die Tür auf."),
    ("teilAufZu", "Er ", "das Buch auf.", "macht", "machst", "aufmacht", "Er macht das Buch auf."),
    ("teilAufZu", "Wir ", "die Flasche auf.", "machen", "macht", "aufmachen", "Wir machen die Flasche auf."),
    ("teilAufZu", "Ihr ", "das Geschenk auf.", "macht", "machst", "aufmacht", "Ihr macht das Geschenk auf."),
    ("teilAufZu", "", "du das Fenster auf?", "Machst", "Macht", "Machen", "Machst du das Fenster auf?"),
    ("teilAufZu", "", "Sie bitte die Tür auf!", "Machen", "Mach", "Macht", "Machen Sie bitte die Tür auf!"),
    ("teilAufZu", "", "das Fenster zu!", "Mach", "Macht", "Machen", "Mach das Fenster zu!"),
    ("teilAufZu", "Ich ", "die Tür zu.", "mache", "machst", "zumache", "Ich mache die Tür zu."),
    ("teilAufZu", "Du ", "das Buch zu.", "machst", "macht", "zumachst", "Du machst das Buch zu."),
    ("teilAufZu", "Er ", "die Flasche zu.", "macht", "machst", "zumacht", "Er macht die Flasche zu."),
    ("teilAufZu", "", "Sie bitte das Fenster zu!", "Machen", "Mach", "Macht", "Machen Sie bitte das Fenster zu!"),
    ("teilAufZu", "", "die Tür auf!", "Machen", "Mach", "Macht", "Machen Sie die Tür auf!"),
    ("teilAufZu", "Warum ", "du das Buch nicht auf?", "machst", "macht", "aufmachst", "Warum machst du das Buch nicht auf?"),
    ("teilAufZu", "", "die Flasche zu!", "Macht", "Mach", "Machen", "Macht die Flasche zu!"),
]
for tup in p5:
    chunks.append(row(n, *tup))
    n += 1

# Teil 6 anziehen / ausziehen (76–90)
p6 = [
    ("teilAnAus", "Ich ", "mich warm an.", "ziehe", "ziehst", "anziehe", "Ich ziehe mich warm an."),
    ("teilAnAus", "Du ", "deine Jacke an.", "ziehst", "zieht", "anziehst", "Du ziehst deine Jacke an."),
    ("teilAnAus", "Er ", "seinen Hut an.", "zieht", "ziehst", "anzieht", "Er zieht seinen Hut an."),
    ("teilAnAus", "Wir ", "uns schnell an.", "ziehen", "zieht", "anziehen", "Wir ziehen uns schnell an."),
    ("teilAnAus", "Ihr ", "eure Schuhe aus.", "zieht", "ziehst", "auszieht", "Ihr zieht eure Schuhe aus."),
    ("teilAnAus", "", "du dich warm an?", "Ziehst", "Zieht", "Ziehen", "Ziehst du dich warm an?"),
    ("teilAnAus", "", "Sie bitte Ihren Mantel aus!", "Ziehen", "Zieh", "Zieht", "Ziehen Sie bitte Ihren Mantel aus!"),
    ("teilAnAus", "", "dich warm an!", "Zieh", "Zieht", "Ziehen", "Zieh dich warm an!"),
    ("teilAnAus", "Ich ", "meine Schuhe aus.", "ziehe", "ziehst", "ausziehe", "Ich ziehe meine Schuhe aus."),
    ("teilAnAus", "Du ", "deinen Pullover an.", "ziehst", "zieht", "anziehst", "Du ziehst deinen Pullover an."),
    ("teilAnAus", "Er ", "seine Hose aus.", "zieht", "ziehst", "auszieht", "Er zieht seine Hose aus."),
    ("teilAnAus", "", "Sie bitte Ihren Hut an!", "Ziehen", "Zieh", "Zieht", "Ziehen Sie bitte Ihren Hut an!"),
    ("teilAnAus", "", "eure Jacken aus!", "Zieht", "Zieh", "Ziehen", "Zieht eure Jacken aus!"),
    ("teilAnAus", "Warum ", "du dich nicht warm an?", "ziehst", "zieht", "anziehst", "Warum ziehst du dich nicht warm an?"),
    ("teilAnAus", "", "dich schnell an!", "Zieh", "Zieht", "Ziehen", "Zieh dich schnell an!"),
]
for tup in p6:
    chunks.append(row(n, *tup))
    n += 1

# Teil 7 fernsehen (91–105)
p7 = [
    ("teilFernsehen", "Ich ", "jeden Tag fern.", "sehe", "siehst", "fernsehe", "Ich sehe jeden Tag fern."),
    ("teilFernsehen", "Du ", "zu viel fern.", "siehst", "sieht", "fernsiehst", "Du siehst zu viel fern."),
    ("teilFernsehen", "Er ", "jeden Abend fern.", "sieht", "siehst", "fernsieht", "Er sieht jeden Abend fern."),
    ("teilFernsehen", "Wir ", "zusammen fern.", "sehen", "seht", "fernsehen", "Wir sehen zusammen fern."),
    ("teilFernsehen", "Ihr ", "selten fern.", "seht", "siehst", "fernseht", "Ihr seht selten fern."),
    ("teilFernsehen", "Sie ", "den ganzen Tag fern.", "sehen", "seht", "fernsehen", "Sie sehen den ganzen Tag fern."),
    ("teilFernsehen", "", "du heute Abend fern?", "Siehst", "Sieht", "Sehen", "Siehst du heute Abend fern?"),
    ("teilFernsehen", "", "er gerne fern?", "Sieht", "Siehst", "Sehen", "Sieht er gerne fern?"),
    ("teilFernsehen", "", "wir zusammen fern?", "Sehen", "Sieht", "Siehst", "Sehen wir zusammen fern?"),
    ("teilFernsehen", "", "ihr oft fern?", "Seht", "Siehst", "Sehen", "Seht ihr oft fern?"),
    ("teilFernsehen", "Wann ", "du fern?", "siehst", "sieht", "fernsiehst", "Wann siehst du fern?"),
    ("teilFernsehen", "Wie lange ", "er fern?", "sieht", "siehst", "fernsieht", "Wie lange sieht er fern?"),
    ("teilFernsehen", "", "Sie nicht so viel fern!", "Sehen", "Sieh", "Seht", "Sehen Sie nicht so viel fern!"),
    ("teilFernsehen", "", "nicht so lange fern!", "Sieh", "Seht", "Sehen", "Sieh nicht so lange fern!"),
    ("teilFernsehen", "", "weniger fern!", "Seht", "Sieh", "Sehen", "Seht weniger fern!"),
]
for tup in p7:
    chunks.append(row(n, *tup))
    n += 1

# Teil 8 einladen (106–120)
p8 = [
    ("teilEinladen", "Ich ", "dich zum Essen ein.", "lade", "lädst", "einlade", "Ich lade dich zum Essen ein."),
    ("teilEinladen", "Du ", "mich zur Party ein.", "lädst", "lädt", "einlädst", "Du lädst mich zur Party ein."),
    ("teilEinladen", "Er ", "seine Freunde ein.", "lädt", "lädst", "einlädt", "Er lädt seine Freunde ein."),
    ("teilEinladen", "Wir ", "euch zum Geburtstag ein.", "laden", "ladet", "einladen", "Wir laden euch zum Geburtstag ein."),
    ("teilEinladen", "Ihr ", "uns ins Kino ein.", "ladet", "lädst", "einladet", "Ihr ladet uns ins Kino ein."),
    ("teilEinladen", "Sie ", "uns nach Hause ein.", "laden", "ladet", "einladen", "Sie laden uns nach Hause ein."),
    ("teilEinladen", "", "du mich zu dir ein?", "Lädst", "Lädt", "Laden", "Lädst du mich zu dir ein?"),
    ("teilEinladen", "", "er seine Kollegen ein?", "Lädt", "Lädst", "Laden", "Lädt er seine Kollegen ein?"),
    ("teilEinladen", "", "wir euch ein?", "Laden", "Lädt", "Lädst", "Laden wir euch ein?"),
    ("teilEinladen", "", "ihr uns zur Hochzeit ein?", "Ladet", "Lädst", "Laden", "Ladet ihr uns zur Hochzeit ein?"),
    ("teilEinladen", "Wen ", "du ein?", "lädst", "lädt", "einlädst", "Wen lädst du ein?"),
    ("teilEinladen", "Wohin ", "er dich ein?", "lädt", "lädst", "einlädt", "Wohin lädt er dich ein?"),
    ("teilEinladen", "", "mich bitte ein!", "Lad", "Ladet", "Laden", "Lad mich bitte ein!"),
    ("teilEinladen", "", "uns zum Abendessen ein!", "Ladet", "Lad", "Laden", "Ladet uns zum Abendessen ein!"),
    ("teilEinladen", "", "Sie mich ein!", "Laden", "Lad", "Ladet", "Laden Sie mich ein!"),
]
for tup in p8:
    chunks.append(row(n, *tup))
    n += 1

# Teil 9 Wahl (121–135) — richtiger Satz / Form wie Antwortschlüssel
p9 = [
    ("teilMix", "Ich ", "um 7 Uhr auf.", "stehe", "aufstehe", "steht", "Ich stehe um 7 Uhr auf."),
    ("teilMix", "Du ", "mich an.", "rufst", "anrufst", "ruft", "Du rufst mich an."),
    ("teilMix", "Er ", "Brot ein.", "kauft", "einkauft", "kaufst", "Er kauft Brot ein."),
    ("teilMix", "Wir ", "ins Kino mit.", "kommen", "mitkommen", "kommt", "Wir kommen ins Kino mit."),
    ("teilMix", "Ihr ", "das Fenster auf.", "macht", "aufmacht", "machst", "Ihr macht das Fenster auf."),
    ("teilMix", "Sie ", "sich warm an.", "zieht", "anzieht", "ziehst", "Sie zieht sich warm an."),
    ("teilMix", "Ich ", "jeden Tag fern.", "sehe", "fernsehe", "siehst", "Ich sehe jeden Tag fern."),
    ("teilMix", "Du ", "mich ein.", "lädst", "einlädst", "lädt", "Du lädst mich ein."),
    ("teilMix", "Er ", "mich um 5 Uhr ab.", "holt", "abholt", "holst", "Er holt mich um 5 Uhr ab."),
    ("teilMix", "Wir ", "dich mit.", "nehmen", "mitnehmen", "nehmt", "Wir nehmen dich mit."),
    ("teilMix", "Ihr ", "euer Zimmer auf.", "räumt", "aufräumt", "räumst", "Ihr räumt euer Zimmer auf."),
    ("teilMix", "Sie ", "mir zu.", "hört", "zuhört", "hörst", "Sie hört mir zu."),
    ("teilMix", "Ich ", "über das Problem nach.", "denke", "nachdenke", "denkst", "Ich denke über das Problem nach."),
    ("teilMix", "Du ", "das Essen vor.", "bereitest", "vorbereitest", "bereitet", "Du bereitest das Essen vor."),
    ("teilMix", "Er ", "am Kurs teil.", "nimmt", "teilnimmt", "nehmt", "Er nimmt am Kurs teil."),
]
for tup in p9:
    chunks.append(row(n, *tup))
    n += 1

# Teil 10 schwer (136–150)
p10 = [
    ("teilSchwer", "Wann ", "du morgen auf?", "stehst", "steht", "aufstehst", "Wann stehst du morgen auf?"),
    ("teilSchwer", "Ich ", "nicht früh auf.", "stehe", "aufstehe", "stehst", "Ich stehe nicht früh auf."),
    ("teilSchwer", "Wen ", "du heute Abend an?", "rufst", "ruft", "anrufst", "Wen rufst du heute Abend an?"),
    ("teilSchwer", "Ich ", "meine Oma an.", "rufe", "rufst", "anrufe", "Ich rufe meine Oma an."),
    ("teilSchwer", "Wo ", "ihr normalerweise ein?", "kauft", "kauft ihr", "einkauft", "Wo kauft ihr normalerweise ein?"),
    ("teilSchwer", "Wir ", "im Supermarkt ein.", "kaufen", "kauft", "einkaufen", "Wir kaufen im Supermarkt ein."),
    ("teilSchwer", "", "du mit ins Kino mit?", "Kommst", "Kommt", "Kommen", "Kommst du mit ins Kino mit?"),
    ("teilSchwer", "Nein, ich ", "nicht mit.", "komme", "mitkomme", "kommst", "Nein, ich komme nicht mit."),
    ("teilSchwer", "Warum ", "du das Fenster nicht auf?", "machst", "macht", "aufmachst", "Warum machst du das Fenster nicht auf?"),
    ("teilSchwer", "Weil es kalt ist, ", "ich das Fenster zu.", "mache", "zumache", "machst", "Weil es kalt ist, mache ich das Fenster zu."),
    ("teilSchwer", "", "du dich warm an?", "Ziehst", "Zieht", "Ziehen", "Ziehst du dich warm an?"),
    ("teilSchwer", "Ja, ich ", "mich warm an.", "ziehe", "anziehe", "ziehst", "Ja, ich ziehe mich warm an."),
    ("teilSchwer", "Wie lange ", "du jeden Tag fern?", "siehst", "sieht", "fernsiehst", "Wie lange siehst du jeden Tag fern?"),
    ("teilSchwer", "Ich ", "nur eine Stunde fern.", "sehe", "fernsehe", "siehst", "Ich sehe nur eine Stunde fern."),
    ("teilSchwer", "", "du mich zu deiner Party ein?", "Lädst", "Lädt", "Laden", "Lädst du mich zu deiner Party ein?"),
]
for tup in p10:
    chunks.append(row(n, *tup))
    n += 1

assert n == 151  # 1..150

header = '''/// Упражнения: Trennbare Verben (A1 / Start Deutsch 1).
enum TrennbarVerbTeil {
  teilAufstehen,
  teilAnrufen,
  teilEinkaufen,
  teilMitkommen,
  teilAufZu,
  teilAnAus,
  teilFernsehen,
  teilEinladen,
  teilMix,
  teilSchwer,
}

class TrennbarVerbFrage {
  const TrennbarVerbFrage({
    required this.nr,
    required this.teil,
    required this.beforeGap,
    required this.afterGap,
    required this.options,
    required this.correctIndex,
    required this.solutionDe,
  });

  final int nr;
  final TrennbarVerbTeil teil;
  final String beforeGap;
  final String afterGap;
  final List<String> options;
  final int correctIndex;
  final String solutionDe;
}

List<TrennbarVerbFrage> allTrennbarVerbenFragen() {
  return [
'''

footer = '''  ];
}

String trennbarVerbTeilLabelDe(TrennbarVerbTeil t) {
  return switch (t) {
    TrennbarVerbTeil.teilAufstehen => 'Teil 1: aufstehen',
    TrennbarVerbTeil.teilAnrufen => 'Teil 2: anrufen',
    TrennbarVerbTeil.teilEinkaufen => 'Teil 3: einkaufen',
    TrennbarVerbTeil.teilMitkommen => 'Teil 4: mitkommen',
    TrennbarVerbTeil.teilAufZu => 'Teil 5: aufmachen / zumachen',
    TrennbarVerbTeil.teilAnAus => 'Teil 6: anziehen / ausziehen',
    TrennbarVerbTeil.teilFernsehen => 'Teil 7: fernsehen',
    TrennbarVerbTeil.teilEinladen => 'Teil 8: einladen',
    TrennbarVerbTeil.teilMix => 'Teil 9: Mix',
    TrennbarVerbTeil.teilSchwer => 'Teil 10: Sätze',
  };
}
'''

OUT.write_text(header + "\n".join(chunks) + "\n" + footer, encoding="utf-8")
print("Wrote", OUT, len(chunks))
