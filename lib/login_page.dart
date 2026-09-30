import 'package:fire_note_cohort_10/home_page.dart';
import 'package:fire_note_cohort_10/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {

  TextEditingController userEmailControlller = TextEditingController();
  TextEditingController passwordControlller = TextEditingController();
  FirebaseAuth fireAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/logo_monety.png"),),
            SizedBox(width: 5,),
            Text("Notes", style: TextStyle(fontSize: 30),),
            SizedBox(width: 20,)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 150,),
            TextField(
              controller: userEmailControlller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  hintText: "Enter your email here..",
                  labelText: "Email",
                  fillColor: Colors.deepPurple.shade100,
                  filled: true
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: passwordControlller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  hintText: "Enter password",
                  labelText: "Password",
                  fillColor: Colors.deepPurple.shade100,
                  filled: true
              ),
            ),
            SizedBox(height: 30,),
            OutlinedButton(onPressed: () async {
              try{
                var userCred = await fireAuth.signInWithEmailAndPassword(
                    email: userEmailControlller.text,
                    password: passwordControlller.text);

                if(userCred.user!=null){
                  print("User logged in");

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("userId", userCred.user!.uid);

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
                } else {
                  print("User not logged in");
                }
              } on FirebaseAuthException catch (e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Invalid Credentials!!"),),
                );
              } catch (e){
                print(e.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString()),),
                );
              }

            },
              child: Text("Login", style: TextStyle(fontSize: 25),),),
            SizedBox(height: 150,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't have any accout?", style: TextStyle(fontSize: 20),),
                SizedBox(width: 10,),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SignupPage()));
                    },
                    child: Text("Sign up", style: TextStyle(
                        fontSize: 20, color: Colors.deepPurpleAccent),)),
              ],
            )
          ],
        ),
      ),
    );
  }
}