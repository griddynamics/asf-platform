#### Previous Step: [Set up and Configure an Amazon Web Services (AWS) Account](step-1.md)

Step 2. Set up a Qubell Account
===============================

## Introduction to Qubell Platform Concepts

Before proceeding, let's review application deployment in Qubell. **_Qubell is designed to simplify the deployment of complex distributed applications for development, testing and production._** Applications are deployed into an environment (e.g. dev, QA or production), where various environments may operate on different clouds, reside in different datacenter, and use different services. Once the environment has been set up, Qubell ensures that applications can be launched into any compatible environment. Compatibility between an application and an environment means that if the application requires a certain service, the environment must have a service available for the application. Qubell validates the compatibility of the application and environment at launch. Services come in three types:
  
- **Cloud Accounts** - Special service types reserved for public cloud accounts (e.g. Amazon EC2 or Rackspace). If your application expects a cloud, it will not be deployed into an environment that doesn't have one.
- **Markers** - Another special service type that indicates whether a service is present in the environment. For example, "Mainframe connection" might be a marker that signals the availability of the mainframe end-point in a particular environment. 
- **Services** - Anything from a pool of VMs to a database with customer records. We will be using a service called "**Secure Vault**". **Secure Vault** is an encrypted store that holds your private information, including Amazon credentials and SSH keys. Applications can safely store, retrieve and use secret data. 

A platform is a central repository of definitions of services available across all environments. The lifecycle of a service starts by being added to the platform, then enabled in environments as needed. Besides different services, environments may have properties and policies. Both properties and policies look like key-value pairs defined for each environment, but they are used for the following different purposes:
  
- **Properties** - Used by Qubell to store the parameters necessary to complete application deployment, configuration and management. For example, `db_connection_string = jdbc://somewhere` is a parameter needed by the application to resolve the location of the database driver in this particular environment. We will use properties to pass the location of files stored on S3 between the web store and the analytic engine.
- **Policies** - These overwrite the values of parameters defined by the application. Different environments may impose different rules on the application. For example, while "test" environment may be configured to offer a choice of Ubuntu or CentOS for an operating system, the "production" environment may allow only RHEL. We are going to define a few policies related to the cloud account. 

Before an application can be launched, there must be at least one environment set up, and that environment must have all services required by the application. Now, let's continue with configuring our application deployment environment.  

## Setup

We are using Qubell as a main infrastructure management tool, so you must have an Qubell account. Sign up for it if you don't have one.

Once you've created your Qubell account, you need to create an environment. To configure your environment for Agile Software Factory, follow the steps below.

1. Open "**Cloud Account**" and press "**...**" next to "**Launch**" button
2. Enter information about your cloud account:  provider, security credentials, region and security group.
3. Open "**Environments**" tab and go to "**default**" or create new environment.
4. Add created cloud account service instance, security vault service instance and workflow service instance
5. Add required environment properties
   - **admin_sonar_username**: < sonar_admin_username > (default: admin)
   - **admin_sonar_password**: < sonar_admin_password > (default: admin)
   - **jenkins_sonar_username**: < jenkins_ci_bot_username > (default: jenkins-ci-bot)
   - **jenkins_sonar_password**: < jenkins_ci_bot_password > (default: jenkin$CiB0t)
   - **jira_username**: < jenkins_ci_bot_username > (default: jenkins-ci-bot)
   - **jira_password**: < jenkins_ci_bot_password > (default: jenkin$CiB0t)
   - **qubell_username**: < your_qubell_username >
   - **qubell_password**: < your_qubell_password >
   - **qubell_app_id**: < qubell_app_id >
   - **qubell_env_id**: < qubell_env_id >
   - **mysql_password**: < password > (default: password123)
   - **amazon_access_id**: < access_id >
   - **amazon_secret_key**: < secret_key > 
   - **amazon_instance_ami**: < ami-id > (default: ami-aacbe6c2)
   - **amazon_instance_cap**: < instance_cap > (default: 30)
   - **amazon_instance_security_groups**: < security_group_list > (default: default)
   - **amazon_instance_type**: < instance_type > (default: M3Large)
   - **amazon_instance_zone**: < instance_zone > (default: us-east-1b)
   - **amazon_region**: < region > (default: us-east-1)

#### Next step: [Obtain the Agile Software Factory](step-3.md)