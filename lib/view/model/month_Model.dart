class MonthModel {
  String? month;

  MonthModel({
    this.month,
  });

  MonthModel.fromJson(Map<String, dynamic> json) {
    month = json['month'] == null
        ? '---'
        : json['month']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['month'] = month;
    return data;
  }
}

class MonthResponse {
  static List<MonthModel> list = [];
}
