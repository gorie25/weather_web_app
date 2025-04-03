import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repository/email_repository.dart';

// Events
abstract class EmailSubscriptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscribeEmail extends EmailSubscriptionEvent {
  final String email;
  final String? cityName;

  SubscribeEmail(this.email, {this.cityName});

  @override
  List<Object?> get props => [email, cityName];
}

class VerifyEmail extends EmailSubscriptionEvent {
  final String email;
  final String token;

  VerifyEmail(this.email, this.token);

  @override
  List<Object?> get props => [email, token];
}

class UnsubscribeEmail extends EmailSubscriptionEvent {
  final String email;

  UnsubscribeEmail(this.email);

  @override
  List<Object?> get props => [email];
}

// States
abstract class EmailSubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailSubscriptionInitial extends EmailSubscriptionState {}

class EmailSubscriptionLoading extends EmailSubscriptionState {}

class EmailSubscriptionSuccess extends EmailSubscriptionState {
  final String message;

  EmailSubscriptionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailSubscriptionError extends EmailSubscriptionState {
  final String error;

  EmailSubscriptionError(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class EmailSubscriptionBloc extends Bloc<EmailSubscriptionEvent, EmailSubscriptionState> {
  final EmailSubscriptionRepository repository;

  EmailSubscriptionBloc({required this.repository}) : super(EmailSubscriptionInitial()) {
    on<SubscribeEmail>(_onSubscribeEmail);
    on<VerifyEmail>(_onVerifyEmail);
    on<UnsubscribeEmail>(_onUnsubscribeEmail);
  }

  void _onSubscribeEmail(SubscribeEmail event, Emitter<EmailSubscriptionState> emit) async {
    emit(EmailSubscriptionLoading());
    try {
      await repository.subscribe(event.email, event.cityName);
      emit(EmailSubscriptionSuccess('Verification email sent. Please check your inbox.'));
    } catch (e) {
      emit(EmailSubscriptionError(e.toString()));
    }
  }

  void _onVerifyEmail(VerifyEmail event, Emitter<EmailSubscriptionState> emit) async {
    emit(EmailSubscriptionLoading());
    try {
      await repository.verifyEmail(event.email, event.token);
      emit(EmailSubscriptionSuccess('Email verified successfully!'));
    } catch (e) {
      emit(EmailSubscriptionError(e.toString()));
    }
  }

  void _onUnsubscribeEmail(UnsubscribeEmail event, Emitter<EmailSubscriptionState> emit) async {
    emit(EmailSubscriptionLoading());
    try {
      await repository.unsubscribe(event.email);
      emit(EmailSubscriptionSuccess('Successfully unsubscribed.'));
    } catch (e) {
      emit(EmailSubscriptionError(e.toString()));
    }
  }
}