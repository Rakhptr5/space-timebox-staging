import 'package:get/get.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/modules/features/backlog/bindings/backlog_binding.dart';
import 'package:timebox/modules/features/backlog/views/ui/backlog_view.dart';
import 'package:timebox/modules/features/home/bindings/home_bindding.dart';
import 'package:timebox/modules/features/home/views/ui/home_view.dart';
import 'package:timebox/modules/features/instruction/bindings/instruction_binding.dart';
import 'package:timebox/modules/features/instruction/views/ui/instruction_view.dart';
import 'package:timebox/modules/features/login/bindings/login_bindings.dart';
import 'package:timebox/modules/features/login/views/ui/login_view.dart';
import 'package:timebox/modules/features/my_squad/bindings/my_squad_binding.dart';
import 'package:timebox/modules/features/my_squad/views/ui/my_squad_view.dart';
import 'package:timebox/modules/features/profile/bindings/profile_binding.dart';
import 'package:timebox/modules/features/profile/views/ui/profile_view.dart';
import 'package:timebox/modules/features/project/binddings/project_binding.dart';
import 'package:timebox/modules/features/project/views/ui/project_view.dart';
import 'package:timebox/modules/features/splash/bindings/splash_binding.dart';
import 'package:timebox/modules/features/splash/views/ui/splash_view.dart';
import 'package:timebox/modules/features/today/bindings/today_binding.dart';
import 'package:timebox/modules/features/today/views/ui/today_view.dart';
import 'package:timebox/modules/features/upcoming/bindings/upcoming_binding.dart';
import 'package:timebox/modules/features/upcoming/views/ui/upcoming_view.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splashRoute,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.homeRoute,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.loginRoute,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.profileRoute,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.todayRoute,
      page: () => TodayView(),
      binding: TodayBinding(),
    ),
    GetPage(
      name: AppRoutes.backlogRoute,
      page: () => BacklogView(),
      binding: BacklogBinding(),
    ),
    GetPage(
      name: AppRoutes.projectRoute,
      page: () => ProjectView(),
      binding: ProjectBinding(),
    ),
    GetPage(
      name: AppRoutes.upcomingRoute,
      page: () => UpcomingView(),
      binding: UpcomingBinding(),
    ),
    GetPage(
      name: AppRoutes.mySquadRoute,
      page: () => MySquadView(),
      binding: MySquadBinding(),
    ),
    GetPage(
      name: AppRoutes.instruction,
      page: () => InstructionView(),
      binding: InstructionBinding(),
    ),
  ];
}
