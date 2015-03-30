Step 4. Launch and post-deployment
==================================

Go to qubell and launch Agile Software Factory. Use Advanced Lunch and set root size around 30Gib.

Add new user into LDAP
----------------------

1. Go to phpldapadmin page
2. Login with credential:
 * login DN: cn=admin,dc=example,dc=com
 * password: password
3. Create account:
 * Choose ou=people group in the tree on the left side.
 * Click "Create new entry here"
4. On the right side choose ASF: create user template for new entry.

5. Add user atester

```
 dn:uid=atester,ou=people,dc=asf,dc=griddynamics,dc=com
 cn: atester
 displayname: Alice Tester
 givenname: Alice
 mail: alisa-qa@griddynamics.com
 objectclass: inetOrgPerson
 objectclass: top
 sn: Tester
 uid: atester
 userpassword: atester
```
6. Press button "Create object".
7. Validate data and press "Commit" button.

8. Add user bcoder

```
dn: uid=bcoder,ou=people,dc=asf,dc=griddynamics,dc=com
cn: bcoder
displayname: Bob Coder
givenname: Bob
mail: bob-dev@griddynamics.com
objectclass: inetOrgPerson
objectclass: top
sn: Coder
uid: bcoder
userpassword: bcoder
```
9. Press button "Create object".
10. Validate data and press "Commit" button.

11. Add the account to groups:
 * Select 'ou=groups', 'cn=developers' on the left side.
 * In member section on the right side, click 'modify group members' and add the account from the right pane to the left one.
 * Press 'Save changes' button.
 * Validate the change and press 'Update Object' button.
12. To make the account fully functional and usable:
 * Login to Jira using the new account credentials.
 * Login to Gerrit using the new account credentials.

JIRA Configuration
------------------

1. Go to JIRA and accept ssl certificates
2. Use JIRA title: ASF JIRA
3. Setup JIRA admin account. Use
 * Full name: Admin
 * Email address: your email
 * Username: admin
 * Password: admin
4. Skip next steps by pressing 'No' button and then setup mail notifications.
 * Configure email notifications: now
 * Name: Default SMTP Server
 * From address: jira-updates@yourdomain
 * Email Prefix: [JIRA]
 * Server Type: SMTP Host
 * Service Provider: Custom
 * Host Name: localhost
 * Protocol: SMTP
5. Jira Agile installation
 * Login into JIRA as administrator
 * In right corner choose configuration menu -> Add-ons
 * Type "greenhopper" in "Search in Marketplace" and install JIRA Agile Plugin
 * Enter your Atlassian ID and password for evaluation license.
6. Gerrit integration
 * Login into JIRA as administrator
 * In right corner choose configuration menu -> Add-ons
 * Type Gerrit in "Search in Marketplace" and install JIRA Gerrit Plugin(MeetMe, Inc.)
 * Choose "Manage add-ons"
 * Click configure button for JIRA Gerrit plugin
 * Put ssh host, port, username and private key which was added into Gerrit
 * Configure Issues Search as message:%s
 * Save configuration
7. Project setup
 * Create new JIRA project
 * Use project type: Agile Kanban
 * Set Project Name: ASF
8. Create new issue
 * Issue type: Task
 * Summary: Test issue

Jenkins jobs Configuration
--------------------------

Run asf-demo-jobs-generator in order to generate jobs

Gerrit configuration
--------------------

1. Go to gerrit
 * Add your ssh key. You can use user noc with password: nocpassword
 * Create project asf-webapp
 * Push source code from [github](https://github.com/griddynamics/asf-webapp-demo) to dev brunch of asf-webapp gerrit repository
 * switch HEAD reference from "master" to "dev"
 * enable fast-forward push only