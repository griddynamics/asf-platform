package helpers

import helpers.Maven
import helpers.Jira
import helpers.Sonar
import helpers.Email
import helpers.Git

class BuildJobTemplate {
    private static final hudson.EnvVars env = hudson.model.Executor.currentExecutor().getCurrentExecutable().getEnvironment()
    private static final String git_url = "ssh://jenkins@\${GERRIT_HOST}:"+env['GERRIT_PORT']+'/'
    private static final String groovy_installation = 'Groovy-'+env['GROOVY_VERSION']
    private static final String maven_installation = 'Maven-default'

    private static final String version_props_generate = """
def binaryVersion(env, version) {
    def buildTime = Date.parse('yyyy-MM-dd_HH-mm-ss', env['BUILD_ID'])
    def timestamp = buildTime.format('yyyyMMdd.HHmmss', TimeZone.getTimeZone('UTC'))
    def buildNo = env['BUILD_NUMBER']
    version.replaceFirst(/-SNAPSHOT\$/, \"-\${timestamp}-\${buildNo}\")
}

def env = System.getenv()
def p = new Properties()

def pom = new XmlParser().parse('pom.xml')

p['projectGroupId'] = 'com.griddynamics.asf.webapp-demo'
p['projectArtifactId'] = 'spring-petclinic'
p['projectVersion'] = pom.version.text() ?: '1.0.0-SNAPSHOT'

p['buildGroupId'] = p['projectGroupId']
p['buildArtifactId'] = p['projectArtifactId']
p['buildVersion'] = binaryVersion(env, p['projectVersion'])
p['buildJob'] = env['JOB_NAME']
p['buildNumber'] = env['BUILD_NUMBER']
p['buildBranch'] = env['GIT_BRANCH'].replaceFirst('^[^/]+/', '')
p['buildCommit'] = env['GIT_COMMIT']

p.store(new FileWriter('version.properties'), env['BUILD_TAG'])
            """

    private static final set_version = "build.displayName = build.getEnvironment(null)[\"buildVersion\"] ?: \"#\${build.number}\""

    static job(dsl, jobName, jobDescription, projectName, 
                gerritRefspec, gerritBranch, gerritEventRegexp, Closure gerritTriggerEvents, 
                skipSonar, isSetVersion, testResultPattern, mavenProfiles = '', 
                isPublishToJira, isPublishToSonar, isPublishToEmail, triggeredJobs) {
        dsl.freeStyleJob(jobName) {
                  description(jobDescription)
                  jdk('jdk-'+env['JDK_VERSION']) 
                  // parameters
                  parameters {
                    booleanParam("SKIP_SONAR",skipSonar,"Skip sonar analysis")
                    stringParam("GERRIT_BRANCH", gerritBranch, "Gerrit branch")
                    stringParam("GERRIT_REFSPEC", gerritRefspec, "Gerrit refspec")
                  }
                  // scm
                  scm {
                    git {
                      remote {
                        name('origin')
                        url(git_url + projectName)
                        refspec("\${GERRIT_REFSPEC}")
                        credentials(env['GIT_CREDS']) 
                      }
                      branch("\${GERRIT_BRANCH}")
                      configure Git.gerritTriggerChoosingStrategy("#")
                    }
                  }
                  triggers {
                    gerrit {
                      events gerritTriggerEvents
                      project(projectName, gerritEventRegexp)
                    }
                  }
                  logRotator(30, 50, -1, -1)
                  concurrentBuild(true)
                  steps {
                    if (isSetVersion) {
                        groovyCommand(version_props_generate, groovy_installation)
                        environmentVariables {
                            propertiesFile("version.properties")
                        }
                        systemGroovyCommand(set_version)
                        maven {
                          goals("versions:set")
                          properties "newVersion": "\${buildVersion}"
                          mavenInstallation(maven_installation)
                          localRepository(LocalToWorkspace)
                          configure Maven.mavenGlobalSettings(env['SETTINGS_ID'])
                        }
                    }
                    maven {
                      goals("-e")
                      goals("clean")
                      if (mavenProfiles) {
                        goals("deploy")
                        goals("-P " + mavenProfiles)
                      }
                      else {
                        goals("install")
                      }
                      properties "maven.test.failure.ignore": "true"
                      mavenInstallation(maven_installation)
                      localRepository(LocalToWorkspace)
                      configure Maven.mavenGlobalSettings(env['SETTINGS_ID'])
                    }
                    maven {
                      goals("pmd:pmd")
                      goals("pmd:cpd")
                      goals("checkstyle:checkstyle")
                      goals("findbugs:findbugs")
                      if (mavenProfiles) {
                        goals("-P " + mavenProfiles)
                      }
                      properties "maven.test.failure.ignore": "true"
                      mavenInstallation(maven_installation)
                      localRepository(LocalToWorkspace)
                      configure Maven.mavenGlobalSettings(env['SETTINGS_ID'])
                    }
                  }
                  publishers{
                    archiveXUnit {
                      jUnit {
                        pattern testResultPattern
                      }
                      failedThresholds {
                        unstable     0
                        unstableNew  99999
                        failure      99999
                        failureNew   99999
                      }
                      skippedThresholds {
                        unstable     0
                        unstableNew  99999
                        failure      99999
                        failureNew   99999
                      }
                    }
                    pmd("**/pmd.xml") {
                        shouldDetectModules true
                    }
                    checkstyle("**/checkstyle-result.xml") {
                        shouldDetectModules true
                    }
                    findbugs("**/findbugsXml.xml", true)
                    dry("**/cpd.xml")
                    if (isSetVersion) {
                        archiveArtifacts "version.properties"
                    }
                    if (triggeredJobs) {
                        downstreamParameterized {
                          triggeredJobs.each() {
                              trigger(it) {
                                if (isSetVersion) {
                                    propertiesFile("version.properties")
                                }
                              }
                          }
                        }
                    }
              }

              if (isPublishToJira) {
                  configure Jira.jiraIssueUpdater()
              }
              if (isPublishToSonar) {
                  configure Sonar.sonarPublisher(maven_installation, env['SETTINGS_ID']) 
              }
              if (isPublishToEmail) {
                  publishers{
                    extendedEmail("\${DEFAULT_RECIPIENTS}") {
                      configure Email.extendedEmailConfig("\${DEFAULT_REPLYTO}","\${DEFAULT_PRESEND_SCRIPT}")
                      trigger(
                        triggerName: "Failure",
                        sendToDevelopers: true,
                        sendToRecipientList: false
                        )
                      trigger(
                        triggerName: "Unstable",
                        sendToDevelopers: true,
                        sendToRecipientList: false
                        )
                    }
                  }
            }
        }
    }
}
