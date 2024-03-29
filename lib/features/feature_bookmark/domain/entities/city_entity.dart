import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@entity
class CityEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String name;

  CityEntity(this.name);

  @override
  List<Object?> get props => [name];
}
