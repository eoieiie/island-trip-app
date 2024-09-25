import 'package:flutter/material.dart';
import 'package:project_island/section/common/google_api/viewmodels/google_place_view_model.dart';
import 'package:project_island/section/common/google_api/models/google_place_model.dart';
import '../model/custom_google_place_model.dart'; // 새로 생성한 모델

class NewGoogleSearchPage extends StatefulWidget {
  final String selectedIsland; // 섬 이름을 별도 매개변수로 전달받음

  const NewGoogleSearchPage({Key? key, required this.selectedIsland}) : super(key: key);

  @override
  _NewGoogleSearchPageState createState() => _NewGoogleSearchPageState();
}

class _NewGoogleSearchPageState extends State<NewGoogleSearchPage> {
  late TextEditingController _controller;
  final GooglePlaceViewModel _viewModel = GooglePlaceViewModel();
  List<GooglePlaceModel> _places = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); // 초기 검색어를 비워둠
  }

  Future<void> _searchPlaces() async {
    final userQuery = _controller.text.trim();
    if (userQuery.isNotEmpty) {
      final fullQuery = "${widget.selectedIsland} $userQuery"; // 섬 이름과 사용자 입력을 결합
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _places = [];
      });
      try {
        final places = await _viewModel.searchPlaces(fullQuery);
        setState(() {
          _places = places;
          if (_places.isEmpty) {
            _errorMessage = '검색 결과가 없습니다.';
          }
        });
      } catch (e) {
        setState(() {
          _errorMessage = '검색 중 오류가 발생했습니다.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _selectPlace(GooglePlaceModel place) {
    final customPlace = CustomGooglePlaceModel.fromGooglePlaceModel(place);
    Navigator.pop(context, {
      'place': customPlace.name,
      'latitude': customPlace.latitude,
      'longitude': customPlace.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장소 검색'),
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
                  icon: const Icon(Icons.search),
                  onPressed: _searchPlaces,
                ),
              ),
              onSubmitted: (_) => _searchPlaces(),
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              )
            else
              Expanded(
                child: _places.isNotEmpty
                    ? ListView.builder(
                  itemCount: _places.length,
                  itemBuilder: (context, index) {
                    final place = _places[index];
                    final thumbnailUrl = place.photoUrls != null && place.photoUrls!.isNotEmpty
                        ? place.photoUrls!.first
                        : null;

                    return ListTile(
                      leading: thumbnailUrl != null
                          ? Image.network(
                        thumbnailUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : const Icon(Icons.image_not_supported),
                      title: Text(place.name),
                      subtitle: Text(place.address),
                      onTap: () => _selectPlace(place),
                    );
                  },
                )
                    : const Center(
                  child: Text('검색 결과가 없습니다.'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
