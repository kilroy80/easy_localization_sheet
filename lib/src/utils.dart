import 'dart:io';

import 'package:easy_localization_sheet/src/configs.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

/// Get config from pubspec.yaml
Configs getConfig() {
  final currentPath = Directory.current.path;
  final pubspecYamlFile = File(path.join(currentPath, 'pubspec.yaml'));
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
  final easyLocalizationSheetConfigs = pubspecYaml['easy_localization_sheet'];
  String? csvUrl;
  String? csvBackup;
  String? outputDir;
  bool useEasyLocalizationGen = false;
  String? easyLocalizationGenOutputDir;
  String? easyLocalizationOutputFileName;
  String? easyLocalizationGenOutputJsonFileName;
  if (easyLocalizationSheetConfigs != null) {
    csvUrl = easyLocalizationSheetConfigs['csv_url'];
    csvBackup = easyLocalizationSheetConfigs['csv_backup'];
    outputDir = easyLocalizationSheetConfigs['output_dir'];

    final generatorConfig =
        easyLocalizationSheetConfigs['easy_localization_generate'];
    useEasyLocalizationGen = generatorConfig != null;
    easyLocalizationGenOutputDir = generatorConfig?['output_dir'];
    easyLocalizationOutputFileName = generatorConfig?['output_file_name'];
    easyLocalizationGenOutputJsonFileName = generatorConfig?['output_code_gen_file_name'];
  }

  if (csvUrl == null) {
    throw Exception('`csv_url` is required');
  }

  return Configs(
    csvUrl: csvUrl,
    csvBackup: csvBackup,
    outputDir: outputDir,
    packageName: pubspecYaml['name'],
    useEasyLocalizationGen: useEasyLocalizationGen,
    easyLocalizationGenOutputDir: easyLocalizationGenOutputDir,
    easyLocalizationGenOutputFileName: easyLocalizationOutputFileName,
    easyLocalizationGenOutputCodeGenFileName: easyLocalizationGenOutputJsonFileName,
  );
}

/// Get csv file from given url
Future<File> getCSVSheet({
  required String url,
  String? backPath,
  File? destFile,
  String? forPackage,
}) async {
  final request = await HttpClient().getUrl(Uri.parse(url));
  final response = await request.close();
  final file = destFile ??
      File(
        path.join(
          backPath == null
              ? getTempDir(forPackage: forPackage).path
              : getBackupDir(backupPath: backPath).path,
          'data.csv',
        ),
      );
  await response.pipe(file.openWrite());
  return file;
}

/// Get template dir
Directory getTempDir({String? forPackage}) {
  final tempDir = Directory(
    path.join(
      Directory.systemTemp.path,
      'easy_localization_sheet',
      forPackage ?? '',
    ),
  );
  if (!tempDir.existsSync()) {
    tempDir.createSync(recursive: true);
  }
  return tempDir;
}

/// Get backup dir
Directory getBackupDir({String? backupPath}) {
  final backupDir = Directory(
    path.join(
      Directory.current.path,
      backupPath,
    ),
  );
  if (!backupDir.existsSync()) {
    backupDir.createSync(recursive: true);
  }
  return backupDir;
}
