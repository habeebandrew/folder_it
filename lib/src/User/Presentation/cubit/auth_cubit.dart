import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;

  AuthCubit(this.signInUseCase) : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase.call(email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }
  Future<void> signup(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase.call(email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }
}
