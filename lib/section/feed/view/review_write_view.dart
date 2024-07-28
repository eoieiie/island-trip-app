import 'package:flutter/material.dart';
import 'package:project_island/section/feed/view/upload_view.dart'; // add_photo_view 파일 가져오기

class ReviewWriteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사진 올리기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UploadView()));
                        },
                        child: Container(
                          margin: EdgeInsets.all(4.0),
                          color: Colors.grey[300],
                          child: Center(child: Icon(Icons.add)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadView()));
                              },
                              child: Container(
                                margin: EdgeInsets.all(4.0),
                                color: Colors.grey[300],
                                child: Center(child: Icon(Icons.add)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadView()));
                              },
                              child: Container(
                                margin: EdgeInsets.all(4.0),
                                color: Colors.grey[300],
                                child: Center(child: Icon(Icons.add)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: '위치',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '어떤 점이 좋았나요?',
                style: TextStyle(fontSize: 16),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  Chip(label: Text('사람 없이 한적해요')),
                  Chip(label: Text('연인과 가기 좋아요')),
                  Chip(label: Text('사진 찍기 좋아요')),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star_border),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: '장소에 대한 솔직한 리뷰를 남겨주세요.',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // 저장 버튼 클릭 시 이전 화면으로 돌아감
                  },
                  child: Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
