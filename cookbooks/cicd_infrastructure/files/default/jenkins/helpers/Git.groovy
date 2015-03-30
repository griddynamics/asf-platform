package helpers

class Git {
  static GERRIT_PLUGIN_VERSION = '2.12.0'
  static Closure gerritTriggerChoosingStrategy(String sep) {
    return { node ->
      node / extensions {
        'hudson.plugins.git.extensions.impl.BuildChooserSetting' {
          buildChooser(
            class: 'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTriggerBuildChooser',
            plugin:"gerrit-trigger@$GERRIT_PLUGIN_VERSION") {
              separator(sep)
          }
        }
      }
    }
  }
}
