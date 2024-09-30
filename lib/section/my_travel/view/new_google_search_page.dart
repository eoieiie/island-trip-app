import 'package:flutter/material.dart';
import 'package:project_island/section/common/google_api/viewmodels/google_place_view_model.dart';
import 'package:project_island/section/common/google_api/models/google_place_model.dart';
import 'package:project_island/section/map/repository/island_repository.dart';
import '../model/custom_google_place_model.dart'; // 새로 생성한 모델
import 'package:geolocator/geolocator.dart'; // 거리 계산을 위함


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
    _fetchRandomPlaces(); // 페이지 로드 시 랜덤 장소 추천
  }

  Future<void> _fetchRandomPlaces() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _places = [];
    });
    try {
      // 선택한 섬의 인기 장소를 가져오는 메서드 호출
      final places = await _viewModel.getPopularPlaces(widget.selectedIsland);
      setState(() {
        _places = places;
        if (_places.isEmpty) {
          _errorMessage = '추천할 장소가 없습니다.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = '장소를 불러오는 중 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _searchPlaces() async {
    final userQuery = _controller.text.trim();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _places = [];
    });
    try {
      List<GooglePlaceModel> places;

      // 섬의 좌표를 가져옵니다.
      List<double>? islandCoords = IslandRepository().islandCoordinates[widget.selectedIsland];

      if (islandCoords != null) {
        // 검색어가 있으면 해당 검색어로 장소 검색, 없으면 인기 장소를 가져옴
        if (userQuery.isNotEmpty) {
          places = await _viewModel.searchPlaces("${widget.selectedIsland} $userQuery");
        } else {
          places = await _viewModel.getPopularPlaces(widget.selectedIsland);
        }

        // 좌표로 필터링: 섬의 좌표와 장소 좌표 간의 거리 계산
        List<GooglePlaceModel> filteredPlaces = places.where((place) {
          double distanceInMeters = Geolocator.distanceBetween(
            islandCoords[0], islandCoords[1], // 섬 좌표
            place.latitude ?? 0.0, place.longitude ?? 0.0, // 장소 좌표
          );
          return distanceInMeters <= 50000; // 50km 이내의 장소만 필터링
        }).toList();

        setState(() {
          _places = filteredPlaces;
          if (_places.isEmpty) {
            _errorMessage = '검색 결과가 없습니다.';
          }
        });
      } else {
        setState(() {
          _errorMessage = '섬의 좌표를 찾을 수 없습니다.';
        });
      }
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();  // 터치 시 키보드 숨기기
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
            '장소 검색',
            style: TextStyle(
              fontFamily: 'Pretendard',
              inherit: true,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF222222),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1.5,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.black,
              selectionHandleColor: Color(0xFF1BB874),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '검색어를 입력하세요',
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: Color(0xFF1BB874)),
                          onPressed: _searchPlaces,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1),
                        ),
                      ),
                      onSubmitted: (_) => _searchPlaces(),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: _errorMessage != null
                          ? Center(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                          : _places.isNotEmpty
                          ? ListView.separated(
                        itemCount: _places.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Color(0xFFF7F7F7),
                          thickness: 1,
                        ),
                        itemBuilder: (context, index) {
                          final place = _places[index];
                          final thumbnailUrl = place.photoUrls != null &&
                              place.photoUrls!.isNotEmpty
                              ? place.photoUrls!.first
                              : null;

                          return ListTile(
                            leading: thumbnailUrl != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                thumbnailUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.white),
                            ),
                            title: Text(
                              place.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              place.address,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () => _selectPlace(place),
                          );
                        },
                      )
                          : Center(
                        child: Text('추천할 장소가 없습니다.'),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    color: Colors.white.withOpacity(0.7),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.green[300],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
