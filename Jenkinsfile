pipeline{
    agent{
         node {
        label 'agent-1'
    }
    }
    options {
        timeout(time: 1, unit: 'HOURS') 
         ansiColor('xterm')
    }
    parameters {
         string(name: 'version', defaultValue: '', description: 'Pick version')
         string(name: 'environment', defaultValue: '', description: 'Pick environment')
         booleanParam(name: 'Create', defaultValue: false, description: 'Toggle this value')
         booleanParam(name: 'Destroy', defaultValue: false, description: 'Toggle this value')
     }
    stages{
         stage("version")
         {
        steps{
             
            sh """
              echo "version: ${params.version}"
              echo "environment: ${params.environment}"
            """
            }
         }

         stage("init")
         {
        steps{
             
            sh """
            cd terraform
            terraform init -backend-config="${params.environment}/backend.tf" -reconfigure
            """
            }
         }
        stage("plan")
         {
        steps{
            
            sh """
            cd terraform
            terraform plan -var-file="../${params.environment}/${params.environment}.tfvars" -var="app_version=${params.version}"
            """   
        }
    }
    stage("apply")
    {
       when
       {
        expression
        {
            params.Create

        }
       }
        steps{
             
            sh """
            cd terraform
            terraform apply -var-file="../${params.environment}/${params.environment}.tfvars" -var="app_version=${params.version}" -auto-approve
            """
        }
    }
    stage("destroy")
    {
       when
       {
        expression
        {
            params.Destroy

        }
      }
        // input {
        //         message "Should we continue?"
        //         ok "Yes, we should."
        // }
        steps{
             
            sh """
           cd terraform
            terraform destroy -var-file="../${environment}/${environment}.tfvars" -var="app_version=${version}" -auto-approve
           """
        }
        }
    } 

 post { 
        always { 
            echo 'I will always say Hello again!'
            deleteDir()
        }
        success { 
            echo 'I will always say success!'
        }
                failure { 
            echo 'I will always say success!'
        }
 }
}