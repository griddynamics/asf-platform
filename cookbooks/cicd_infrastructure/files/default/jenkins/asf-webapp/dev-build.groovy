//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.BuildJobTemplate

BuildJobTemplate.job(this,
                    "${project_name}/dev-build",
                    "<p>This job builds code published to dev branch and run unit tests, triggered job with functional test.",
                    "${project_name}",
                    "dev",
                    "*/dev",
                    "plain:dev",
                    {changeMerged()},
                    true,
                    true,
                    "spring-petclinic/target/surefire-reports/TEST-*.xml",
                    "build",
                    true,
                    true,
                    true,
                    ["dev-orchestrator"]
                    )
