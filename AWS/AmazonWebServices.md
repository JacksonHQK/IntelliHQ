# Basic tasks with Amazon Web Services (AWS)
This document summarises some useful topics which are necessary to get Zeppelin notebooks to run on Elastic Map Reduce (EMR) cluster. The first section of the document shows how to use the web console interface. The second section provides how to create a cluster using AWS Command Line Interface. Finally, the third section gives an example of writing bash shell scripts to create a cluster.
##  1. AWS Management Console
### 1.1 Amazon EMR [Management Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html) - Summary
This section is a summary of Amazon tutorial to create an EMR cluster to run Zeppelin notebooks. An Overview of Amazon EMR could be found in this [link](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-overview.html).

**Important note:** The clusters which you create will be charged for using AWS resources. Therefore, remember to terminate the clusters when you finish. 

####    Step 1: [Set up prerequisites](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-prerequisites.html)
- [ ] Sign Up for AWS
- [ ] Create an [Amazon S3 Bucket](https://docs.aws.amazon.com/AmazonS3/latest/user-guide/create-bucket.html)
- [ ] Create an [Amazon EC2 Key Pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).
####    Step 2: [Launch Your Sample Cluster](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-launch-sample-cluster.html)
Using Quick Cluster Configuration Overview: to quickly create a cluster, open the [Amazon EMR console](https://console.aws.amazon.com/elasticmapreduce/), then click on **Create Cluster** to open **Create Cluster - Quick Options** page.
  - General Configuration
    - Cluster name
      - Logging: Enable/Disable Amazon EMR writes detailed log data.
      - S3 folder: Specify an S3 bucket to store the log.
    - Launch mode
      - Cluster: Amazon EMR will launch a cluster with applications from "Software Configuration".
      - Step execution: Steps which specify the included applications will be added. The cluster will be automatically terminated after all of the steps complete.
      
  - Software Configuration
    - Release: Specify the software and Amazon EMR platform components to install on the cluster. Normally, the latest release is chosen.
    - Applications: Specify the applications to install on the cluster.
    - Use AWS Glue Data Catalog for table metadata: Use the AWS Glue Data Catalog to provide an external Hive metastore for Hive. More information about AWS GLue Data Catalog could be found in this [link](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark-glue.html).
    
  - Hardware Configuration
    - Instance type: Select the Amazon EC2 instance type that runs in your cluster. Each type of instances is a combination of CPU, memory, storage and networking capacity. More information about Amazon EC2 Instance Types could be found in this [link](https://aws.amazon.com/ec2/instance-types/).
    - Number of instances: Select number if instances. Each instance corresponds to a note in the EMR cluster. Amazon will charge base on type and number of used instances. More information about Amazon EC2 Pricing could be found in this [link](https://aws.amazon.com/ec2/pricing/).

  - Security and access
    - EC2 key pair: Use an existing EC2 key pair to SSH into the master node of EMR cluster.
    - Permissions: Determine the permissions for the EMR cluster.    
  - Choose **Create cluster**

####    Step 3: [Prepare your sample data and script](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-prepare-data-and-script.html)
- Sample Data Overview
- Sample Hive Script Overview
####    Step 4: [Process your sample data](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-launch-sample-cluster.html)
Depending on the applications which are used, one or more steps will be added in the Amazon EMR console.
- Submit the Hive Script as a Step: In the Amazon EMR console, choose your cluster. Click on **Steps** tabs --> **Add step**
  - Step type
  - Name
  - JAR location
  - Arguments
  - Action on failure
- View the Results: To check the result, click on **Configuration** tab then choose **View JSON**.
####    Step 5: Connect to the master node of the cluster
##### - Using SSH
In the Command Line window, type: shh hadoop@< Master public DNS > -i < path to the private key file >. **Note**: the private key file must be in **.pem** format.
	
```
ssh hadoop@ec2-54-206-???-??.ap-southeast-2.compute.amazonaws.com -i ***\_CreatingCluster\intellihq_zeppelin_keypair.pem
```
##### - Using Putty: 
From the Putty window
  - Category list --> Session --> type hadoop@< Master public DNS >
  - Category list --> Connection --> SSH --> Auth --> click Browse and select the private key file. Please note that the private key file must be in **.ppk** format.
  - Click **Open**.
####    Step 6: Open Zeppelin application
In Aamzon EMR console, choose your cluster --> Summary tab --> Connections --> Zeppelin
####    Step 7: [Reset your environment](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-reset-environment.html)
##### - Deleting Your Amazon S3 Bucket
From Amazon S3 console, choose the bucket you want to delete. Then type the name of the bucket to confirm deletion.
##### - Terminating Your Cluster
In Aamzon EMR console, choose the cluster you want to terminate. In the top section of the page, click on **Terminate**. **Note**: You cannot restart terminated clusters but clone them.
### 1.2 Amazon EC2

##  2. AWS Command Line Interface (AWS CLI)
This section is a summary of AWS Command Line Interface - [User Guide](https://docs.aws.amazon.com/cli/latest/userguide/aws-cli.pdf).
### 2.1 Installing AWS CLI
- [ ] Install Python
- [ ] Install pip
- [ ] Install AWS CLI
### 2.2 Configuring the AWS CLI
- Obtain AWS Access Key ID and Secret Key Access
  From **AWS Management Console** window --> **Services** --> **IAM** (under **Security, Identity & Compliance** group) --> **Users** (from the left column) --> Choose your Username --> Choose **Security credentials** tab --> Click on **Create access key** under **Access keys** section. Save the **Access Key ID** and **Secret Key Access**.
- Import AWS profile by typing **aws configure --profile < profile name >** from Windows Command Line.
```
$ aws configure --profile <default>
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: ap-southeast-2
Default output format [None]: ENTER
 ```
  
##  3. Creating bash shell scripts to create a cluster
Another way to create a cluster is using bash shell scripts which is basically a defined configuration of a cluster. This section will show how to write a .sh file along with its parameter files to create a cluster.

#### - Set up prerequisites
In order to create a cluster from bash shell scripts, you need to
- [ ] Install Python
- [ ] Install pip
- [ ] Install AWS CLI
- [ ] Install [Git Bash/GUI](https://gitforwindows.org/) to run .sh files. 
#### - Create "ec2-attributes.json" file
  "ec2-attributes.json" contains  _Network_ as well as _Security and access_ parameters including:
-- Keyname: Name of the keypair
-- InstanceProfile
-- SubnetID
-- EMRManagedSlaveSecurityGroup
-- EMRManagedMasterSecurityGroup
```
{
  "KeyName": "intellihq_zeppelin_keypair", 
  "InstanceProfile": "EMR_EC2_DefaultRole",
  "SubnetId": "subnet-14e57f73",
  
 
  "EmrManagedSlaveSecurityGroup": "sg-0eef0776",
  "EmrManagedMasterSecurityGroup": "sg-65e20a1d"
}
```
#### - Create "instance-group.json" file
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
#### - Create "configurations.json" file
"configurations.json" file contains all information of steps which were added into the cluster.
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
- The "zeppelin-env" classification defines S3 bucket, which stores Zeppelin notebook and data files, and the S3 user. **Note**: S3 user is specified as a sub-folder insider S3 bucket.
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
#### - Create "deployment.sh" file
"deployment.sh" file is a master file which links all parameter files such as "configurations.json", "instance-group.json".
```
#!/bin/bash

set -e
set -u
set -x

# requires the profile to be added as parameters to this i.e. --profile myprofile

# deploy the cluster
aws emr create-cluster \
	--name 'My cluster' \
	--instance-groups file://./instance-groups.json \
	--release-label emr-5.13.0\
	--ec2-attributes file://./ec2-attributes.json \
	--service-role EMR_DefaultRole \
    	--applications Name=Spark Name=Zeppelin Name=Hadoop Name=Hive\
	--configurations file://./configurations.json \
    	--region ap-southeast-2 \
	--no-auto-terminate \
#	--scale-down-behavior TERMINATE_AT_TASK_COMPLETION \
    $@

```

##  4. Relevant topics
- [1]. [Creating a Spark Cluster on AWS EMR: a Tutorial](http://queirozf.com/entries/creating-a-spark-cluster-on-aws-emr-a-tutorial)
- [2]. [Add an Apache Zeppelin UI to your Spark cluster on AWS EMR](http://queirozf.com/entries/add-an-apache-zeppelin-ui-to-your-spark-cluster-on-aws-emr) 
- [3]. [Creates an cluster with the specified configurations](https://docs.aws.amazon.com/cli/latest/reference/emr/create-cluster.html)
- [4]. [Tutorial: Creating a Cluster with a EC2 Task Using the AWS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_AWSCLI_EC2.html)
- [5]. [S3 backed notebooks for Zeppelin running on Amazon EMR](https://medium.com/@addnab/s3-backed-notebooks-for-zeppelin-running-on-amazon-emr-7a743d546846)
- [6]. [Get AWS EMR Cluster ID from Name](https://stackoverflow.com/questions/48529819/get-aws-emr-cluster-id-from-name)

# Acknowledgments
* [AWS Documentation](https://aws.amazon.com/documentation/)
* Sample codes supplied by **Tech-connect**
