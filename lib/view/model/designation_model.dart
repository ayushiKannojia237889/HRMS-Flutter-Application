class DesignationModel {
  String? post_designation;

  DesignationModel({
    this.post_designation,
  });

  DesignationModel.fromJson(Map<String, dynamic> json) {
    post_designation = json['post_designation'] == null
        ? '---'
        : json['post_designation']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['post_designation'] = post_designation;
    return data;
  }
}

class DesignationResponse {
  static List<DesignationModel> list = [];
}