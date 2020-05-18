import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttersecretchat/models/pet_res.dart';
import 'package:fluttersecretchat/utils/dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../app_config.dart';

class PetsApi {
  static Future<PetRes> getPets({
    @required BuildContext context,
    @required String token,
    int page = 1,
  }) async {
    try {
      final url = '${AppConfig.apiHost}/pets?page=$page';

      final res = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      final petRes = petResFromJson(res.body);

      if (res.statusCode == 200) {
        return petRes;
      }
      throw PlatformException(code: "201", message: "error: /user-info");
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> uploadPetImage(
      BuildContext context, File file, String token) async {
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();
    try {
      final res = await dio.post(
        '${AppConfig.apiHost}/pets/image',
        data: data,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        ),
      );
      print(res.statusCode);
      print(res.data);
      return res.data['url'];
    } catch (e) {
      print(e);
      Dialogs.alert(
        context,
        title: 'Error Ocurred',
        message: 'Please try again',
      );
      return '';
    }
  }

  static Future<bool> addPet(
    BuildContext context, {
    @required String token,
    @required String animal,
    @required String name,
    @required int age,
    @required String description,
    @required String imageUrl,
  }) async {
    final res = await http.post('${AppConfig.apiHost}/pets', body: {
      'animal': animal,
      'name': name,
      'age': age.toString(),
      'description': description,
      'imageUrl': imageUrl
    }, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (res.statusCode == 201) {
      return true;
    }
    Dialogs.alert(
      context,
      title: 'Error',
      message: 'Lo sentimos, intentalo de nuevo.',
    );
    return false;
  }
}
