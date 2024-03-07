import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}
bool _isObscure = true;

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  startAuthentication() {
    final validity = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (validity!) {
      _formKey.currentState?.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String? uid = authResult.user?.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your credentials!';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(30),
              height: 200,
              child: Image.asset('assets/todo.png'),
            ),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isLoginPage)
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Incorrect Username';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  borderSide: new BorderSide()),
                              labelText: "Enter Username",
                              labelStyle: GoogleFonts.roboto()),
                        ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Incorrect Email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: "Enter Email",
                            labelStyle: GoogleFonts.roboto()),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: _isObscure,
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Incorrect password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(),
                          ),
                          labelText: "Enter Password",
                          labelStyle: GoogleFonts.roboto(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      Container(
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                          height: 70,
                          child: ElevatedButton(
                              child: isLoginPage
                                  ? Text('Login',
                                      style: GoogleFonts.roboto(fontSize: 16))
                                  : Text('SignUp',
                                      style: GoogleFonts.roboto(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                startAuthentication();
                              })),
                      SizedBox(height: 10),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                isLoginPage = !isLoginPage;
                              });
                            },
                            child: isLoginPage
                                ? Text(
                                    'Not a member?',
                                    style: GoogleFonts.roboto(
                                        fontSize: 16, color: Colors.white),
                                  )
                                : Text('Already a Member?',
                                    style: GoogleFonts.roboto(
                                        fontSize: 16, color: Colors.white))),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}

// /*import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class AuthForm extends StatefulWidget {
//   @override
//   _AuthFormState createState() => _AuthFormState();
// }
//
// class _AuthFormState extends State<AuthForm> {
//
//   final _formkey = GlobalKey<FormState>();
//   var _email = '';
//   var _password = '';
//   var _username = '';
//   bool isLoginPage = false;
//
//
//
//   startauthentication() {
//     final validity = _formkey.currentState?.validate();
//     FocusScope.of(context).unfocus();
//
//     if (validity) {
//       _formkey.currentState?.save();
//       submitform(_email, _password, _username);
//     }
//   }
//
//   submitform(String email, String password, String username) async {
//     final auth = FirebaseAuth.instance;
//     AuthResult authResult;
//     try {
//       if (isLoginPage) {
//         authResult = await auth.signInWithEmailAndPassword(
//             email: email, password: password);
//       } else {
//         authResult = await auth.createUserWithEmailAndPassword(
//             email: email, password: password);
//         String uid = authResult.user.uid;
//         await Firestore.instance
//             .collection('users')
//             .document(uid)
//             .setData({'username': username, 'email': email});
//       }
//     } on PlatformException catch (err) {
//       String? message = 'An error occured';
//       if (err.message != null) {
//         message = err.message;
//       }
//       Scaffold.of(context).showSnackBar(SnackBar(
//         content: Text(message!),
//         backgroundColor: Colors.red,
//       ));
//     } catch (err) {
//       print(err);
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: ListView(
//           children: [
//             Container(
//               margin: EdgeInsets.all(30),
//               height: 200,
//               child: Image.asset('assets/todo.png'),
//             ),
//             Container(
//                 padding: EdgeInsets.only(left: 10, right: 10, top: 10),
//                 child: Form(
//                   key: _formkey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (!isLoginPage)
//                         TextFormField(
//                           keyboardType: TextInputType.emailAddress,
//                           key: ValueKey('username'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Incorrect Username';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             _username = value!;
//                           },
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: new BorderRadius.circular(8.0),
//                                   borderSide: new BorderSide()),
//                               labelText: "Enter Username",
//                               labelStyle: GoogleFonts.roboto()),
//                         ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         keyboardType: TextInputType.emailAddress,
//                         key: ValueKey('email'),
//                         validator: (value) {
//                           if (value!.isEmpty || !value!.contains('@')) {
//                             return 'Incorrect Email';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           _email = value!;
//                         },
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: new BorderRadius.circular(8.0),
//                                 borderSide: new BorderSide()),
//                             labelText: "Enter Email",
//                             labelStyle: GoogleFonts.roboto()),
//                       ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         obscureText: true,
//                         keyboardType: TextInputType.emailAddress,
//                         key: ValueKey('password'),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Incorrect password';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           _password = value!;
//                         },
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: new BorderRadius.circular(8.0),
//                                 borderSide: new BorderSide()),
//                             labelText: "Enter Password",
//                             labelStyle: GoogleFonts.roboto()),
//                       ),
//                       SizedBox(height: 10),
//                       Container(
//                           padding: EdgeInsets.all(5),
//                           width: double.infinity,
//                           height: 70,
//                           child: ElevatedButton(
//                               child: isLoginPage
//                                   ? Text('Login',
//                                       style: GoogleFonts.roboto(fontSize: 16))
//                                   : Text('SignUp',
//                                       style: GoogleFonts.roboto(fontSize: 16)),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               color: Theme.of(context).primaryColor,
//                               onPressed: () {
//                                 startauthentication();
//                               })),
//                       SizedBox(height: 10),
//                       Container(
//                         child: TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 isLoginPage = !isLoginPage;
//                               });
//                             },
//                             child: isLoginPage
//                                 ? Text(
//                                     'Not a member?',
//                                     style: GoogleFonts.roboto(
//                                         fontSize: 16, color: Colors.white),
//                                   )
//                                 : Text('Already a Member?',
//                                     style: GoogleFonts.roboto(
//                                         fontSize: 16, color: Colors.white))),
//                       )
//                     ],
//                   ),
//                 ))
//           ],
//         ));
//   }
// }


