import 'package:dartz/dartz.dart';
import 'package:folder_it/core/errors/failure.dart';
import 'package:folder_it/core/params/params.dart';
import 'package:folder_it/features/Groups/domain/entities/invite_entity.dart';




abstract class GroupRepository {

  Future<Either<Failure,List<InviteEntity>>> viewMyInvites({required  int userId});

}
