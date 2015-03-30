//NOTE: project_name is parameter of seed job it's available as variable in dsl scope
import helpers.BuildJobTemplate

BuildJobTemplate.job(this,
                    "${project_name}/fb-build-review",
                    "<p>This job builds code and run unit tests. Triggered by Gerrit review action. Source code: <code>\${git_url}</code></p>",
                    "${project_name}",
                    "refs/heads/fb-*",
                    "fb-*",
                    "ant:fb-*",
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
