import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadView extends StatefulWidget {
  @override
  _UploadViewState createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  List<AssetPathEntity> albums = []; // 앨범 리스트
  List<AssetEntity> imageList = []; // 이미지 리스트
  AssetEntity? selectedImage; // 선택된 이미지
  String headerTitle = 'All Photos'; // 헤더 타이틀

  @override
  void initState() {
    super.initState();
    _loadImages(); // 이미지 로드
  }

  Future<void> _loadImages() async {
    final permitted = await PhotoManager.requestPermissionExtend(); // 권한 요청
    if (!permitted.isAuth) return;

    List<AssetPathEntity> albumList = await PhotoManager.getAssetPathList(); // 앨범 리스트 가져오기
    setState(() {
      albums = albumList;
      headerTitle = albums.first.name; // 첫 앨범 이름 설정
    });
    _loadData(albums.first); // 첫 앨범 데이터 로드
  }

  Future<void> _loadData(AssetPathEntity album) async {
    List<AssetEntity> imageListData = await album.getAssetListPaged(page: 0, size: 80); // 이미지 리스트 가져오기
    setState(() {
      imageList = imageListData;
      selectedImage = imageList.first; // 첫 이미지 선택
    });
  }

  Widget _imagePreview() {
    var width = MediaQuery.of(context).size.width; // 화면 너비
    return Container(
      width: width,
      height: width,
      color: Colors.grey,
      child: selectedImage != null
          ? _photoWidget(
        selectedImage!,
        width.toInt(),
        builder: (data) {
          return Image.memory(
            data,
            fit: BoxFit.cover,
          );
        },
      )
          : Container(),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                isScrollControlled: albums.length > 10 ? true : false,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                ),
                builder: (_) => Container(
                  height: albums.length > 10
                      ? MediaQuery.of(context).size.height * 0.7
                      : albums.length * 60.0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black54,
                            ),
                            width: 40,
                            height: 4,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                albums.length,
                                    (index) => GestureDetector(
                                  onTap: () {
                                    _loadData(albums[index]);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    child: Text(albums[index].name),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Text(
                    headerTitle,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: const Color(0xff808080),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    Icon(Icons.select_all),
                    const SizedBox(width: 7),
                    const Text(
                      '여러 항목 선택',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff808080),
                ),
                child: Icon(Icons.camera_alt),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageSelectList() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return _photoWidget(imageList[index], 200, builder: (data) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  selectedImage = imageList[index];
                });
              },
              child: Opacity(
                opacity: imageList[index] == selectedImage ? 0.3 : 1,
                child: Image.memory(
                  data,
                  fit: BoxFit.cover,
                ),
              ));
        });
      },
    );
  }

  Widget _photoWidget(AssetEntity asset, int size,
      {required Widget Function(Uint8List) builder}) {
    return FutureBuilder(
      future: asset.thumbnailDataWithSize(ThumbnailSize(size, size)),
      builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data!);
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 흰색
      appBar: AppBar(
        backgroundColor: Colors.white, // 앱바 배경색 흰색
        elevation: 0, // 앱바 그림자 제거
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // 뒤로가기
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(Icons.close, color: Colors.black), // 닫기 아이콘
          ),
        ),
        title: const Text(
          'New Post', // 제목
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // 이미지 필터 화면으로 이동 (추후 구현)
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.arrow_forward, color: Colors.black), // 앞으로 가기 아이콘
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imagePreview(), // 이미지 미리보기
            _header(), // 헤더
            _imageSelectList(), // 이미지 선택 리스트
          ],
        ),
      ),
    );
  }
}
