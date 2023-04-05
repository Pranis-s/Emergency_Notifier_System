class UserModel {
  String? name;
  String? id;
  String? phone;
  String? childEmail;
  String? guardianEmail;
  String? type;

  UserModel(
      {this.name,
      this.childEmail,
      this.type,
      this.guardianEmail,
      this.phone,
      this.id});

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'id': id,
        'childEmail': childEmail,
        'parentEmail': guardianEmail,
        'type': type,
      };
}
