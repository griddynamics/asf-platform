//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.CopyArtifact
import helpers.EnvInject
import helpers.Groovy
import helpers.Qubell
import helpers.ParameterizedTrigger

final hudson.EnvVars env = hudson.model.Executor.currentExecutor().getCurrentExecutable().getEnvironment()

jdk_installation = 'jdk-'+env['JDK_VERSION']
groovy_installation = 'Groovy-'+env['GROOVY_VERSION']

set_version = "build.displayName = build.getEnvironment(null)[\"buildVersion\"] ?: \"#\${build.number}\""

qubell_app_params = '''{
  "instanceName":           "asf-webapp-demo-${buildVersion}",
  "destroyInterval":        7200000,
  "input.docker_registry":  "${DOCKER_REGISTRY}",
  "input.image_name":       "asf-webapp",
  "input.image_version":    "${buildVersion}",
  "input.docker_vm_ip":     "${SHIPYARD}"
}'''

freeStyleJob("${project_name}/dev-deploy") {
  description("<p>This job requested Qubell deployment ${project_name}, triggered job with an integration tests, destroyed application in Qubell.</p>")
  jdk(jdk_installation)
  logRotator(30, 50, -1, -1)
  steps {
    configure CopyArtifact.copyArtifact('dev-build','version.properties')
    configure EnvInject.envInject('version.properties') 
    configure Groovy.systemGroovy(set_version)  
    configure Qubell.startInstance("${qubell_env_id}","${qubell_app_id}", qubell_app_params)
    configure Groovy.groovyScript("""
import groovy.json.JsonSlurper;
import hudson.model.*;

def env_vars = System.getenv()
def workspace_path = env_vars.WORKSPACE

def qubellOutputFile = new File("\${workspace_path}/qubell_output.json")
def userJson = new JsonSlurper().parseText(qubellOutputFile.text)
def webapp_endpoint = userJson.returnValues.'output.webapp_endpoint'

def f= new File("petclinic_url.properties")
f.withWriter{ it << "PETCLINIC_URL=\${webapp_endpoint}"}
""",
              groovy_installation)// It's hack because for some reasone DSL does not add qubell plugin into job

    configure ParameterizedTrigger.parameterizedTrigger('dev-test-integration',
                                            'ALWAYS',
                                            'buildCommit=\${buildCommit}\nbuildNumber=\${buildNumber}',
                                            'petclinic_url.properties')

    configure Qubell.destroyInstance() 
  }
}

