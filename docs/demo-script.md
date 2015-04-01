Demo Script
===========

To reproduce our end-to-end demo scenario use following steps:

- Show the application itself and describe a change we are going to make and pass through CI pipeline
- Create a JIRA ticket with a story (a story is to change full name format from "lastname firstname" to "firstname, lastname" or vice versa).
- Checkout `dev` branch of `asf-webapp` repository from Gerrit
- Create a new feature branch
- Change code, run unit tests locally. Unit tests fail. Fix them.
- Commit change for review and wait Jenkins `fb-build-review` job passes
- Another engineer does code review and submit change. Engineer waits for Jenkins to complete the validation `fb-build` job and on success approves the change
- Show that code review status is visible in JIRA and notification comes to original developer
- *Dev Build pipeline* starts on Jenkins and fails on `fb-test-functional` job
- Original engineer receives notification via email, goes to Jenkins, goes to test report and finds failed test
- Engineer fixes the test and commits change for review
- Review process described above passes
- *Feature Branch Build pipeline* completes successfully
- Engineer merges feature branch to `dev` and submits to code review
- Code review described above passes
- *Dev Build pipeline* starts and fails on `dev-test-integration` job
- Engineer receives notification via email and demonstrates that pipeline failure is posted to JIRA story by Jenkins
- Engineer investigates the bug through Jenkins and test report
- Engineer fixes the bug and commits for review
- Review process passes
- *Dev Build pipeline* passes successfully

#### [Back to README](../README.md)