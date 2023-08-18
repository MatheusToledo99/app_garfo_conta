class UnitModel {
  int? unitId;
  String? unitDescription;
  UnitModel({
    this.unitId,
    this.unitDescription,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
        unitId: json['unitId'],
        unitDescription: json['unitDescription'],
      );
}
