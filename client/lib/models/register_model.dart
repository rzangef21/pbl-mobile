class RegisterModel {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String address;
  final int positionId;
  final int departmentId;
  final String password;

  RegisterModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.address,
    required this.positionId,
    required this.departmentId,
    required this.password,
  });

  RegisterModel get() {
    return RegisterModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      gender: gender,
      address: address,
      positionId: positionId,
      departmentId: departmentId,
      password: password,
    );
  }
}
