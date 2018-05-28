def apply = false
pipeline {
  agent { label 'ec2'}
  options {
    skipDefaultCheckout(true)
  }
  environment {
     terraformHome = tool 'terraform'
 }

  stages {
    stage ('Checkout SCM') {
      steps {
        cleanWs()
        checkout scm
      }
    }
    stage ('Init') {
      steps{
        script{
          dir('vpc') {
            sh "${terraformHome}/terraform init -input=false; echo \$? > init.status"
            def InitExitCode = readFile('init.status').trim()
            if (InitExitCode == "0") {
             slackSend channel: '#iad-test', color: 'good', message: "Initial Phase Completed : ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
           }
           if (InitExitCode == "1") {
             slackSend channel: '#iad-test', color: '#0080ff', message: "Init Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
             currentBuild.result = 'FAILURE'
           }
         }
       }
     }
  }
    stage ('Verify') {
      steps {
        script {
          dir('vpc') {
            sh "set +e;${terraformHome}/terraform plan -out=plan.out -var-file=./variables.tfvars -detailed-exitcode; echo \$? > plan.status"
            def exitCode = readFile('plan.status').trim()
            echo "Terraform Plan Exit Code: ${exitCode}"
            if (exitCode == "0") {
              currentBuild.result = 'SUCCESS'
            }
            if (exitCode == "1") {
              slackSend channel: '#iad-test', color: '#0080ff', message: "Plan Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
              currentBuild.result = 'FAILURE'
            }
            if (exitCode == "2") {
              stash name: "plan", includes: "plan.out"
              slackSend channel: '#iad-test', color: 'good', message: "Plan Awaiting Approval: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ${env.JOB_URL} ()"
              try {
                  input message: 'Apply Plan?', ok: 'Apply'
                  apply = true
                  } catch (err) {
                    slackSend channel: '#iad-test', color: 'warning', message: "Plan Discarded: ${env.JOB_NAME} - ${env.BUILD_NUMBER} - ${env.JOB_URL}()"
                    apply = false
                    currentBuild.result = 'UNSTABLE'
                  }
            }
          }
        }
      }
    }
    stage ('Apply') {
      when {
        expression { return readFile('vpc/plan.status').contains('2') }
      }
      steps {
        script {
          dir('vpc')
            unstash 'plan'
            sh "set +e; ${terraformHome}/terraform plan.out; echo \$? > status.apply"
            def applyExitCode = readFile('status.apply').trim()
            if (applyExitCode == "0") {
                slackSend channel: '#iad-test', color: 'good', message: "Changes Applied ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
                } else {
                  slackSend channel: '#iad-test', color: 'danger', message: "Apply Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
                  currentBuild.result = 'FAILURE'
                }
        }
      }
    }
    stage ('destroy') {
      steps {
        script {
          dir('vpc') {
            sh "ls -la"
            sh "set +e; ${terraformHome}/terraform destroy"
            slackSend channel: '#iad-test', color: 'good', message: "Changes Destroyed ()"
          }
        }
      }
    }
  }
}
