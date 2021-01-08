import 'dart:io';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;


class AppleSignInService {

  static String clientId = 'com.inyigolopez.signinservice';
  static String redirectUri = 'https://signin-auth-backend.herokuapp.com/callbacks/sign_in_with_apple';

  static void signIn() async {


    try {
      
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: clientId, 
          redirectUri: Uri.parse( redirectUri )
        )
      );

      print(credential);
      print(credential.authorizationCode); //Like Token de Google

      // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
      // after they have been validated with Apple (see `Integration` section for more information on how to do this)
      final signInWithAppleEndpoint = Uri(
        scheme: 'https',
        host: 'signin-auth-backend.herokuapp.com',
        path: '/sign_in_with_apple',
        queryParameters: {
          'code': credential.authorizationCode,
          'firstName': credential.givenName,
          'lastName': credential.familyName,
          'useBundleId': Platform.isIOS ? 'true' : 'false',
          if( credential.state != null ) 'state': credential.state
        }
      );

      final session = await http.post( signInWithAppleEndpoint );

      print('Respuesta de mi servicio');
      print( session.body );

    } catch (e) {
      print('Error en signin');
      print(e.toString());
    }


  }





}