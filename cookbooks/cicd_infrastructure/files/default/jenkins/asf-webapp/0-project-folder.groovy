//NOTE: project_name is parameter of seed job it's available as variable in dsl scope

final hudson.EnvVars env = hudson.model.Executor.currentExecutor().getCurrentExecutable().getEnvironment()

folder {
    name "${project_name}"
    description("<a href='http://${env['GERRIT_HOST']}'> Gerrit</a>, <a href='http://${env['JIRA_HOST']}'> JIRA</a>")
}
