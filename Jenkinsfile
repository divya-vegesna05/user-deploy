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
     }
    stages{
         stage("version")
         {
        steps{
             
            sh """
              echo "version: ${version}"
              echo "environment: ${environment}"
            """
            }
         }

         stage("init")
         {
        steps{
             
            sh """
            cd terraform
            terraform init -backend-config="${environment}/backend.tf" -reconfigure
            """
            }
         }
        stage("plan")
         {
        steps{
            
            sh """
            cd terraform
            terraform plan -var-file="../${environment}/${environment}.tfvars" -var="app_version=${version}"
            """   
        }
    }
    stage("apply")
    {
    //    when
    //    {
    //     expression
    //     {
    //         params.Action == 'apply'

    //     }
    //    }
        steps{
             
            sh """
            cd terraform
            terraform apply -var-file="../${environment}/${environment}.tfvars" -var="app_version=${version}" -auto-approve
            """
        }
    }
    // stage("destroy")
    // {
    //    when
    //    {
    //     expression
    //     {
    //         params.Action == 'destroy'

    //     }
    //    }
        // input {
        //         message "Should we continue?"
        //         ok "Yes, we should."
        // }
        // steps{
             
        //     sh """
        //    cd terraform
        //     terraform destroy -var-file="../${environment}/${environment}.tfvars" -var="app_version=${version}" -auto-approve
        //    """
        
        // }
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