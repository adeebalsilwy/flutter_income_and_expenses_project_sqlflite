class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  // Convert a Category object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Create a Category object from a map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
    );
  }
}
