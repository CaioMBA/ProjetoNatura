import 'package:google_sign_in/google_sign_in.dart';

class OutsideAppSignInResponse{
  bool? Valid;
  GoogleSignInAccount? Account;

  OutsideAppSignInResponse({this.Valid,this.Account});
}