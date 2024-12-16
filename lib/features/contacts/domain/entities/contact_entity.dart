// ignore_for_file: public_member_api_docs, sort_constructors_first

class ContactEntity {
  final String id;
  final String username;
  final String email;

  ContactEntity({
    required this.id,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
    };
  }
}
