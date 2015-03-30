Set up and Configure an Amazon Web Services (AWS) Account
=========================================================

1. Open your Amazon EC2 console at https://console.aws.amazon.com/ec2/.
2. In the navigation pane, click **Security Groups**.
3. Select the security group named "**default**".
4. Click on "**Inbound**" tab to add new rules (note that there should already be three existing/default rules).
5. To add the new rules, select "**Custom TCP Rule**" from the "**Create a new rule**" drop-down list. In the "**Port Range**" field, enter the port and click the "**+ Add Rule**" button.
   * Selenium: 5555, 4444
   * Sonar: 9000, 9092
   * Nexus: 8081
   * Gerrit: 80, 8000, 29418
   * JIRA: 443
   * Jenkins: 8080
   * Qubell: 22
   * LDAP: 389
   * Docker: 5000
