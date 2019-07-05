import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Response {
  final String token;
  final String message;
  final String data;

  Response({this.token, this.message,this.data});

  Response.fromJson(Map<String, dynamic> json)
      : message = json['success'],
        token = json['error'],
        data = json['data'];
}
class User {
  final int id;
  final String firstname;
  final String lastname;
  //final DateTime createdAt;
 final String avatar;
  final String email;
  final String role;

  User({this.id,this.firstname,this.lastname,this.email,this.role,this.avatar});
  
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        email = json['email'],
        role = json['role'],
        avatar=json['avatar'];

        /*createdAt = DateTime.tryParse(json['created_at']) ?? new DateTime.now(),*/
        /* @override
      String toString() => '$name, $email, $imageUrl';*/ 
}
/*class Scan {
  final int id;
  final String firstname;
  final String lastname;
  //final DateTime createdAt;
 final String avatar;
  final String email;
  final String role;

  Scan({this.id,this.firstname,this.lastname,this.email,this.role,this.avatar});
}*/


class MyHttpException extends HttpException {
  final int statusCode;
  MyHttpException(this.statusCode, String message) : super(message);
}

  class Login {
  int code;
  final String error;
  final bool success;
  final String access_token;
  final String role;

  Login({this.code, this.error, this.success, this.access_token,this.role});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      //code: json['code'],
      error: json['error'],
      success: json['success'],
      access_token: json['access_token'],
      role: json['role'],
    );
  }
}
  class WStat {
  //int code;
  //final String error;
  final bool success;
  final int aT_collected;
  final int today_collected;

  WStat({this.success, this.aT_collected,this.today_collected});

  factory WStat.fromJson(Map<String, dynamic> json) {
    return WStat(
      //code: json['code'],
      //error: json['error'],
      success: json['success'],
      aT_collected: json['AT_collected'],
      today_collected: json['Today_collected'],
    );
  }
}
class ApiService {
  static const String baseUrl = '192.168.1.101:8000';
  //static const int port = 8000;
  static const String Authorization = 'access_token';

  static ApiService instance;
  factory ApiService() => instance ??= ApiService._internal();
  ApiService._internal();

  // return message and token
  Future<http.Response> post(String url, var body){
    return http.post(url,body: body, headers: {
      //'Content-Type':'application/json',
      'Accept': 'application/json'
    });
  }
    Future<http.Response> get(String url,String token){
    return http.get(url,headers: {
      'Accept': 'application/json',
      'Authorization' : token
    });
  }
  Future<http.Response> put (String url,String token){
    return http.put(url,headers: {
      'Accept': 'application/json',
      'Authorization' : token
    });
  }

  
  Future<Login> signIn(String email, String password) async {
      String url = Uri.encodeFull('http://192.168.1.101:8000/api/auth/Mlogin');
      var body = {"email": email, "password": password};
      http.Response response = await post(url,body);
      print("Response: "+ response.toString());
      print("Response Body: "+ response.body);
      
      Login login = Login.fromJson(json.decode(response.body));
      login.code=response.statusCode;
      return login;      
  
  }
  
  Future<User> getUserProfile(String token) async {
    String url = Uri.encodeFull('http://192.168.1.101:8000/api/auth/user');

    http.Response response = await get(url,token);
    print("Response Body: "+ response.body);
    
  
    var resBody = json.decode(response.body);
    var data= resBody["data"];
    print("UserData= "+ data.toString());
    
    return User.fromJson(data);
  }

    Future<http.Response> workerCollects(String token,String barcode) async {
    String url = Uri.encodeFull('http://192.168.1.101:8000/api/workers/sacs/collect_sac_in_bank/$barcode');

    http.Response response = await put(url,token);
    print("Response Body: "+ response.body);    
  
    
    return response;
  }

Future<WStat> workerNumbers(String token) async {
    String url = Uri.encodeFull('http://192.168.1.101:8000/api/worker/MySacsNumbers');

    http.Response response = await get(url,token);
    print("Response Body: "+ response.body);   
    WStat wStat = WStat.fromJson(json.decode(response.body));
    print(wStat);    
    
    return wStat;
  }










 /* Future<Response> loginUser(String email, String password) async {
    
    final url = new Uri.http('192.168.1.101:8000','/api/auth/login');
    //final credentials = '$email:$password';
    //final basic = 'Basic ${base64Encode(utf8.encode(credentials))}';
    final json = await NetworkUtils.post(url, body:{"email": email, "password": password});   
    print('jalal'); 
    //print(Response.fromJson(json).message);
    print(json);

    return json;
  }*/

  // return message
  Future<Response> registerUser(
      String name, String email, String password) async {
    final url = new Uri.https('192.168.1.101:8000', '/users');
    final body = <String, String>{
      'name': name,
      'email': email,
      'password': password,
    };
    final decoded = await NetworkUtils.post(url, body: body);
    return new Response.fromJson(decoded);
  }


  // return message
  Future<Response> changePassword(
      String email, String password, String newPassword, String token) async {
    final url = new Uri.http('192.168.1.101:8000', "/users/$email/password");
    final body = {'password': password, 'new_password': newPassword};
    final json = await NetworkUtils.put(
      url,
      headers: {Authorization: token},
      body: body,
    );
    return Response.fromJson(json);
  }

  // return message
  // special token and newPassword to reset password,
  // otherwise, send an email to email
  Future<Response> resetPassword(String email,
      {String token, String newPassword}) async {
    final url = new Uri.https('192.168.1.101:8000', '/users/$email/password');
    final task = token != null && newPassword != null
        ? NetworkUtils.post(url, body: {
            'token': token,
            'new_password': newPassword,
          })
        : NetworkUtils.post(url);
    final json = await task;
    return Response.fromJson(json);
  }

  Future<User> uploadImage(File file, String email) async {
    final url = new Uri.https('192.168.1.101:8000', '/users/upload');
    final stream = new http.ByteStream(file.openRead());
    final length = await file.length();
    final request = new http.MultipartRequest('POST', url)
      ..fields['user'] = email
      ..files.add(
        new http.MultipartFile('my_image', stream, length, filename: path.basename(file.path)),
      );
    final streamedReponse = await request.send();
    final statusCode = streamedReponse.statusCode;
    final decoded = json.decode(await streamedReponse.stream.bytesToString());

    debugPrint('decoded: $decoded');

    if (statusCode < 200 || statusCode >= 300) {
      throw MyHttpException(statusCode, decoded['message']);
    }

    return User.fromJson(decoded);
  }
}

class NetworkUtils {
  static Future get(Uri url, {Map<String, String> headers}) async {
    final response = await http.get(url, headers: headers);
    final body = response.body;
    final statusCode = response.statusCode;
    if (body == null) {
      throw MyHttpException(statusCode, 'Response body is null');
    }
    final decoded = json.decode(body);
    if (statusCode < 200 || statusCode >= 300) {
      print('I guess its an error');
      throw MyHttpException(statusCode, decoded['message']);
    }
    return decoded;
  }

  static Future post(Uri url,
      {Map<String, String> headers, Map<String, String> body}) {
    return _helper('POST', url, headers: headers, body: body);
  }

  static Future _helper(String method, Uri url,
      {Map<String, String> headers, Map<String, String> body}) async {
    final request = new http.Request(method, url);
    if (body != null) {
      request.bodyFields = body;
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    final streamedReponse = await request.send();

    final statusCode = streamedReponse.statusCode;
   // if ((statusCode == 500)|| (statusCode == 404)) return statusCode ;
    //if (statusCode == 404)  return statusCode ;
    if (statusCode==200) {
    final decoded = json.decode(await streamedReponse.stream.bytesToString());

    debugPrint('decoded: $decoded');
   
    /*if (statusCode < 200 || statusCode >= 300) {
      throw MyHttpException(statusCode, decoded['message']);
    }*/
    
    //print(decoded['error']);
    return decoded; } else {return Exception('Failed to load post');}
  }

  static Future put(Uri url, {Map<String, String> headers, body}) {
    return _helper('PUT', url, headers: headers, body: body);
  }
}
