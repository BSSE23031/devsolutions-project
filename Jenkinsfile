pipeline {
  agent any

  environment {
    REG = "ayeshausman204"
    WEB_IMAGE = "${REG}/devsolutions-web:${env.BUILD_NUMBER}"
    API_IMAGE = "${REG}/devsolutions-api:${env.BUILD_NUMBER}"
    KUBECONFIG_CREDENTIAL = 'kubeconfig-cred'    // Jenkins credential id (secret file)
    DOCKERHUB_CRED = 'dockerhub-cred'            // Jenkins username/password id
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Images') {
      steps {
        sh 'docker version || true'
        sh "docker build -t ${WEB_IMAGE} ."
        sh "docker build -t ${API_IMAGE} ./api"
      }
    }

    stage('Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: DOCKERHUB_CRED, usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh "echo $DH_PASS | docker login -u $DH_USER --password-stdin"
          sh "docker push ${WEB_IMAGE}"
          sh "docker push ${API_IMAGE}"
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        // assume kubeconfig stored as secret file in Jenkins and injected
        withCredentials([file(credentialsId: KUBECONFIG_CREDENTIAL, variable: 'KUBECONF')]) {
          sh 'kubectl version --client'
          // Replace images in k8s YAMLs or use kubectl set image
          sh "kubectl set image deployment/web-deploy web=${WEB_IMAGE} --kubeconfig=$KUBECONF || true"
          sh "kubectl set image deployment/api-deploy api=${API_IMAGE} --kubeconfig=$KUBECONF || true"
          sh "kubectl rollout status deployment/web-deploy --kubeconfig=$KUBECONF"
          sh "kubectl rollout status deployment/api-deploy --kubeconfig=$KUBECONF"
        }
      }
    }
  }

  post {
    always {
      sh 'docker images | head -n 20'
      cleanWs()
    }
  }
}
