<#
  Version:        1.0
  Author:         Franklin Correa
  Creation Date:  26/07/2019
  Purpose/Change: Serverless Lambda script Installation
#>

Clear

#Aws Access configuration
$AccesskeyID = ""
$Secretaccesskey = ""


if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) 
{
        Write-Warning "You are not running this as local administrator. Run it again in an elevated prompt." ; break
}
elseif (!$AccesskeyID)
{
     Write-Warning "Script can't proceed without Access Key ID"
     Write-Warning "Please update your Access Key ID" ; break
    
}
elseif (!$Secretaccesskey)
{
    
     Write-Warning "Script can't proceed without Scret Access Key"
     Write-Warning "Please update your Secret Access Key" ; break
   
}

#Setting execution police
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

#ErrorAction
$ErrorActionPreference = "SilentlyContinue"


#Dependecies Installation
# nodejs
$version = "10.16.0"
$url = "https://nodejs.org/dist/v$version/node-v$version-x64.msi"

# activate / desactivate any install
$install_node = $TRUE
$install_serverless = $TRUE
$deploy_lambda = $TRUE
$install_NPM = $TRUE
$install_DynamoDB = $TRUE


write-host "`n----------------------------"
write-host "System Requirements Checking  "
write-host "----------------------------`n"


if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
   write-Warning "This setup needs admin permissions. Please run this file as admin."     
   break
}
#Checking Nodejs installation
if (Get-Command node -errorAction SilentlyContinue) {
    $current_version = (node -v)
}
 
if ($current_version) {
    write-host "[NODE] nodejs $current_version already installed"
    $confirmation = read-host "Are you sure you want to replace this version ? [y/N]"
    if ($confirmation -ne "y") {
        $install_node = $FALSE
   }
}

write-host "`n"

if ($install_node) {
    
    ### download nodejs msi file
    # warning : if a node.msi file is already present in the current folder, this script will simply use it
        
    write-host "`n----------------------------"
    write-host " nodejs msi file retrieving  "
    write-host "----------------------------`n"

    $filename = "node.msi"
    $node_msi = "$PSScriptRoot\$filename"
    
    $download_node = $TRUE

    if (Test-Path $node_msi) {
        $confirmation = read-host "Local $filename file detected. Do you want to use it ? [Y/n]"
        if ($confirmation -eq "n") {
            $download_node = $FALSE
        }
    }

    if ($download_node) {
        write-host "[NODE] downloading nodejs install"
        write-host "url : $url"
        $start_time = Get-Date
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($url, $node_msi)
        write-Output "$filename downloaded"
        write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
    } else {
        write-host "using the existing node.msi file"
    }

    ### nodejs install
    write-host "`n----------------------------"
    write-host "Nodejs Installation  "
    write-host "----------------------------`n"

    write-host "[NODE] running $node_msi"
    Start-Process $node_msi -Wait
    
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
    
} else {
    write-host "Proceeding with the previously installed nodejs version ..."
}

`n

# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

cd $ScriptDir
if ($install_serverless) {

    #Serverless install
    write-host "`n----------------------------------"
    write-host "Serverless Framework Installation "
    write-host "----------------------------------`n"


    #Serverless Installation
    write-host "`[SERVERLESS] installing Serverless Framework..."
    npm install -g serverless
    #npm i
    #sls dynamodb install


    write-host "`[SERVERLESS] Configuring Serverless AWS Access profile..."
    serverless config credentials --provider aws --key $AccesskeyID --secret $Secretaccesskey --overwrite  

}


if ($install_NPM) {
    
    #Serverless install
    write-host "`n----------------"
    write-host "NPM Installation "
    write-host "----------------`n"

    # Deploying to AWS
    write-host "`[NPM] Installing..."
    npm i

}

if ($install_DynamoDB) {
    
    #Serverless install
    write-host "`n---------------------"
    write-host "DynamoDB Installation "
    write-host "---------------------`n"

    # Deploying to AWS
    write-host "`[SLS] Installing Dynamodb..."
    sls dynamodb install

}


if ($deploy_lambda) {
    
    #Serverless install
    write-host "`n---------------"
    write-host "Deployig Lambda "
    write-host "---------------`n"

    # Deploying to AWS
    write-host "`[SERVERLESS] Deploying AWS Lambda..."
    serverless deploy

}



    sls dynamodb install