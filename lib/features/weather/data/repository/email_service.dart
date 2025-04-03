import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';
  static const String serviceId = 'service_tq709si';  
  static const String templateId = 'template_75bv74e'; 
  static const String userId = '3LMivM6Z562AI5hsY';

  Future<void> sendEmail({
    required String to,
    required String subject,
    required String htmlContent,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(emailJsUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'to_email': to,
            'subject': subject,
            'message': htmlContent,
          },
        }),
      );

      if (response.statusCode != 200) {
        print('Failed to send email: ${response.body}');
        throw Exception('Failed to send email');
      }

      print('Email sent successfully');
    } catch (e) {
      print('Error sending email: $e');
      throw Exception('Failed to send email');
    }
  }
}
