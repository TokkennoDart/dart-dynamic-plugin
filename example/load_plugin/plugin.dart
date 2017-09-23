// Copyright (c) 2017, Minerhub. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:isolate';
import 'dart:async';
import 'plugin_definition.dart';
import 'package:dynamic_plugin/plugin_api.dart';

class SpecificPluginImp implements SpecificPlugin {
  String get Name => "Example";

  Future<String> tellMe() async { return "Hello world"; }
  Future<int> sum(int x, int y) async { return x+y; }
}

main(List<String> args, SendPort port) {
  PluginExporter.main(port, new SpecificPluginImp());
}