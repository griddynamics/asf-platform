package helpers

class Groovy {
  static GROOVY_PLUGIN_VERSION = '1.22'
  static Closure systemGroovy(String script) {
    return { node ->
      node / builders << "hudson.plugins.groovy.SystemGroovy"(plugin: "groovy@$GROOVY_PLUGIN_VERSION") {
        scriptSource(class : "hudson.plugins.groovy.StringScriptSource") {
          command(script)
        }
      }
    }
  }

  static Closure groovyScript(String script, String groovyInstallationName) {
    return { node ->
      node / builders << "hudson.plugins.groovy.Groovy"(plugin: "groovy@$GROOVY_PLUGIN_VERSION") {
		    scriptSource(class : "hudson.plugins.groovy.StringScriptSource") {
			    command(script)
        }
        groovyName(groovyInstallationName)
      }
    }
  }
}
