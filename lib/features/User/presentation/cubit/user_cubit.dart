import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/connection/network_info.dart';
import 'package:folder_it/core/databases/api/http_consumer.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/User/Data/datasources/user_local_data_source.dart';
import 'package:folder_it/features/User/Data/datasources/user_remote_data_source.dart';
import 'package:folder_it/features/User/data/repositories/user_repository_impl.dart';
import 'package:folder_it/features/User/domain/usecases/login_usecase.dart';
import 'package:folder_it/features/User/domain/usecases/sign_up_usecase.dart';
import 'package:go_router/go_router.dart';


part 'user_state.dart';

class UserCubit extends Cubit<UserState> {


  UserCubit() : super(UserAuthInitialState());
  
    final TextEditingController userNameController=TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    
    bool rememberMe = false;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
   
    static UserCubit get(context)=>BlocProvider.of(context);

   signUp(BuildContext context,String userName,String email, String password) async {
    if (formKey.currentState!.validate()){
    emit(UserAuthLoadingState());
      final failureOrUser = await SignUpUseCase(
      repository: UserRepositoryImpl(
          remoteDataSource:UserRemoteDataSource(api: HttpConsumer()) ,
          localDataSource: UserLocalDataSource(cache:CacheHelper() ),
          networkInfo:NetworkInfoImpl(connectivity: Connectivity()),
      )
    ).call(userName: userName, email: email, password: password);
      print('cubit:$userName$email$password');
    failureOrUser.fold(
          (failure) => emit(UserAuthFailureState(message: failure.errMessage)),
          (user) { 
            emit(UserAuthSuccessState());
             context.go("/home");
          }
     );
   }
   
  }
  login(BuildContext context,String userName,String password) async {
    if (formKey.currentState!.validate()){
    emit(UserAuthLoadingState());
      final failureOrUser = await LoginUsecase(
      repository: UserRepositoryImpl(
          remoteDataSource:UserRemoteDataSource(api: HttpConsumer()) ,
          localDataSource: UserLocalDataSource(cache:CacheHelper() ),
          networkInfo:NetworkInfoImpl(connectivity: Connectivity()),

      )
    ).call(userName: userName, password: password);
      print('cubit login:$userName$password');
    failureOrUser.fold(
          (failure) => emit(UserAuthFailureState(message: failure.errMessage)),
          (user) { 
            emit(UserAuthSuccessState());
             context.go("/home");
          }
     );
   }
   
  }
}