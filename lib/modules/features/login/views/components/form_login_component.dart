import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/login/controllers/login_controller.dart';

class FormLoginComponent extends StatelessWidget {
  const FormLoginComponent({
    super.key,
    required this.emailC,
    required this.passwordC,
    required this.onFieldSubmitted,
  });

  final TextEditingController emailC;
  final TextEditingController passwordC;
  final Function(String) onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alamat Email',
          style: AppTextStyle.f12BlackW400,
        ),
        TextFormField(
          autofocus: true,
          controller: emailC,
          style: AppTextStyle.f16BlackW400,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: DimensionConstant.pixel10,
            ),
            isDense: true,
            fillColor: Colors.white,
            hintText: 'Masukkan alamat email kamu..',
            hintStyle: AppTextStyle.f16GreyW400,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueUnderline),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.redColor),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.redColor),
            ),
          ),
          validator: (String? value) {
            String trim = value!.trim();
            if (trim.isEmpty) {
              return 'Alamat email tidak boleh kosong';
            }

            return null;
          },
        ),
        const SizedBox(height: DimensionConstant.pixel35),
        const Text(
          'Kata Sandi',
          style: AppTextStyle.f12BlackW400,
        ),
        Obx(
          () => TextFormField(
            controller: passwordC,
            obscureText: LoginController.loginC.isHidePassword.value,
            autocorrect: false,
            style: AppTextStyle.f16BlackW400,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: DimensionConstant.pixel10,
              ),
              isDense: true,
              hintText: 'Masukkan kata sandi kamu..',
              hintStyle: AppTextStyle.f16GreyW400,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.black),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.blueUnderline),
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.redColor),
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.redColor),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 2,
                minHeight: 2,
              ),
              suffixIcon: InkWell(
                  onTap: () {
                    LoginController.loginC.isHidePassword.value =
                        !LoginController.loginC.isHidePassword.value;
                  },
                  child: Icon(
                    LoginController.loginC.isHidePassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: LoginController.loginC.isHidePassword.value
                        ? AppColors.grey
                        : AppColors.primaryColor,
                    size: 18,
                  )),
            ),
            validator: (String? value) {
              String trim = value!.trim();
              if (trim.isEmpty) {
                return 'Kata sandi tidak boleh kosong';
              }

              return null;
            },
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ],
    );
  }
}
