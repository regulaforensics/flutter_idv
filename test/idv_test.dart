import 'package:flutter_idv/flutter_idv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'json.dart';
import 'utils.dart';

void main() {
  group("IDV", () {
    compare('initConfig', initConfig, InitConfig.fromJson);
  });
}
