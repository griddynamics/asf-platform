package helpers

import helpers.Maven
import helpers.Jira
import helpers.Sonar
import helpers.Email
import helpers.Git

class FunctionalTestJobTemplate {
    private static final hudson.EnvVars env = hudson.model.Executor.currentExecutor().getCurrentExecutable().getEnvironment()
    private static final String git_url = "ssh://jenkins@\${GERRIT_HOST}:"+env['GERRIT_PORT']+'/'
    private static final String maven_installation = 'Maven-default'

    private static final set_version = "build.displayName = build.getEnvironment(null)[\"buildVersion\"] ?: \"#\${build.number}\""

    static job(dsl, jobName, jobDescription, projectName, jobParameters, allocatePortList = [],
               mavenProperties, mavenProfiles = '',
               copyArtefactPath, isArchiveArtifacts, isPublishToJira) {
        dsl.freeStyleJob(jobName) {
          description(jobDescription)
          jdk("jdk-"+env['JDK_VERSION']) 
          logRotator(30,50,-1,-1)
          if (jobParameters){
            parameters {
              jobParameters.each { param ->
                stringParam(param)
              }
            }
          }
          if (allocatePortList){
            wrappers{
              allocatePortList.each { port ->
                allocatePorts "${port}"
              }
            }
          }
          scm {
            git {
              remote {
                name('origin')
                url(git_url + projectName)
                credentials(env['GIT_CREDS']) 
              }
              branch('\${buildCommit}')
            }
          }
          steps {
            copyArtifacts(copyArtefactPath, 'version.properties') {
                buildNumber('\${buildNumber}')
            }
            systemGroovyCommand(set_version)
            maven {
              rootPOM("spring-petclinic-test/pom.xml")
              goals('clean')
              goals('verify')
              if (mavenProfiles) {
                goals("-P " + mavenProfiles)
              }
              mavenOpts('-XX:MaxPermSize=256m')
              if (mavenProperties){
                mavenProperties.each { key, value ->
                  properties "${key}": "${value}"
                }
              }
              mavenInstallation(maven_installation)
              localRepository(LocalToWorkspace)
              configure Maven.mavenGlobalSettings(env['SETTINGS_ID'])
            }
          }
          publishers {
            if (isArchiveArtifacts) {
                archiveArtifacts 'version.properties'
            }
            publishHtml{
              report('spring-petclinic-test/target/jbehave'){
                reportName('HTML Report')
                reportFiles('view/index.html')
                keepAll()
              }
            }
          }
          if (isPublishToJira) {
              configure Jira.jiraIssueUpdater()
          }
          configure XUnit.jbehavePublisher('spring-petclinic-test/target/jbehave/*.xml','0') 
          configure Email.extendedEmail('$DEFAULT_RECIPIENTS','$DEFAULT_REPLYTO','$DEFAULT_PRESEND_SCRIPT',
            [
              (Email.FAILURE_TRIGGER) : [ Email.DEVELOPERS, Email.REQUESTER, Email.UPSTREAM_COMITTER ],
              (Email.UNSTABLE_TRIGGER): [ Email.DEVELOPERS, Email.REQUESTER, Email.UPSTREAM_COMITTER ]
            ]
          ) 
        }
    }
}
