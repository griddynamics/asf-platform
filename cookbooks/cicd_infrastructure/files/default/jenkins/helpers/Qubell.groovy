package helpers

class Qubell {
  static QUBELL_VERSION = '2.5'
  static Closure startInstance(String qubellEnvId,
                               String qubellAppId,
                               String qubellAppParams,
                               String startTimeout = '1200',
                               String outputFile = 'qubell_output.json',
                               String manifestPath = '') {
    return { node ->
      node / builders << "com.qubell.jenkinsci.plugins.qubell.builders.StartInstanceBuilder"(
        plugin: "qubell@$QUBELL_VERSION") {
        expectedStatus('RUNNING')
        timeout(startTimeout)
        outputFilePath(outputFile)
        manifestRelativePath(manifestPath)
        environmentId(qubellEnvId)
        applicationId(qubellAppId)
        extraParameters(qubellAppParams)
      }
    }
  }

  static Closure destroyInstance(String destroyTimeout = '600', String qubellAppParams = '{}') {
    return { node ->
      node / builders << "com.qubell.jenkinsci.plugins.qubell.builders.DestroyInstanceBuilder"(
        plugin: "qubell@$QUBELL_VERSION") {
    	    expectedStatus('DESTROYED')
          timeout(destroyTimeout)
          commandName('destroy')
          extraParameters(qubellAppParams)
        }
     }
  }
}
