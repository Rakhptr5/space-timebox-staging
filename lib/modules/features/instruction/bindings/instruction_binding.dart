import 'package:get/get.dart';
import 'package:timebox/modules/features/instruction/controllers/instruction_controller.dart';

class InstructionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InstructionController());
  }
}
