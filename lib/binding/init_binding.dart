/* Flutter에서 GetX 패키지를 사용하여 상태 관리를 할 때, 각 컨트롤러를 바인딩(binding)하는 것은 의존성 주입(dependency injection)을 관리하기 위한 중요한 과정입니다. 당신이 제시한 코드에서는 `InitBinding` 클래스를 사용하여 여러 컨트롤러를 애플리케이션의 생명주기 동안 유지하고 사용할 수 있도록 설정하고 있습니다.

각 파일들을 바인딩한 이유는 다음과 같습니다:

1. **의존성 관리**: `GetX`의 `Get.put()` 메소드를 사용하여 컨트롤러를 등록하면, 해당 컨트롤러의 인스턴스를 애플리케이션의 전역 상태에서 관리할 수 있게 됩니다. 이를 통해 필요할 때마다 새로 인스턴스를 생성하는 것이 아니라, 이미 생성된 인스턴스를 재사용하여 효율성을 높입니다.

2. **상태 관리**: 바인딩된 컨트롤러는 특정 화면이나 기능에서 상태를 관리하는 데 사용됩니다. 예를 들어, `BottomNavController`는 하단 네비게이션 바의 상태를 관리하고, `AuthController`는 인증 관련 상태를 관리합니다. 이를 통해 UI와 로직을 분리할 수 있고, 보다 깔끔한 코드를 유지할 수 있습니다.

3. **자동 생명주기 관리**: `permanent: true`로 설정된 컨트롤러는 앱이 종료될 때까지 메모리에 유지됩니다. 이는 중요한 데이터나 상태를 계속해서 유지해야 할 필요가 있을 때 유용합니다.

4. **모듈화**: 각 기능별로 컨트롤러를 분리하여 모듈화함으로써, 코드의 유지보수성과 확장성을 높일 수 있습니다. 새로운 기능을 추가하거나 변경할 때 각 기능에 맞는 컨트롤러만 수정하면 되기 때문에, 다른 부분에 영향을 주지 않습니다.

따라서, 각 파일을 바인딩하는 것은 이와 같은 이유들로 인해 상태 관리와 의존성 관리의 편의성을 높이기 위한 것입니다. */


import 'package:project_island/section/feed/viewmodel/auth_controller.dart';
//import 'package:flutter_clone_instagram/src/controller/bottom_nav_controller.dart';
import 'package:project_island/section/feed/viewmodel/feed_controller.dart';
import 'package:project_island/section/my_page/viewmodel/my_page_controller.dart';
import 'package:project_island/section/feed/viewmodel/upload_controller.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(BottomNavController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(UploadController(), permanent: true); // UploadController 추가
    Get.put(MypageController(), permanent: true);
    Get.put(FeedController(), permanent: true);
  }

  static additionalBinding() { // 추가적인 바인딩이 필요하다면 여기에 추가
  }
}
