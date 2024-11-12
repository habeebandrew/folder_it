
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/connection/network_info.dart';
import 'package:folder_it/core/databases/api/http_consumer.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Groups/data/datasources/group_local_data_source.dart';
import 'package:folder_it/features/Groups/data/datasources/group_remote_data_source.dart';
import 'package:folder_it/features/Groups/data/repositories/group_repository_impl.dart';
import 'package:folder_it/features/Groups/domain/entities/invite_entity.dart';
import 'package:folder_it/features/Groups/domain/usecases/view_invites_usecase.dart';



part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {


  GroupCubit() : super(UserAuthInitialState());
  

   
    static GroupCubit get(context)=>BlocProvider.of(context);

    viewMyInvites()async{
      emit(GroupLoadingState());
      final failureOrInvites = await ViewInvitesUsecase(
      repository: GroupRepositoryImpl(
          remoteDataSource:GroupRemoteDataSource(api: HttpConsumer()) ,
          localDataSource: GroupLocalDataSource(cache:CacheHelper() ),
          networkInfo:NetworkInfoImpl(connectivity: Connectivity()),

      )
    ).call(userId:CacheHelper().getData(key: 'myid') );
      failureOrInvites.fold(
          (failure) => emit(GroupFailureState(message: failure.errMessage)),
          (invites) { 
            emit(GroupGetInvitesSuccess(invites:invites ));
             
          }
     );
    }
    
   
}