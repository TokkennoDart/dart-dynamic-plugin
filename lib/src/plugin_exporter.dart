// Copyright (c) 2017, Minerhub. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:isolate';
import 'dart:mirrors';

import 'plugin.dart';

class PluginExporter {
  static Future main(SendPort portOut, Plugin plugin) async {
    ReceivePort portIn = new ReceivePort();
    InstanceMirror pluginMirr = reflect(plugin);

    StreamSubscription subscription = portIn.listen(null);
    subscription.onData((data) {
      if (data is Map<String, String>) {
        portOut.send(pluginMirr.invoke(new Symbol(data["method"]), []));
      }
    });

    portOut.send(portIn.sendPort);
  }
}