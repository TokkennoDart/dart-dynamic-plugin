# dynamic_plugin

Plugin framework.

Work in progress, highly experimental, with many bugs, don't use it!!!

## How it works

dynamic_plugin use reflection and isolation to run plugins that can be loaded dynamically and used as any other class instance.

## Usage

A simple usage example:

- Define a plugin interface extending the "Plugin" interface. All methods should return a Future.

```dart
import 'dart:async';
import 'package:dynamic_plugin/plugin_api.dart';

class SpecificPlugin extends Plugin {
  Future<String> tellMe();
  Future<int> sum(int n, int y);
}
```
- Implement your plugin inheriting the interface defined in the previous step
- Expose a class instance of your plugin with ```PluginExporter.main()```:

```dart
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
```
- Load the plugin with PluginManager in your program and use it!!!

```dart
import 'dart:async';
import 'package:dynamic_plugin/plugin.dart';
import 'plugin_definition.dart';

main() async {
  var pm = new PluginManager();

  SpecificPlugin sp = await pm.load<SpecificPlugin>(SpecificPlugin, "./plugin.dart");

  print(await sp.tellMe());
  print(await sp.sum(4, 6));
}

```