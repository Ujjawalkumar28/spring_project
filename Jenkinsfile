pipeline {
    agent any
        environment {
            AWS_ACCOUNT_ID="995823033771"
            AWS_ACCESS_KEY_ID = 'AKIA6PW5NTWVTUTBJ5RZ'
            AWS_SECRET_ACCESS_KEY = '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'
            AWS_DEFAULT_REGION="us-east-1"
            IMAGE_REPO_NAME="app-repo"
            IMAGE_TAG="${BUILD_NUMBER}"
            REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        }
        
  tools {
    maven 'MAVEN_HOME' 
  }
       
    stages {
        stage ('checkout') {
          steps {    
            checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: '1b6d2ccc-714f-45eb-b7ab-e83a595a77c2', url: 'https://gitlab.com/jay823001/spring-project.git']])
          }
        }
        stage ('Build') {
          steps {
            sh 'mvn clean package'
          }
        }
        stage ('Docker Build') {
          steps {
              sh 'docker build -t app-repo:${BUILD_NUMBER} .'
          }
        }  
	    stage('Logging into AWS ECR and pussing image to ECR') {
	        steps {
		        script {
			               sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 995823033771.dkr.ecr.us-east-1.amazonaws.com/app-repo"
		                 sh "docker tag app-repo:${IMAGE_TAG} 995823033771.dkr.ecr.us-east-1.amazonaws.com/app-repo:${IMAGE_TAG}"
		                 sh "docker push 995823033771.dkr.ecr.us-east-1.amazonaws.com/app-repo:${IMAGE_TAG}"       
		        }
	        }
        }
         stage ('Updating Deployment Manifest file') {
             steps {
                 script {
                     withCredentials([usernamePassword(credentialsId: '1b6d2ccc-714f-45eb-b7ab-e83a595a77c2', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                     sh " git config user.email jay823001@gmail.com"
                     sh " git config user.name jay"
                     sh "sed -i 's/app-repo:.*/app-repo:${BUILD_NUMBER}/g' deployment_manifest_green/deployment_green.yaml"
                     sh "sed -i 's/app-repo:.*/app-repo:${BUILD_NUMBER}/g' deployment_manifest_blue/deployment_blue.yaml"
                     sh "git add ."
                     sh "git commit -m 'Done by Jenkins pipeline :${env.BUILD_NUMBER}'"
                     sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@gitlab.com/${GIT_USERNAME}/spring-project.git HEAD:main"
                     }
                 }
             }  
         }
    }
}
