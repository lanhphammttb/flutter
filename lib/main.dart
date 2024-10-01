import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nttcs/gen/assets.gen.dart';
import 'package:nttcs/start.dart';

Future<void> main() async {
  await dotenv.load(fileName: Assets.env.aEnvStaging);

  startApp();
}