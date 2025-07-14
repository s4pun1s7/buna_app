# Website Integration Guide

This document explains how the Buna Festival app integrates with the festival website to fetch real-time data including news, events, venues, and other content.

## Overview

The app uses the WordPress REST API to fetch data from the festival website (https://bunavarna.com). This allows the app to display up-to-date information without manual updates.

## API Endpoints

The app expects the following WordPress REST API endpoints to be available:

### Base URL
- **Website**: `https://bunavarna.com`
- **API Base**: `https://bunavarna.com/wp-json/wp/v2`

### Required Endpoints

#### 1. News Articles
```
GET /wp-json/wp/v2/posts?_embed
```
- Fetches blog posts/news articles
- Includes featured images and categories
- Supports pagination with `page` and `per_page` parameters

#### 2. Events (Optional)
```
GET /wp-json/wp/v2/events?_embed
```
- If available, fetches custom event post type
- Falls back to posts with "event" category if not available
- Expected custom fields: `event_start_date`, `event_end_date`, `event_location`, `event_venue`

#### 3. Venues (Optional)
```
GET /wp-json/wp/v2/venues?_embed
```
- If available, fetches custom venue post type
- Expected custom fields: `venue_address`, `venue_latitude`, `venue_longitude`, `venue_website`, `venue_phone`, `venue_email`

#### 4. Festival Information
```
GET /wp-json/wp/v2/pages?slug=about&_embed
```
- Fetches the "About" page for festival information

#### 5. Search
```
GET /wp-json/wp/v2/search?search={query}&_embed
```
- Searches across all content types

## WordPress Setup Requirements

### 1. Enable REST API
Ensure the WordPress REST API is enabled (it's enabled by default in modern WordPress installations).

### 2. Custom Post Types (Recommended)
For better organization, consider creating custom post types for events and venues:

#### Events Custom Post Type
```php
// Add to functions.php or custom plugin
register_post_type('events', [
    'public' => true,
    'show_in_rest' => true,
    'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
    'labels' => [
        'name' => 'Events',
        'singular_name' => 'Event'
    ]
]);
```

#### Venues Custom Post Type
```php
register_post_type('venues', [
    'public' => true,
    'show_in_rest' => true,
    'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
    'labels' => [
        'name' => 'Venues',
        'singular_name' => 'Venue'
    ]
]);
```

### 3. Custom Fields
Set up custom fields for events and venues using Advanced Custom Fields (ACF) or similar:

#### Event Fields
- `event_start_date` (Date/Time)
- `event_end_date` (Date/Time)
- `event_location` (Text)
- `event_venue` (Text or Relationship to Venue)

#### Venue Fields
- `venue_address` (Text)
- `venue_latitude` (Number)
- `venue_longitude` (Number)
- `venue_website` (URL)
- `venue_phone` (Text)
- `venue_email` (Email)

### 4. CORS Configuration
Add CORS headers to allow the app to access the API:

```php
// Add to functions.php
add_action('rest_api_init', function() {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
});
```

## App Configuration

### API Service
The app uses the `ApiService` class (`lib/services/api_service.dart`) to handle all API communication:

- **Base URL**: Configured to `https://bunavarna.com`
- **Caching**: 15-minute cache for API responses
- **Error Handling**: Graceful fallbacks for missing endpoints
- **Pagination**: Supports loading more content

### Data Models
The app includes data models for all content types:

- `NewsArticle`: Blog posts and news
- `FestivalEvent`: Events with dates and locations
- `Venue`: Venues with coordinates and contact info
- `FestivalInfo`: General festival information
- `SearchResults`: Combined search results

### State Management
Riverpod providers manage the data state:

- `newsStateProvider`: News articles with pagination
- `eventsStateProvider`: Events with filtering (upcoming, past, current)
- `venuesStateProvider`: Venues with location-based filtering
- `searchStateProvider`: Search functionality across all content

## Features

### 1. News Feed
- Fetches latest news from the website
- Displays featured images and excerpts
- Pull-to-refresh functionality
- Infinite scrolling for pagination
- Links to full articles on the website

### 2. Events
- Displays upcoming, current, and past events
- Filters events by date
- Shows event details including venue and location
- Links to event pages on the website

### 3. Venues
- Lists all festival venues
- Shows venue details and contact information
- Displays venues on the map
- Location-based filtering

### 4. Search
- Searches across news, events, and venues
- Real-time search results
- Categorized results display

## Testing the Integration

### 1. Test API Endpoints
Use a browser or tool like Postman to test the endpoints:

```bash
# Test news endpoint
curl "https://bunavarna.com/wp-json/wp/v2/posts?_embed"

# Test events endpoint
curl "https://bunavarna.com/wp-json/wp/v2/events?_embed"

# Test venues endpoint
curl "https://bunavarna.com/wp-json/wp/v2/venues?_embed"
```

### 2. Check Response Format
Ensure the API returns JSON with the expected structure:

```json
[
  {
    "id": 123,
    "title": {
      "rendered": "Event Title"
    },
    "content": {
      "rendered": "Event description..."
    },
    "date": "2024-05-22T16:00:00",
    "meta": {
      "event_start_date": "2024-05-22T16:00:00",
      "event_venue": "Venue Name"
    },
    "_embedded": {
      "wp:featuredmedia": [
        {
          "source_url": "https://example.com/image.jpg"
        }
      ]
    }
  }
]
```

### 3. Test in App
Run the app and check:
- News screen loads articles
- Events are displayed correctly
- Venues show on the map
- Search functionality works

## Troubleshooting

### Common Issues

1. **CORS Errors**
   - Ensure CORS headers are properly configured
   - Check if the website allows cross-origin requests

2. **404 Errors**
   - Verify the REST API is enabled
   - Check if custom post types are registered with `show_in_rest: true`

3. **Missing Data**
   - Ensure posts have the required custom fields
   - Check if featured images are properly set

4. **Slow Loading**
   - Consider implementing caching on the WordPress side
   - Optimize images and content

### Debug Mode
Enable debug logging in the app to see API requests and responses:

```dart
// In ApiService.dart, add logging
print('API Request: ${request.url}');
print('API Response: ${response.body}');
```

## Future Enhancements

1. **Real-time Updates**: Implement WebSocket connections for live updates
2. **Offline Support**: Cache content for offline viewing
3. **Push Notifications**: Notify users of new content
4. **User-generated Content**: Allow users to submit photos and reviews
5. **Social Integration**: Share content on social media platforms

## Security Considerations

1. **Rate Limiting**: Implement rate limiting on the WordPress API
2. **Authentication**: Consider adding API keys for production
3. **Data Validation**: Validate all incoming data
4. **HTTPS**: Ensure all API calls use HTTPS

## Support

For issues with the website integration:
1. Check the WordPress REST API documentation
2. Verify endpoint availability and response format
3. Test with curl or Postman
4. Review the app's error logs
5. Contact the development team for assistance 