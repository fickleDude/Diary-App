import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> with TickerProviderStateMixin {
  late TextEditingController _emailController, _passwordController;
  late FocusNode _emailFocusNode, _passwordFocusNode;
  late bool _passwordVisibility;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordVisibility = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_emailFocusNode.canRequestFocus || _passwordFocusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      child: Scaffold(
        key: GlobalKey<ScaffoldState>(),
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4B39EF), Color(0xFFEE8B60)],
              stops: [0, 1],
              begin: AlignmentDirectional(0.87, -1),
              end: AlignmentDirectional(-0.87, 1),
            ),
          ),
          alignment: AlignmentDirectional(0, -1),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 16),
                  child: Container(
                    width: 200,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: AlignmentDirectional(0, 0),
                    child: Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Text(
                        'Memento Mori',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(0, 70, 0),
                  child: Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 570),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome Back',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Color(0xFF101213),
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                              child: Text(
                                'Fill out the information below to access your account.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            for (var inputField in [
                              _buildInputField('Email', _emailController, _emailFocusNode, Icons.email),
                              _buildInputField('Password', _passwordController, _passwordFocusNode, Icons.lock, obscureText: !_passwordVisibility),
                            ])
                              Container(width: double.infinity, child: inputField),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                              child: Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle login button press
                                  },
                                  child: Text('Login'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, FocusNode focusNode, IconData icon, {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
