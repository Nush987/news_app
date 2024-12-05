import 'dart:convert';

import 'package:http/http.dart' as http;

class NewsApiConnector {
  final String _apiKey = "3e199c661f184d889690650bff606621";
  final String _baseUrl = "https://newsapi.org/v2";

  /// Fetch articles from the "Everything" endpoint
  Future<List<dynamic>> fetchArticles({
    String? query,
    String? searchIn,
    String? sources,
    String? domains,
    String? excludeDomains,
    String? from,
    String? to,
    String? language,
    String? sortBy,
    int? pageSize = 20,
    int? page = 1,
  }) async {
    final Uri url = Uri.parse("$_baseUrl/everything").replace(queryParameters: {
      "apiKey": _apiKey,
      if (query != null) "q": query,
      if (searchIn != null) "searchIn": searchIn,
      if (sources != null) "sources": sources,
      if (domains != null) "domains": domains,
      if (excludeDomains != null) "excludeDomains": excludeDomains,
      if (from != null) "from": from,
      if (to != null) "to": to,
      if (language != null) "language": language,
      if (sortBy != null) "sortBy": sortBy,
      "pageSize": pageSize.toString(),
      "page": page.toString(),
    });

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data["articles"] ?? [];
    } else {
      throw Exception("Failed to load articles: ${response.body}");
    }
  }

  /// Fetch top headlines from the "Top Headlines" endpoint
  Future<List<dynamic>> fetchTopHeadlines({
    String? country,
    String? category,
    String? sources,
    String? query,
    int? pageSize = 20,
    int? page = 1,
  }) async {
    final Uri url = Uri.parse("$_baseUrl/top-headlines").replace(queryParameters: {
      "apiKey": _apiKey,
      if (country != null) "country": country,
      if (category != null) "category": category,
      if (sources != null) "sources": sources,
      if (query != null) "q": query,
      "pageSize": pageSize.toString(),
      "page": page.toString(),
    });

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data["articles"] ?? [];
    } else {
      throw Exception("Failed to load headlines: ${response.body}");
    }
  }
}
