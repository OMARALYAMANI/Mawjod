/// نموذج المستخدم — يمثّل طالب الجامعة المسجّل.
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
      };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        uid: (map['uid'] ?? '') as String,
        name: (map['name'] ?? '') as String,
        email: (map['email'] ?? '') as String,
        phone: (map['phone'] ?? '') as String,
      );
}
