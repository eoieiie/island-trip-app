import 'dart:io'; // 파일 입출력을 위한 패키지
import 'dart:convert'; // JSON 처리를 위한 패키지
import 'package:flutter/material.dart'; // Flutter UI 패키지
import 'package:project_island/section/common/feed_my_page common/src/components/message_popup.dart'; // 커스텀 메시지 팝업
import 'package:project_island/section/feed/viewmodel/auth_controller.dart'; // 인증 컨트롤러
import 'package:project_island/section/feed/model/post_model.dart'; // 포스트 모델
// import 'package:project_island/section/feed/repository/post_repository.dart'; // 포스트 리포지토리
import 'package:project_island/section/feed/view/upload_description.dart'; // 업로드 설명 뷰
import 'package:project_island/section/common/feed_my_page common/src/utils/data_util.dart'; // 데이터 유틸리티
import 'package:get/get.dart'; // GetX 패키지
import 'package:image_picker/image_picker.dart'; // 이미지 선택기
import 'package:photo_manager/photo_manager.dart'; // 사진 관리자
import 'package:image/image.dart' as imageLib; // 이미지 라이브러리
import 'package:path/path.dart'; // 경로 관련 유틸리티
import 'package:photofilters/filters/preset_filters.dart'; // 사진 필터 프리셋
import 'package:photofilters/widgets/photo_filter.dart'; // 사진 필터 위젯
import 'package:http/http.dart' as http;

import '../../../my_page/view/upload_description.dart'; // HTTP 패키지

class ProfileUploadController extends GetxController { // GetxController를 상속받아 컨트롤러로 설정
  var albums = <AssetPathEntity>[]; // 사진 앨범 리스트
  RxList<AssetEntity> imageList = <AssetEntity>[].obs; // Observable한 이미지 리스트
  RxList<AssetEntity> selectedImages = <AssetEntity>[].obs; // 선택된 이미지 리스트
  RxString headerTitle = ''.obs; // 헤더 타이틀
  TextEditingController textEditingController = TextEditingController(); // 텍스트 입력 컨트롤러
  Rx<AssetEntity> selectedImage = AssetEntity( // 선택된 이미지 (Observable)
    id: '0',
    typeInt: 0,
    width: 0,
    height: 0,
  ).obs;
  File? filteredImage; // 필터가 적용된 이미지 파일
  Post? post; // 업로드할 포스트 데이터
  final ImagePicker _picker = ImagePicker(); // 이미지 선택기 초기화

  @override
  void onInit() { // 컨트롤러 초기화 시 호출
    super.onInit();
    post = Post.init(AuthController.to.user.value); // 현재 사용자로 초기 포스트 생성
    _loadPhotos(); // 사진 로드 메서드 호출
  }

  void _loadPhotos() async { // 사진 로드 메서드
    var result = await PhotoManager.requestPermissionExtend(); // 사진 접근 권한 요청
    if (result.isAuth) { // 권한이 허가된 경우
      albums = await PhotoManager.getAssetPathList( // 사진 앨범 리스트 가져오기
        type: RequestType.image, // 이미지 타입만 가져오기
        filterOption: FilterOptionGroup( // 필터 옵션 설정
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minHeight: 100, minWidth: 100), // 이미지 크기 제한
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false), // 생성일 기준 내림차순 정렬
          ],
        ),
      );
      _loadData(); // 데이터 로드 메서드 호출
    } else {
      // 권한이 거부된 경우 처리
    }
  }

  void _loadData() async { // 데이터 로드 메서드
    if (albums.isNotEmpty) { // 앨범이 비어있지 않은 경우
      changeAlbum(albums.first); // 첫 번째 앨범 선택
    }
  }

  Future<void> _pagingPhotos(AssetPathEntity album) async { // 페이징 방식으로 사진 로드
    imageList.clear(); // 이미지 리스트 초기화
    var photos = await album.getAssetListPaged(page: 0, size: 30); // 30개씩 가져오기
    imageList.addAll(photos); // 가져온 사진 리스트에 추가
    if (imageList.isNotEmpty) { // 가져온 사진이 있는 경우
      changeSelectedImage(imageList.first); // 첫 번째 사진을 선택된 사진으로 설정
    }
  }

  changeSelectedImage(AssetEntity image) { // 선택된 이미지 변경 메서드
    selectedImage(image); // 선택된 이미지 변경
  }

  void changeAlbum(AssetPathEntity album) async { // 앨범 변경 메서드
    headerTitle(album.name); // 헤더 타이틀 변경
    await _pagingPhotos(album); // 선택된 앨범의 사진 로드
  }

  void toggleSelectImage(AssetEntity image) { // 이미지 선택 토글 메서드
    if (selectedImages.contains(image)) {
      selectedImages.remove(image);
    } else {
      selectedImages.add(image);
    }
  }

  Future<void> takePhoto() async { // 카메라 기능을 통해 사진 촬영 메서드
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage.value = AssetEntity(
        id: pickedFile.path,
        typeInt: 1,
        width: 0,
        height: 0,
      );
      selectedImages.add(selectedImage.value);
    }
  }

  void gotoImageFilter() async { // 이미지 필터 페이지로 이동 메서드
    var file = await selectedImage.value.file; // 선택된 이미지 파일 가져오기
    var fileName = basename(file!.path); // 파일 경로에서 파일명 추출
    var image = imageLib.decodeImage(file.readAsBytesSync()); // 이미지 디코딩
    image = imageLib.copyResize(image!, width: 1000); // 이미지 크기 조정
    var imagefile = await Navigator.push( // 필터 적용 화면으로 이동
      Get.context!,
      MaterialPageRoute(
        builder: (context) => PhotoFilterSelector(
          title: const Text('Photo Filter Example'),
          image: image!, // 이미지 전달
          filters: presetFiltersList, // 필터 리스트 전달
          filename: fileName, // 파일명 전달
          loader: const Center(child: CircularProgressIndicator()), // 로딩 인디케이터
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) { // 필터가 적용된 이미지가 있는 경우
      filteredImage = imagefile['image_filtered']; // 필터된 이미지 설정
      Get.to(() => const UploadDescription()); // 업로드 설명 페이지로 이동
    }
  }

  void unfocusKeyboard() { // 키보드 비활성화 메서드
    FocusManager.instance.primaryFocus?.unfocus(); // 키보드 포커스 해제
  }

  void uploadPost() { // 포스트 업로드 메서드
    unfocusKeyboard(); // 키보드 비활성화
    var filename = DataUtil.makeFilePath(); // 파일명 생성
    if (filteredImage != null) { // 필터된 이미지가 있는 경우
      var task = uploadFile(filteredImage!, filename); // 파일 업로드
      if (task != null) { // 업로드 작업이 있는 경우
        task.then((downloadUrl) { // 업로드 완료 후 다운로드 URL 반환
          var updatedPost = post!.copyWith( // 포스트 데이터 업데이트
            thumbnail: downloadUrl, // 썸네일 URL 설정
            description: textEditingController.text, // 설명 설정
          );
          _submitPost(updatedPost); // 포스트 데이터 전송
        });
      }
    }
  }

  Future<String> uploadFile(File file, String filename) async { // 파일 업로드 메서드
    var request = http.MultipartRequest('POST', Uri.parse('https://your-api-url.com/upload')); // MultipartRequest로 파일 업로드 요청
    request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: filename)); // 파일 추가
    var response = await request.send(); // 요청 전송
    if (response.statusCode == 200) { // 성공적으로 업로드된 경우
      var responseData = await response.stream.bytesToString(); // 응답 데이터 읽기
      var jsonData = jsonDecode(responseData); // JSON 데이터 디코딩
      return jsonData['downloadUrl']; // 다운로드 URL 반환
    } else {
      throw Exception('Failed to upload file'); // 업로드 실패 시 예외 발생
    }
  }

  void _submitPost(Post postData) async { // 포스트 데이터 제출 메서드
    var response = await http.post( // 포스트 요청 전송
      Uri.parse('https://your-api-url.com/posts'), // API 엔드포인트
      headers: {'Content-Type': 'application/json'}, // 요청 헤더 설정
      body: jsonEncode(postData.toMap()), // 포스트 데이터를 JSON으로 인코딩하여 전송
    );

    if (response.statusCode == 201) { // 성공적으로 포스트가 생성된 경우
      showDialog( // 팝업 메시지
        context: Get.context!,
        builder: (context) => MessagePopup(
          title: '포스트', // 팝업 제목
          message: '포스팅이 완료 되었습니다.', // 팝업 메시지
          okCallback: () {
            Get.until((route) => Get.currentRoute == '/'); // 메인 화면으로 이동
          },
        ),
      );
    } else { // 포스트 생성에 실패한 경우
      showDialog( // 팝업 메시지
        context: Get.context!,
        builder: (context) => MessagePopup(
          title: '오류', // 팝업 제목
          message: '포스팅 중 오류가 발생했습니다.', // 오류 메시지
          okCallback: () => Get.back(), // 확인 버튼을 누르면 이전 화면으로 이동
        ),
      );
    }
  }
}
