import 'package:flutter/material.dart';
import 'package:overlay_webview/overlay_webview.dart';
import 'fullpage.dart';

void main() => runApp(
      MaterialApp(
        home: MyApp(),
        navigatorObservers: [],
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final webView = WebViewController(id: "main");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              RaisedButton(
                child: Text("Active WebViews"),
                onPressed: () async {
                  print(await WebViewController.activeWebViews());
                },
              ),
              RaisedButton(
                child: Text("Dispose All"),
                onPressed: () async {
                  await WebViewController.disposeAll();
                },
              ),
              RaisedButton(
                child: Text("Init"),
                onPressed: () {
                  webView.init();
                },
              ),
              RaisedButton(
                child: Text("Google"),
                onPressed: () {
                  webView.load("https://google.com");
                },
              ),
              RaisedButton(
                child: Text("DO"),
                onPressed: () {
                  webView.load("http://speedtest-blr1.digitalocean.com");
                },
              ),
              RaisedButton(
                child: Text("Downloads"),
                onPressed: () {
                  webView.loadHTML("""
                  <a href="javascript:download()">
                    Click to download
                  </a>

                  <script>
                  var saveData = (function () {
                    var a = document.createElement("a");
                    document.body.appendChild(a);
                    a.style = "display: none";
                    return function (data, fileName) {
                        var json = JSON.stringify(data),
                            blob = new Blob([json], {type: "octet/stream"}),
                            url = window.URL.createObjectURL(blob);
                        a.href = url;
                        a.download = fileName;
                        a.click();
                        window.URL.revokeObjectURL(url);
                    };
                }());

                var data = { x: 42, s: "hello, world", d: new Date() },
                    fileName = "my-download.json";

                  function download() {
                    saveData(data, fileName);
                  }
                  </script>
                  """);
                },
              ),
              RaisedButton(
                child: Text("onMessage"),
                onPressed: () {
                  webView.loadHTML("""
                    hello
                    <script>
                    if(window.WebViewBridge) {
                      window.WebViewBridge.postMessage("hello");
                      document.body.innerHTML = "android bridge";
                    }
                    
                    if(window.webkit.messageHandlers.WebViewBridge) {
                      window.webkit.messageHandlers.WebViewBridge.postMessage("hello");
                      document.body.innerHTML = "ios bridge";
                    }
                    </script>
                  """);
                },
              ),
              RaisedButton(
                child: Text("Post Message"),
                onPressed: () async {
                  await webView.loadHTML("""
                    hello
                    <script>
                      window.addEventListener("message", receiveMessage, false);

                      function receiveMessage(event) {
                        document.body.innerHTML = event.data;

                        window.WebViewBridge.postMessage("hello from webview");
                      }
                    </script>
                  """);
                  await webView.postMessage("hello from flutter");
                },
              ),
              RaisedButton(
                child: Text("Show"),
                onPressed: () {
                  webView.show();
                },
              ),
              RaisedButton(
                child: Text("Hide"),
                onPressed: () {
                  webView.hide();
                },
              ),
              RaisedButton(
                child: Text("Exec"),
                onPressed: () async {
                  print(await webView.exec("JSON.parse(JSON.stringify(window.location))"));
                },
              ),
              RaisedButton(
                child: Text("Deny Google"),
                onPressed: () {
                  webView.setDenyList({
                    "block_google": ".*?google.com.*",
                  });
                },
              ),
              RaisedButton(
                child: Text("Fullpage"),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => FullPage()));
                },
              ),
              RaisedButton(
                child: Text("Window creation"),
                onPressed: () async {
                  await webView.loadHTML("""
                    <a href="https://google.com" target="_blank">Google in new window</a>
                  """);
                },
              ),
              RaisedButton(
                child: Text("Back"),
                onPressed: () async {
                  final canBack = await webView.canGoBack();
                  if (canBack) {
                    webView.back();
                  }
                },
              ),
              RaisedButton(
                child: Text("Forward"),
                onPressed: () async {
                  webView.forward();
                },
              ),
            ],
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.red),
              ),
              child: WebView(
                url: "http://www.baidu.com",
                controller: webView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
