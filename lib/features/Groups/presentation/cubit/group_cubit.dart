
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/connection/network_info.dart';
import 'package:folder_it/core/databases/api/http_consumer.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Groups/data/datasources/group_local_data_source.dart';
import 'package:folder_it/features/Groups/data/datasources/group_remote_data_source.dart';
import 'package:folder_it/features/Groups/data/repositories/group_repository_impl.dart';
import 'package:folder_it/features/Groups/domain/entities/invite_entity.dart';
import 'package:folder_it/features/Groups/domain/usecases/accept_or_reject_invite.dart';
import 'package:folder_it/features/Groups/domain/usecases/invite_member.dart';
import 'package:folder_it/features/Groups/domain/usecases/view_invites_usecase.dart';



part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {


  GroupCubit() : super(UserAuthInitialState());
  

   
    static GroupCubit get(context)=>BlocProvider.of(context);

    TextEditingController userNameController = TextEditingController();

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

    acceptOrRejectInvite({
    
    required int inviteId , 
    required int groupId,required int inviteStatus,
    required BuildContext context})async{
       emit(GroupLoadingState());
       final failureOrAcceptOrReject=await AcceptOrRejectInvite(
        repository: GroupRepositoryImpl(
          remoteDataSource:GroupRemoteDataSource(api: HttpConsumer()) ,
          localDataSource: GroupLocalDataSource(cache:CacheHelper() ),
          networkInfo:NetworkInfoImpl(connectivity: Connectivity()),
        )
       ).call(userId: CacheHelper().getData(key: 'myid'), inviteId: inviteId, groupId: groupId, inviteStatus: inviteStatus);
       failureOrAcceptOrReject.fold(
        (failure)=>emit(GroupFailureState(message: failure.errMessage)), 
        (acceptOrRejectInvite){
          emit(GroupSuccessState());
           viewMyInvites();
            
          
        }
      );
    }

    inviteMember({
    required String userName,
    required int groupId,
    required BuildContext context})async{
       emit(GroupLoadingState());
       final failureOrInviteMember=await InviteMember(
        repository: GroupRepositoryImpl(
          remoteDataSource:GroupRemoteDataSource(api: HttpConsumer()) ,
          localDataSource: GroupLocalDataSource(cache:CacheHelper() ),
          networkInfo:NetworkInfoImpl(connectivity: Connectivity()),
        )
       ).call(userName: userName,groupId: groupId);
       failureOrInviteMember.fold(
        (failure)=>emit(GroupFailureState(message: failure.errMessage)), 
        (inviteMembers){
          userNameController.clear();
          emit(GroupSuccessState());

        }
      );
    }
    
   
}