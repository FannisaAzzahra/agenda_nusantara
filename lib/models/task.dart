class Task {
  int? id;
  String title;
  String description;
  String dueDate;
  String category; // 'penting' atau 'biasa'
  int isCompleted; // 0 = belum, 1 = selesai
  String completedDate; // tanggal diselesaikan (untuk grafik)

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,
    this.isCompleted = 0,
    this.completedDate = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'category': category,
      'isCompleted': isCompleted,
      'completedDate': completedDate,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      category: map['category'],
      isCompleted: map['isCompleted'],
      completedDate: map['completedDate'] ?? '',
    );
  }
}
