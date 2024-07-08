class UserModel {
  final int id;
  final String? firstname;
  final String? lastname;
  final String? mobile;
  final String? birthday;
  final String? gender;
  final bool? visibleGender;

  UserModel(
    this.id,
    this.firstname,
    this.lastname,
    this.mobile,
    this.birthday,
    this.gender,
    this.visibleGender,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        json['id'],
        json['firstname'],
        json['lastname'],
        json['mobile'],
        json['birthday'],
        json['gender'],
        json['visibleGender'],
      );
}
