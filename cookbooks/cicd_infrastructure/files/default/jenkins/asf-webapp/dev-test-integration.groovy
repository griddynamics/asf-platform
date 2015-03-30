//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.FunctionalTestJobTemplate

FunctionalTestJobTemplate.job(this,
                    "${project_name}/dev-test-integration",
                    "<p>This job run integration tests on dev branch code.</p>",
                    "${project_name}",
                    ['buildCommit','buildNumber','PETCLINIC_URL'],
                    [],
                    ['spring.profiles.active': 'remote', 'REMOTE_WEBDRIVER_URL': '\${SELENIUM_URL}', 'browser.version': '', 'selenium.version': '2.44.0', 'petclinic.url': '\${PETCLINIC_URL}', 'maven.test.failure.ignore': 'true'],
                    'integration-test',
                    "dev-build",
                    true,
                    true
                    )
