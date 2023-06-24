class BaseApiResponse {
  bool? status;
  String? message;

  BaseApiResponse({this.status, this.message});

  bool get hasError => !status! && message!.isNotEmpty;

  BaseApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool;
    message = json['message'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
