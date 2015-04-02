Step 1. Set up and Configure an Amazon Web Services (AWS) Account
=================================================================

Since you will be deploying the sample web store and analytics on Amazon Cloud, you must have an AWS account. The instructions below will walk you through configuring your AWS account's security group to allow traffic to your applications.

First, sign up for an Amazon EC2 account (one that supports EC2 nodes and S3). If you don't have an AWS account, you can create one by navigating here.

Once you've created your AWS account, you need to configure your security group. To configure your security group for Agile Software Factory, follow the steps below.

1. Open your Amazon EC2 console at https://console.aws.amazon.com/ec2
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

If you need additional help, please refer to the [Amazon portal](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html#adding-security-group-rule).

#### Next step: [Set up a Qubell Account](step-2.md)