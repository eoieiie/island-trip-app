import 'package:flutter/material.dart';

class SettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('이용 안내'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Text('알림 설정'),
                    value: true,
                    onChanged: (bool value) {},
                  ),
                  SwitchListTile(
                    title: Text('공지사항'),
                    value: true,
                    onChanged: (bool value) {},
                  ),
                  SwitchListTile(
                    title: Text('이용약관'),
                    value: true,
                    onChanged: (bool value) {},
                  ),
                  SwitchListTile(
                    title: Text('개인정보 처리 방침'),
                    value: true,
                    onChanged: (bool value) {},
                  ),
                  SwitchListTile(
                    title: Text('사용 가이드'),
                    value: true,
                    onChanged: (bool value) {},
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('문의하기'),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text('계정'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('로그아웃'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('계정 삭제'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
