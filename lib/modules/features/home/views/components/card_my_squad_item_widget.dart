import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../configs/themes/app_text_style.dart';
import '../../../../../constants/cores/dimension_constant.dart';
import '../../../../../shared/widgets/chip_checked_widget.dart';

class CardMySquadItemWidget extends StatelessWidget {
  const CardMySquadItemWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.desc,
    required this.number,
    this.checkedAt,
    this.onTap,
  });

  final String imageUrl;
  final String title;
  final String desc;
  final String number;
  final String? checkedAt;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstant.pixel20,
          vertical: DimensionConstant.pixel20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                width: DimensionConstant.pixel30,
                height: DimensionConstant.pixel30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const SizedBox(
                width: DimensionConstant.pixel30,
                height: DimensionConstant.pixel30,
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: DimensionConstant.pixel12,
              ),
            ),
            const SizedBox(
              width: DimensionConstant.pixel12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.f16BlackTextW500,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: DimensionConstant.pixel2,
                  ),
                  Text(
                    desc,
                    style: AppTextStyle.f9GreyTextW400,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: checkedAt != null && checkedAt != '',
              child: ChipCheckedWidget(checkedAt: checkedAt),
            ),
            Text(
              number,
              style: AppTextStyle.f16BlackTextW400,
            ),
          ],
        ),
      ),
    );
  }
}
