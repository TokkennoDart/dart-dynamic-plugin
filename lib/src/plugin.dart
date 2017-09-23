// Copyright (c) 2017, Minerhub. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'dart:isolate';
import 'rpc.dart';
import 'plugin_manager.dart';

class Plugin {
  String get Name;

  @protected
  PluginEncapsulation _capsule;

  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isMethod) {
      RpcRequest req = new RpcRequest(invocation.memberName);
      _capsule.call(req);
    }
    else throw new Exception("No such method");
  }
}

class PluginEncapsulation<E> {
  final String Path;
  final Type PluginType;
  final Object PluginInstance;

  ReceivePort PortIn;
  SendPort PortOut;
  Isolate Isolation;

  PluginEncapsulation(this.PluginInstance, this.Path) : this.PluginType = E {
    if (!PluginManager.isPlugin(E)) {
      throw new Exception("PluginEncapsulation only can encapsulate classes than inherit Plugin.");
    }
    else {
      (this.PluginInstance as Plugin)._capsule = this;

      this.PortIn = new ReceivePort();
    }
  }

  void handle(message) {

    if (message is SendPort) {
      this.PortOut = message as SendPort;
    }
    else {

      print(message);
    }
  }

  RpcResponse call(RpcRequest req) {
    this.PortOut.send(req.serialize());
  }
}