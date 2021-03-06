import 'package:file_picker/file_picker.dart';

class MediaServices{
  MediaServices(){}

  Future<PlatformFile?> returnPickedFile() async
  {
       FilePickerResult? _result = await  FilePicker.platform.pickFiles(type: FileType.image,allowMultiple: false);
       if(_result==null) {
         return null;
       } else {
         return _result.files.first;
       }
  }
}