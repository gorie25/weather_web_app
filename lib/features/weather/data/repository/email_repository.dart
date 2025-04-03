import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_web_app/features/weather/data/repository/email_service.dart';
import 'package:weather_web_app/features/weather/model/email.dart';

class EmailSubscriptionRepository {
  static const String _key = 'email_subscriptions';
  final EmailService _emailService;

  EmailSubscriptionRepository() : _emailService = EmailService();

  Future<void> subscribe(String email, String? cityName) async {
    try {
      final subscriptions = await _getSubscriptions();

      if (subscriptions.any((sub) => sub.email == email)) {
        throw Exception('Email already subscribed');
      }

      final token = _generateToken(email);

      final subscription = EmailSubscription(
        email: email,
        isVerified: false,
        verificationToken: token,
        createdAt: DateTime.now(),
        cityName: cityName,
      );

      subscriptions.add(subscription);
      await _saveSubscriptions(subscriptions);

      await _sendVerificationEmail(email, token);
    } catch (e) {
      print('Error in subscribe: $e');
      throw Exception('Failed to subscribe');
    }
  }

  String _generateToken(String email) {
    final bytes = utf8.encode(email + DateTime.now().toString());
    return sha256.convert(bytes).toString().substring(0, 32);
  }

  Future<void> _sendVerificationEmail(String email, String token) async {
    final verificationLink = 'http://yourapp.com/verify?email=$email&token=$token';
    final htmlContent = '''
      Verify Your Email
      Click the link below to verify your email:
            "$verificationLink"
      If you didn't request this, ignore this email.
    ''';

    await _emailService.sendEmail(
      to: email,
      subject: 'Verify your email address',
      htmlContent: htmlContent,
    );
  }

  Future<void> _sendWelcomeEmail(String email) async {
    final unsubscribeLink = 'http://yourapp.com/unsubscribe?email=$email';
    final htmlContent = '''
      <h1>Welcome to Weather Service!</h1>
      <p>Thank you for subscribing. You will now receive daily weather updates.</p>
      <p>To unsubscribe, click <a href="$unsubscribeLink">here</a>.</p>
    ''';

    await _emailService.sendEmail(
      to: email,
      subject: 'Welcome to Weather Forecast Service',
      htmlContent: htmlContent,
    );
  }

  Future<void> _sendUnsubscribeConfirmation(String email) async {
    final htmlContent = '''
      You have been unsubscribe
      You will no longer receive weather updates.    
    ''';

    await _emailService.sendEmail(
      to: email,
      subject: 'Unsubscribed from Weather Service',
      htmlContent: htmlContent,
    );
  }

  Future<List<EmailSubscription>> _getSubscriptions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_key);
      if (data == null) return [];

      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((json) => EmailSubscription.fromJson(json)).toList();
    } catch (e) {
      print('Error getting subscriptions: $e');
      return [];
    }
  }

  Future<void> _saveSubscriptions(List<EmailSubscription> subscriptions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = json.encode(subscriptions.map((s) => s.toJson()).toList());
      await prefs.setString(_key, data);
    } catch (e) {
      print('Error saving subscriptions: $e');
      throw Exception('Failed to save subscriptions');
    }
  }

  Future<void> verifyEmail(String email, String token) async {
    try {
      final subscriptions = await _getSubscriptions();
      final index = subscriptions.indexWhere((sub) => 
        sub.email == email && sub.verificationToken == token);

      if (index == -1) {
        throw Exception('Invalid verification token');
      }

      final updatedSubscription = EmailSubscription(
        email: email,
        isVerified: true,
        verificationToken: token,
        createdAt: subscriptions[index].createdAt,
        cityName: subscriptions[index].cityName,
      );

      subscriptions[index] = updatedSubscription;
      await _saveSubscriptions(subscriptions);

      await _sendWelcomeEmail(email);
    } catch (e) {
      print('Error in verifyEmail: $e');
      throw Exception('Failed to verify email');
    }
  }

  Future<void> unsubscribe(String email) async {
    try {
      final subscriptions = await _getSubscriptions();
      subscriptions.removeWhere((sub) => sub.email == email);
      await _saveSubscriptions(subscriptions);
      await _sendUnsubscribeConfirmation(email);
    } catch (e) {
      print('Error in unsubscribe: $e');
      throw Exception('Failed to unsubscribe');
    }
  }
}
