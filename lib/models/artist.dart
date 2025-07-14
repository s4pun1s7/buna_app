class Artist {
  final String id;
  final String name;
  final String country;
  final String bio;
  final String specialty;
  final String? imageUrl;
  final String website;
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
