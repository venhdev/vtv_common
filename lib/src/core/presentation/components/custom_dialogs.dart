import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<T?> showDialogWithTextField<T>({
  required BuildContext context,
  required String title,
  String? hintText,
  String submitButtonText = 'Gửi',
  String cancelButtonText = 'Hủy',
  TextStyle? titleTextStyle,
  TextStyle? contentTextStyle,
}) async {
  final TextEditingController textController = TextEditingController();
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        titleTextStyle: titleTextStyle,
        contentTextStyle: contentTextStyle,
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: hintText),
        ),
        actions: [
          TextButton(
            child: Text(cancelButtonText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(submitButtonText),
            onPressed: () {
              Navigator.of(context).pop(textController.text);
            },
          ),
        ],
      );
    },
  );
}

Future<T?> showDialogToConfirm<T>({
  required BuildContext context,
  String? title,
  String? content,
  VoidCallback? onConfirm,
  String confirmText = 'Có',
  String dismissText = 'Không',
  TextStyle? titleTextStyle,
  TextStyle? contentTextStyle,
  Color? dismissBackgroundColor,
  Color? confirmBackgroundColor,
  Color titleColor = Colors.black87,
  Color contentColor = Colors.black87,
  Color? dismissTextColor,
  Color? confirmTextColor,
  bool barrierDismissible = true,
  bool hideDismiss = false,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        titleTextStyle: titleTextStyle,
        contentTextStyle: contentTextStyle,
        title: title != null
            ? Text(
                title,
                textAlign: TextAlign.center, // Căn giữa tiêu đề
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              )
            : null,
        content: content != null
            ? Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 16.0,
                ),
              )
            : null,
        actions: [
          // ButtonBar(
          OverflowBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              hideDismiss
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        backgroundColor: dismissBackgroundColor,
                      ),
                      child: Text(dismissText, style: TextStyle(color: dismissTextColor, fontWeight: FontWeight.bold)),
                    ),
              TextButton(
                onPressed: () async {
                  onConfirm?.call();
                  Navigator.of(context).pop(true);
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  backgroundColor: confirmBackgroundColor,
                ),
                child: Text(confirmText, style: TextStyle(color: confirmTextColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future showDialogToAlert(
  BuildContext context, {
  List<Widget>? children,
  bool scrollable = false,
  Widget? title,
  TextStyle? titleTextStyle,
  bool barrierDismissible = true,
  String confirmText = 'Đóng',
}) async {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible, // user must tap button if set to false
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: title,
        titleTextStyle: titleTextStyle ??
            const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
        content: children != null
            ? ListBody(
                children: children,
              )
            : null,
        actions: <Widget>[
          TextButton(
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

/// Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
/// WidgetsFlutterBinding.ensureInitialized();
void showCrossPlatformAboutDialog({
  required BuildContext context,
  String? logo,
  List<Widget>? children,
}) async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    if (!context.mounted) return;
    showAboutDialog(
      context: context,
      applicationName: packageInfo.appName,
      applicationVersion: '${packageInfo.version}\n${packageInfo.packageName}',
      applicationIcon: (logo != null)
          ? Image.asset(
              logo,
              width: 50,
              height: 50,
            )
          : const FlutterLogo(),
      applicationLegalese: '© ${DateTime.now().year} VTV',
      children: children,
      // children: [
      //   // Text(packageInfo.packageName),
      //   if (children != null) ...children,
      // ],
      // bool barrierDismissible = true,
      // Color? barrierColor,
      // String? barrierLabel,
      // bool useRootNavigator = true,
      // RouteSettings? routeSettings,
      // Offset? anchorPoint,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

/// - [closeBy] this use for close dialog when dataCallback is done,
/// the data will be passed to this function base on navigation using in the app:
///   - when use `GoRouter`, it will be `(context, result) => context.pop(result)`
///   - when use `Navigator`, it will be `(context, result) => Navigator.of(context).pop(result)`
Future<T?> showDialogToPerform<T>(
  BuildContext context, {
  required Future<T> Function() dataCallback,
  required void Function(BuildContext context, dynamic result) closeBy,
  String message = 'Đang tải',
}) async {
  final GlobalKey alertDialogKey = GlobalKey();
  return showDialog<T>(
    context: context,
    barrierDismissible: true, // Prevent user interaction with the screen << back button
    builder: (BuildContext context) {
      return LoadingAlertDialog<T>(
        key: alertDialogKey,
        message: message,
        dataCallback: dataCallback,
        closeBy: closeBy,
      );
    },
  );
}

class LoadingAlertDialog<T> extends StatefulWidget {
  const LoadingAlertDialog({
    super.key,
    required this.message,
    required this.dataCallback,
    required this.closeBy,
  });

  final String message;
  final Future<T> Function() dataCallback;
  final void Function(BuildContext context, T result) closeBy;

  @override
  State<LoadingAlertDialog> createState() => _LoadingAlertDialogState<T>();
}

class _LoadingAlertDialogState<T> extends State<LoadingAlertDialog> {
  void invokeCallback() async {
    widget.dataCallback().then((result) {
      if (mounted) {
        widget.closeBy(context, result);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => invokeCallback());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16.0),
            Text(widget.message),
          ],
        ),
      ),
    );
  }
}
