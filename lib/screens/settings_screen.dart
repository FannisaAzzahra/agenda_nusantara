import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _currentPasswordController = TextEditingController();  // menyimpan password
  final _newPasswordController = TextEditingController(); // menyimpan password baru  
  bool _isSaving = false;
  String _message = '';
  bool _isSuccess = false; // true = pesan sukses, false = pesan error

  Future<void> _savePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty) {
      setState(() {
        _message = 'Semua field harus diisi.';
        _isSuccess = false;
      });
      return;
    }

    setState(() => _isSaving = true);

    final isCorrect =
        await DatabaseHelper.instance.checkPassword(currentPassword);

    if (!isCorrect) {
      setState(() {
        _isSaving = false;
        _message = 'Password saat ini salah!';
        _isSuccess = false;
      });
      return;
    }

    await DatabaseHelper.instance.updatePassword(newPassword);

    setState(() {
      _isSaving = false;
      _message = 'Password berhasil diubah!';
      _isSuccess = true;
    });

    _currentPasswordController.clear();
    _newPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: const Color(0xFF4A7C6F),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Ganti Password
            const Text(
              'GANTI PASSWORD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A7C6F),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // Password Saat Ini
            _FieldLabel(text: 'PASSWORD SAAT INI'),
            const SizedBox(height: 8),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '••••',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password Baru
            _FieldLabel(text: 'PASSWORD BARU'),
            const SizedBox(height: 8),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '••••••••',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Pesan sukses / error
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color: _isSuccess ? Colors.green[700] : Colors.red,
                  fontSize: 13,
                ),
              ),
            const SizedBox(height: 12),

            // Tombol Simpan Password
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _savePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7C6F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SIMPAN PASSWORD',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 20),

            // Section: Developer
            const Text(
              'DEVELOPER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A7C6F),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // Developer Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Avatar / Foto
                  // CircleAvatar(
                  //   radius: 30,
                  //   backgroundColor: const Color(0xFF4A7C6F).withOpacity(0.15),
                  //   child: const Icon(
                  //     Icons.person,
                  //     size: 32,
                  //     color: Color(0xFF4A7C6F),
                  //   ),
                  // ),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/foto.jpg'),
                  ),
                  const SizedBox(width: 16),
                  // Info Developer
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fannisa Azzahra',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'NIM: 2241760102',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'DEVELOPER APLIKASI',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
        letterSpacing: 1,
      ),
    );
  }
}
