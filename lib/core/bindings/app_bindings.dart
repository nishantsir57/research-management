import 'package:get/get.dart';

import '../../features/admin/controllers/admin_controller.dart';
import '../../features/admin/controllers/department_controller.dart';
import '../../features/admin/controllers/settings_controller.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/common/controllers/loading_controller.dart';
import '../../features/common/controllers/user_directory_controller.dart';
import '../../features/discussions/controllers/discussion_controller.dart';
import '../../features/networking/controllers/connection_controller.dart';
import '../../features/submissions/controllers/submission_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<LoadingController>(LoadingController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<DepartmentController>(DepartmentController(), permanent: true);
    Get.put<SettingsController>(SettingsController(), permanent: true);
    Get.put<SubmissionController>(SubmissionController(), permanent: true);
    Get.put<DiscussionController>(DiscussionController(), permanent: true);
    Get.put<ConnectionController>(ConnectionController(), permanent: true);
    Get.put<UserDirectoryController>(UserDirectoryController(), permanent: true);
    Get.put<AdminController>(AdminController(), permanent: true);
  }
}
