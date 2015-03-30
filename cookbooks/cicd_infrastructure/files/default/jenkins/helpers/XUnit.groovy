package helpers

class XUnit {
  static XUNIT_VERSION = '1.89'
  static JBEHAVE_VERSION = '3.7'
  static Closure jbehavePublisher(String filePattern,
                                  String failedUnstableThreshold = '',
                                  String failedUnstableNewThreshold = '',
                                  String failedFailureThreshold = '',
                                  String failedFailureNewThreshold = '',
                                  String skippedUnstableThreshold = '',
                                  String skippedUnstableNewThreshold = '',
                                  String skippedFailureThreshold = '',
                                  String skippedFailureNewThreshold = ''
                                  ) {
    return { node ->
      node / publishers << "xunit"(plugin: "xunit@$XUNIT_VERSION") {
        types {
          "org.jbehave.jenkins.JBehavePluginType"(plugin: "jbehave-jenkins-plugin@$JBEHAVE_VERSION"){
            failIfNotNew(false)
            deleteOutputFiles(true)
            stopProcessingIfError(true)
            pattern(filePattern)
          }
        }
        thresholds {
          "org.jenkinsci.plugins.xunit.threshold.FailedThreshold" {
            unstableThreshold   (failedUnstableThreshold)
            unstableNewThreshold(failedUnstableNewThreshold)
            failureThreshold    (failedFailureThreshold)
            failureNewThreshold (failedFailureNewThreshold)
          }
          "org.jenkinsci.plugins.xunit.threshold.SkippedThreshold"{
            unstableThreshold   (skippedUnstableThreshold)
            unstableNewThreshold(skippedUnstableNewThreshold)
            failureThreshold    (skippedFailureThreshold)
            failureNewThreshold (skippedFailureNewThreshold)
          }
        }
        thresholdMode("1")
        extraConfiguration{
          testTimeMargin("3000")
        }
      }
    }
  }
}
