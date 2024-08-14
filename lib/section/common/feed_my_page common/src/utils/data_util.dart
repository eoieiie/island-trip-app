import 'package:uuid/uuid.dart';

class DataUtil {
  static String makeFilePath() {
    // filename.split(pattern) //14강 13분
    return '${const Uuid().v4()}.jpg'; //jpg나 png는 호환 잘됨. 고해상도인 hic에 대한 확장자를 맘대로 바꿔버리면 이미지가 안나올 수 있음.
    // 그걸 방지하기 위하여 오리지널 파일명에서 확장자를 추출하는 거임
  }
}
