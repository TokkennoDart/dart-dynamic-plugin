// Copyright (c) 2017, Minerhub. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:dynamic_plugin/plugin_api.dart';
import 'dart:async';

/// Plugin interface to implements by plugin and used by the main program
class SpecificPlugin extends Plugin {
  Future<String> tellMe();
  Future<int> sum(int n, int y);
}