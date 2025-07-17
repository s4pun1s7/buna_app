// Service abstraction for Map Gallery data

import 'map_gallery_screen.dart';
import '../../config/mock_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

abstract class MapGalleryDataSource {
  Future<List<MapGalleryItem>> fetchItems();
}

class MockMapGalleryDataSource implements MapGalleryDataSource {
  @override
  Future<List<MapGalleryItem>> fetchItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.mapGalleryItems;
  }
}

class ApiMapGalleryDataSource implements MapGalleryDataSource {
  static const String _endpoint = 'https://api.example.com/map_gallery_items'; // TODO: Replace with real endpoint

  @override
  Future<List<MapGalleryItem>> fetchItems() async {
    try {
      final response = await http.get(Uri.parse(_endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => _fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('No map gallery items found.');
      } else {
        throw Exception('Server error: \\${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on FormatException {
      throw Exception('Invalid data format received from server.');
    } catch (e) {
      throw Exception('Failed to load map gallery items: $e');
    }
  }

  MapGalleryItem _fromJson(Map<String, dynamic> json) {
    return MapGalleryItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      tags: List<String>.from(json['tags'] as List<dynamic>),
      isInteractive: json['isInteractive'] as bool,
    );
  }
} 