import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService{

  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  static Future<GoogleSignInAccount> signInWithGoogle() async {

    try {
      
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      final googleKey = await account.authentication;

      // print('========== ID TOKEN ==========');
      // print(account);
      // print( googleKey.idToken );

      final signinWithGoogleEndpoint = Uri(
        scheme: 'https',
        host: 'signin-auth-backend.herokuapp.com',
        path: 'google'
      );

      final session = await http.post(
        signinWithGoogleEndpoint,
        body: {
          'token': googleKey.idToken
        }
      );

      print('========= BACKEND SERVER ========');
      print( session.body );

      return account;

    } catch (e) {
      print('Error en Google SignIn');
      print(e);
      return null;
    }
  }

  static Future signOut() async {
    await _googleSignIn.signOut();
  }

}