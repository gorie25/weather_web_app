class EmailSubscription {
  final String email;
  final bool isVerified;
  final String verificationToken;
  final DateTime createdAt;
  final String? cityName;

  EmailSubscription({
    required this.email,
    required this.isVerified,
    required this.verificationToken,
    required this.createdAt,
    this.cityName,
  });

  factory EmailSubscription.fromJson(Map<String, dynamic> json) {
    return EmailSubscription(
      email: json['email'] ?? '',
      isVerified: json['isVerified'] ?? false,
      verificationToken: json['verificationToken'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      cityName: json['cityName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'isVerified': isVerified,
      'verificationToken': verificationToken,
      'createdAt': createdAt.toIso8601String(),
      'cityName': cityName,
    };
  }
}