//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.Maven

final hudson.EnvVars env = hudson.model.Executor.currentExecutor().getCurrentExecutable().getEnvironment()

jdk_installation= 'jdk-'+env['Jdk_version']
maven_installation = 'Maven-default'
git_url = "ssh://jenkins@\${GERRIT_HOST}:"+env['GERRIT_PORT']+"/${project_name}"

set_version = "build.displayName = build.getEnvironment(null)[\"buildVersion\"] ?: \"#\${build.number}\""

job() {
  name "${project_name}/dev-docker-build"
  description("<p>This job builds docker image and push it to registry. Triggered by dev-build job. Source code: <code>${git_url}</code></p>")
  jdk(jdk_installation)
  parameters {
    stringParam("buildCommit")
    stringParam("buildVersion")
    stringParam("buildNumber")
  }
  scm {
    git {
      remote {
        name('origin')
        url(git_url)
        credentials(env['GIT_CREDS'])
      }
      branch('\${buildCommit}')
    }
  }
  logRotator(30, 50, -1, -1)
  concurrentBuild(true)
  steps {
    copyArtifacts('dev-build', targetPath = 'version.properties') {
        buildNumber('\${buildNumber}')
    }
    systemGroovyCommand(set_version)
    maven {
      rootPOM("asf-webapp-docker/pom.xml")
      goals('-e clean package -P build')
      mavenInstallation(maven_installation)
      localRepository(LocalToWorkspace)
      configure Maven.mavenGlobalSettings(env['Settings_id'])
    }
    shell("sudo docker build -t \${DOCKER_REGISTRY}/${project_name}:\${buildVersion} asf-webapp-docker/")
    shell("sudo docker push \${DOCKER_REGISTRY}/${project_name}:\${buildVersion} ")
  }
}
