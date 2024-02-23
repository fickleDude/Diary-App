import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import '../../common/helpers.dart';
import '../../models/user_model.dart';

class AppUserProvider extends ChangeNotifier {
  /// state  of UserModel information
  AppUserModel _user = const AppUserModel();
  AppUserModel get user => _user;

  set user(AppUserModel userModel) {
    _user = userModel;
    notifyListeners();
  }

  bool displayedOnboard = false;

  void logout(){
    _user = const AppUserModel(); // api token is empty
    notifyListeners();
  }

  bool get isAuthorized{
    return _user.id != null && _user.id!.isNotEmpty;
  }

  Future<bool> login() async {
    final preferences= await SharedPreferences.getInstance();

    // check on board from local storage
    displayedOnboard = preferences.getBool(isStoredKey) ?? false;
    if(!displayedOnboard){
      // directly return false, when onboard never displayed
      return false;
    }

    // fetch user info
    final user = await _fetchUser();
    if (user != null) {
      _user = user;
      return true; // has a login record.
    }
    return false;
  }

  Future<AppUserModel?> _fetchUser() async{
    //only apply to shared preferences
    final preferences = await SharedPreferences.getInstance();
    String? userJson = preferences.getString(userKey);
    return userJson == null ? null : AppUserModel.userFromJson(userJson);
  }
}