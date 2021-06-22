import 'package:hive/hive.dart';
import 'package:vahak_assesment/utils/Constant.dart';

class Database {
  Box _dbBox = Hive.box(Constant.HIVE_BOX_NAME);

  saveDb(String searchStr, Map<String, dynamic> map) {
    _dbBox.put(searchStr, map);
  }

  getDb() {
    _dbBox.values.forEach((element) {
      print(element);
    });
  }
}
