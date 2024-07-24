pipeline {
  environment {
    imagename = "bannimal/movieapp"
    registryCredential = 'dockerhub_id'
    dockerImage = ''
  }
  agent {
        docker { image 'cgr.dev/chainguard/docker-cli' }
    }
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'https://github.com/ericbannon/chainguard-ci-demo.git', branch: 'main', credentialsId: 'github_pat'])

      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $imagename:$BUILD_NUMBER"
         sh "docker rmi $imagename:latest"

      }
    }
  }
}
