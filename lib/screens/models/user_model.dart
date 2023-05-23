class UserModel {
  final String displayName;
  final String? email;
  final DateTime creationTime;
  final DateTime lastSignInTime;
  final String phoneNumber;
  final String uid;
  final List<dynamic> contactMethods;

  UserModel(
      {required this.displayName,
      required this.email,
      required this.creationTime,
      required this.lastSignInTime,
      required this.phoneNumber,
      required this.uid,
      required this.contactMethods});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
        contactMethods: data['contactMethods'],
        displayName: data['displayName'],
        email: data['email'],
        creationTime: data['creationTime'].toDate(),
        lastSignInTime: data['lastSignInTime'].toDate(),
        phoneNumber: data['phoneNumber'],
        uid: data['uid']);
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'creationTime': creationTime,
      'lastSignInTime': lastSignInTime,
      'phoneNumber': phoneNumber,
      'uid': uid
    };
  }
}
