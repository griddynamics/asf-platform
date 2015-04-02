//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.BuildJobTemplate

BuildJobTemplate.job(this,
                    "${project_name}/dev-build-review",
                    "<p>This job builds code and run unit tests. Triggered by Gerrit review action.",
                    "${project_name}",
                    "refs/heads/dev",
                    "*/dev",
                    "plain:dev",
                    {patchsetCreated();draftPublished()},
                    true,
                    false,
                    "spring-petclinic/target/surefire-reports/TEST-*.xml",
                    "",
                    false,
                    false,
                    false,
                    []
                    )
