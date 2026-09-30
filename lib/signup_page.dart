import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userMobileNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool isPassVisible = false;
  bool isConfirmPassVisible = false;
  FirebaseAuth fireAuth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/logo_monety.png"),
            ),
            SizedBox(width: 5),
            Text("Monety", style: TextStyle(fontSize: 30)),
            SizedBox(width: 20),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hi, Welcome to Monety..",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  } else {
                    return null;
                  }
                },
                controller: userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: "Enter your name here..",
                  labelText: "Name",
                  fillColor: Colors.deepPurple.shade100,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  } else if (!emailRegExp.hasMatch(value)) {
                    return "Please enter a valid email";
                  } else {
                    return null;
                  }
                },
                controller: userEmailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: "Enter your email here..",
                  labelText: "Email",
                  fillColor: Colors.deepPurple.shade100,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your mobile no";
                  } else if (value.length != 10) {
                    return "Please enter a valid mobile no";
                  } else {
                    return null;
                  }
                },
                controller: userMobileNoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: "Enter your mobile no here..",
                  labelText: "Mobile no",
                  fillColor: Colors.deepPurple.shade100,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, ss) {
                  return TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (!passwordRegex.hasMatch(value)) {
                        return "Password must contain at least 8 characters, \none uppercase letter, \none lowercase letter, \none digit, \nand one special character";
                      } else {
                        return null;
                      }
                    },
                    controller: passwordController,
                    obscureText: !isPassVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: "Create password",
                      labelText: "Create password",
                      fillColor: Colors.deepPurple.shade100,
                      filled: true,
                      suffixIcon: InkWell(
                        child: Icon(
                          isPassVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onTap: () {
                          isPassVisible = !isPassVisible;
                          ss(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, ss) {
                  return TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please re-enter your password";
                      } else if (value != passwordController.text) {
                        return "Password doesn't match";
                      } else {
                        return null;
                      }
                    },
                    controller: confirmPassController,
                    obscureText: !isConfirmPassVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: "Re-type you password here..",
                      labelText: "Confirm Password",
                      fillColor: Colors.deepPurple.shade100,
                      filled: true,
                      suffixIcon: InkWell(
                        child: Icon(
                          isConfirmPassVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onTap: () {
                          isConfirmPassVisible = !isConfirmPassVisible;
                          ss(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () async {

                    try{
                      var userCred = await fireAuth.createUserWithEmailAndPassword(
                          email: userEmailController.text, password: passwordController.text
                      );

                      if(userCred.user!=null){
                        print("UserId: ${userCred.user!.uid}");

                        fireStore.collection("users").doc(userCred.user!.uid).set({
                          "email" : userEmailController.text,
                          "name" : userNameController.text,
                          "mobNo" : userMobileNoController.text,
                          "createdAt" : DateTime.now().millisecondsSinceEpoch,
                        });

                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User not created"),),
                        );
                      }
                    } catch (e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString()),),
                      );
                    }

                  },
                  child: Text("Sign up", style: TextStyle(fontSize: 25)),
                ),
              ),
              SizedBox(height: 11),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Already have an account, Login now..",
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
