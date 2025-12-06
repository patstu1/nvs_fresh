// packages/core/lib/models/verification_info.dart

class VerificationInfo {
  final bool isVerified;
  final String? verificationMethod;
  final DateTime? verifiedAt;

  const VerificationInfo({
    required this.isVerified,
    this.verificationMethod,
    this.verifiedAt,
  });

  factory VerificationInfo.unverified() {
    return const VerificationInfo(isVerified: false);
  }

  factory VerificationInfo.verified({String method = 'phone'}) {
    return VerificationInfo(
      isVerified: true,
      verificationMethod: method,
      verifiedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isVerified': isVerified,
      'verificationMethod': verificationMethod,
      'verifiedAt': verifiedAt?.millisecondsSinceEpoch,
    };
  }

  factory VerificationInfo.fromFirestore(Map<String, dynamic> data) {
    return VerificationInfo(
      isVerified: data['isVerified'] ?? false,
      verificationMethod: data['verificationMethod'],
      verifiedAt: data['verifiedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['verifiedAt'])
          : null,
    );
  }
}
