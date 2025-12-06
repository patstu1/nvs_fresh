// packages/core/lib/models/subscription_info.dart

class SubscriptionInfo {
  final String plan; // Missing getter causing errors

  const SubscriptionInfo({this.plan = 'free'});

  Map<String, dynamic> toJson() => {'plan': plan};

  factory SubscriptionInfo.fromMap(Map<String, dynamic> map) {
    return SubscriptionInfo(plan: map['plan'] ?? 'free');
  }
}
