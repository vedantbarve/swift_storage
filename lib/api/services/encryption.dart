import 'package:encryptor/encryptor.dart';
import 'package:get/get.dart';

class EncryptionController extends GetxController {
  String encryptData(String key, String data) {
    return Encryptor.encrypt(key, data);
  }

  String decryptData(String key, String data) {
    return Encryptor.decrypt(key, data);
  }
}
