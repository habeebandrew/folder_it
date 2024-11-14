import 'package:dartz/dartz.dart';
import 'package:folder_it/core/errors/failure.dart';
import 'package:folder_it/features/Groups/domain/entities/invite_entity.dart';
import 'package:folder_it/features/Groups/domain/repositories/group_repository.dart';


//!يأخذ المدخلات ويفوض العمل إلى المستودع.  
class ViewInvitesUsecase {
  final GroupRepository repository;

  ViewInvitesUsecase({required this.repository});

  Future<Either<Failure,List<InviteEntity>>> call({required int userId}) {
    return repository.viewMyInvites(userId: userId);
  }
}
