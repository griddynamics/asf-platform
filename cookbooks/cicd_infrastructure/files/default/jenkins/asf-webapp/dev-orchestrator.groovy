//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.ParameterizedTrigger

freeStyleJob("${project_name}/dev-orchestrator") {
  description("<p>This job trigger jobs dev-test-functional and dev-docker-build, after it trigger dev-deploy job.Triggered by dev-build job.</p>")
  parameters {
    stringParam("buildCommit")
    stringParam("buildVersion")
    stringParam("buildNumber")
  }
  logRotator(30, 50, -1, -1)
  concurrentBuild(true)
  steps {
    configure ParameterizedTrigger.parameterizedTrigger('dev-test-functional,dev-docker-build',
                                            'ALWAYS',
                                            'buildCommit=\${buildCommit}\nbuildNumber=\${buildNumber}\nbuildVersion=\${buildVersion}')
  }
  publishers{
    downstreamParameterized {
      trigger('dev-deploy') {
        currentBuild()
      }
    }
  }
}
