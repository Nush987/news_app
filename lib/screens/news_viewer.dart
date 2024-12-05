import 'package:flutter/material.dart';

class NewsViewer extends StatelessWidget {
  final Map<String, dynamic>
  article; // Pass the selected article as a parameter

  NewsViewer({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title'] ?? 'News Article'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            if (article['urlToImage'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article['urlToImage'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback UI if the image fails to load
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey.shade700,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),

            SizedBox(height: 16),
            // Article Title
            Text(
              article['title'] ?? 'No Title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Article Author and Published Date
            Text(
              'By ${article['author'] ?? 'Unknown Author'} | ${article['publishedAt'] ?? 'Unknown Date'}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            SizedBox(height: 16),
            // Article Description
            Text(
              article['description'] ?? 'No description available.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            // Read More Button
            Center(child: SelectableText(article['url'])),
          ],
        ),
      ),
    );
  }
}
