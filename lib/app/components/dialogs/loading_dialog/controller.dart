import 'package:get/get.dart';

class LoadingDialogController extends GetxController with StateMixin {
  late Function() _task;

  void init(Function() task) {
    _task = task;
    _runTask();
  }

  Future<void> _runTask() async {
    try {
      await _task();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
