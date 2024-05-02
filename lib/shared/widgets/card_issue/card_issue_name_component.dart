// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/features/home/models/home_model.dart';
import 'package:timebox/modules/features/home/models/squad_res/squad_new.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/utils/services/api_service.dart';
import 'package:timebox/utils/services/dialog_service.dart';

import '../../../configs/themes/app_colors.dart';
import '../../../modules/features/home/models/squad_res/squad_model.dart';
import '../../../utils/services/hive_service.dart';

// ignore: must_be_immutable
class CardIssueNameComponent extends StatefulWidget {
  CardIssueNameComponent({
    super.key,
    required this.from,
    required this.readOnly,
    this.onSuccess,
    this.onError,
    this.isEdit = false,
  });

  final String from;
  final bool readOnly;
  Function()? onSuccess;
  Function()? onError;
  final bool isEdit;

  @override
  State<CardIssueNameComponent> createState() => _CardIssueNameComponentState();
}

class _CardIssueNameComponentState extends State<CardIssueNameComponent> {
  static final controller = IssueController.issueC;
  final Dio dio = ApiServices.dioCall(
    baseUrl: GlobalController.getGlobalBaseUrl,
  );

  RxInt idProject = controller.projectId;
  RxInt selectedAutocompleteHihlightedIndex = RxInt(0);
  String urlSquad = "api/v2/timebox-project";
  List<SquadNew> listSquad = [];
  RxList<SquadNew> newListSquad = RxList<SquadNew>([]);
  List<Project> listProject = [];
  RxList<Project> newListProject = RxList<Project>([]);
  int currPageSquad = 1;
  String userAuthId = HiveServices.box.get('id').toString();
  String urlProject = "api/v1/mobile/timebox-home?user_auth_id=";
  late ScrollController _scrollController;
  late FocusNode _focusNode;
  @override
  void initState() {
    onInitProject();
    onInitSquad(currPageSquad, '');
    // Inisialisasi ScrollController
    _scrollController = ScrollController();
    // Inisialisasi FocusNode
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // Hapus ScrollController
    _scrollController.dispose();
    // Hapus FocusNode
    _focusNode.dispose();
    super.dispose();
  }

  void onInitProject() async {
    if (widget.from != 'project') {
      var responseProject = await dio.get(urlProject + userAuthId);
      var modelsProject = Project.fromJsonList(
        responseProject.data['data']['project'],
      );

      listProject = modelsProject;
    }
  }

  void onInitSquad(int? page, String? nama) async {
    if (widget.from != 'mySquad') {
      if (!widget.isEdit) {
        controller.assigneName.value = "";
        controller.assignePhoto.value = "";
      }

      if (widget.isEdit &&
          controller.assigneName.value == controller.authName.value) {
        controller.assigneName.value = "";
        controller.assignePhoto.value = "";
      }

      var projectId = controller.projectId.value.toString();

      var projectIdString = "";
      if (Get.isRegistered<HomeController>()) {
        projectIdString = HomeController.homeC.listProjectString.value;
      }

      var response = await dio.get(
        urlSquad,
        queryParameters: {
          if (projectId != "0") 'm_project_id': projectId,
          'nama': nama ?? '',
          'page': page.toString(),
          if (projectIdString.isNotEmpty && projectId == "0")
            "all_project": projectIdString,
        },
      );

      var models = SquadModelNew.fromJson(
        response.data['data'],
      );

      /// add dataList here
      setState(() {
        listSquad = models.data!;
      });
    }
  }

  void replaceTextField() {
    var replace = controller.nameTextController.text
        .replaceAll(
          RegExp(r'\*.*'),
          "",
        )
        .replaceAll(
          RegExp(r'@.*'),
          "",
        );

    controller.nameTextController.text = replace;
    controller.nameTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.nameTextController.text.length),
    );
    controller.nameFocusNode.requestFocus();
  }

  Future<bool> filterAssignee({required String projectId}) async {
    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    String urlSquad = "api/v2/timebox-project";

    var response = await dio.get(
      urlSquad,
      queryParameters: {
        'm_project_id': projectId == '0' ? null : projectId,
        'nama': '',
        'page': 1,
      },
    );

    var models = SquadModelNew.fromJson(response.data["data"]);
    var selectedAssignee = controller.assigneName.value.trim();
    if (models.data != null) {
      SquadNew? selectedAssigneExist = models.data?.firstWhereOrNull(
        (element) => element.namaUser == selectedAssignee,
      );

      if (selectedAssigneExist == null) {
        DialogServices.generalSnackbar(
          context: Get.context!,
          message: '$selectedAssignee tidak masuk ke projek ini',
          dialogType: PanaraDialogType.warning,
        );
        return false;
      }

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    return Row(
      children: [
        Expanded(
          child: RawAutocomplete<CardIssueDataModel>(
            textEditingController: controller.nameTextController,
            focusNode: controller.nameFocusNode,
            optionsBuilder: (textEditingValue) async {
              /// if textediting is not empty and the first index of string is '@'
              if (textEditingValue.text.isNotEmpty &&
                  textEditingValue.text.contains("@") &&
                  listSquad.isNotEmpty) {
                /// all element string matches to lowercase
                /// and replace the '@' symbol inside textEditingValue
                onInitSquad(
                    currPageSquad,
                    textEditingValue.text.toLowerCase().replaceAll(
                          RegExp(r'.*@'),
                          '',
                        ));
                newListSquad.value = List.from(
                  listSquad.where(
                    (element) =>
                        (element.namaUser ?? '').toLowerCase().contains(
                              textEditingValue.text.toLowerCase().replaceAll(
                                    RegExp(r'.*@'),
                                    '',
                                  ),
                            ),
                  ),
                );
                textEditingValue.text.toLowerCase().replaceAll(
                      RegExp(r'.*@'),
                      '',
                    );

                return newListSquad;

                /// if textediting is not empty and the first index of string is '*'
              } else if (textEditingValue.text.isNotEmpty &&
                  textEditingValue.text.contains("*") &&
                  listProject.isNotEmpty) {
                /// all element string matches to lowercase
                /// and replace the '*' symbol inside textEditingValue
                newListProject.value = List.from(
                  listProject.where(
                    (element) => (element.name ?? '').toLowerCase().contains(
                          textEditingValue.text.toLowerCase().replaceAll(
                                RegExp(r'.*\*'),
                                '',
                              ),
                        ),
                  ),
                );

                return newListProject;

                /// if textediting noting response
              } else {
                return [];
              }
            },
            optionsViewBuilder: (context, onSelected, options) => Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: DimensionConstant.pixel300,
                      maxWidth: DimensionConstant.pixel300,
                      maxHeight: DimensionConstant.pixel200),
                  child: ListView.separated(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: options.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      /// selectedData
                      final selectedData = options.elementAt(index);

                      /// using autocompleteHighLightedOption.of(context) will pas the index
                      /// of the selected item inside the autocomplete widget(optionsViewBuilder).
                      /// (this is feature from Autocomplete material.dart)
                      if (kIsWeb) {
                        selectedAutocompleteHihlightedIndex.value =
                            AutocompleteHighlightedOption.of(context);
                      }
                      // Tetapkan fokus pada item yang dipilih
                      if (index == selectedAutocompleteHihlightedIndex.value) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToIndex(index);
                          _focusNode.requestFocus();
                        });
                      }

                      /// onTap based on squad or project
                      if (selectedData is SquadNew) {
                        return listTileFromAssigneComponent(
                          onTap: () {
                            controller.onChangeAssigne(selectedData);
                            replaceTextField();
                          },
                          assigneName: selectedData.namaUser ?? '-',
                          assignePhoto: selectedData.humanisFoto ?? '',
                          isSelected:
                              selectedAutocompleteHihlightedIndex.value ==
                                  index,
                        );
                      } else if (selectedData is Project) {
                        return listTileFromProjectComponent(
                          onTap: () async {
                            var selectedProject = selectedData;
                            if (controller.assigneName.trim().isNotEmpty ||
                                controller.authId.value != 0) {
                              if (!await filterAssignee(
                                projectId: selectedData.mProjectId.toString(),
                              )) {
                                selectedProject = Project(
                                  name: '',
                                  countTimebox: 0,
                                  mProjectId: 0,
                                );
                              }
                            }

                            controller.onChangeProject(selectedProject);
                            replaceTextField();
                          },
                          title: selectedData.name ?? '-',
                          isSelected:
                              selectedAutocompleteHihlightedIndex.value ==
                                  index,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: AppColors.greyDivider,
                    ),
                  ),
                ),
              ),
            ),
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextField(
                autofocus: true,
                readOnly: widget.readOnly,
                focusNode: focusNode,
                controller: textEditingController,
                style: AppTextStyle.f24GreyTextW600,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Task name',
                  hintStyle: AppTextStyle.f24GreyThroughW400,
                ),
                onChanged: (text) {
                  controller.onChangeName(text, widget.from, fToast);
                },
                onSubmitted: (value) async {
                  if (textEditingController.text.isNotEmpty &&
                      textEditingController.text.contains('*')) {
                    if (listProject.isNotEmpty && newListProject.isNotEmpty) {
                      if (selectedAutocompleteHihlightedIndex.value == 0) {
                        var selectedProject = newListProject.first;

                        if (controller.assigneName.trim().isNotEmpty ||
                            controller.authId.value != 0) {
                          if (!await filterAssignee(
                            projectId: selectedProject.mProjectId.toString(),
                          )) {
                            selectedProject = Project(
                              name: '',
                              countTimebox: 0,
                              mProjectId: 0,
                            );
                          }
                        }

                        controller.onChangeProject(selectedProject);
                      } else {
                        var selectedProject = newListProject[
                            selectedAutocompleteHihlightedIndex.value];

                        if (controller.assigneName.trim().isNotEmpty ||
                            controller.authId.value != 0) {
                          if (!await filterAssignee(
                            projectId: selectedProject.mProjectId.toString(),
                          )) {
                            selectedProject = Project(
                              name: '',
                              countTimebox: 0,
                              mProjectId: 0,
                            );
                          }
                        }

                        controller.onChangeProject(selectedProject);
                      }
                      replaceTextField();
                    } else {
                      focusNode.requestFocus();
                    }
                  } else if (textEditingController.text.isNotEmpty &&
                      textEditingController.text.contains('@')) {
                    if (listSquad.isNotEmpty) {
                      if (selectedAutocompleteHihlightedIndex.value == 0) {
                        controller.onChangeAssigne(
                          newListSquad.first,
                        );
                      } else {
                        controller.onChangeAssigne(
                          newListSquad[
                              selectedAutocompleteHihlightedIndex.value],
                        );
                      }
                      replaceTextField();
                    } else {
                      focusNode.requestFocus();
                    }
                  } else {
                    controller.onSaveDataText(value, widget.from, fToast,
                        widget.onSuccess, widget.onError);
                  }
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                maxLines: null,
              );
            },
          ),
        ),
      ],
    );
  }

  void _scrollToIndex(int index) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    double itemSize = 0.0;

    if (newListSquad.isNotEmpty && listSquad.isNotEmpty) {
      itemSize = 49.4 * index;
    } else if (newListProject.isNotEmpty && listProject.isNotEmpty) {
      itemSize = 44.9 * index;
    }

    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    // Pastikan scrollOffset tidak melampaui maxScrollExtent
    final clampedScrollOffset = itemSize.clamp(0.0, maxScrollExtent);

    // Scroll ke clampedScrollOffset
    _scrollController.jumpTo(clampedScrollOffset);
  }
}

Widget listTileFromAssigneComponent({
  required String assigneName,
  required String assignePhoto,
  required bool isSelected,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap ?? () {},
    child: Container(
      color: kIsWeb
          ? isSelected
              ? AppColors.greyDivider
              : AppColors.white
          : AppColors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: assignePhoto,
            imageBuilder: (context, imageProvider) => Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            placeholder: (context, url) => const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              assigneName,
              style: AppTextStyle.f14BlackTextW500,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget listTileFromProjectComponent({
  required String title,
  required bool isSelected,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap ?? () {},
    child: Container(
      color: kIsWeb
          ? isSelected
              ? AppColors.greyDivider
              : AppColors.white
          : AppColors.white,
      padding: const EdgeInsets.all(12),
      child: Text(
        title,
        style: AppTextStyle.f14BlackTextW400,
      ),
    ),
  );
}
