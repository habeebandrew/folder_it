import 'package:dartz/dartz.dart';
import 'package:folder_it/features/User/data/models/user_model.dart';
import 'package:folder_it/features/User/domain/repositories/user_repository.dart';
import 'package:folder_it/core/errors/failure.dart';



//!يأخذ المدخلات ويفوض العمل إلى المستودع.  
class SignUpUseCase {
  final UserRepository repository;

  SignUpUseCase({required this.repository});

  Future<Either<Failure,UserModel>> call({required String userName ,required String email,required String password}) {
    return repository.signUp(userName: userName,email: email,password:  password);
  }
}
