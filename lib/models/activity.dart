import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
class Activity {
  Activity({required this.name, }) : id = uuid.v4();
  final String id;
  final String name;

}