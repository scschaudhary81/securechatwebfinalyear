import 'package:encrypt/encrypt.dart';



class EncryptionService{
  static final _iv = IV.fromLength(16);
  static final _key = Key.fromUtf8('my 32 length key................');


  static String encryptAES(plainText){
    final Encrypter _encrypter =  Encrypter(AES(_key));;
     return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  static decryptAES(String plainText){
    final _encrypted = Encrypted.from64(plainText);
    final Encrypter _encrypter =  Encrypter(AES(_key));
    return  _encrypter.decrypt(_encrypted, iv: _iv);

  }
}