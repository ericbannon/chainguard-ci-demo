pipeline {
    // ① Select a Jenkins slave with Docker capabilities

    environment {
        PRODUCT = 'chainguard'
        GIT_HOST = 'somewhere'
        GIT_REPO = 'repo'
    }

    stages {
        // ② Checkout the right branch
        stage('Checkout') {
            steps {
                script {
                    BRANCH_NAME = env.CHANGE_BRANCH ? env.CHANGE_BRANCH : env.BRANCH_NAME
                    deleteDir()
                    git url: "git@github.com:ericbannon/chainguard-ci-demo.git", branch: BRANCH_NAME
                }
            }
        }
    }
}