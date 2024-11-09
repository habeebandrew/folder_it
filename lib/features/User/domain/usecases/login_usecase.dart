import 'package:dartz/dartz.dart';
import 'package:folder_it/core/errors/failure.dart';
import 'package:folder_it/features/User/data/models/user_model.dart';
import 'package:folder_it/features/User/domain/entities/user_entity.dart';
import 'package:folder_it/features/User/domain/repositories/user_repository.dart';

//!يأخذ المدخلات ويفوض العمل إلى المستودع.  
class LoginUsecase {
  final UserRepository repository;

  LoginUsecase({required this.repository});

  Future<Either<Failure,UserModel>> call({required String userName,required String password}) {
    return repository.login(userName: userName,password: password);
  }
}
