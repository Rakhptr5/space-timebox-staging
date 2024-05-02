import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timebox/configs/themes/app_text_style.dart';

class ProjectTitleComponent extends StatelessWidget {
  const ProjectTitleComponent({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.pointNum,
    required this.issueNum,
  });

  final String imageUrl;
  final String title;
  final String pointNum;
  final String issueNum;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 25,
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.f15BlackTextW500,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${pointNum.replaceAll(".0", "")} Points',
                style: AppTextStyle.f12BlackTextW500,
              ),
              Text(
                '$issueNum Issues',
                style: AppTextStyle.f9BlackTextW400,
              )
            ],
          ),
        ],
      ),
    );
  }
}
