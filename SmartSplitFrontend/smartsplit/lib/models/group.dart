class Group {
  final String id;
  final String groupName;
  final String description;
  final String createdBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  DateTime? deletedAt;

  Group({
    required this.id,
    required this.groupName,
    required this.description,
    required this.createdBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'],
      groupName: json['groupName'],
      description: json['description'],
      createdBy: json['createdBy'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
