import 'package:staffku/shared/shared.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: ColorConstants.mainColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .30,
              maxWidth: MediaQuery.of(context).size.width * .70,
            ),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
