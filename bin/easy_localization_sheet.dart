import 'dart:io';

import 'package:easy_localization_sheet/src/sheet_parser.dart' as sheet_parser;
import 'package:easy_localization_sheet/src/utils.dart' as utils;

void main(List<String> arguments) async {
  final configs = utils.getConfig();
  final outputDir = configs.outputDir ?? 'assets';
  try {
    final sheetFile = await utils.getCSVSheet(
      url: configs.csvUrl,
      backPath: configs.csvBackup,
      forPackage: configs.packageName,
    );
    sheet_parser.parseSheet(
      sheetFile: sheetFile,
      outputRelatedPath: outputDir,
    );
    if (configs.useEasyLocalizationGen) {
      final generatedDir = configs.easyLocalizationGenOutputDir;
      final generatedFileName = configs.easyLocalizationGenOutputFileName;
      stdout.writeln('Run easy_localization:generate');
      await Process.run(
        'dart',
        [
          'run',
          'easy_localization:generate',
          '-S',
          outputDir,
          '-f',
          'keys',
          if (generatedDir != null) ...[
            '-O',
            generatedDir,
          ],
          if (generatedFileName != null) ...[
            '-o',
            generatedFileName,
          ],
        ],
      );
      if (configs.easyLocalizationGenOutputCodeGenFileName != null) {
        stdout.writeln('Run easy_localization:generate, Create Code generation From Json');
        final generatedJsonFileName = configs.easyLocalizationGenOutputCodeGenFileName;
        await Process.run(
          'dart',
          [
            'run',
            'easy_localization:generate',
            '-S',
            outputDir,
            '-f',
            'json',
            if (generatedDir != null) ...[
              '-O',
              generatedDir,
            ],
            if (generatedJsonFileName != null) ...[
              '-o',
              generatedJsonFileName,
            ],
          ],
        );
      }
    }
    stdout.writeln('Generate successful');
  } catch (e) {
    print(e.toString());
    rethrow;
  }
  exit(0);
}
