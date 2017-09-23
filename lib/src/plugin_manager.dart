// Copyright (c) 2017, Minerhub. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:isolate';
import 'dart:mirrors';

import 'plugin.dart';

class PluginManager {
  // Singleton lazy load
  static final PluginManager _singleton = new PluginManager._internal();

  factory PluginManager() {
    return _singleton;
  }

  PluginManager._internal();

  // Implementation

  Future<E> load<E>(Type type, String path) async {
    if (isPlugin(E)) {
      ClassMirror c = reflectClass(type);
      InstanceMirror im = c.newInstance(const Symbol('load'), []);
      PluginEncapsulation<E> plugin = new PluginEncapsulation<E>(im.reflectee, path);

      Completer<E> completer = new Completer<E>();

      Isolate
          .spawnUri(new Uri.file(path), new List<String>(), plugin.PortIn.sendPort)
          .then((isolateInstance) {

        plugin.Isolation = isolateInstance;

        // Waiting for the connection
        plugin.PortIn.listen((message) {
          if (message is SendPort) {
            plugin.PortOut = message as SendPort;
            completer.complete(plugin.PluginInstance);
          }
          else plugin.handle(message);
        });
      });

      return completer.future;
    }
    else {
      throw new Exception(
          "PluginManager only can load classes than inherit Plugin.");
    }
  }

  static bool isPlugin(Type t) {
    TypeMirror im = reflectType(t);
    TypeMirror pm = reflectType(Plugin);
    return im.isSubtypeOf(pm);
  }

  static bool isPluginInstance(Object o) {
    InstanceMirror im = reflect(o);
    return isPlugin(im.runtimeType);
  }
}