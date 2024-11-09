import 'dart:async';
import 'dart:io';

import 'package:folder_it/core/errors/error_model.dart';


//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  final String message; // إضافة هذا المتغير ليُستخدم مع الرسالة
  ServerException(this.errorModel, {required this.message});
}

//!CacheException
class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel)
      : super(message: 'Bad Certificate');
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel)
      : super(message: 'Connection Timeout');
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel)
      : super(message: 'Bad Response');
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel)
      : super(message: 'Receive Timeout');
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel)
      : super(message: 'Connection Error');
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel)
      : super(message: 'Send Timeout');
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel)
      : super(message: 'Unauthorized');
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel)
      : super(message: 'Forbidden');
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel)
      : super(message: 'Not Found');
}

class ConflictException extends ServerException {
  ConflictException(super.errorModel)
      : super(message: 'Conflict');
}

class CancelException extends ServerException {
  CancelException(super.errorModel)
      : super(message: 'Request Cancelled');
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel)
      : super(message: 'Unknown Error');
}

//! Error handling for http exceptions
void handleHttpException(Exception e) {
  if (e is SocketException) {
    // Handle connection errors
    throw ConnectionErrorException(
        ErrorModel(errorMessage: 'No Internet connection', status: 500));
  } else if (e is HttpException) {
    // Handle specific HTTP errors
    switch (e.message) {
      case 'Unauthorized':
        throw UnauthorizedException(
            ErrorModel(errorMessage: 'Unauthorized', status: 401));
      case 'Forbidden':
        throw ForbiddenException(
            ErrorModel(errorMessage: 'Forbidden', status: 403));
      case 'Not Found':
        throw NotFoundException(
            ErrorModel(errorMessage: 'Not Found', status: 404));
      default:
        throw BadResponseException(
            ErrorModel(errorMessage: e.message, status: 500));
    }
  } else if (e is TimeoutException) {
    // Handle timeout errors
    throw ConnectionTimeoutException(
        ErrorModel(errorMessage: 'Connection Timeout', status: 408));
  } else {
    // Handle unknown errors
    throw UnknownException(
        ErrorModel(errorMessage: 'Unknown error occurred', status: 500));
  }
}
