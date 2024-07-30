## Migration of a Java Application to Chainguard images using a Jenkins Pipeline 

This repo is designed to be an example of migrating to chainguard images using a CI/CD pipeline in Jenkins

### Requirements
- Kubernetes Cluster provisioned
- Jenkins helm chart repo
- Several Jenkins plugins installed
  * 

### Instructions

#### Clone the git repo

Fork and clone https://github.com/ericbannon/chainguard-ci-demo.git (with your forked repo)

#### Install Jenkins and expose svc

helm repo add jenkins https://charts.jenkins.io
helm repo update

kubectl expose svc jenkins-demo --type=LoadBalancer --port=8080 --target-port=8080 --name=jenkins-lb

Retrieve admin password:  kubectl exec --namespace default -it svc/jenkins-demo -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo

#### Configure plugins for Jenkins

Login to the Jenkins GUI using the admin credentials and install the following plugins:

- Warnings
- Grype
- pipeline-graph-view
- Git
- Pipeline (declarative)
- Groovy
- Docker
- Maven
- Pipeline Maven
- Quality Gates (optional)
- Blue Ocean (optiional)

#### Create a multibranch pipeline

##### Step 1

Add your repository URL to the Git project repository and use a PAT token to add your GH credentials (Note: Use the username/password option where your password is your PAT)

##### Step 2

Make sure you have added behviours for "Discover Branches" and "Clean after checkout"

##### Step 3

Change the build configuration Mode to "by Jenkinsfile" and enter the script path from your repo's Jenkinsfile - Jenkinsfile-k8s-java

#### Modifying the Dockerfile to illustrate before and after Chainguard migration 

By default, your forked repo will have a Dockerfile with an application built fromthe default Dockerhub maven and jdk images. Your multi branch pipeline should have run automatically when you created the project, but run it again if it did not. 

##### Look at the finished pipeline run results to view Grype scan details of all the vulnerabilities



The chainguard-demo app should be deployed to your K8s cluster. Check the exposed service and go to the static html page: http://<your-service>/index.html

##### Modify the Dockerfile to move to chainguard images

In the Dockerfile.tmp, you will see the same application but migrated to Chainguard images. Modify the original Dockerfile after moving the old one over to a tmp file, and push your changes to the repo. 

Click "Scan Multibranch Pipeline Now" to re-run the pipeline

##### Notice the trend donwards in grype warnings


Check the updated chainguard-demo service to see the same application running but, with low CVEs
