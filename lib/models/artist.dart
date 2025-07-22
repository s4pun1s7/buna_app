/// Artist model representing a festival artist profile.
///
/// Used throughout the app for artist cards, lists, and details.
class Artist {
  /// Unique identifier for the artist.
  final String id;

  /// Display name of the artist.
  final String name;

  /// Country of origin or residence.
  final String country;

  /// Short biography or description.
  final String bio;

  /// Main specialty or artistic field.
  final String specialty;

  /// Optional image URL for the artist's portrait.
  final String? imageUrl;

  /// Official website URL.
  final String website;

  /// List of social media profile URLs.
  final List<String> socialMedia;

  const Artist({
    required this.id,
    required this.name,
    required this.country,
    required this.bio,
    required this.specialty,
    this.imageUrl,
    required this.website,
    required this.socialMedia,
  });
}
