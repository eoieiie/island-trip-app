import '../model/home_model.dart';
import 'dart:convert';  // JSON 파싱을 위해 필요
import 'package:http/http.dart' as http;  // HTTP 요청을 위해 필요
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';  // 로컬 JSON 파일을 불러오기 위해 필요
import 'dart:io';

final String apiKey = dotenv.env['TOUR_API_KEY'] ?? ''; // 환경 변수에서 API 키 가져오기


String generateImageUrl(String contentId) {
  return 'http://apis.data.go.kr/B551011/KorService1/detailImage1?ServiceKey=$apiKey&contentId=$contentId&MobileOS=ETC&MobileApp=AppTest&imageYN=Y&subImageYN=Y&numOfRows=10';
}

String generateThumnailUrl(String contentId) {
  return 'http://apis.data.go.kr/B551011/KorService1/detailCommon1?ServiceKey=$apiKey&contentTypeId=12&contentId=$contentId&MobileOS=ETC&MobileApp=AppTest&defaultYN=Y&firstImageYN=Y&areacodeYN=Y&catcodeYN=Y&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y';
}
