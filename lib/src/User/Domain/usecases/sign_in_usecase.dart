import '../entities/user.dart';
import '../repositories/auth_repository.dart';
//!يأخذ المدخلات ويفوض العمل إلى المستودع.  
class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<User?> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
