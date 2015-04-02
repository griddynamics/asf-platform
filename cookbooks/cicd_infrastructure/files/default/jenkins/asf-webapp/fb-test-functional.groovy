//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.FunctionalTestJobTemplate

FunctionalTestJobTemplate.job(this,
                    "${project_name}/fb-test-functional",
                    "<p>This job run functional tests on feature branch code.</p>",
                    "${project_name}",
                    ['buildCommit','buildVersion','buildNumber'],
                    ['HTTP_PORT'],
                    ['petclinic.version': '\${buildVersion}', 'httpPort': '\${HTTP_PORT}', 'maven.test.failure.ignore': 'true'],
                    'functional-test,build-fb',
                    'fb-build',
                    true,
                    false
                    )
