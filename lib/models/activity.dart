import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
class Activity {
  Activity({required this.id, required this.name, });
  final String id;
  final String name;

}