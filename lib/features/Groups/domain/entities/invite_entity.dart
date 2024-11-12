
import 'package:folder_it/features/Groups/domain/entities/sub_entities/group_entity.dart';

class InviteEntity {
  
   int inviteId;
   GroupEntity group; 

   InviteEntity({
    required this.inviteId,
    required this.group
   });
   
  
}