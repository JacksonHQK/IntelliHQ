# Basic tasks with Amazon Web Services (AWS)
##  1. AWS Management Console
### 1.1 Amazon EMR [Management Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html) - Summary
This section is a summary of Amazon tutorial to create a cluster where Zeppelin notebooks run. An Overview of Amazon EMR could be found in this [link](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-overview.html).

**Important note:** The clusters which you create will be charge for using AWS resources. Therefore, remember to terminate the clusters when you finish. 
####    Step 1: [Set up prerequisites](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-prerequisites.html)
- Sign Up for AWS
- Create an Amazon S3 Bucket
- Create an Amazon EC2 Key Pair
####    Step 2: [Launch Your Sample Cluster](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-launch-sample-cluster.html)
- Using Quick Cluster Configuration Overview
- Lauch the Sample Cluster
####    Step 3: [Prepare your sample data and script](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-prepare-data-and-script.html)
####    Step 4: [Process your sample data](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-launch-sample-cluster.html)
####    Step 5: [Reset your environment](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-reset-environment.html)
### 1.2 Amazon EC2

##  2. AWS Command Line Interface (AWS CLI)
This section is a summary of AWS Command Line Interface - [User Guide](https://docs.aws.amazon.com/cli/latest/userguide/aws-cli.pdf).
### 2.1 Installing AWS CLI
- Install Python
- Install pip
- Install AWS CLI
### 2.2 Configuring the AWS CLI
- Obtain AWS Access Key ID and Secret Key Access
  From **AWS Management Console** window --> **Services** --> **IAM** (under **Security, Identity & Compliance** group) --> **Users** (from the left column) --> Choose your Username --> Choose **Security credentials** tab --> Click on **Create access key** under **Access keys** section. Save the **Access key ID** and **Secret Key Access**.
- Import AWS profile by typing **aws configure --profile <profile name>** from Windows Commnand Line.
```
$ aws configure --profile <default>
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: ap-southeast-2
Default output format [None]: ENTER
 ```
  
##  3. Creating bash shell scripts to create a cluster
Another way to create a cluster is using bash shell scripts which is basically a defined configurations of a cluster. This section will show how to write a .sh file along with its parameter files to create a cluster.

#### Set up prerequisites
In order to create a cluster from bash shell scripts, you may need [Git Bash/GUI](https://gitforwindows.org/) to run .sh files. 
#### Create "ec2-attributes.json" file
  "ec2-attributes.json" contains  _Network_ as well as _Security and access_ parameters including:
- Keyname: Name of the keypair
- InstanceProfile
- SubnetID
- EMRManagedSlaveSecurityGroup
- EMRManagedMasterSecurityGroup
```
{
  "KeyName": "intellihq_zeppelin_keypair", 
  "InstanceProfile": "EMR_EC2_DefaultRole",
  "SubnetId": "subnet-14e57f73",
  
 
  "EmrManagedSlaveSecurityGroup": "sg-0eef0776",
  "EmrManagedMasterSecurityGroup": "sg-65e20a1d"
}
```
#### Create "instance-group.json" file
"instance-group.json" contains  _hardware_ parameters including:
- InstanceCount
- InstanceGroupType
- InstanceType
- Name

```
[
  {
    "InstanceCount": 1,
    "InstanceGroupType": "MASTER",
    "InstanceType": "m4.large",
    "Name": "Master Instance Group"
  },
  {
    "InstanceCount": 2,
    "InstanceGroupType": "CORE",
    "InstanceType": "m4.large",
    "Name": "Core Instance Group"
  }
]
```
#### Create "configurations.json" file
- The "spark" classification
```
  {
    "Classification": "spark",
    "Properties": {
      "maximizeResourceAllocation": "true"
    },
    "Configurations": []
  },
```
- The "spark-hive-site" classification allows [using the AWS Glue Data Catalog as the Metastore](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark-glue.html). By doing that the metastore can be shared by different clusters, services, and applications. 
```
  {
    "Classification": "spark-hive-site",
    "Properties": {
      "hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"
    },
    "Configurations": []
  },
```
- The "zeppelin-env" classification defines S3 bucket which stores Zeppelin notebook and data files.
```
  {
    "Classification": "zeppelin-env",
    "Properties": {
    },
    "Configurations": [
      {
        "Classification": "export",
        "Properties": {
            "ZEPPELIN_WEBSOCKET_MAX_TEXT_MESSAGE_SIZE": "3072000",
            "ZEPPELIN_NOTEBOOK_S3_BUCKET": "jackie-bucket-zeppelin",
            "ZEPPELIN_NOTEBOOK_S3_USER": "zeppelin",
            "ZEPPELIN_NOTEBOOK_STORAGE": "org.apache.zeppelin.notebook.repo.S3NotebookRepo"
        },
        "Configurations": []
      }
    ]
  }
```
#### Create "deployment.sh" file

##  4. Relevant topics
- [Tutorial: Creating a Cluster with a EC2 Task Using the AWS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_AWSCLI_EC2.html) 
- [S3 backed notebooks for Zeppelin running on Amazon EMR](https://medium.com/@addnab/s3-backed-notebooks-for-zeppelin-running-on-amazon-emr-7a743d546846)
- [Get AWS EMR Cluster ID from Name](https://stackoverflow.com/questions/48529819/get-aws-emr-cluster-id-from-name)
# Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
