// import 'package:eco_saver/models/user.dart';
// import 'package:get/get.dart';
// import '../services/auth_service.dart';

// class UserController extends GetxController {
//   final AuthService _authService = Get.find<AuthService>();

//   // Observable user model
//   Rx<UserModel?> userModel = Rx<UserModel?>(null);

//   @override
//   void onInit() {
//     super.onInit();
//     // Listen to changes in the AuthController's userModel
//     ever(_authService.userModel, (UserModel? user) {
//       if (user != null) {
//         // print(
//         //     "ever(_authService.userModel) _authService.userModel = ${user!.uid}");
//         userModel.value = user;
//       } else {
//         //print("user = null in ever of user_Controller");
//         clearUserData();
//       }
//     });
//   }

//   // Method to clear user data (e.g., on sign out)
//   void clearUserData() {
//     userModel.value = null;
//     _authService.signOut();
//   }
// }
