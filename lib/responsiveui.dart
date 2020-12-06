import 'package:streamico/globals.dart' as globals;
import 'package:streamico/size_config.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget portraitLayout;
  final Widget webLayout;

  const ResponsiveWidget({
    Key key,
    @required this.portraitLayout,
    this.webLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (SizeConfig.isPortrait && SizeConfig.isMobilePortrait) {
      globals.isPortrait = true;
      return portraitLayout;
    } else {
      globals.isPortrait = false;
      return webLayout ?? portraitLayout;
    }
  }
}
