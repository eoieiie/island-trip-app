import 'package:flutter/material.dart';
import '../viewmodels/tour_api_view_model.dart';
import '../models/tour_api_photo_model.dart';
import 'full_screen_image_view.dart'; // 전체 화면 이미지 페이지 임포트

class TourApiSearchPage extends StatefulWidget {
  @override
  _TourApiSearchPageState createState() => _TourApiSearchPageState();
}

class _TourApiSearchPageState extends State<TourApiSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final TourApiViewModel _viewModel = TourApiViewModel();
  List<TourApiPhotoModel> _photos = [];

  Future<void> _searchPhotos() async {
    final query = _controller.text;
    if (query.isNotEmpty) {
      try {
        final photos = await _viewModel.searchPhotos(query);
        setState(() {
          _photos = photos;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TourAPI 사진 검색'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '검색어를 입력하세요',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchPhotos,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  final photo = _photos[index];
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        // 이미지를 클릭했을 때 전체 화면으로 보기
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(
                              imageUrl: photo.galWebImageUrl,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: photo.galWebImageUrl,
                        child: Image.network(
                          photo.galWebImageUrl,
                          fit: BoxFit.cover,
                          width: 100,
                        ),
                      ),
                    ),
                    title: Text(photo.galTitle),
                    subtitle: Text(photo.galPhotographyLocation ?? '촬영 장소 없음'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
