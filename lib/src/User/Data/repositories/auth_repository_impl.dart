import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User?> signIn(String email, String password) async {
    // هنا سيكون منطق المصادقة مثل استدعاء API
    // سنعيد نموذجًا مؤقتًا للتوضيح
    UserModel userModel = UserModel(email: email, password: password);

    // تحويل UserModel إلى User قبل الإعادة
    return User(email: userModel.email);
  }
}
