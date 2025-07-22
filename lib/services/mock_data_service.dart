import '../models/festival_data.dart';

/// Comprehensive data service for Buna Festival
class DataService {
  /// Get news articles
  static List<NewsArticle> getNews() {
    return [
      NewsArticle(
        id: 1,
        title: 'Buna Festival 2024: A Celebration of Art and Culture',
        content:
            'The highly anticipated Buna Festival 2024 is set to transform Varna into a vibrant hub of creativity and cultural expression. This year\'s festival promises to be the most spectacular yet, featuring over 50 artists from 15 countries, innovative installations, and immersive experiences that will captivate audiences of all ages.',
        excerpt:
            'Get ready for the most spectacular art festival of the year with over 50 artists from 15 countries!',
        date: DateTime.now().subtract(const Duration(days: 2)),
        featuredImageUrl: null,
        author: 'Festival Team',
        categories: ['Festival', 'Announcement'],
        url: '',
      ),
      NewsArticle(
        id: 2,
        title: 'New Interactive Venues Announced for Buna Festival',
        content:
            'Buna Festival is excited to announce the addition of three new interactive venues that will enhance the festival experience and provide unique spaces for artistic expression.',
        excerpt:
            'Three new interactive venues will transform the festival experience with digital art, floating galleries, and underground theaters.',
        date: DateTime.now().subtract(const Duration(days: 5)),
        featuredImageUrl: null,
        author: 'Venue Coordinator',
        categories: ['Venues', 'Festival'],
        url: '',
      ),
      NewsArticle(
        id: 3,
        title: 'International Artist Lineup Revealed for Buna Festival 2024',
        content:
            'Buna Festival is proud to announce the complete lineup of international artists who will be participating in this year\'s event. The roster includes acclaimed artists from across Europe, Asia, and the Americas, representing a diverse range of artistic disciplines and cultural perspectives.',
        excerpt:
            'Discover the incredible international artists who will be showcasing their work at Buna Festival 2024.',
        date: DateTime.now().subtract(const Duration(days: 7)),
        featuredImageUrl: null,
        author: 'Art Director',
        categories: ['Artists', 'Festival'],
        url: '',
      ),
      NewsArticle(
        id: 4,
        title: 'Festival Passes Now Available - Early Bird Discounts',
        content: '''
Festival passes for Buna Festival 2024 are now available for purchase, with special early bird discounts for those who book before May 1st. The festival offers several pass options to suit different needs and budgets.

Pass Options:
- Day Pass: Access to all venues and events for a single day
- Weekend Pass: Access for Friday through Sunday
- Full Festival Pass: Complete access to all three weeks of the festival
- VIP Pass: Premium access including exclusive events, artist meet-and-greets, and priority seating

Early bird discounts offer up to 30% off regular prices, making this the perfect time to secure your spot at the most anticipated art event of the year. Passes can be purchased online through the festival website or at designated ticket outlets throughout Varna.

"We want to make the festival accessible to everyone," says marketing director Victoria Petrova. "The early bird discounts are our way of rewarding those who plan ahead and ensuring that art lovers can experience everything the festival has to offer."
        ''',
        excerpt:
            'Secure your spot at Buna Festival 2024 with early bird discounts of up to 30% off festival passes.',
        date: DateTime.now().subtract(const Duration(days: 10)),
        author: 'Marketing Team',
        featuredImageUrl: null,
        categories: ['Tickets', 'Festival'],
        url: '',
      ),
      NewsArticle(
        id: 5,
        title: 'Volunteer Applications Open for Buna Festival 2024',
        content: '''
Buna Festival is seeking enthusiastic volunteers to help make this year's event a success. Volunteers play a crucial role in the festival's operations, from assisting artists and managing venues to helping visitors navigate the festival grounds.

Volunteer positions available include:
- Venue assistants
- Artist liaisons
- Information desk staff
- Technical support
- Photography and documentation
- Sustainability coordinators

Volunteers receive free festival passes, exclusive behind-the-scenes access, and the opportunity to work alongside international artists. Training sessions will be provided before the festival begins, ensuring that all volunteers are well-prepared for their roles.

"Volunteering at Buna Festival is a unique opportunity to be part of something truly special," says volunteer coordinator Dimitar Georgiev. "It's not just about helping out - it's about being part of a community that celebrates art and creativity."

Applications are open until June 1st, with interviews and training sessions scheduled throughout June.
        ''',
        excerpt:
            'Join the Buna Festival team as a volunteer and be part of the most exciting art event of the year.',
        date: DateTime.now().subtract(const Duration(days: 12)),
        author: 'Volunteer Coordinator',
        featuredImageUrl: null,
        categories: ['Volunteers', 'Festival'],
        url: '',
      ),
    ];
  }

  /// Get events
  static List<FestivalEvent> getEvents() {
    return [
      FestivalEvent(
        id: 1,
        title: 'Opening Ceremony & Light Show',
        description:
            'Join us for the spectacular opening of Buna Festival 2024! The evening begins with a grand ceremony featuring local dignitaries and festival organizers, followed by an incredible light show.',
        startDate: DateTime.now().add(const Duration(days: 30, hours: 19)),
        endDate: DateTime.now().add(const Duration(days: 30, hours: 23)),
        venue: 'Main Square',
        category: 'Ceremony',
        featuredImageUrl: null,
        url: '',
      ),
      FestivalEvent(
        id: 2,
        title: 'Contemporary Art Exhibition',
        description:
            'Experience the cutting edge of contemporary art at this major exhibition featuring works from international and local artists.',
        startDate: DateTime.now().add(const Duration(days: 31)),
        endDate: DateTime.now().add(const Duration(days: 45)),
        venue: 'City Gallery',
        category: 'Exhibition',
        featuredImageUrl: null,
        url: '',
      ),
      FestivalEvent(
        id: 3,
        title: 'Live Music & Performance Night',
        description:
            'An evening of extraordinary live performances featuring musicians, dancers, and performance artists from around the world.',
        startDate: DateTime.now().add(const Duration(days: 32, hours: 20)),
        endDate: DateTime.now().add(const Duration(days: 32, hours: 23)),
        venue: 'Outdoor Amphitheater',
        category: 'Performance',
        featuredImageUrl: null,
        url: '',
      ),
      FestivalEvent(
        id: 4,
        title: 'Digital Art & VR Experience',
        description: '''
Step into the future of art at this immersive digital art exhibition featuring virtual reality experiences, augmented reality installations, and interactive digital artworks. This cutting-edge showcase demonstrates how technology is transforming the way we create and experience art.

Visitors can don VR headsets to explore virtual art galleries, interact with AI-generated artworks, and experience immersive storytelling that blurs the line between reality and imagination.

The exhibition also includes workshops where participants can learn about digital art creation, coding for artists, and the future of art in the digital age.
        ''',
        startDate: DateTime.now().add(const Duration(days: 33)),
        endDate: DateTime.now().add(const Duration(days: 40)),
        venue: 'Digital Art Pavilion',
        category: 'Digital Art',
        featuredImageUrl: null,
        url: '',
      ),
      FestivalEvent(
        id: 5,
        title: 'Environmental Art Installation',
        description: '''
Experience art that responds to and reflects our relationship with the natural world. This large-scale environmental art installation uses sustainable materials and renewable energy to create thought-provoking works that address climate change and environmental conservation.

The installation includes sculptures made from recycled materials, living artworks that grow and change throughout the festival, and interactive pieces that educate visitors about environmental issues.

Artists will be present to discuss their work and the environmental themes they explore, making this both an artistic and educational experience.
        ''',
        startDate: DateTime.now().add(const Duration(days: 35)),
        endDate: DateTime.now().add(const Duration(days: 50)),
        venue: 'Seaside Park',
        category: 'Environmental Art',
        featuredImageUrl: null,
        url: '',
      ),
      FestivalEvent(
        id: 6,
        title: 'Artist Workshops & Masterclasses',
        description: '''
Learn directly from the masters! This series of workshops and masterclasses gives you the opportunity to work alongside international artists and learn their techniques and creative processes.

Workshops include:
- Digital Art Creation with Hiroshi Tanaka
- Sustainable Sculpture with Sarah Johnson
- Performance Art with Marcus Weber
- Traditional Bulgarian Crafts with local artisans
- Photography and Documentation

All skill levels are welcome, and materials are provided. Pre-registration is required as spaces are limited.
        ''',
        startDate: DateTime.now().add(const Duration(days: 37)),
        endDate: DateTime.now().add(const Duration(days: 42)),
        venue: 'Art Studio Complex',
        category: 'Workshop',
        featuredImageUrl: null,
        url: '',
      ),
      FestivalEvent(
        id: 7,
        title: 'Closing Ceremony & Collaborative Performance',
        description: '''
The grand finale of Buna Festival 2024 brings together all participating artists for a spectacular collaborative performance that celebrates the power of art to unite people across cultures and disciplines.

The evening features a multimedia performance combining music, dance, visual art, and technology, created specifically for this closing event. All festival artists have contributed to this unique collaborative piece, making it a true celebration of artistic diversity and creativity.

The ceremony also includes awards for outstanding contributions to the festival and announcements about plans for next year's event.
        ''',
        startDate: DateTime.now().add(const Duration(days: 50, hours: 19)),
        endDate: DateTime.now().add(const Duration(days: 50, hours: 23)),
        venue: 'Main Square',
        category: 'Ceremony',
        featuredImageUrl: null,
        url: '',
      ),
    ];
  }

  /// Get venues
  static List<Venue> getVenues() {
    return [
      Venue(
        id: 1,
        name: 'Main Square',
        address: 'Central Square, Varna, Bulgaria',
        description:
            'The heart of Varna and the primary venue for major festival events.',
        latitude: 43.2141,
        longitude: 27.9147,
        featuredImageUrl: null,
        events: [],
      ),
      Venue(
        id: 2,
        name: 'City Gallery',
        address: '123 Art Street, Varna, Bulgaria',
        description:
            'A modern, purpose-built gallery space that serves as the primary venue for contemporary art exhibitions.',
        latitude: 43.2150,
        longitude: 27.9150,
        featuredImageUrl: null,
        events: [],
      ),
      Venue(
        id: 3,
        name: 'Outdoor Amphitheater',
        address: 'Seaside Park, Varna, Bulgaria',
        description:
            'A stunning open-air performance venue located on the Black Sea coast.',
        latitude: 43.2130,
        longitude: 27.9130,
        featuredImageUrl: null,
        events: [],
      ),
      Venue(
        id: 4,
        name: 'Digital Art Pavilion',
        address: '456 Innovation Boulevard, Varna, Bulgaria',
        description: '''
A cutting-edge venue specifically designed for digital art and technology-based installations. The pavilion features high-speed internet, advanced projection systems, VR equipment, and interactive displays.

The space is divided into several zones: a VR experience area, an interactive installation space, a digital art gallery, and a workshop area where visitors can learn about digital art creation.

The pavilion represents the future of art exhibition spaces, combining technology and creativity in innovative ways.
        ''',
        latitude: 43.2160,
        longitude: 27.9160,
        featuredImageUrl: null,
        events: [],
      ),
      Venue(
        id: 5,
        name: 'Seaside Park',
        address: 'Seaside Park, Varna, Bulgaria',
        description: '''
A beautiful natural setting for environmental art installations and outdoor exhibitions. The park's diverse landscape includes gardens, walking paths, and open spaces perfect for large-scale sculptures and land art.

The park is home to several environmental art installations that change throughout the festival, responding to weather conditions and natural cycles. Visitors can enjoy art while connecting with nature in this peaceful setting.

The park also features picnic areas, restrooms, and refreshment stands for visitors' convenience.
        ''',
        latitude: 43.2120,
        longitude: 27.9120,
        featuredImageUrl: null,
        events: [],
      ),
      Venue(
        id: 6,
        name: 'Art Studio Complex',
        address: '789 Creative Lane, Varna, Bulgaria',
        description: '''
A dedicated space for workshops, masterclasses, and hands-on art creation. The complex includes multiple studio spaces equipped with various art supplies and tools for different mediums.

The studios are designed to accommodate different group sizes and art forms, from painting and sculpture to digital art and performance. Each studio has proper ventilation, lighting, and safety equipment.

The complex also includes a gallery space where workshop participants can display their work and a café for breaks and discussions.
        ''',
        latitude: 43.2170,
        longitude: 27.9170,
        featuredImageUrl: null,
        events: [],
      ),
      Venue(
        id: 7,
        name: 'Underground Theater',
        address: '321 Industrial Zone, Varna, Bulgaria',
        description: '''
A converted warehouse space that has been transformed into an experimental theater venue. The industrial aesthetic of the space provides a unique backdrop for avant-garde performances and multimedia art.

The theater features flexible seating arrangements, advanced lighting and sound systems, and a large stage area that can be configured for different types of performances.

The underground location creates an intimate atmosphere perfect for experimental theater, performance art, and immersive experiences.
        ''',
        latitude: 43.2180,
        longitude: 27.9180,
        featuredImageUrl: null,
        events: [],
      ),
    ];
  }

  /// Get festival information
  static FestivalInfo getFestivalInfo() {
    return FestivalInfo(
      title: 'Buna Festival 2024',
      description:
          'Buna Festival is the premier art and culture festival in Varna, Bulgaria, bringing together artists, musicians, performers, and art enthusiasts from around the world for three weeks of creative celebration.',
      featuredImageUrl: null,
      metadata: {
        'excerpt':
            'Experience the magic of art and culture at Buna Festival 2024 - three weeks of creative celebration in Varna, Bulgaria.',
        'url': '',
      },
    );
  }

  /// Get search results
  static SearchResults getSearchResults(String query) {
    final lowercaseQuery = query.toLowerCase();
    final news = getNews();
    final events = getEvents();
    final venues = getVenues();

    final filteredNews = news
        .where(
          (article) =>
              article.title.toLowerCase().contains(lowercaseQuery) ||
              article.content.toLowerCase().contains(lowercaseQuery) ||
              article.excerpt.toLowerCase().contains(lowercaseQuery),
        )
        .toList();

    final filteredEvents = events
        .where(
          (event) =>
              event.title.toLowerCase().contains(lowercaseQuery) ||
              event.description.toLowerCase().contains(lowercaseQuery) ||
              (event.venue?.toLowerCase().contains(lowercaseQuery) ?? false) ||
              (event.category?.toLowerCase().contains(lowercaseQuery) ?? false),
        )
        .toList();

    final filteredVenues = venues
        .where(
          (venue) =>
              venue.name.toLowerCase().contains(lowercaseQuery) ||
              (venue.description?.toLowerCase().contains(lowercaseQuery) ??
                  false) ||
              venue.address.toLowerCase().contains(lowercaseQuery),
        )
        .toList();

    return SearchResults(
      news: filteredNews,
      events: filteredEvents,
      venues: filteredVenues,
      totalResults:
          filteredNews.length + filteredEvents.length + filteredVenues.length,
    );
  }
}
