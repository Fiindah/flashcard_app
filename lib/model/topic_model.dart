import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Topic {
  final int? id;
  final String name;

  Topic({this.id, required this.name});

  // Convert a Topic object into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  // Implement fromMap to create a Topic object from a Map (e.g., from a database query).
  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
    );
  }

  @override
  String toString() {
    return 'Topic(id: $id, name: $name)';
  }

  String toJson() => json.encode(toMap());

  factory Topic.fromJson(String source) =>
      Topic.fromMap(json.decode(source) as Map<String, dynamic>);
}
