package helpers

class Email {
  static FAILURE_TRIGGER   = 'hudson.plugins.emailext.plugins.trigger.FailureTrigger'
  static UNSTABLE_TRIGGER  = 'hudson.plugins.emailext.plugins.trigger.UnstableTrigger'
  static DEVELOPERS        = 'hudson.plugins.emailext.plugins.recipients.DevelopersRecipientProvider'
  static REQUESTER         = 'hudson.plugins.emailext.plugins.recipients.RequesterRecipientProvider'
  static UPSTREAM_COMITTER = 'hudson.plugins.emailext.plugins.recipients.UpstreamComitterRecipientProvider'
  static EMAILEXT_VERSION  = '2.39'

  static Closure extendedEmailConfig(String replyToAddress, String presendScriptContent) {
    return { node ->
      node / replyTo << replyToAddress
      node / presendScript << presendScriptContent
    }
  }

  static Closure extendedEmail(String recipientAddresses, String replyToAddress, String presendScriptContent, HashMap triggers) {
    return { node ->
      node / publishers << "hudson.plugins.emailext.ExtendedEmailPublisher"(plugin: "email-ext@$EMAILEXT_VERSION") {
        recipientList(recipientAddresses)
        contentType('default')
        defaultSubject('$DEFAULT_SUBJECT')
        defaultContent('$DEFAULT_CONTENT')
        attachmentsPattern()
        presendScript(presendScriptContent)
        attachBuildLog('false')
        compressBuildLog('false')
        replyTo(replyToAddress)
        saveOutput('false')
        disabled('false')
        configuredTriggers {
          triggers.each{ triggerType, recipients ->
            "${triggerType}"{
              email{
                recipientList('')
                subject('$PROJECT_DEFAULT_SUBJECT')
                body('$PROJECT_DEFAULT_CONTENT')
                attachmentsPattern('')
                attachBuildLog('false')
                compressBuildLog('false')
                replyTo('$PROJECT_DEFAULT_REPLYTO')
                contentType('project')
                recipientProviders {
                  recipients.each{ "${it}"() }
                }
              }
            }
          }
        }
      }
    }
  }
}
