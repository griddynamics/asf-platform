//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.BuildJobTemplate

BuildJobTemplate.job(this,
                    "${project_name}/fb-build",
                    "<p>This job builds code published to fb branch and run unit tests, triggered job with functional test.",
                    "${project_name}",
                    "refs/head/dev",
                    "*/fb",
                    "ant:fb-*",
                    {changeMerged()},
                    true,
                    true,
                    "spring-petclinic/target/surefire-reports/TEST-*.xml",
                    "build-fb",
                    true,
                    true,
                    true,
                    ["fb-test-functional"]
                    )
