import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:vahak_assesment/db/Database.dart';
import 'package:vahak_assesment/utils/Constant.dart';
import 'package:vahak_assesment/utils/NetworkConnectionStatus.dart';
import 'package:vahak_assesment/utils/Utility.dart';

class Api {
  static Future<List> wikiRequest(BuildContext context, String searchStr) async {
    Box box = Hive.box(Constant.HIVE_BOX_NAME);
    List lst = [];
    print(box.keys);
    List<String> keyList = [];
    keyList.addAll(List<String>.from(box.keys));
    if (box.isNotEmpty && keyList.contains(searchStr)) {
      lst.addAll(box.get(searchStr)['query']['pages']);
    } else {
      bool isInternet = await NetworkConnectionStatus.getInstance().checkConnection();
      if (isInternet) {
        var response = await http.post(Uri.parse('${Constant.WIKI_REQUEST_URL}$searchStr'));
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print(jsonResponse['query']['pages'].length);
          lst.addAll(jsonResponse['query']['pages']);
          Database().saveDb(searchStr, jsonResponse);
        } else {
          print('Api.wikiRequest -> Something went wrong');
          Utility.showErrorDialog(context, 'Something went wrong, try again');
        }
      } else {
        Utility.showErrorDialog(context, 'Please check your internet & try again');
      }
    }

    return lst;
  }
}
