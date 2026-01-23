// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 1;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      onboardingComplete: fields[0] as bool,
      selectedInterests: (fields[1] as List).cast<String>(),
      selectedCity: fields[2] as String?,
      themeMode: fields[3] as String,
      lastUpdated: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.onboardingComplete)
      ..writeByte(1)
      ..write(obj.selectedInterests)
      ..writeByte(2)
      ..write(obj.selectedCity)
      ..writeByte(3)
      ..write(obj.themeMode)
      ..writeByte(4)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
