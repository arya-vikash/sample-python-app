# Folder structure 
### App
- Contains all the application related files i.e. application python code, unit tests, requirements.txt. 
- Dockerfile is present to build container image for this application. 
- Jenkinsfile is configured to orchestrate the Jenkins app build pipeline with necessary stages.
### Infra
- Contains terraform code to setup networking and EKS cluster, Iam roles, cloudwatch logging setup.
- Kubernetes/:  this folder contains all the manifest yml files for creating  python application, database and monitoring sidecar for python application.
- **NOTE**: Fluentd image used for sidecar container in application deployment yml file needs to be built manually one time. Dockerfile to build the image is provided in Documentation_and_bootstrap/Dockerfile_fluentd.
Tag the image with 160071257600.dkr.ecr.eu-west-2.amazonaws.com/sample-fluentd and push to ECR.
- ECR repositories are created as part of Bootstrap with help of bootstrap_infra.sh script file.
### Documentation_and_Bootstrap
- Contains bootstrap script to setup required infra before deploying rest infrastructure using terraform.
- Contains jenkins, fluentd custom docker files.
- Documentation of the project.


# Project Setup and running

### Setup Jenkins infra for CICD
```
PS: Below jenkins dockerfile is custom built and not from jenkins public registry. As it's built to run on Mac arm64 arch (my local system) some package installation will need updating  if running on linux/amd64.
```

1. NEED: docker installed on the system
2. Setup Jenkins on the local system. 
3. Use Dockerfile_jenkins provided in Documentation_and_bootstrap directory to run Jenkins in a docker container. Use the below commands for setup.
    - docker volume create jenkins
    - docker run -p 8080:8080 -p 50000:50000 -v jenkins:/var/jenkins_home jenkins/jenkins
    - Above commands create jenkins volume and attach it to jenkins container during docker run to persist data
4. Copy jenkins password displayed in logs and open http://127.0.0.1:8080/
5. Pass the copied password and proceed with default plugin installation, skip next steps.

### Bootstrap Infra
- Move to Documentation_and_bootstrap. Execute bootstrap_infra.sh file. It will create S3 bucket and DynamoDB table to manage terraform state remotely.

***Important: Before Proceeding Add AWS credentials in jenkins credentials for App, infra pipelines to work. See add AWS credentials step below***

### Add AWS credentials
- Copy and store AWS access key, access_id, session token  in aws_creds file in below format
```
[default]
aws_access_key_id=ASIASKRH5RYAF4KE2PHX
aws_secret_access_key=QTm//hA38E9EsofdOxPBMjKcIvYvK+xREP26kFr6
aws_session_token=IQoJb3JpZ2luX2VjEF4aDGV1LWNlbnRyYWwtMSJGMEQCIBzG
```
- Got to manage jenkins > credentials > global domain > add credentials
- Select kind as Secret file. Upload file aws_creds. Give id as aws_creds and save.

### Create APP Pipelines in Jenkins
1. Once jenkins infra setup is done. Go to dashboard
2. Click on new item -> Enter pipeline name + select type as Pipeline -> Click OK
    - Select Build trigger as GitHub hook trigger for GITScm polling 
    - For definition select pipeline script from SCM , for SCM select Git , for repository add https://github.com/arya-vikash/sample-python-app, for credentials add github credentials ( refer here)
    - For branch to build  provide */main , add script file path as app/Jenkinsfile , uncheck Lightweight checkout and save.
3. Trigger manual build first. Pipeline auto triggers will happen on the next push to the main branch.

### Create Infra Pipelines in Jenkins
1. Once jenkins infra setup is done. Go to dashboard
2. Click on new item -> Enter pipeline name + select type as Pipeline -> Click OK
    - Select Build trigger as GitHub hook trigger for GITScm polling 
    - For definition select pipeline script from SCM , for SCM select Git , for repository add https://github.com/arya-vikash/sample-python-app, for credentials add github credentials ( refer here) or use existing if any.
    - For branch to build  provide */main , add script file path as infra/Jenkinsfile , uncheck Lightweight checkout and save.
3. Trigger manual build first. Pipeline auto trigger will happen on the next push to the main branch.

# What each Pipeline does
### App Pipeline
There are following stages involved in the app build pipeline. Working dir =  app/.
- **Install dependencies** : install all the app dependency libraries to run tests in next stage. Uses requirements.txt 
- **Run tests** : runs unit tests written in test_app.py using pytest.
- **Build docker image** :  Builds container image using Dockerfile defined in app/ using kankio build and pushes it to AWS ECR repository.
### Infra pipeline**
Following stages are involved in the infra deployment pipeline. Working dir = infra/
- **Login to AWS** :  Set up aws credentials to connect to AWS cloud in next steps. 
- **Terraform init** : Initializes terraform state and installs any dependency modules 
- **Terraform plan & validate** : Validates terraform files. Runs terraform plan which show infra changes to be performed and save the plan  in a file.
- **Terraform apply** : Deploys infrastructure on AWS cloud as per the provided plan in the previous stage. Uses previous saved plan file
- **Deploy on EKS** : WorkingDir = infra/kubernetes. Connects to the remote cluster. Applies application, Database resource manifests file to kubernetes cluster to deploy application code.


