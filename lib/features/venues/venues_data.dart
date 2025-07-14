class Event {
  final String name;
  final String date; // e.g. '2024-05-22'
  final String time; // e.g. '16:00 - 17:00'

  const Event({required this.name, required this.date, required this.time});

  @override
  String toString() => '$name\n$date, $time';
}

class Venue {
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<Event> events;

  const Venue({
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    this.events = const [],
  });
}

const venues = [
  Venue(
    name: 'Moonlight',
    address:
        'PrimorskiOdesos, ul. "Kapitan Georgi Georgiev" 9000, 9000 Varna, Bulgaria',
    latitude: 43.2101,
    longitude: 27.9292,
    events: [
      Event(
        name: 'CAST IN SITU / LOCAL ECOLOGY',
        date: '2024-05-22',
        time: '16:00 - 17:00',
      ),
      Event(name: 'PURE', date: '2024-05-25', time: '19:00 - 21:00'),
    ],
  ),
  Venue(
    name: 'Beach Bar Menthol',
    address:
        'PrimorskiOdesos, ul. "Kapitan Georgi Georgiev", 9000 Varna, Bulgaria',
    latitude: 43.2107,
    longitude: 27.9297,
    events: [
      Event(
        name: 'REACH - INTERACTIVE WORKSHOP',
        date: '2024-05-23',
        time: '15:00 - 17:00',
      ),
      Event(name: 'BUNA AWARDS', date: '2024-05-25', time: '19:30 - 20:30'),
      Event(
        name: 'JULIETA INTERGALACTICA',
        date: '2024-05-25',
        time: '22:00 - 14:00 (next day)',
      ),
    ],
  ),
  Venue(
    name: 'Largo Art Gallery',
    address: 'Varna CenterOdesos, ul. "Han Krum" 8, 9000 Varna, Bulgaria',
    latitude: 43.2076,
    longitude: 27.9196,
    events: [
      Event(
        name: 'LARGO PRESENTS RAWLAB & KOKIMOTO',
        date: '2024-05-24',
        time: '18:00 - 20:00',
      ),
      Event(
        name: 'EXHIBITIONS & INTERVENTIONS TOUR',
        date: '2024-05-25',
        time: '10:00 - 12:00',
      ),
    ],
  ),
  Venue(
    name: 'ReBonkers',
    address: 'Varna CenterOdesos, ul. "Baruten pogreb" 4, 9008 Varna, Bulgaria',
    latitude: 43.2105,
    longitude: 27.9222,
    events: [
      Event(
        name: 'THE NATURE OF RELATIONSHIPS @ REBONKERS',
        date: '2024-05-24',
        time: '17:00 - 19:00',
      ),
      Event(
        name: 'BUN OPENING PARTY',
        date: '2024-05-25',
        time: '20:00 - 23:00',
      ),
    ],
  ),
  Venue(
    name: 'South Beach Varna',
    address:
        'Under the pool Coastal Promenade, South Beach 9000, PrimorskiOdesos, 9000 Varna, Bulgaria',
    latitude: 43.1997,
    longitude: 27.9216,
    events: [
      Event(
        name: 'MŌ-TIV MEETS BUNA - OPENING PARTY',
        date: '2024-05-24',
        time: '18:00 - 22:00',
      ),
    ],
  ),
  Venue(
    name: 'Square "Atlantic solidarity"',
    address: 'Varna CenterOdesos, bul. "Slivnitsa" 24, 9002 Varna, Bulgaria',
    latitude: 43.2108,
    longitude: 27.9226,
    events: [
      Event(
        name: 'URBAN INTERVENTIONS: A WALK WITH THE CURATOR ALEXANDER VALCHEV',
        date: '2024-05-22',
        time: '10:00 - 12:00',
      ),
    ],
  ),
  Venue(
    name: 'Archaeological Museum Varna',
    address: '41 Knyaginya Maria Luiza Blvd., 9000 Varna, Bulgaria',
    latitude: 43.2077,
    longitude: 27.9192,
    events: [
      Event(
        name: 'VLACHUGANE, EXHIBITION BY MARTINA VACHEVA',
        date: '2024-05-22',
        time: '18:00 - 20:00',
      ),
      Event(name: 'BARE GUTS', date: '2024-05-24', time: '19:00 - 21:00'),
      Event(name: 'SOUND 6', date: '2024-05-25', time: '20:00 - 22:00'),
    ],
  ),
  Venue(
    name: 'Kastha-Muzey Georgi Velchev',
    address:
        'Varna CenterOdesos, ul. "General Radko Dimitriev" 8, 9000 Varna, Bulgaria',
    latitude: 43.2131,
    longitude: 27.9227,
    events: [
      Event(
        name: 'ON THE EDGE OF THE MATERIAL',
        date: '2024-05-23',
        time: '18:00 - 20:00',
      ),
    ],
  ),
  Venue(
    name: 'Bnr',
    address: 'PrimorskiOdesos, bul. "Primorski" 22, 9002 Varna, Bulgaria',
    latitude: 43.2027,
    longitude: 27.9292,
    events: [
      Event(
        name: 'PASSAGE EXHIBITION OF SMILYA IGANTOVICH',
        date: '2024-05-22',
        time: '17:00 - 19:00',
      ),
    ],
  ),
  Venue(
    name: 'Art Gallery Le Papillon',
    address: 'Varna CenterOdesos, ul. "Dragoman" 12, 9000 Varna, Bulgaria',
    latitude: 43.2067,
    longitude: 27.9222,
    events: [
      Event(name: 'NEVO\'S BEDROOM', date: '2024-05-24', time: '18:00 - 20:00'),
    ],
  ),
  Venue(
    name: 'Art Gallery Boris Georgiev',
    address:
        'Varna CenterOdesos, ul. "Lyuben Karavelov" 1, 9002 Varna, Bulgaria',
    latitude: 43.2102,
    longitude: 27.9221,
    events: [
      Event(name: 'THERE YOU ARE', date: '2024-05-22', time: '18:00 - 20:00'),
      Event(
        name: 'EGO-SYSTEM / ECO-SYSTEM',
        date: '2024-05-23',
        time: '19:00 - 21:00',
      ),
      Event(
        name: 'VENICE, SANTA LUCIA AND CROOKED RIVER - NO GUILT GUILTY',
        date: '2024-05-24',
        time: '20:00 - 22:00',
      ),
      Event(
        name: 'SILENT STORIES, FOUND OBJECTS AND COLLECTIVE PRACTICES',
        date: '2024-05-25',
        time: '21:00 - 23:00',
      ),
      Event(
        name: 'NONUMENT 2.0 — IN THE ZONE OF CONFLICTING DESIRES',
        date: '2024-05-26',
        time: '20:00 - 22:00',
      ),
    ],
  ),
  Venue(
    name: 'Gallery A&G Art Meeting',
    address:
        'Varna CenterOdesos, ul. "Lyuben Karavelov" 8, 9002 Varna, Bulgaria',
    latitude: 43.2107,
    longitude: 27.9232,
    events: [
      Event(
        name: 'A&G ART MEETING THE WIND IS BLOWING FROM THIS SIDE',
        date: '2024-05-22',
        time: '18:00 - 20:00',
      ),
    ],
  ),
  Venue(
    name: 'The Bookstore',
    address: 'Greek NeighborhoodOdesos, ul. "Preslav" 12, 9000 Varna, Bulgaria',
    latitude: 43.2037,
    longitude: 27.9197,
    events: [
      Event(name: 'SPEED OPENING 2', date: '2024-05-22', time: '17:00 - 19:00'),
      Event(
        name: 'STEPHAN PANEV + STFN',
        date: '2024-05-24',
        time: '18:00 - 20:00',
      ),
    ],
  ),
  Venue(
    name: 'Kamara Na Arhitektite',
    address: 'Greek NeighborhoodOdesos, ul. "Musala" 10, 9000 Varna, Bulgaria',
    latitude: 43.2032,
    longitude: 27.9207,
    events: [
      Event(
        name: 'EMOTIONAL DECOMPRESSION',
        date: '2024-05-23',
        time: '17:00 - 19:00',
      ),
    ],
  ),
  Venue(
    name: 'Room at the End of the World (Nicotea - culture warehouse)',
    address: 'Varna CenterOdesos, ul. "Nikola Kanev" 1, 9000 Varna, Bulgaria',
    latitude: 43.2109,
    longitude: 27.9179,
    events: [
      Event(
        name: 'ROOM AT THE END OF THE WORLD',
        date: '2024-05-24',
        time: '18:00 - 20:00',
      ),
    ],
  ),
  Venue(
    name: '43.12 Café',
    address: 'Varna CenterOdesos, ul. "Preslav" 15, 9000 Varna, Bulgaria',
    latitude: 43.2040,
    longitude: 27.9202,
    events: [
      Event(
        name: 'NIKOLINA NU X CULPA',
        date: '2024-05-25',
        time: '19:00 - 21:00',
      ),
    ],
  ),
  Venue(
    name: 'Campus 90 - art hotel',
    address:
        'Varna CenterPrimorski, bul. "Tsar Osvoboditel" 90, 9000 Varna, Bulgaria',
    latitude: 43.2132,
    longitude: 27.9117,
    events: [
      Event(
        name: 'REINIS JAUNAIS (LITHUANIA)',
        date: '2024-05-26',
        time: '20:00 - 22:00',
      ),
    ],
  ),
  Venue(
    name: 'Papion Gallery',
    address: '12 "Dragoman" St, Varna',
    latitude: 43.2067,
    longitude: 27.9222,
    events: [
      Event(
        name: 'GROWNUP KIDS ONLY FINISSAGE',
        date: '2024-05-24',
        time: '18:00 - 20:00',
      ),
    ],
  ),
];
