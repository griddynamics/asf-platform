package helpers

class Jira {
  static JIRA_VERSION = '1.39'
  static Closure jiraIssueUpdater() {
    return { node ->
      node / publishers << "hudson.plugins.jira.JiraIssueUpdater"(plugin:"jira@$JIRA_VERSION")
    }
  }
}
