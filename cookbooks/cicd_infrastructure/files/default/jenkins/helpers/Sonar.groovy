package helpers

class Sonar {
  static CONFIG_FILE_PROVIDER = '2.7.5'
  static Closure sonarPublisher(String mavenInstallation, String settingsId) {
    return { node ->
      node / publishers << "hudson.plugins.sonar.SonarPublisher"(plugin:"sonar@"){
        jobAdditionalProperties('-Dsonar.profile="Sonar way"')
        mavenInstallationName(mavenInstallation)
        usePrivateRepository('true')
      	globalSettings(
      		class:'org.jenkinsci.plugins.configfiles.maven.job.MvnGlobalSettingsProvider',
      		plugin:"config-file-provider@$CONFIG_FILE_PROVIDER") {
      		settingsConfigId(settingsId)
      	}
      }
    }
  }
}
