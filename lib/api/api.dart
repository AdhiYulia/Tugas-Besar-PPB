import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;

class Api {
  String? status, message;
  List<dynamic>? data;

  Api({this.status, this.message, this.data});

  factory Api.result(dynamic object) {
    return Api(
        status: object['status'],
        message: object['message'],
        data: object['data']);
  }

  static Future<Api?> getData(BuildContext context, String url) async {
    String apiUrl = "https://absensibulog.mywebtrial.online/$url";

    BaseOptions options = BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: 60000,
        receiveTimeout: 30000,
        contentType: "application/json;charset=utf-8");

    Dio dio = Dio(options);

    try {
      Response response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        dynamic listData = response.data;

        Api data = Api.result(listData);

        return data;
      } else {
        dynamic listData = {
          "status": "failed",
          "message": "Koneksi Bermasalah",
          "data": null
        };

        Api data = Api.result(listData);

        return data;
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.red[900],
              child: const Center(
                child: Text(
                  "Terdapat Error",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            titlePadding: EdgeInsets.zero,
            content: Text(
              e.toString(),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  g.Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                ),
                child: const Text("Tutup"),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          ),
        );
      }

      dynamic listData = {
        "status": "failed",
        "message": "Gagal Parsing Data\nError ${e.toString()}",
        "data": null
      };

      Api data = Api.result(listData);

      return data;
    }
  }

  static Future<Api?> postData(
      BuildContext context, String url, var data) async {
    String apiUrl = "https://absensibulog.mywebtrial.online/$url";

    BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: 60000,
      receiveTimeout: 30000,
      contentType: "application/json;charset=utf-8",
    );

    Dio dio = Dio(options);

    try {
      Response response = await dio.post(apiUrl, data: data);

      if (response.statusCode == 200) {
        dynamic listData = response.data;

        Api data = Api.result(listData);

        return data;
      } else {
        dynamic listData = {
          "status": "failed",
          "message": "Koneksi Bermasalah",
          "data": null
        };

        Api data = Api.result(listData);

        return data;
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.red[900],
              child: const Center(
                child: Text(
                  "Terdapat Error",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            titlePadding: EdgeInsets.zero,
            content: Text(
              e.toString(),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  g.Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                ),
                child: const Text("Tutup"),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          ),
        );
      }

      dynamic listData = {
        "status": "failed",
        "message": "Gagal Parsing Data\nError ${e.toString()}",
        "data": null
      };

      Api data = Api.result(listData);

      return data;
    }
  }

  static Future<Api?> postDataMultiPart(
      BuildContext context, String url, FormData formData) async {
    String apiUrl = "https://absensibulog.mywebtrial.online/$url";

    BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: 60000,
      receiveTimeout: 30000,
      contentType: "application/json;charset=utf-8",
    );

    Dio dio = Dio(options);

    try {
      Response response = await dio.post(
        apiUrl,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        dynamic listData = response.data;

        Api data = Api.result(listData);

        return data;
      } else {
        dynamic listData = {
          "status": "failed",
          "message": "Koneksi Bermasalah",
          "data": null
        };

        Api data = Api.result(listData);

        return data;
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.red[900],
              child: const Center(
                child: Text(
                  "Terdapat Error",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            titlePadding: EdgeInsets.zero,
            content: Text(
              e.toString(),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  g.Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                ),
                child: const Text("Tutup"),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          ),
        );
      }

      dynamic listData = {
        "status": "failed",
        "message": "Gagal Parsing Data\nError ${e.toString()}",
        "data": null
      };

      Api data = Api.result(listData);

      return data;
    }
  }
}
