// Config for parser
class Configs {
  final String csvUrl;
  final String? csvBackup;
  final String? outputDir;
  final String? packageName;
  final bool useEasyLocalizationGen;
  final String? easyLocalizationGenOutputDir;
  final String? easyLocalizationGenOutputFileName;
  final String? easyLocalizationGenOutputCodeGenFileName;

  Configs({
    required this.csvUrl,
    this.csvBackup,
    this.outputDir,
    this.packageName,
    required this.useEasyLocalizationGen,
    this.easyLocalizationGenOutputDir,
    this.easyLocalizationGenOutputFileName,
    this.easyLocalizationGenOutputCodeGenFileName,
  });
}
