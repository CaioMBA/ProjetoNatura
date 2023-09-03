import 'package:google_sign_in/google_sign_in.dart';
import 'package:natura_app/Domain/StaticSchematics.dart';

import '../Domain/OutsideAppSignInResponse.dart';
import 'UserServices.dart';


Future<OutsideAppSignInResponse?> SignInWithGoogle() async {
  bool SignInValidation = false;
  try{
    await GoogleSignIn().signOut();

    GoogleSignInAccount? googleSignInAccount =
    await GoogleSignIn().signIn();

    if (googleSignInAccount != null) {
      // User successfully signed in.
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final accessToken = googleSignInAuthentication.accessToken;
      final idToken = googleSignInAuthentication.idToken;
      SignInValidation = true;
    } else {
      await GoogleSignIn().signOut();
    }

    if (SignInValidation) {
      await GetExtraInfo(googleSignInAccount?.email);
      if (GlobalStatics.UserLogin == '') {
        return OutsideAppSignInResponse(Valid: false, Account: googleSignInAccount);
      } else {
        return OutsideAppSignInResponse(Valid: true, Account: googleSignInAccount);
      }
    }
    googleSignInAccount = null;
    return null;
  }
  catch (_){
    return null;
  }
}
