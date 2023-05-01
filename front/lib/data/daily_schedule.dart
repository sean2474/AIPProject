// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class DailySchedule {
  String date;
  Widget imageWidget;

  DailySchedule({
    required this.date, 
    required this.imageWidget
  });

  static List<DailySchedule> transformData(List<Map<String, dynamic>> data) {
    return data.map((json) => DailySchedule.fromJson(json)).toList();
  }
  
  factory DailySchedule.fromJson(Map<String, dynamic> json) {
    String centeredHtml = '''
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body {
          display: flex;
          justify-content: center;
          align-items: center;
          margin: 0;
        }
      </style>
    </head>
    <body>
      ${json['image_html']}
      <script>
        // Send content height to Flutter
        function sendHeightToFlutter() {
          var height = Math.max(
            document.body.scrollHeight,
            document.body.offsetHeight,
            document.documentElement.clientHeight,
            document.documentElement.scrollHeight,
            document.documentElement.offsetHeight
          );
          Toaster.postMessage(height);
        }
        sendHeightToFlutter();
      </script>
    </body>
    </html>
    ''';
    double height = 1000;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            debugPrint('''\nPage resource error:\n\tcode: ${error.errorCode}\n\tdescription: ${error.description}\n\terrorType: ${error.errorType}\n\tisForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onUrlChange: (UrlChange change) async {
            await launchUrl(Uri.parse(change.url.toString()));
            controller.loadHtmlString(centeredHtml);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint(message.message);
          height = double.parse(message.message);
        },
      );

      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
        (controller.platform as AndroidWebViewController)
          .enableZoom(true);
      }

      controller.loadHtmlString(centeredHtml);

      return DailySchedule(
        date: json['date'],
        imageWidget: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ),
      );
    }
  }