package helpers

class EnvInject {
  static ENVINJECT_VERSION = '1.90'
  static Closure envInject(String propertiesFile) {
    return { node ->
      node / builders << "EnvInjectBuilder"(
      plugin: "envinject@$ENVINJECT_VERSION") {
        info() {
          propertiesFilePath(propertiesFile)
        }
      }
    }
  }
}
