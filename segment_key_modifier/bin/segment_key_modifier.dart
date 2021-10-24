import 'dart:developer';

import 'package:args/args.dart';
import 'package:segment_key_modifier/segment_key_modifier.dart';

const String targetEnv = 'targetEnvironment';
const String prod = "prod";
const String test = "test";
final ArgParser argParser = ArgParser()
  ..addMultiOption(
    targetEnv,
    abbr: 't',
    allowed: [prod, test],
    help: 'specify the flavor [prod/test]',
  );

void main(List<String> args) {
  try {
    final parsedArguments = argParser.parse(args);
    final flavor = parsedArguments[targetEnv];
    if (flavor.contains(test)) {
      SegmentKeyModifier(test).modifyKeys();
    } else if (flavor.contains(prod)) {
      SegmentKeyModifier(prod).modifyKeys();
    }
  } catch (e) {
    log(e.toString());
  }
}
