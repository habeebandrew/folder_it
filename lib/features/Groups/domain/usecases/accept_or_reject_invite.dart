import 'package:dartz/dartz.dart';
import 'package:folder_it/core/errors/failure.dart';
import 'package:folder_it/features/Groups/domain/repositories/group_repository.dart';

class AcceptOrRejectInvite {
  final GroupRepository repository;

  AcceptOrRejectInvite({required this.repository});

  Future<Either<Failure,bool>> call({required int userId, required int inviteId , required int groupId,required int inviteStatus }) {
    return repository.acceptOrRejectInvites(userId: userId,inviteId: inviteId,groupId: groupId,inviteStatus: inviteStatus);
  }
}
