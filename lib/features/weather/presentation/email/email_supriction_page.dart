import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_web_app/features/weather/bloc/email_bloc/email_bloc.dart';
class EmailSubscriptionPage extends StatefulWidget {
  final String? initialCityName;

  const EmailSubscriptionPage({Key? key, this.initialCityName}) : super(key: key);

  @override
  State<EmailSubscriptionPage> createState() => _EmailSubscriptionPageState();
}

class _EmailSubscriptionPageState extends State<EmailSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubscribing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSubscribing ? 'Subscribe to Weather Forecast' : 'Unsubscribe'),
        backgroundColor: Colors.blue[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<EmailSubscriptionBloc, EmailSubscriptionState>(
          listener: (context, state) {
            if (state is EmailSubscriptionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
              Navigator.pop(context);
            } else if (state is EmailSubscriptionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email address',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_isSubscribing) {
                        context.read<EmailSubscriptionBloc>().add(
                          SubscribeEmail(
                            _emailController.text,
                            cityName: widget.initialCityName,
                          ),
                        );
                      } else {
                        context.read<EmailSubscriptionBloc>().add(
                          UnsubscribeEmail(_emailController.text),
                        );
                      }
                    }
                  },
                  child: Text(_isSubscribing ? 'Subscribe' : 'Unsubscribe'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSubscribing = !_isSubscribing;
                    });
                  },
                  child: Text(_isSubscribing 
                    ? 'Want to unsubscribe instead?' 
                    : 'Want to subscribe instead?'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}