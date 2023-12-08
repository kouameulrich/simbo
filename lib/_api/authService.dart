
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:simbo_mobile/_api/tokenStorageService.dart';
import 'package:simbo_mobile/models/tokenModel.dart';


class AuthService{
  final TokenStorageService _tokenStorageService;
  Dio dio=Dio();

  AuthService(this._tokenStorageService);
  Future<int?> authenticateUser(String tenantID, String username, String password) async {
    _tokenStorageService.saveTenantId(tenantID);

    String url = 'https://auth.simbo.me/auth/realms/$tenantID/protocol/openid-connect/token';
     final Response response= await dio.post(url,
          data:{
            "username": username,
            "password": password,
            "client_id": "simbowebfrontend",
            "grant_type": "password",
            "scope": "email openid profile"
          },
        options: Options(contentType: Headers.formUrlEncodedContentType,
                          responseType: ResponseType.json)
      );
     if(response.statusCode == 200){
        print(json.encode(response.data));
       _tokenStorageService.saveToken(json.encode(response.data));
       print('--------------access-------------------');
       print(await _tokenStorageService.retrieveAccessToken());
       print('-----------refresh----------------------');
       print( await _tokenStorageService.retrieveRefreshToken());
       return response.statusCode;
     } else {
       debugPrint(
           "An Error Occurred during loggin in. Status code: ${response.statusCode} , body: ${response.data}");
       return response.statusCode;
     }
    var res = await http.post(Uri.parse(
        url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        }, body: {
          "username": username,
          "password": password,
          "client_id": "simbowebfrontend",
          "grant_type": "password",
          "scope": "email openid profile"
        });
    if (res.statusCode == 200) {
      print(res.body);
      _tokenStorageService.saveToken(res.body);
      // print(res.body);
      print('--------------access-------------------');
      print(await _tokenStorageService.retrieveAccessToken());
      print('-----------refresh----------------------');
      print( await _tokenStorageService.retrieveRefreshToken());
      return res.statusCode;
    } else {
      debugPrint(
          "An Error Occurred during loggin in. Status code: ${res.statusCode} , body: ${res.body}");
      return res.statusCode;
    }
  }
}