part of '../pref_controller.dart';

enum PrefMapDefaultRangeType {
  thisMonth(0),
  prevMonth(1),
  thisYear(2),
  custom(3);

  const PrefMapDefaultRangeType(this.value);

  static PrefMapDefaultRangeType fromValue(int value) =>
      PrefMapDefaultRangeType.values[value];

  final int value;
}

class PrefHomeCollectionsNavButton {
  const PrefHomeCollectionsNavButton({
    required this.type,
    required this.isMinimized,
  });

  static PrefHomeCollectionsNavButton fromJson(JsonObj json) =>
      PrefHomeCollectionsNavButton(
        type: HomeCollectionsNavBarButtonType.fromValue(json["type"]),
        isMinimized: json["isMinimized"],
      );

  JsonObj toJson() => {"type": type.index, "isMinimized": isMinimized};

  final HomeCollectionsNavBarButtonType type;
  final bool isMinimized;
}
