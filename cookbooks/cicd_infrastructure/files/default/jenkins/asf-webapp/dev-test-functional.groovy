//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.FunctionalTestJobTemplate

FunctionalTestJobTemplate.job(this,
                    "${project_name}/dev-test-functional",
                    "<p>This job builds code published to dev branch and run unit tests, triggered job with functional test.",
                    "${project_name}",
                    ['buildCommit','buildVersion','buildNumber'],
                    ['HTTP_PORT'],
                    ['petclinic.version': '\${buildVersion}', 'httpPort': '\${HTTP_PORT}', 'maven.test.failure.ignore': 'true'],
                    'functional-test,build',
                    "dev-build",
                    true,
                    true
                    )
