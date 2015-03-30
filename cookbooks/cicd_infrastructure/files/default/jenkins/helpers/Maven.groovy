package helpers

class Maven {
  static CONFIG_FILE_PROVIDER = '2.7.5'
  static Closure mavenGlobalSettings(String settingsId) {
    return { node ->
      node << globalSettings(
        class:'org.jenkinsci.plugins.configfiles.maven.job.MvnGlobalSettingsProvider',
        plugin:"config-file-provider@$CONFIG_FILE_PROVIDER") {
          settingsConfigId(settingsId)
        }
    }
  }
}
