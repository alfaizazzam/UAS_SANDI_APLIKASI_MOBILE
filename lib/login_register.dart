import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  void _toggleView() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        _currentUser = userCredential.user;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e);
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<void> _register() async {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (userCredential.user != null) {
          await userCredential.user!
              .updateDisplayName(_usernameController.text.trim());
          setState(() {
            _currentUser = userCredential.user;
          });
        }
        setState(() {
          _isLogin = true;
        });
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e);
      } catch (e) {
        print('Unexpected error: $e');
      }
    } else {
      _showErrorDialogMessage('Passwords do not match');
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _currentUser = null;
    });
  }

  Future<void> _sendPasswordResetEmail() async {
    if (_emailController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());
        print('Password reset email sent');
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Email is empty');
    }
  }

  Future<void> _deleteUser() async {
    try {
      await _currentUser?.delete();
      print('User deleted');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateUserProfile(
      {String? displayName, String? photoURL}) async {
    try {
      if (displayName != null) {
        await _currentUser?.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await _currentUser?.updatePhotoURL(photoURL);
      }
      print('User profile updated');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateUserEmail(String newEmail) async {
    try {
      await _currentUser?.updateEmail(newEmail);
      print('User email updated');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _sendEmailVerification() async {
    try {
      await _currentUser?.sendEmailVerification();
      print('Email verification sent');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateUserPassword(String newPassword) async {
    try {
      await _currentUser?.updatePassword(newPassword);
      print('User password updated');
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showErrorDialog(FirebaseAuthException e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('${e.message} (${e.code})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialogMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          if (_currentUser != null)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _signOut,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start, // Align to left
          children: [
            Center(
              // Centering the logo
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo_1.png', // Your logo path
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _isLogin ? 'MASUK' : 'BUAT AKUN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32), // Green color
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              _isLogin ? 'Masuk' : 'Buat Akun',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Change color to white
              ),
            ),
            SizedBox(height: 20),
            if (!_isLogin)
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Masukkan Username Disini',
                  border: OutlineInputBorder(),
                ),
              ),
            if (!_isLogin) SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Masukkan Email Disini',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Masukkan Password Disini',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            if (!_isLogin) SizedBox(height: 10),
            if (!_isLogin)
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  hintText: 'Masukkan Password Disini',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
              ),
            if (_isLogin) SizedBox(height: 10),
            if (_isLogin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _sendPasswordResetEmail,
                    child: Text(
                      'Lupa Password?',
                      style: TextStyle(color: Color(0xFF2E7D32)),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLogin ? _signIn : _register,
              child: Text(_isLogin ? 'Masuk' : 'Buat Akun'),
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    Color(0xFFFFFFFF), // Mengubah warna teks menjadi putih
                backgroundColor: Color(0xFF2E7D32), // Warna background hijau
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_isLogin ? 'Kamu Belum Punya Akun?' : 'Sudah Punya Akun?'),
                TextButton(
                  onPressed: _toggleView,
                  child: Text(
                    _isLogin ? 'Buat disini' : 'Masuk sekarang',
                    style: TextStyle(color: Color(0xFF2E7D32)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
