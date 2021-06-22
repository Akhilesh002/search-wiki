import 'package:flutter/material.dart';
import 'package:vahak_assesment/utils/Constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  const WebViewScreen({Key key, @required this.url}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String url = '';
  final _webViewKey = UniqueKey();
  bool _isLoading = true;
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    url = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(url),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 30,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  WebView(
                    key: _webViewKey,
                    initialUrl: Constant.WIKI_PAGE_URL + url,
                    onWebViewCreated: (controller) {
                      _controller = controller;
                    },
                    onPageFinished: (url) {
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                  Visibility(
                    visible: _isLoading,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
