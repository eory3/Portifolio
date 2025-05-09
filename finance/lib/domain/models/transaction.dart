abstract class ITransaction {
  final String? id;
  final double value;
  final String date;
  final String category;
  final String type;
  final String description;
  final String day;
  final String month;
  final String year;

  ITransaction({
    this.id,
    required this.value,
    required this.date,
    required this.category,
    required this.type,
    required this.description,
    required this.day,
    required this.month,
    required this.year,
  });
}
