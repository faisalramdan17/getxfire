part of '../getxfire.dart';

class OpenDialog {
  DialogTransitionType animationType = DialogTransitionType.size;

  Future<void> messageSuccess(String message,
      {String? title, Duration? duration}) async {
    // await GetxFire.hideProgressHud();

    Get.snackbar(
      title ?? "Success",
      message,
      backgroundColor: Colors.green[400],
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      borderRadius: 5,
      icon: const Icon(FontAwesomeIcons.checkCircle, color: Colors.white),
      colorText: Colors.white,
      animationDuration: const Duration(milliseconds: 1200),
      duration: duration,
    );
  }

  Future<void> messageError(String message,
      {String? title, Duration? duration}) async {
    debugPrint("[ERROR] : ${message.toString()}");
    await GetxFire.hideProgressHud();

    Get.snackbar(
      title ?? "Error",
      message,
      backgroundColor: Colors.red[400],
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      borderRadius: 5,
      icon: const Icon(FontAwesomeIcons.exclamationCircle, color: Colors.white),
      colorText: Colors.white,
      animationDuration: const Duration(milliseconds: 1200),
      duration: duration,
    );
  }

  Future<T?> info<T>({
    String? title,
    String? content,
    String? lottiePath,
    EdgeInsets? lottiePadding,
    String? labelButton,
    Function()? onClicked,
    Widget? customWidget,
    bool isBackAfterYes = true,
  }) async {
    return await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: true,
      animationType: animationType,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      builder: (_) => InfoDialog(
        title: title,
        content: content,
        lottiePath: lottiePath,
        lottiePadding: lottiePadding,
        labelButton: labelButton,
        customWidget: customWidget,
        onPressed: () {
          if (isBackAfterYes) Get.back();
          if (onClicked != null) onClicked();
        },
      ),
    );
  }

  Future<T?> confirm<T>({
    String? title,
    String? content,
    String? lottiePath,
    String? labelNoButton,
    Function()? onNoClicked,
    String? labelYesButton,
    required Function()? onYesClicked,
    Widget? customWidget,
    bool isBackAfterYes = true,
  }) async {
    // await GetxFire.progressHud.hide();
    return await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: true,
      animationType: animationType,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      builder: (_) => ConfirmDialog(
        title: title,
        content: content,
        lottiePath: lottiePath,
        labelLeftButton: labelNoButton,
        customWidget: customWidget,
        onLeftPressed: () {
          Get.back();
          if (onNoClicked != null) onNoClicked();
        },
        labelRightButton: labelYesButton,
        onRightPressed: () {
          if (isBackAfterYes) Get.back();
          if (onYesClicked != null) onYesClicked();
        },
      ),
    );
  }

  Future<T?> getImage<T>({
    String? title,
    String? content,
    CropStyle cropStyle = CropStyle.rectangle,
    int maxSize = 1080,
    required Function(File?)? onCameraClicked,
    required Function(File?)? onGalleryClicked,
  }) async {
    return await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: true,
      animationType: animationType,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      builder: (context) {
        final ImagePicker _picker = ImagePicker();
        return ConfirmDialog(
          title: title,
          content: content ?? "Choose the one to use:",
          lottiePath: GetxFire.lottiePath.IMAGE_ICON,
          labelLeftButton: "Camera",
          colorLeftButton:
              Get.isDarkMode ? null : Colors.blue[600]?.withOpacity(0.9),
          onLeftPressed: () async {
            XFile? pickedFile =
                await _picker.pickImage(source: ImageSource.camera);
            File? file = pickedFile == null
                ? null
                : await imageCropper(pickedFile.path,
                    cropStyle: cropStyle, maxSize: maxSize);
            Get.back();
            if (onCameraClicked != null) onCameraClicked(file);
          },
          labelRightButton: "Gallery",
          colorRightButton: Get.isDarkMode ? null : Colors.yellow[700],
          onRightPressed: () async {
            XFile? pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);
            File? file = pickedFile == null
                ? null
                : await imageCropper(pickedFile.path,
                    cropStyle: cropStyle, maxSize: maxSize);
            Get.back();
            if (onGalleryClicked != null) onGalleryClicked(file);
          },
        );
      },
    );
  }

  Future<File?> imageCropper(String imagePath,
      {CropStyle cropStyle = CropStyle.rectangle, int maxSize = 1080}) async {
    return await ImageCropper.cropImage(
      sourcePath: imagePath,
      compressFormat: ImageCompressFormat.png,
      cropStyle: cropStyle,
      maxHeight: maxSize,
      maxWidth: maxSize,
      compressQuality: 100,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          activeControlsWidgetColor: Get.context?.theme.primaryColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: const IOSUiSettings(
        title: 'Cropper',
      ),
    );
  }
}
