import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalLoadingProvider =
    StateNotifierProvider<LoadingController, bool>((ref) => LoadingController());

class LoadingController extends StateNotifier<bool> {
  LoadingController() : super(false);

  void show() => state = true;
  void hide() => state = false;

  Future<T> during<T>(Future<T> Function() action) async {
    show();
    try {
      return await action();
    } finally {
      hide();
    }
  }
}
