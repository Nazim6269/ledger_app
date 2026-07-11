class MemberInput {
  final String userId;
  final String userName;
  final double rawValue;

  MemberInput({
    required this.userId,
    required this.userName,
    this.rawValue = 0,
  });
}
