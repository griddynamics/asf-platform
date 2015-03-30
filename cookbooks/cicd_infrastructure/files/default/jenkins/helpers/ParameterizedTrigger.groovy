package helpers

class ParameterizedTrigger {
  static PARAMETERIZED_TRIGGER_VERSION = '2.25'
  static Closure parameterizedTrigger(String triggeringProjects,
                                      String triggeringCondition,
                                      String triggeringProperties,
                                      String triggeringPropertiesFile = ''
                                      ) {
    return { node ->
      node / builders << "hudson.plugins.parameterizedtrigger.TriggerBuilder"(plugin:"parameterized-trigger@$PARAMETERIZED_TRIGGER_VERSION") {
          configs{
            "hudson.plugins.parameterizedtrigger.BlockableBuildTriggerConfig" {
              projects(triggeringProjects)
              condition(triggeringCondition)
              triggerWithNoParameters(false)
              buildAllNodesWithLabel(false)
            configs {
              if (triggeringProperties){
                "hudson.plugins.parameterizedtrigger.PredefinedBuildParameters" {
                  properties(triggeringProperties)
                }
              }
              if (triggeringPropertiesFile){
                "hudson.plugins.parameterizedtrigger.FileBuildParameters" {
                  propertiesFile(triggeringPropertiesFile)
                  failTriggerOnMissing(true)
                  useMatrixChild(false)
                  onlyExactRuns(false)
                }
              }
            }
            block{
              buildStepFailureThreshold {
                name("UNSTABLE")
                ordinal(1)
                color("YELLOW")
              }
              failureThreshold {
                name("FAILURE")
                ordinal(2)
                color("RED")
              }
              unstableThreshold {
                name("UNSTABLE")
                ordinal(1)
                color("YELLOW")
              }
            }
          }
        }
      }
    }
  }
}
