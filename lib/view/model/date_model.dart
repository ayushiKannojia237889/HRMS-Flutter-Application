class DateModel {
  String? month;

  DateModel({
    this.month,
  });

  DateModel.fromJson(Map<String, dynamic> json) {
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

class DateResponse {
  static List<DateModel> list = [];
}