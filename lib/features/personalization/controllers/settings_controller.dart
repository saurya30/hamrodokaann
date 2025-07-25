import 'package:get/get.dart';

import '../../../data/repositories/settings/setting_repository.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/popups/loaders.dart';
import '../models/setting_model.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

// Observable variables
  RxBool loading = false.obs;
  Rx<SettingsModel> settings = SettingsModel().obs;
  final settingRepository = Get.put(SettingsRepository());

  @override
  Future<void> onInit() async {
    // Fetch setting details on controller initialization
    await fetchSettingDetails();
    super.onInit();
  }

  /// Fetches setting details from the repository
  Future<void> fetchSettingDetails() async {
    try {
      loading.value = true;
      final settings = await settingRepository.getSettings();
      this.settings.value = settings;
      loading.value = false;
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.somethingWentWrong.tr, message: e.toString());
    }
  }
}
