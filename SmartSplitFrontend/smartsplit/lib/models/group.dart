class Group {
  final String id;
  final String groupName;
  final String description;
  final String profilePicture;
  final String createdBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Group({
    required this.id,
    required this.groupName,
    required this.description,
    required this.profilePicture,
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
      profilePicture: json['profilePicture'],
      createdBy: json['createdBy'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
