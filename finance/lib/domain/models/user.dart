abstract class IUser {
  IUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
}
