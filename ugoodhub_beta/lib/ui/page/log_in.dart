import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ug_foodhub/utility/account_api.dart';
import 'package:ug_foodhub/model/account_model.dart';
import '../../logic/bloc/product/product_bloc.dart';
import '../../logic/bloc/restaurant/restaurant_bloc.dart';
import '../../logic/provider/login_provider.dart';
import 'sign_up.dart';
import 'home_page.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoggedin = false;
  int id = 0;
  String nama = "";
  String email = "";
  String _msg = "";

  final formKey = GlobalKey<FormState>();

  ///This function is for saving data to shared preferences locally
  void saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('id', id);
    await pref.setString('nama', nama);
    await pref.setString('email', email);
    await pref.setBool('isLoggedin', isLoggedin);
  }

  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  String validateUser(String? email) {
    var s = email != null && !EmailValidator.validate(email)
        ? 'Enter a valid email'
        : this._msg;
    print("test1");
    return s;
  }

  String validatePass(String? pass) {
    var s = pass!.isEmpty ? "Please enter password" : this._msg;
    print("test2");
    return s;
  }

  void doLogin(
      {required String username,
      required String password,
      required List<AccountModel>? account,
      required LoginProvider auth}) {
    _msg = auth.loginAuth(username: username, password: password);
    final form = formKey.currentState;
    try {
      if (form!.validate()) {
        /*
         for loops used for accesing data from list
         the username.compareTo and password.compareTo will pick the choosen account
         and if all conditions true, the code will set id, nama, and email based on the choosen account
         isLoggedin set to opposite of it`s value
         saveData() used to save the data to shared preferences 
        */
        for (var user in account!) {
          if (username.compareTo(user.username) == 0) {
            if (password.compareTo(user.password) == 0) {
              id = user.id;
              nama = user.nama;
              email = user.email;
              isLoggedin = !isLoggedin;
              saveData();
              break;
            }
          }
        }
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => RestaurantBloc()..add(LoadRestaurant()),
                ),
                BlocProvider(
                  create: (context) => ProductBloc()..add(LoadProduct()),
                ),
              ],
              child: HomePage(),
            );
          },
        ));
      }
    } catch (e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Terdapat kesalahan'),
          //content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isHiddenPass = true;

  @override
  Widget build(BuildContext context) {
    LoginProvider _auth = Provider.of<LoginProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: Container(
            margin:
                const EdgeInsets.only(left: 7, top: 4, right: 10, bottom: 10),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 11,
                  offset: Offset(6, 4), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Center(
                child: IconButton(
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        /*
          body part using future builder for account data fetch
         
        */
        body: FutureBuilder<List<AccountModel>>(
          future: _auth.loadData(),
          builder: (context, snapshot) {
            final _account = snapshot.data;
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/BackgroundImage.png'),
                  fit: BoxFit.fill,
                ),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Masuk",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 40),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //Log-in form text field group

                      Text(
                        'E-mail',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        validator: validateUser,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepOrange, width: 2.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusColor: Colors.deepOrange,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Kata Sandi',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextFormField(
                        obscureText: isHiddenPass,
                        controller: _passwordController,
                        validator: validatePass,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepOrange, width: 2.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusColor: Colors.deepOrange,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isHiddenPass = !isHiddenPass;
                              });
                            },
                            child: Icon(
                              isHiddenPass
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: MaterialButton(
                          onPressed: () {
                            doLogin(
                              username: _usernameController.text,
                              password: _passwordController.text,
                              account: _account,
                              auth: _auth,
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          child: Text(
                            'MASUK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          color: Colors.deepOrange,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Belum memiliki akun ?',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}