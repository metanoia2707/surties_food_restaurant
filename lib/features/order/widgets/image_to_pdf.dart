import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';

Future<void> capturedImageToPdf({Uint8List? capturedImage, required String businessName, required String orderId}) async {
  if (capturedImage == null) return;

  final pdf = pw.Document();

  final image = pw.MemoryImage(capturedImage);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image),
        );
      },
    ),
  );

  final output = await getProjectDirectory(businessName);
  final file = File("${output.path}/${'invoice'.tr}-$orderId.pdf");

  await Permission.storage.request();

  if (await Permission.storage.isGranted) {
    await file.writeAsBytes(await pdf.save());
    showCustomSnackBar('${'pdf_saved_at'.tr} ${file.path.replaceAll('/storage/emulated/0/', '')}', isError: false);
  } else {
    showCustomSnackBar('permission_denied_cannot_download_the_file'.tr);
  }
}

Future<Directory> getProjectDirectory(String projectName) async {
  Directory? downloadsDirectory;
  if (Platform.isAndroid) {
    downloadsDirectory = Directory('/storage/emulated/0/Download/$projectName');
  } else if (Platform.isIOS) {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    downloadsDirectory = Directory('${documentsDirectory.path}/$projectName');
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  if (!await downloadsDirectory.exists()) {
    await downloadsDirectory.create(recursive: true);
  }

  return downloadsDirectory;
}
