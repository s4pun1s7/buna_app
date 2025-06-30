/// News article model
class NewsArticle {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final DateTime date;
  final String? featuredImageUrl;
  final String author;
  final List<String> categories;
  final String url;

  NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.date,
    this.featuredImageUrl,
    required this.author,
    required this.categories,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as int,
      title: _parseHtml(json['title']['rendered'] as String),
      content: json['content']['rendered'] as String,
      excerpt: _parseHtml(json['excerpt']['rendered'] as String),
      date: DateTime.parse(json['date'] as String),
      featuredImageUrl:
          json['_embedded']?['wp:featuredmedia']?[0]?['source_url'] as String?,
      author: json['_embedded']?['author']?[0]?['name'] as String? ?? 'Unknown',
      categories:
          (json['_embedded']?['wp:term']?[0] as List<dynamic>?)
              ?.map((cat) => cat['name'] as String)
              .toList() ??
          [],
      url: json['link'] as String,
    );
  }

  static String _parseHtml(String html) {
    // Simple HTML tag removal - in production, use a proper HTML parser
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .trim();
  }
}

/// Festival event model
class FestivalEvent {
  final int id;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;
  final String? location;
  final String? venue;
  final String? category;
  final String? featuredImageUrl;
  final String url;

  FestivalEvent({
    required this.id,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.location,
    this.venue,
    this.category,
    this.featuredImageUrl,
    required this.url,
  });

  factory FestivalEvent.fromJson(Map<String, dynamic> json) {
    return FestivalEvent(
      id: json['id'] as int,
      title: _parseHtml(json['title']['rendered'] as String),
      description: _parseHtml(json['content']['rendered'] as String),
      startDate: json['meta']?['event_start_date'] != null
          ? DateTime.parse(json['meta']['event_start_date'] as String)
          : null,
      endDate: json['meta']?['event_end_date'] != null
          ? DateTime.parse(json['meta']['event_end_date'] as String)
          : null,
      startTime: json['meta']?['event_start_time'] as String?,
      endTime: json['meta']?['event_end_time'] as String?,
      location: json['meta']?['event_location'] as String?,
      venue: json['meta']?['event_venue'] as String?,
      category: json['meta']?['event_category'] as String?,
      featuredImageUrl:
          json['_embedded']?['wp:featuredmedia']?[0]?['source_url'] as String?,
      url: json['link'] as String,
    );
  }

  factory FestivalEvent.fromPostJson(Map<String, dynamic> json) {
    return FestivalEvent(
      id: json['id'] as int,
      title: _parseHtml(json['title']['rendered'] as String),
      description: _parseHtml(json['content']['rendered'] as String),
      startDate: json['meta']?['event_start_date'] != null
          ? DateTime.parse(json['meta']['event_start_date'] as String)
          : null,
      endDate: json['meta']?['event_end_date'] != null
          ? DateTime.parse(json['meta']['event_end_date'] as String)
          : null,
      startTime: json['meta']?['event_start_time'] as String?,
      endTime: json['meta']?['event_end_time'] as String?,
      location: json['meta']?['event_location'] as String?,
      venue: json['meta']?['event_venue'] as String?,
      category: json['meta']?['event_category'] as String?,
      featuredImageUrl:
          json['_embedded']?['wp:featuredmedia']?[0]?['source_url'] as String?,
      url: json['link'] as String,
    );
  }

  static String _parseHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .trim();
  }
}

/// Venue model
class Venue {
  final int id;
  final String name;
  final String address;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? email;
  final String? website;
  final String? featuredImageUrl;
  final List<Event> events;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    this.description,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.website,
    this.featuredImageUrl,
    required this.events,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as int,
      name: _parseHtml(json['title']['rendered'] as String),
      address: json['meta']?['venue_address'] as String? ?? '',
      description: _parseHtml(json['content']['rendered'] as String),
      latitude: json['meta']?['venue_latitude'] != null
          ? double.parse(json['meta']['venue_latitude'] as String)
          : null,
      longitude: json['meta']?['venue_longitude'] != null
          ? double.parse(json['meta']['venue_longitude'] as String)
          : null,
      phone: json['meta']?['venue_phone'] as String?,
      email: json['meta']?['venue_email'] as String?,
      website: json['meta']?['venue_website'] as String?,
      featuredImageUrl:
          json['_embedded']?['wp:featuredmedia']?[0]?['source_url'] as String?,
      events: [], // Events will be populated separately
    );
  }

  static String _parseHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .trim();
  }
}

/// Festival information model
class FestivalInfo {
  final String title;
  final String description;
  final String? featuredImageUrl;
  final Map<String, dynamic> metadata;

  FestivalInfo({
    required this.title,
    required this.description,
    this.featuredImageUrl,
    required this.metadata,
  });

  factory FestivalInfo.fromJson(Map<String, dynamic> json) {
    return FestivalInfo(
      title: _parseHtml(json['title']['rendered'] as String),
      description: _parseHtml(json['content']['rendered'] as String),
      featuredImageUrl:
          json['_embedded']?['wp:featuredmedia']?[0]?['source_url'] as String?,
      metadata: json['meta'] as Map<String, dynamic>? ?? {},
    );
  }

  static String _parseHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .trim();
  }
}

/// Search results model
class SearchResults {
  final List<NewsArticle> news;
  final List<FestivalEvent> events;
  final List<Venue> venues;
  final int totalResults;

  SearchResults({
    required this.news,
    required this.events,
    required this.venues,
    required this.totalResults,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      news:
          (json['news'] as List<dynamic>?)
              ?.map(
                (item) => NewsArticle.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      events:
          (json['events'] as List<dynamic>?)
              ?.map(
                (item) => FestivalEvent.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      venues:
          (json['venues'] as List<dynamic>?)
              ?.map((item) => Venue.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
}

/// Event model (for venues)
class Event {
  final String name;
  final String date;
  final String time;
  final String? description;

  Event({
    required this.name,
    required this.date,
    required this.time,
    this.description,
  });
}
