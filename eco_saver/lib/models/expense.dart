class Expense {
  String userId;
  String name;
  double amount;
  String category;
  DateTime date;
  String? notes;
  DateTime createdAt;

  Expense({
    required this.userId,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      userId: json['userId'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
