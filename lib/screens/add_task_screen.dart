import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final String category; // 'penting' atau 'biasa'

  const AddTaskScreen({super.key, required this.category});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  bool get _isPenting => widget.category == 'penting';

  Color get _primaryColor =>
      _isPenting ? const Color(0xFFD32F2F) : const Color(0xFF4A7C6F);

  String get _screenTitle =>
      _isPenting ? 'Tambah Tugas Penting' : 'Tambah Tugas Biasa';

  String get _categoryLabel => _isPenting ? 'PENTING' : 'BIASA';

  Color get _badgeColor =>
      _isPenting ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9);

  Color get _badgeTextColor =>
      _isPenting ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: _primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tugas tidak boleh kosong.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final task = Task(
      title: title,
      description: _descController.text.trim(),
      dueDate: DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDate),
      category: widget.category,
    );

    await DatabaseHelper.instance.insertTask(task);

    setState(() => _isSaving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tugas berhasil disimpan!'),
        backgroundColor: _primaryColor,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle),
        backgroundColor: _primaryColor,
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
            // Badge kategori
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _badgeColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _categoryLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _badgeTextColor,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tanggal Jatuh Tempo
            _FieldLabel(text: 'TANGGAL JATUH TEMPO'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month,
                        color: Colors.grey[600], size: 18),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDate),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Judul Tugas
            _FieldLabel(text: 'JUDUL TUGAS'),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: _isPenting
                    ? 'Contoh: Submit laporan'
                    : 'Contoh: Beli buah',
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
            const SizedBox(height: 20),

            // Deskripsi
            _FieldLabel(text: 'DESKRIPSI'),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Jelaskan tugas...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SIMPAN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
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
