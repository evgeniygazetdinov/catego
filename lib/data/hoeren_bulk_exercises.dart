part of 'hoeren_exercises.dart';

/// Дополнительные задания Hören (85 шт.) — вместе с ядром = 100.
List<HoerenExercise> hoerenBulkExtras() => [
      ..._bulkTeil1(),
      ..._bulkTeil2(),
      ..._bulkTeil3(),
      ..._bulkBonus(),
    ];

// ——— Teil 1: Kurzdialoge (40) ———

List<HoerenExercise> _bulkTeil1() {
  final rows = <_Pic>[
    _Pic('Schuhe suchen', 'Verkäufer: Kann ich helfen? Frau: Ja, ich suche Schuhe in Größe 39.', 'Was sucht die Frau?', ['🥿 Schuhe', '🎩 einen Hut', '👔 ein Hemd'], 0, 'Sie sagt: Schuhe, Größe 39.'),
    _Pic('Zum Bahnhof', 'Frau: Entschuldigung, wo ist der Bahnhof? Mann: Geradeaus, dann links.', 'Was will die Frau wissen?', ['🚉 wo der Bahnhof ist', '🏥 wo das Krankenhaus ist', '🏬 wo das Kaufhaus ist'], 0, 'Sie fragt nach dem Bahnhof.'),
    _Pic('Im Café', 'Kellner: Möchten Sie noch etwas? Gast: Ja, noch ein Stück Kuchen, bitte.', 'Was bestellt der Gast?', ['🍰 noch Kuchen', '☕ noch Kaffee', '🥤 noch Saft'], 0, 'Er will noch ein Stück Kuchen.'),
    _Pic('Post', 'Kunde: Ich möchte diesen Brief nach Österreich schicken. Angestellte: Luftpost oder normal?', 'Wohin schickt der Kunde den Brief?', ['🇦🇹 nach Österreich', '🇫🇷 nach Frankreich', '🇮🇹 nach Italien'], 0, 'Nach Österreich.'),
    _Pic('Apotheke', 'Kundin: Haben Sie etwas gegen Husten? Apotheker: Ja, hier bitte.', 'Was hat die Kundin?', ['🤧 Husten', '🤕 Kopfschmerzen', '🤒 Fieber'], 0, 'Sie fragt gegen Husten.'),
    _Pic('Tankstelle', 'Mann: Volltanken, bitte. Angestellte: Super oder Diesel?', 'Was will der Mann?', ['⛽ volltanken', '🧽 Auto waschen', '🔧 Reparatur'], 0, 'Er sagt: Volltanken.'),
    _Pic('Im Zug', 'Schaffner: Ihre Fahrkarte, bitte. Fahrgast: Hier, bitte schön.', 'Was zeigt der Fahrgast?', ['🎫 die Fahrkarte', '📰 eine Zeitung', '📱 das Handy'], 0, 'Die Fahrkarte.'),
    _Pic('Obstladen', 'Frau: Ein Kilo Bananen und zwei Orangen, bitte. Verkäufer: Sonst noch etwas?', 'Was kauft die Frau?', ['🍌 Bananen und Orangen', '🍎 nur Äpfel', '🍇 nur Trauben'], 0, 'Bananen und Orangen.'),
    _Pic('Bibliothek', 'Angestellte: Ihren Ausweis, bitte. Student: Hier.', 'Was braucht die Angestellte?', ['🪪 den Ausweis', '💶 Geld', '📚 ein Buch'], 0, 'Den Ausweis.'),
    _Pic('Fitnessstudio', 'Trainer: Heute trainieren wir die Beine. Mitglied: Okay, gut.', 'Was trainieren sie heute?', ['🦵 die Beine', '💪 nur Arme', '🏃 nur Laufen'], 0, 'Die Beine.'),
    _Pic('Wetter', 'Moderatorin: Morgen wird es regnen. Nehmen Sie einen Regenschirm.', 'Was kommt morgen?', ['🌧️ Regen', '☀️ Sonne', '❄️ Schnee'], 0, 'Regen.'),
    _Pic('Termin', 'Sekretärin: Herr Klein kann Sie um 11 Uhr empfangen. Gast: Das passt.', 'Wann ist der Termin?', ['🕚 um 11 Uhr', '🕒 um 15 Uhr', '🕘 um 9 Uhr'], 0, 'Um 11 Uhr.'),
    _Pic('Flughafen', 'Stimme: Flug nach Paris startet von Gate C4.', 'Wohin fliegt der Flug?', ['🇫🇷 nach Paris', '🇪🇸 nach Madrid', '🇬🇧 nach London'], 0, 'Nach Paris.'),
    _Pic('Hotel', 'Gast: Gibt es WLAN im Zimmer? Rezeptionist: Ja, kostenlos.', 'Was fragt der Gast?', ['📶 WLAN', '📺 Fernseher', '🛎️ Frühstück'], 0, 'Nach WLAN.'),
    _Pic('Kino', 'Freundin: Der Film beginnt um 20 Uhr. Freund: Dann beeilen wir uns.', 'Wann beginnt der Film?', ['🕗 um 20 Uhr', '🕕 um 18 Uhr', '🕙 um 22 Uhr'], 0, 'Um 20 Uhr.'),
    _Pic('Schule', 'Lehrer: Morgen schreiben wir eine Klassearbeit. Schüler: Oh nein!', 'Was gibt es morgen?', ['📝 eine Klassearbeit', '🎉 eine Party', '🏖️ frei'], 0, 'Eine Klassearbeit.'),
    _Pic('Park', 'Mutter: Die Kinder spielen auf dem Spielplatz. Vater: Ich sehe sie.', 'Wo spielen die Kinder?', ['🛝 auf dem Spielplatz', '🏠 zu Hause', '🏊 im Pool'], 0, 'Auf dem Spielplatz.'),
    _Pic('Restaurant: Suppe', 'Gast: Ich nehme die Tomatensuppe. Kellner: Sehr gut.', 'Was isst der Gast?', ['🍅 Tomatensuppe', '🥗 Salat', '🍕 Pizza'], 0, 'Tomatensuppe.'),
    _Pic('Bus', 'Fahrer: Nächste Haltestelle: Marktplatz. Fahrgast: Danke.', 'Was ist die nächste Haltestelle?', ['🏛️ Marktplatz', '🏥 Krankenhaus', '🚉 Hauptbahnhof'], 0, 'Marktplatz.'),
    _Pic('Geldautomat', 'Stimme: Bitte geben Sie Ihre PIN ein. Person: Okay.', 'Was muss die Person eingeben?', ['🔢 die PIN', '💳 die Karte ziehen', '📞 anrufen'], 0, 'Die PIN.'),
    _Pic('Im Büro', 'Chef: Die Besprechung ist um 14 Uhr im großen Raum. Mitarbeiter: Verstanden.', 'Wo ist die Besprechung?', ['🏢 im großen Raum', '☕ in der Küche', '🏠 zu Hause'], 0, 'Im großen Raum.'),
    _Pic('Strand', 'Kind: Darf ich ins Wasser? Mutter: Ja, aber nicht zu weit.', 'Was will das Kind?', ['🌊 ins Wasser', '🏖️ Sandburg bauen', '🍦 Eis essen'], 0, 'Ins Wasser.'),
    _Pic('Möbelhaus', 'Kunde: Ich brauche einen neuen Schreibtisch. Verkäufer: Dieser hier ist sehr beliebt.', 'Was braucht der Kunde?', ['🪑 einen Schreibtisch', '🛏️ ein Bett', '🛋️ ein Sofa'], 0, 'Einen Schreibtisch.'),
    _Pic('Tierarzt', 'Besitzer: Mein Hund hat keinen Appetit. Tierarzt: Wir schauen nach.', 'Was fehlt dem Hund?', ['🍽️ Appetit', '🦴 ein Knochen', '🎾 ein Ball'], 0, 'Appetit.'),
    _Pic('Blumenladen', 'Mann: Einen Strauß Rosen für meine Frau, bitte. Verkäuferin: Welche Farbe?', 'Was kauft der Mann?', ['🌹 Rosen', '🌻 Sonnenblumen', '🌷 Tulpen'], 0, 'Rosen.'),
    _Pic('Kirche Uhr', 'Guide: Die Kirche ist 300 Jahre alt. Tourist: Beeindruckend!', 'Wie alt ist die Kirche?', ['⛪ 300 Jahre', '🏰 100 Jahre', '🗼 50 Jahre'], 0, '300 Jahre.'),
    _Pic('Schwimmbad', 'Bademeister: Bitte erst duschen, dann ins Becken. Kind: Okay.', 'Was soll das Kind zuerst?', ['🚿 duschen', '🏊 springen', '🩴 Schuhe anziehen'], 0, 'Zuerst duschen.'),
    _Pic('Im Taxi', 'Fahrer: Wohin möchten Sie? Fahrgast: Zur Goethestraße 5, bitte.', 'Wohin will der Fahrgast?', ['🏠 Goethestraße 5', '🏥 zum Krankenhaus', '🚉 zum Bahnhof'], 0, 'Goethestraße 5.'),
    _Pic('Bäckerei', 'Frau: Drei Brötchen und ein Croissant, bitte. Verkäufer: Sonst noch etwas?', 'Was kauft die Frau?', ['🥐 Brötchen und Croissant', '🎂 eine Torte', '🍩 Donuts'], 0, 'Brötchen und Croissant.'),
    _Pic('Arzt', 'Arzt: Sie sollten mehr Wasser trinken. Patient: Mache ich.', 'Was empfiehlt der Arzt?', ['💧 mehr Wasser', '☕ mehr Kaffee', '🍷 mehr Wein'], 0, 'Mehr Wasser.'),
    _Pic('Markt', 'Verkäufer: Die Erdbeeren sind heute frisch. Kundin: Dann nehme ich ein Pfund.', 'Was kauft die Kundin?', ['🍓 Erdbeeren', '🍒 Kirschen', '🫐 Heidelbeeren'], 0, 'Erdbeeren.'),
    _Pic('Museum', 'Angestellte: Fotografieren ist hier nicht erlaubt. Besucher: Entschuldigung.', 'Was ist nicht erlaubt?', ['📷 Fotografieren', '🗣️ Sprechen', '🚶 Gehen'], 0, 'Fotografieren.'),
    _Pic('Aufgabe Arbeit', 'Kollegin: Kannst du mir beim Kopieren helfen? Kollege: Klar, gleich.', 'Womit braucht die Kollegin Hilfe?', ['🖨️ Kopieren', '☕ Kaffee kochen', '📧 E-Mail'], 0, 'Beim Kopieren.'),
    _Pic('Kindergeburtstag', 'Mutter: Wir essen zuerst Kuchen, dann spielen wir. Kinder: Hurra!', 'Was gibt es zuerst?', ['🎂 Kuchen', '🎈 Spiele', '🎁 Geschenke'], 0, 'Zuerst Kuchen.'),
    _Pic('Winter', 'Wetterbericht: Morgen schneit es in den Bergen. Skifahrer: Perfekt!', 'Wo schneit es?', ['🏔️ in den Bergen', '🏖️ am Meer', '🌆 in der Stadt'], 0, 'In den Bergen.'),
    _Pic('Telefon', 'Freundin: Ich rufe dich heute Abend an. Freundin 2: Bis dann!', 'Wann ruft sie an?', ['🌙 heute Abend', '🌅 morgen früh', '🏖️ am Wochenende'], 0, 'Heute Abend.'),
    _Pic('Fahrrad', 'Mechaniker: Ihre Bremse ist kaputt. Radfahrer: Können Sie sie reparieren?', 'Was ist kaputt?', ['🛑 die Bremse', '🔔 die Klingel', '🛞 der Reifen'], 0, 'Die Bremse.'),
    _Pic('Küche', 'Mann: Wo ist der Salz? Frau: Im Schrank links.', 'Wo ist das Salz?', ['🧂 im Schrank links', '🥄 in der Schublade', '🧊 im Kühlschrank'], 0, 'Im Schrank links.'),
    _Pic('Urlaub', 'Paar: Wir fliegen in zwei Wochen nach Griechenland. Freunde: Schön!', 'Wohin fliegen sie?', ['🇬🇷 nach Griechenland', '🇹🇷 in die Türkei', '🇪🇬 nach Ägypten'], 0, 'Nach Griechenland.'),
    _Pic('Nachhilfe', 'Lehrer: Wir üben heute die Vergangenheit. Schüler: Gut.', 'Was üben sie?', ['📖 die Vergangenheit', '🔢 Mathe', '🌍 Geografie'], 0, 'Die Vergangenheit.'),
    _Pic('Eisdiele', 'Kind: Ich möchte Schokolade und Vanille. Verkäufer: In einer Waffel?', 'Welche Sorten will das Kind?', ['🍫 Schokolade und Vanille', '🍓 nur Erdbeere', '🍋 nur Zitrone'], 0, 'Schokolade und Vanille.'),
    _Pic('Umzug', 'Mann: Wir brauchen einen großen Transporter. Frau: Ich rufe die Firma an.', 'Was brauchen sie?', ['🚐 einen Transporter', '📦 nur Kartons', '🛋️ nur Sofa'], 0, 'Einen Transporter.'),
  ];
  return rows
      .map(
        (r) => HoerenPictureExercise(
          teil: 'Teil 1',
          title: r.title,
          hortext: r.h,
          rounds: [
            HoerenPictureRound(
              question: r.q,
              options: ['A) ${r.o0}', 'B) ${r.o1}', 'C) ${r.o2}'],
              correctIndex: r.ok,
              explanation: r.exp,
            ),
          ],
        ),
      )
      .toList();
}

// ——— Teil 2: Ansagen (15 × 2 Aussagen) ———

List<HoerenExercise> _bulkTeil2() {
  const blocks = <_Rf>[
    _Rf(
      'Bahnhof: Verspätung',
      'Achtung auf Gleis 3: Der Regionalexpress nach Leipzig hat 15 Minuten Verspätung. Abfahrt jetzt voraussichtlich um 10:40 Uhr.',
      'Der Zug fährt pünktlich um 10:25 Uhr.',
      false,
      'Er hat Verspätung, Abfahrt etwa 10:40.',
      'Der Zug fährt nach Leipzig.',
      true,
      'Der Text nennt Leipzig.',
    ),
    _Rf(
      'Schwimmbad',
      'Liebe Besucher, heute ist das Wellenbad wegen Reparatur geschlossen. Das Sportbecken ist geöffnet von 10 bis 19 Uhr.',
      'Das Wellenbad ist heute geöffnet.',
      false,
      'Wellenbad geschlossen.',
      'Das Sportbecken ist bis 19 Uhr geöffnet.',
      true,
      '10 bis 19 Uhr.',
    ),
    _Rf(
      'Museum Audio',
      'Willkommen in Raum 2. Dieses Gemälde stammt aus dem Jahr 1820. Bitte nicht berühren.',
      'Man darf die Bilder berühren.',
      false,
      'Bitte nicht berühren.',
      'Das Gemälde ist aus dem 19. Jahrhundert.',
      true,
      '1820 gehört ins 19. Jahrhundert.',
    ),
    _Rf(
      'Parkhaus',
      'Parkhaus City: Einfahrt über die Lindenstraße. Stundenlohn 2 Euro, maximal 15 Euro pro Tag.',
      'Die erste Stunde ist gratis.',
      false,
      'Es steht nur 2 Euro pro Stunde.',
      'Man zahlt höchstens 15 Euro am Tag.',
      true,
      'Maximal 15 Euro pro Tag.',
    ),
    _Rf(
      'Zug Ausfall',
      'Der ICE 592 nach Köln fällt heute aus. Bitte nutzen Sie den RE 8 ab Gleis 6.',
      'Der ICE 592 fährt normal.',
      false,
      'Er fällt aus.',
      'Der Ersatzzug geht von Gleis 6.',
      true,
      'RE 8 ab Gleis 6.',
    ),
    _Rf(
      'Apotheke Notdienst',
      'Heute Nacht hat die Apotheke am Markt von 20 bis 8 Uhr Notdienst. Adresse: Marktplatz 3.',
      'Notdienst ist nur tagsüber.',
      false,
      '20 bis 8 Uhr nachts.',
      'Die Apotheke liegt am Marktplatz.',
      true,
      'Marktplatz 3.',
    ),
    _Rf(
      'Wetterwarnung',
      'Warnung: Heute Nachmittag Sturmböen bis 80 km/h. Bäume können umfallen.',
      'Es wird windstill.',
      false,
      'Sturmböen bis 80 km/h.',
      'Vorsicht vor Bäumen.',
      true,
      'Bäume können umfallen.',
    ),
    _Rf(
      'Krankenhaus',
      'Besucherzeit auf Station 4 ist täglich von 14 bis 18 Uhr. Bitte maximal zwei Personen pro Zimmer.',
      'Man darf zu jeder Zeit kommen.',
      false,
      'Nur 14 bis 18 Uhr.',
      'Drei Besucher gleichzeitig sind erlaubt.',
      false,
      'Maximal zwei Personen.',
    ),
    _Rf(
      'Flughafen Gepäck',
      'Gepäckband 2: Koffer aus Flug XY 901. Bitte kontrollieren Sie Ihre Taschen.',
      'Das Gepäck kommt auf Band 1.',
      false,
      'Band 2.',
      'Der Flug heißt XY 901.',
      true,
      'So steht es im Text.',
    ),
    _Rf(
      'Supermarkt Angebot',
      'Diese Woche: Milch 0,99 Euro pro Liter, Brot 1,29 Euro. Angebot bis Samstag.',
      'Das Brot kostet 0,99 Euro.',
      false,
      'Milch 0,99, Brot 1,29.',
      'Das Angebot gilt bis Samstag.',
      true,
      'Bis Samstag.',
    ),
    _Rf(
      'Stadtfest',
      'Das Stadtfest beginnt am Freitag um 18 Uhr auf dem Rathausplatz. Eintritt frei.',
      'Man muss Eintritt zahlen.',
      false,
      'Eintritt frei.',
      'Beginn ist am Samstag.',
      false,
      'Am Freitag.',
    ),
    _Rf(
      'Bibliothek',
      'Die Bibliothek schließt heute um 17 Uhr wegen Inventur. Ausleihe bis 16:30 möglich.',
      'Die Bibliothek hat ganztägig geöffnet.',
      false,
      'Schließt um 17 Uhr.',
      'Bücher kann man bis 16:30 ausleihen.',
      true,
      'Ausleihe bis 16:30.',
    ),
    _Rf(
      'Autobahn',
      'Achtung: Auf der A9 zwischen München und Nürnberg Stau, etwa 8 Kilometer. Zeitverlust 30 Minuten.',
      'Auf der A9 ist freie Fahrt.',
      false,
      'Stau 8 km.',
      'Der Stau dauert etwa 30 Minuten länger.',
      true,
      'Zeitverlust 30 Minuten.',
    ),
    _Rf(
      'Fitness Öffnung',
      'Unser Studio hat sonntags von 9 bis 14 Uhr geöffnet. Sauna bleibt geschlossen.',
      'Sonntags ist das Studio zu.',
      false,
      '9 bis 14 Uhr geöffnet.',
      'Die Sauna ist sonntags offen.',
      false,
      'Sauna geschlossen.',
    ),
    _Rf(
      'Schule Elternabend',
      'Elternabend für Klasse 5b am Donnerstag um 19 Uhr in Raum 12. Bitte pünktlich kommen.',
      'Der Elternabend ist am Mittwoch.',
      false,
      'Donnerstag.',
      'Er findet in Raum 12 statt.',
      true,
      'Raum 12.',
    ),
  ];
  return blocks
      .map(
        (b) => HoerenRichtigFalschExercise(
          teil: 'Teil 2',
          title: b.title,
          hortext: b.h,
          items: [
            HoerenRfItem(
              statement: b.s1,
              correctIsRichtig: b.c1,
              explanation: b.e1,
            ),
            HoerenRfItem(
              statement: b.s2,
              correctIsRichtig: b.c2,
              explanation: b.e2,
            ),
          ],
        ),
      )
      .toList();
}

// ——— Teil 3: längere Dialoge (25) ———

List<HoerenExercise> _bulkTeil3() {
  final rows = <_Pic>[
    _Pic('Zug und Taxi', 'Frau: Wenn der Zug Verspätung hat, nehme ich ein Taxi zum Hotel. Kollegin: Gute Idee, dann kommen Sie pünktlich zum Meeting.', 'Was macht die Frau bei Verspätung?', ['🚕 Sie nimmt ein Taxi', '🚶 Sie läuft', '🚌 Sie wartet auf den Bus'], 0, 'Taxi zum Hotel.'),
    _Pic('Geburtstag', 'Sohn: Mama, ich lade fünf Freunde zum Geburtstag ein. Mutter: Dann backen wir zwei Kuchen.', 'Wie viele Kuchen backen sie?', ['🎂 zwei Kuchen', '🎂 einen Kuchen', '🎂 drei Kuchen'], 0, 'Zwei Kuchen.'),
    _Pic('Wohnungssuche', 'Makler: Die Wohnung hat zwei Zimmer und Balkon. Interessent: Ist die Miete warm?', 'Was fragt der Interessent?', ['💶 ob die Miete warm ist', '🪟 ob es Fenster gibt', '🛗 ob es einen Aufzug gibt'], 0, 'Ob die Miete warm ist.'),
    _Pic('Krankmeldung', 'Angestellter: Ich kann heute nicht kommen, ich habe Fieber. Chef: Gute Besserung, schicken Sie ein Attest.', 'Was soll der Angestellte schicken?', ['📄 ein Attest', '📧 eine E-Mail ohne Arzt', '💊 Medikamente'], 0, 'Ein Attest.'),
    _Pic('Rezept', 'Arzt: Nehmen Sie die Tabletten dreimal täglich nach dem Essen. Patient: Verstanden, drei Wochen lang?', 'Wie oft täglich?', ['3️⃣ dreimal', '2️⃣ zweimal', '1️⃣ einmal'], 0, 'Dreimal täglich.'),
    _Pic('Kurs Anmeldung', 'Lehrerin: Der Kurs startet am 5. September. Sie brauchen nur einen Stift und ein Heft. Schüler: Muss ich ein Buch kaufen?', 'Was braucht der Schüler laut Text?', ['✏️ Stift und Heft', '📕 ein teures Buch', '💻 einen Laptop'], 0, 'Stift und Heft.'),
    _Pic('Paket', 'Bote: Niemand zu Hause. Ich lege eine Karte in den Briefkasten. Nachbarin: Ich kann das Paket annehmen.', 'Was macht der Bote zuerst?', ['📮 Karte in den Briefkasten', '📦 sofort beim Nachbarn lassen', '🔙 Paket mitnehmen'], 0, 'Karte in den Briefkasten.'),
    _Pic('Hund', 'Tierarzt: Ihr Hund soll weniger Futter bekommen und mehr laufen. Herr Schmidt: Wir gehen länger spazieren.', 'Was empfiehlt der Tierarzt?', ['🚶 mehr laufen', '🍖 mehr Fressen', '🛁 mehr baden'], 0, 'Mehr laufen, weniger Futter.'),
    _Pic('Streit Nachbarn', 'Nachbar A: Bitte leise Musik ab 22 Uhr. Nachbar B: Entschuldigung, ich drehe die Lautstärke runter.', 'Was macht Nachbar B?', ['🔉 dreht die Musik leiser', '🚪 ruft die Polizei', '📢 macht noch lauter'], 0, 'Lautstärke runter.'),
    _Pic('Prüfung', 'Prüfer: Sie haben bestanden mit der Note 2. Kandidatin: Vielen Dank, ich war sehr nervös.', 'Welche Note hat die Kandidatin?', ['2️⃣ Note 2', '3️⃣ Note 3', '1️⃣ Note 1'], 0, 'Note 2.'),
    _Pic('Umleitung', 'Polizist: Die Brücke ist gesperrt. Bitte fahren Sie über die Neustadt. Autofahrer: Wie lange dauert das?', 'Warum Umleitung?', ['🚧 Brücke gesperrt', '⛽ Tankstelle zu', '🎉 Fest auf der Straße'], 0, 'Brücke gesperrt.'),
    _Pic('Handyvertrag', 'Berater: Mit 10 GB Daten kostet der Vertrag 25 Euro. Kundin: Gibt es eine Mindestlaufzeit?', 'Was fragt die Kundin?', ['📅 nach Mindestlaufzeit', '📶 nach WLAN', '🎁 nach Geschenk'], 0, 'Mindestlaufzeit.'),
    _Pic('Kinderbetreuung', 'Tagesmutter: Ich kann Ihr Kind ab 15 Uhr abholen. Mutter: Perfekt, ich arbeite bis 16:30.', 'Wann holt die Tagesmutter ab?', ['🕒 ab 15 Uhr', '🕘 um 9 Uhr', '🕛 um 12 Uhr'], 0, 'Ab 15 Uhr.'),
    _Pic('Kaffeemaschine', 'Verkäufer: Diese Maschine macht Kaffee und Milchschaum. Kunde: Wie oft muss man entkalken?', 'Was kann die Maschine?', ['☕ Kaffee und Milchschaum', '🫖 nur Tee', '🥤 nur Saft'], 0, 'Kaffee und Milchschaum.'),
    _Pic('Versicherung', 'Agent: Der Schaden am Auto wird übernommen, wenn Sie die Police zeigen. Kunde: Die habe ich im Handschuhfach.', 'Was braucht der Agent?', ['📋 die Police', '🔑 nur den Schlüssel', '🪪 den Führerschein allein'], 0, 'Die Police.'),
    _Pic('Garten', 'Nachbar: Ich pflanze Tomaten und Gurken. Sie: Dann tauschen wir später Salat gegen Tomaten.', 'Was pflanzt der Nachbar?', ['🍅 Tomaten und Gurken', '🥕 nur Karotten', '🌽 nur Mais'], 0, 'Tomaten und Gurken.'),
    _Pic('Flughafen Check-in', 'Mitarbeiter: Ihr Gepäck ist 3 Kilo zu schwer. Sie müssen 30 Euro zahlen oder etwas rausnehmen.', 'Was ist das Problem?', ['⚖️ Gepäck zu schwer', '🎫 falsches Ticket', '🪪 Pass abgelaufen'], 0, '3 Kilo zu schwer.'),
    _Pic('Nachbarschaftshilfe', 'Senior: Könnten Sie mir beim Einkaufen helfen? Nachbarin: Gerne, ich gehe morgen ohnehin zum Markt.', 'Wann geht die Nachbarin einkaufen?', ['🌅 morgen', '🌙 heute Nacht', '📅 nächste Woche'], 0, 'Morgen.'),
    _Pic('Sportverein', 'Trainer: Training ist dienstags und donnerstags um 18 Uhr. Neuling: Muss ich eine Mitgliedskarte sofort haben?', 'Wann ist Training?', ['🗓️ Di und Do 18 Uhr', '🗓️ Mo und Mi', '🗓️ nur Samstag'], 0, 'Dienstag und Donnerstag 18 Uhr.'),
    _Pic('Stromausfall', 'Ansage: Der Strom ist in der ganzen Straße weg. Techniker arbeiten daran, Dauer unbekannt.', 'Wo ist kein Strom?', ['🏘️ in der ganzen Straße', '🏠 nur in einem Zimmer', '🏬 nur im Supermarkt'], 0, 'Ganze Straße.'),
    _Pic('Sprachkurs', 'Lehrerin: Nächste Woche machen wir eine Hörprüfung. Student: Gibt es eine zweite Chance?', 'Was kommt nächste Woche?', ['👂 eine Hörprüfung', '✍️ nur Schreiben', '📖 nur Lesen'], 0, 'Hörprüfung.'),
    _Pic('Autoverkauf', 'Verkäufer: Das Auto hat 80.000 Kilometer und neue Winterreifen. Käufer: Kann ich eine Probefahrt machen?', 'Was hat das Auto neu?', ['❄️ Winterreifen', '🪑 neue Sitze', '🎨 neue Farbe'], 0, 'Neue Winterreifen.'),
    _Pic('Kinderarzt', 'Arzt: Ihr Kind braucht Ruhe und viel trinken. Mutter: Darf es in die Schule gehen?', 'Was empfiehlt der Arzt?', ['🛏️ Ruhe und viel trinken', '⚽ viel Sport', '📺 viel Fernsehen'], 0, 'Ruhe und trinken.'),
    _Pic('Steuer', 'Berater: Die Frist für die Steuererklärung ist der 31. Juli. Mandant: Ich schicke alles online.', 'Bis wann Frist?', ['📅 31. Juli', '📅 31. August', '📅 15. April'], 0, '31. Juli.'),
    _Pic('Wanderung', 'Guide: Der Weg dauert vier Stunden, nehmen Sie Wasser mit. Tourist: Gibt es unterwegs eine Hütte?', 'Wie lange dauert der Weg?', ['⏱️ vier Stunden', '⏱️ zwei Stunden', '⏱️ acht Stunden'], 0, 'Vier Stunden.'),
  ];
  return rows
      .map(
        (r) => HoerenPictureExercise(
          teil: 'Teil 3',
          title: r.title,
          hortext: r.h,
          rounds: [
            HoerenPictureRound(
              question: r.q,
              options: ['A) ${r.o0}', 'B) ${r.o1}', 'C) ${r.o2}'],
              correctIndex: r.ok,
              explanation: r.exp,
            ),
          ],
        ),
      )
      .toList();
}

// ——— Bonus (5) ———

List<HoerenExercise> _bulkBonus() {
  return [
    const HoerenOpenExercise(
      teil: 'Bonus',
      title: 'Im Zug',
      hortext:
          'Schaffner: Fahrkarten, bitte. Passagier: Hier, ich fahre bis Dresden. Schaffner: Danke, nächster Halt ist in 20 Minuten Leipzig.',
      qa: [
        HoerenOpenQa(question: 'Wohin fährt der Passagier?', answer: 'Bis Dresden.'),
        HoerenOpenQa(question: 'Welcher Halt kommt zuerst?', answer: 'Leipzig in 20 Minuten.'),
      ],
    ),
    const HoerenOpenExercise(
      teil: 'Bonus',
      title: 'Pizzeria',
      hortext:
          'Gast: Eine große Pizza Margherita und eine kleine Cola. Kellner: Essen Sie hier oder zum Mitnehmen? Gast: Hier, bitte.',
      qa: [
        HoerenOpenQa(question: 'Was bestellt der Gast?', answer: 'Große Pizza Margherita und kleine Cola.'),
        HoerenOpenQa(question: 'Wo isst er?', answer: 'Im Restaurant (hier).'),
      ],
    ),
    const HoerenOpenExercise(
      teil: 'Bonus',
      title: 'Nach der Arbeit',
      hortext:
          'Lisa: Ich bin müde, aber ich muss noch einkaufen. Ben: Ich helfe dir, wir gehen zusammen zum Supermarkt. Lisa: Super, danke!',
      qa: [
        HoerenOpenQa(question: 'Was muss Lisa noch machen?', answer: 'Einkaufen.'),
        HoerenOpenQa(question: 'Was macht Ben?', answer: 'Er hilft ihr und geht mit zum Supermarkt.'),
      ],
    ),
    const HoerenOpenExercise(
      teil: 'Bonus',
      title: 'Wohnungstausch',
      hortext:
          'Anna: Meine Wohnung ist zu klein für zwei Kinder. Tom: Wir tauschen: unsere ist größer, aber weiter vom Kindergarten. Anna: Das ist okay.',
      qa: [
        HoerenOpenQa(question: 'Warum sucht Anna etwas Neues?', answer: 'Die Wohnung ist zu klein für zwei Kinder.'),
        HoerenOpenQa(question: 'Was sagt Tom über seine Wohnung?', answer: 'Größer, aber weiter vom Kindergarten.'),
      ],
    ),
    const HoerenOpenExercise(
      teil: 'Bonus',
      title: 'Sport',
      hortext:
          'Trainer: Wer möchte heute den Marathon trainieren? Gruppe: Nur Maria und ich. Trainer: Dann lauft ihr 10 Kilometer, die anderen machen Dehnung.',
      qa: [
        HoerenOpenQa(question: 'Wer trainiert Marathon?', answer: 'Maria und eine weitere Person aus der Gruppe.'),
        HoerenOpenQa(question: 'Was machen die anderen?', answer: 'Dehnung.'),
      ],
    ),
  ];
}

class _Pic {
  _Pic(this.title, this.h, this.q, List<String> opts, this.ok, this.exp)
      : o0 = opts[0],
        o1 = opts[1],
        o2 = opts[2];

  final String title;
  final String h;
  final String q;
  final String o0;
  final String o1;
  final String o2;
  final int ok;
  final String exp;
}

class _Rf {
  const _Rf(
    this.title,
    this.h,
    this.s1,
    this.c1,
    this.e1,
    this.s2,
    this.c2,
    this.e2,
  );

  final String title;
  final String h;
  final String s1;
  final bool c1;
  final String e1;
  final String s2;
  final bool c2;
  final String e2;
}
