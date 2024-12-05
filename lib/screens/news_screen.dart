import 'package:e184969_news_app/screens/news_viewer.dart';
import 'package:e184969_news_app/services/api_connector.dart'; // Import the API connector
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiConnector _apiConnector = NewsApiConnector();
  List<dynamic> _articles = [];
  bool _isLoading = true;
  String _sortBy = 'publishedAt'; // Default sorting
  String _query = ''; // Default query

  // Fetch articles with the current filters
  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final articles = await _apiConnector.fetchArticles(
        query: _query.isEmpty ? null : _query,
        sortBy: _sortBy,
      );

      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching articles: $e")));
    }
  }

// Fetch top headlines using the fetchTopHeadlines method
  Future<void> _loadTopHeadlines({
    String? country = 'us',
    String? category,
  }) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final articles = await _apiConnector.fetchTopHeadlines(
        country: country,
        category: category,
      );

      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading headlines: $e")),
      );
    }
  }
  
  @override
  void initState() {
    super.initState();
    _loadTopHeadlines(); // Fetch articles on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Screen"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchArticles, // Refresh articles
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Sort Controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Sort Dropdown
                Expanded(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    items: [
                      DropdownMenuItem(
                        value: 'publishedAt',
                        child: Text('Newest'),
                      ),
                      DropdownMenuItem(
                        value: 'popularity',
                        child: Text('Popularity'),
                      ),
                      DropdownMenuItem(
                        value: 'relevancy',
                        child: Text('Relevancy'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _sortBy = value;
                          _fetchArticles();
                        });
                      }
                    },
                  ),
                ),
                SizedBox(width: 8),
                // Search Field
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _fetchArticles,
                      ),
                    ),
                    onChanged: (value) {
                      _query = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // Display Articles
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _articles.isEmpty
                    ? Center(child: Text('No articles found'))
                    : ListView.builder(
                      itemCount: _articles.length,
                      itemBuilder: (context, index) {
                        final article = _articles[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: ListTile(
                            leading:
                                article['urlToImage'] != null
                                    ? Image.network(
                                      article['urlToImage'],
                                      width: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        // Fallback UI if the image fails to load
                                        return CircleAvatar(
                                          backgroundColor: Colors.blue.shade200,
                                          child: Text(
                                            article['title']![0].toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    : CircleAvatar(
                                      backgroundColor: Colors.blue.shade200,
                                      child: Text(
                                        article['title']![0].toUpperCase(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),

                            title: Text(article['title'] ?? 'No title'),
                            subtitle: Text(
                              article['description'] ?? 'No description',
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => NewsViewer(article: article),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
