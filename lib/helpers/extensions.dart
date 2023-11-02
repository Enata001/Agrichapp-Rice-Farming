import 'package:agrichapp/features/feature_authentication/models/user_data.dart';
import 'package:agrichapp/helpers/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension CacheExtension on SharedPreferences {
  UserData getUserData() {
    String? userDataString = getString(CacheConstants.USER_DATA);
    return UserData.fromString(data: userDataString);
  }

}
