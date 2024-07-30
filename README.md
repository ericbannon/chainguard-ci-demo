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

```
helm repo add jenkins https://charts.jenkins.io
helm repo update

kubectl expose svc jenkins-demo --type=LoadBalancer --port=8080 --target-port=8080 --name=jenkins-lb
```

Retrieve admin password:  

```
kubectl exec --namespace default -it svc/jenkins-demo -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
```

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

![Screenshot 2024-07-30 at 9 43 40 AM](https://github.com/user-attachments/assets/64e08e7b-c4cf-48d3-8353-0ba976945b1e)

##### Step 2

Make sure you have added behviours for "Discover Branches" and "Clean after checkout"

![Screenshot 2024-07-30 at 9 45 41 AM](https://github.com/user-attachments/assets/64118af3-5482-45c7-ae89-465ad2882847)

##### Step 3

Change the build configuration Mode to "by Jenkinsfile" and enter the script path from your repo's Jenkinsfile - Jenkinsfile-k8s-java

![Screenshot 2024-07-30 at 9 45 53 AM](https://github.com/user-attachments/assets/c82af264-d285-4e9e-bec8-11e182cf8ae8)

#### Modifying the Dockerfile to illustrate before and after Chainguard migration 

By default, your forked repo will have a Dockerfile with an application built fromthe default Dockerhub maven and jdk images. Your multi branch pipeline should have run automatically when you created the project, but run it again if it did not. 

```
FROM maven:3.9.0-eclipse-temurin-17 as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM eclipse-temurin:17.0.6_10-jdk
WORKDIR /app
COPY --from=build /app/target/demoapp.jar /app/
EXPOSE 8080
CMD ["java", "-jar","demoapp.jar"]
```

##### Look at the finished pipeline run results to view Grype scan details of all the vulnerabilities

![Screenshot 2024-07-30 at 10 04 39 AM](https://github.com/user-attachments/assets/89ccf89f-b8bf-4cc9-9f81-bcf7bb5f6614)

The chainguard-demo app should be deployed to your K8s cluster. Check the exposed service and open the URL i.e. 

```
http://<your-service>:80
```

![Screenshot 2024-07-30 at 9 57 01 AM](https://github.com/user-attachments/assets/c964360c-f76e-45ff-a6e7-3777e89571bd)

##### Modify the Dockerfile to move to chainguard images

In the Dockerfile.tmp, you will see the same application but migrated to Chainguard images. Modify the original Dockerfile after moving the old one over to a tmp file, and push your changes to the repo. 

```
FROM cgr.dev/chainguard/maven:latest-dev as builder
USER root
WORKDIR /app
COPY . .
RUN mvn clean install

FROM cgr.dev/chainguard/jdk:latest-dev
USER root
WORKDIR /app
COPY --from=builder /app/target/demoapp.jar /app/
EXPOSE 8080
CMD ["java", "-jar","demoapp.jar"]
```

Click "Scan Multibranch Pipeline Now" to re-run the pipeline

![Screenshot 2024-07-30 at 9 50 00 AM](https://github.com/user-attachments/assets/e590f64d-1aaf-4e8a-a55f-a964dec36159)

##### Notice the trend donwards in grype warnings

![Screenshot 2024-07-30 at 9 58 07 AM](https://github.com/user-attachments/assets/e9cddd2f-f158-4b79-bd62-bc946113e2c5)

Check the updated chainguard-demo service to see the same application running but, with low CVEs!
