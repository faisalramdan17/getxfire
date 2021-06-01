part of '../getxfire.dart';

class OpenDialog {
  static const DialogTransitionType animationType = DialogTransitionType.size;

  static Future<void> messageSuccess(String message,
      {String? title, Duration? duration}) async {
    await ProgressHud.hide();

    Get.snackbar(
      title ?? "Success",
      message,
      backgroundColor: Colors.green[400],
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      borderRadius: 5,
      icon: Icon(FontAwesomeIcons.checkCircle, color: Colors.white),
      colorText: Colors.white,
      animationDuration: Duration(milliseconds: 1200),
      duration: duration,
    );
  }

  static Future<void> messageError(String message,
      {String? title, Duration? duration}) async {
    await ProgressHud.hide();
    print("[ERROR] : ${message.toString()}");

    Get.snackbar(
      title ?? "Error",
      message,
      backgroundColor: Colors.red[400],
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      borderRadius: 5,
      icon: Icon(FontAwesomeIcons.exclamationCircle, color: Colors.white),
      colorText: Colors.white,
      animationDuration: Duration(milliseconds: 1200),
      duration: duration,
    );
  }

  static Future<T?> confirm<T>({
    String? title,
    String? content,
    String? lottieFilename,
    String? labelNoButton,
    Function()? onNoClicked,
    String? labelYesButton,
    required Function()? onYesClicked,
    Widget? customWidget,
    bool isBackAfterYes = true,
  }) async {
    await ProgressHud.hide();
    return await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: true,
      animationType: animationType,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
      builder: (_) => ConfirmDialog(
        title: title,
        content: content,
        lottiePath: lottieFilename,
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

  static Future<T?> getImage<T>({
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
      duration: Duration(milliseconds: 500),
      builder: (context) {
        final ImagePicker _picker = ImagePicker();
        return ConfirmDialog(
          title: title,
          content: content ?? "Choose the one to use:",
          lottiePath: "image-icon",
          labelLeftButton: "Camera",
          colorLeftButton:
              Get.isDarkMode ? null : Colors.blue[600]?.withOpacity(0.9),
          onLeftPressed: () async {
            PickedFile? pickedFile =
                await _picker.getImage(source: ImageSource.camera);
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
            PickedFile? pickedFile =
                await _picker.getImage(source: ImageSource.gallery);
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

  static Future<File?> imageCropper(String imagePath,
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
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
    );
  }
}