import 'package:e184969_news_app/services/database_helper.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Perform sign-up action
                String name = _nameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;

                if (name.isEmpty || email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                // Insert the new user into the database
                await _dbHelper.insert({
                  'name': name,
                  'email': email,
                  'password': password,
                });
                print("Signed Up!: ${name} - ${email} - ${password}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Account created for $email')),
                );

                Navigator.pop(context); // Navigate back to LoginScreen
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
