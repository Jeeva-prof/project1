pipeline {
    agent any
    stages{
        stage('checkout SCM'){
            steps{
	        git credentialsId: 'git-pwd', url: 'https://github.com/Jeeva-prof/project1.git'
            }
        }
        stage('compile project'){
            steps{
	        sh 'mvn compile'           
            }
        }
        stage('test project'){
            steps{
	        sh 'mvn compile'           
            }
        }
        stage('build project'){
            steps{
	        sh 'mvn clean package'
            }
        }
        stage('qa project'){
            steps{
                sh 'mvn checkstyle:checkstyle'
            }
        }
        stage('Containerize project'){
            steps{
                script{
                    sh 'docker build -t 10551jeeva/healthcare:v1 . '
                    sh 'docker images'
                }
            }
        }
        
	stage('Docker login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pwd', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh 'docker push 10551jeeva/healthcare:v1'
                }
            } 
 	}       
     	stage('Create testcluster') {
            steps {
	        sh '''cd test 
		sudo terraform init
		sudo terraform apply --auto-approve
		sudo terraform output -raw masterip >masterhost | pwd 
    sudo sed -i \'\'s/localhost/$(cat masterhost)/g\'\' prometheus_test.yml
    sudo sed -i \'\'s/localhost/$(cat masterhost)/g\'\' dash/test_dash.json
  	sudo sed -i \'\'s/localhost/$(cat masterhost)/g\'\' ds/test_ds_.yaml 
		sudo sed -i \'s/$/  ansible_user=ubuntu/\' masterhost
    sudo ansible-playbook -i masterhost testtoken.yml 
    sudo terraform output -raw nodeip >nodehost
    sudo sed -i \'s/$/  ansible_user=ubuntu/\' nodehost
    sudo ansible-playbook -i nodehost testnodeconnect.yml'''   
		          }
	    }
     	stage('Deploy to testcluster') {
            steps {
		   sh 'sudo ansible-playbook -i test/masterhost deployplaybook.yml'
		          }
	    }
     	stage('Create productioncluster') {
            steps {
      		sh '''sudo pwd
		            cd prod
                sudo terraform init
		            sudo terraform apply --auto-approve
		            sudo terraform output -raw masterip >prodhost
                sudo sed -i \'\'s/localhost/$(cat prodhost)/g\'\' prometheus_production.yml
                sudo sed -i \'\'s/localhost/$(cat prodhost)/g\'\' dash/prod_dash.json
                sudo sed -i \'\'s/localhost/$(cat prodhost)/g\'\' ds/prod_ds_.yaml
  	          	sudo sed -i \'s/$/  ansible_user=ubuntu/\' prodhost
                sudo ansible-playbook -i prodhost productiontoken.yml
                sudo terraform output -raw nodeip >nodeprodhost 
                sudo sed -i \'s/$/  ansible_user=ubuntu/\' nodeprodhost
                sudo ansible-playbook -i nodeprodhost productionnodeconnect.yml'''
		          }
	    }
	 stage('Deploy to productioncluster') {
            steps {
		sh 'sudo ansible-playbook -i prod/prodhost deployplaybook.yml'
                
                }
            }
	 stage('Setup continous monitoring ') {
            steps {
              sh '''  sudo ansible-playbook test/playbookgrafana.yaml'''            
		          sh '''  sudo ansible-playbook prod/playbookgrafana.yaml'''
                
                }
            }
        }
    }   
