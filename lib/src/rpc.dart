// Copyright (c) 2017, Minerhub. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

class RpcRequest {
  final Symbol Method;

  RpcRequest(this.Method);

  Map<String, String> serialize() {
    return {
      "method": this.Method.toString()
    };
  }
}

class RpcResponse {
  final RpcRequest Call;
  final Object Return;

  RpcResponse(this.Call, this.Return);
}