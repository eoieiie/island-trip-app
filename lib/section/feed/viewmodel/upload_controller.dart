import 'dart:io'; // 파일 입출력을 위한 패키지
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage 사용을 위한 패키지 가져오기
import 'package:flutter/material.dart'; // Flutter UI 패키지
import 'package:project_island/section/common/feed_my_page common/src/components/message_popup.dart'; // 커스텀 메시지 팝업
import 'package:project_island/section/feed/viewmodel/auth_controller.dart'; // 인증 컨트롤러
import 'package:project_island/section/feed/model/post_model.dart'; // 포스트 모델
import 'package:project_island/section/feed/repository/post_repository.dart'; // 포스트 리포지토리
import 'package:project_island/section/feed/view/upload_description.dart'; // 업로드 설명 뷰
import 'package:project_island/section/common/feed_my_page common/src/utils/data_util.dart'; // 데이터 유틸리티
import 'package:get/get.dart'; // GetX 패키지
// import 'package:image_picker/image_picker.dart'; // 이미지 선택기
import 'package:photo_manager/photo_manager.dart'; // 사진 관리자
import 'package:image/image.dart' as imageLib; // 이미지 라이브러리
import 'package:path/path.dart'; // 경로 관련 유틸리티
import 'package:photofilters/filters/preset_filters.dart'; // 사진 필터 프리셋
import 'package:photofilters/widgets/photo_filter.dart'; // 사진 필터 위젯

class UploadController extends GetxController { // GetX 컨트롤러 상속
  var albums = <AssetPathEntity>[]; // 앨범 리스트
  RxList<AssetEntity> imageList = <AssetEntity>[].obs; // 이미지 리스트 (Observable)
  RxString headerTitle = ''.obs; // 헤더 타이틀 (Observable)
  TextEditingController textEditingController = TextEditingController(); // 텍스트 입력 컨트롤러
  Rx<AssetEntity> selectedImage = AssetEntity( // 선택된 이미지 (Observable)
    id: '0',
    typeInt: 0,
    width: 0,
    height: 0,
  ).obs;
  File? filteredImage; // 필터 적용된 이미지 파일
  Post? post; // 업로드할 포스트 데이터

  @override
  void onInit() { // 초기화 메서드
    super.onInit();
    post = Post.init(AuthController.to.user.value); // 현재 사용자 정보로 초기 포스트 생성
    _loadPhotos(); // 사진 로드
  }

  void _loadPhotos() async { // 사진 로드 메서드
    var result = await PhotoManager.requestPermissionExtend(); // 사진 접근 권한 요청
    if (result.isAuth) { // 권한이 허용된 경우
      albums = await PhotoManager.getAssetPathList( // 앨범 리스트 가져오기
        type: RequestType.image, // 이미지 타입만 가져옴
        filterOption: FilterOptionGroup( // 필터 옵션 설정
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minHeight: 100, minWidth: 100), // 최소 크기 설정
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false), // 생성일 기준 내림차순 정렬
          ],
        ),
      );
      _loadData(); // 데이터 로드
    } else {
      // 권한 요청 메시지
    }
  }

  void _loadData() async { // 데이터 로드 메서드
    changeAlbum(albums.first); // 첫 번째 앨범으로 변경

    // update(); // 상태 업데이트
  }

  Future<void> _pagingPhotos(AssetPathEntity album) async { // 페이징으로 사진 로드
    imageList.clear(); // 이미지 리스트 초기화
    var photos = await album.getAssetListPaged(page: 0, size: 30); // 페이징으로 사진 가져오기
    imageList.addAll(photos); // 사진 리스트에 추가
    changeSelectedImage(imageList.first); // 첫 번째 이미지로 선택 변경
  }

  changeSelectedImage(AssetEntity image) { // 선택된 이미지 변경
    selectedImage(image); // Observable 값 업데이트
  }

  void changeAlbum(AssetPathEntity album) async { // 앨범 변경 메서드
    headerTitle(album.name); // 헤더 타이틀 변경
    await _pagingPhotos(album); // 선택된 앨범의 사진 로드
  }

  void gotoImageFilter() async { // 이미지 필터 화면으로 이동
    var file = await selectedImage.value.file; // 선택된 이미지 파일 가져오기
    var fileName = basename(file!.path); // 파일명 추출
    var image = imageLib.decodeImage(file.readAsBytesSync()); // 이미지 디코딩
    image = imageLib.copyResize(image!, width: 1000); // 이미지 리사이즈
    var imagefile = await Navigator.push( // 필터 선택 화면으로 이동
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
      filteredImage = imagefile['image_filtered']; // 필터된 이미지 저장
      Get.to(() => const UploadDescription()); // 업로드 설명 화면으로 이동
    }
  }

  void unfocusKeyboard() { // 키보드 비활성화
    FocusManager.instance.primaryFocus?.unfocus(); // 포커스 해제
  }

  void uplaodPost() { // 포스트 업로드 메서드
    unfocusKeyboard(); // 키보드 비활성화
    var filename = DataUtil.makeFilePath(); // 파일 경로 생성
    var task = uploadFile(
        filteredImage!, '/${AuthController.to.user.value.uid}/$filename'); // 파일 업로드
    if (task != null) { // 업로드 작업이 있는 경우
      task.snapshotEvents.listen( // 업로드 이벤트 리스너
            (event) async {
          if (event.bytesTransferred == event.totalBytes &&
              event.state == TaskState.success) { // 업로드 완료 시
            var downloadUrl = await event.ref.getDownloadURL(); // 다운로드 URL 가져오기
            var updatedPost = post!.copyWith( // 포스트 데이터 업데이트
              thumbnail: downloadUrl, // 썸네일 URL
              description: textEditingController.text, // 설명
            );
            _submitPost(updatedPost); // 포스트 제출
          }
        },
      );
    }
  }

  UploadTask uploadFile(File file, String filename) { // 파일 업로드 메서드
    var ref = FirebaseStorage.instance.ref().child('instagram').child(filename); // Firebase 참조 생성
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path}); // 메타데이터 설정
    return ref.putFile(file, metadata); // 파일 업로드
  }

  void _submitPost(Post postData) async { // 포스트 제출 메서드
    await PostRepository.updatePost(postData); // 포스트 데이터 업데이트
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
  }
}
