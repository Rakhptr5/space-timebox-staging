import 'package:flutter/material.dart';
import 'package:timebox/constants/cores/assets_constant.dart';

class EmptyDataComponent extends StatelessWidget {
  const EmptyDataComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Center(
        child: Image.asset(AssetConstants.bgEmptyData),
      ),
    );
  }
}
