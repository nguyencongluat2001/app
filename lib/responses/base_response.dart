class BaseResponse {
  bool status = false;
  String message;
  dynamic data;

  BaseResponse(this.status, this.message, this.data);

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      json['status'],
      json['message'],
      json['data'],
    );
  }
}
