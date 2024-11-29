import 'package:dartz/dartz.dart';
import 'package:folder_it/core/errors/failure.dart';
import 'package:folder_it/features/Groups/data/models/invite_model.dart';
import 'package:folder_it/features/Groups/domain/repositories/group_repository.dart';

class InviteMember {
  final GroupRepository repository;

  InviteMember({required this.repository});

  Future<Either<Failure,InviteModel>> call({required String userName, required int groupId  }) {
    return repository.inviteMember(userName: userName, groupId:groupId );
  }
}