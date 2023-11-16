class DivisionModel {
  String? division;

  DivisionModel({
    this.division,
  });

  DivisionModel.fromJson(Map<String, dynamic> json) {
    division = json['division'] == null
        ? '---'
        : json['division']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['division'] = division;
    return data;
  }
}

class DivisionResponse {
  static List<DivisionModel> list = [];
}
