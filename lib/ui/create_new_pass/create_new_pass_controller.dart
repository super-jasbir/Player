
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../base_controller.dart';
import '../../data/network/api_endpoints.dart';
import '../../routes/app_routes.dart';
import '../../utils/dialogs/custom_dialog.dart';

class CreateNewPassController extends BaseController{
  var obscure = true.obs;
  var obscure2 = true.obs;
  TextEditingController enterPassC = TextEditingController();
  TextEditingController enterConfirmPassC = TextEditingController();
  var suffixIcon = "assets/images/pass_hide.png".obs;


  resetPassword(String playerId,BuildContext context)async{
    var request = {
      "password":enterPassC.text,
      "password_confirmation":enterConfirmPassC.text,
      "player_id":playerId
    };
    var result = await apiService.postRequest(ApiEndPoint.resetPassword, request);
    if(result.data != null){
      // success redirect
      Get.offAllNamed(AppRoutes.loginScreen);

    }else{
      Fluttertoast.showToast(msg: result.error.toString());
    }

  }


}