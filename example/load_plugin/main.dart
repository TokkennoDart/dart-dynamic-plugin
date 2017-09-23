// Copyright (c) 2017, Minerhub. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:dynamic_plugin/plugin.dart';
import 'plugin_definition.dart';

main() async {
  var pm = new PluginManager();

  String current = Directory.current.absolute.path + "/example/load_plugin/plugin.dart";
  print("Loading as plugin: " + current);

  SpecificPlugin sp = await pm.load<SpecificPlugin>(SpecificPlugin, current);

  print(await sp.tellMe());
  print(await sp.sum(4, 6));
}
