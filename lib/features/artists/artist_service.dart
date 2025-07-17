import '../../models/artist.dart';
import '../../config/mock_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

abstract class ArtistDataSource {
  Future<List<Artist>> fetchArtists();
}

class MockArtistDataSource implements ArtistDataSource {
  @override
  Future<List<Artist>> fetchArtists() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.artists;
  }
}

class ApiArtistDataSource implements ArtistDataSource {
  static const String _endpoint = 'https://api.example.com/artists'; // TODO: Replace with real endpoint

  @override
  Future<List<Artist>> fetchArtists() async {
    try {
      final response = await http.get(Uri.parse(_endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => _fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('No artists found.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on FormatException {
      throw Exception('Invalid data format received from server.');
    } catch (e) {
      throw Exception('Failed to load artists: $e');
    }
  }

  Artist _fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      bio: json['bio'] as String,
      specialty: json['specialty'] as String,
      imageUrl: json['imageUrl'] as String?,
      website: (json['website'] as String?) ?? '',
      socialMedia: List<String>.from(json['socialMedia'] as List<dynamic>),
    );
  }
} 