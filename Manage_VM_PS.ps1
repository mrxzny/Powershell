#------------------------------------------------------------------------------------------------
#Retrieve login details and save to .txt file in specified location - Delete comment line 3 to use
#(Get-Credential).Password | ConvertFrom-SecureString | Out-File -PSPath C:\yourpath\yourpassword.txt
#------------------------------------------------------------------------------------------------
$path = "C:\yourpath\yourpassword.txt" # Path to the password above
$CLUIP = "XXX.XXX.XXX.XXX" #Cluster IP
$LogID = "Username" #Login to cluster (USERNAME) (can be with domain)
$Node1IP = "XXX.XXX.XXX.XXX" #IP NODE 1
$Node2IP = "XXX.XXX.XXX.XXX" #IP NODE 2
$Node3IP = "XXX.XXX.XXX.XXX" #IP NODE 3
$Node4IP = "XXX.XXX.XXX.XXX" #IP NODE 4 etc..
$listNode = $Node1IP, $Node2IP, $Node3IP, $Node4IP

#$VM ="VM_NAME" #The name of the VM on which we are working - STATIC
$VM = Read-Host -Prompt 'Podaj nazwe VM'# # Specifying the name of the VM


$confirmation = Read-Host "Do you want to turn on the machine  $VM  ? [y/n]" #Confirm if we are sure we want to turn on the machine
if($confirmation -eq "y")
{
#------------------------------------------------------------------------------------------------
#Setting up REMOTE-related options on the server and your computer
#foreach ($node in $listNode)
#{
#    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $node -Force
#}

#------------------------------------------------------------------------------------------------
#Password retrieval and credential creation
function InitPassword($path, $LogID) 
{
    $global:password = Get-Content -Path $path | ConvertTo-SecureString
    $global:cred = New-Object System.Management.Automation.PSCredential ($LogID, $global:password)
}
#------------------------------------------------------------------------------------------------
#Function used to connect to a cluster using credentials
function Connect($NodeIP)
{
    $trusted = Get-Item WSMan:\localhost\Client\TrustedHosts
    if($trusted.Value.IndexOf($NodeIP) -eq -1){
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value $NodeIP -Concatenate -Force #Add to trusted host , if not trusted (requires administrator privileges)
    }
    $global:session = New-PSSession -ComputerName $NodeIP -Credential $global:cred
}
#------------------------------------------------------------------------------------------------
#Function used to retrieve the status of a given VM (Off/Runing)
function GetVmState($VM2)
{
    try 
        {
            $stateVM = Invoke-Command  -Session $global:session -ScriptBlock {Get-VM -Name $Using:VM2 | Select State} -ErrorAction Stop
    
        }
   catch 
        {
            $stateVM = "Not found"
        }
return $stateVM
}
#------------------------------------------------------------------------------------------------
#Script Execution:
#1. Initialization of credentials
InitPassword $path $LogID
#2. Taking up the session
Get-PSSession
#3. Search nodes to find VM and enable/disable it
#W celu wykonania zadania polegającego na wyłączeniu włączonej maszyny wykonujemy zmiany:

foreach ($node in $listNode)
{
    
    #Set-Item WSMan:\localhost\Client\TrustedHosts -Value $node -Force
    Connect $node 
    $state = GetVmState($VM)
    if($state.State.Value -eq "Off") {
        Invoke-Command -Session $global:session -ScriptBlock {Start-vm -VMName $Using:VM} #Włączenie VM   
    }  
}
#------------------------------------------------------------------------------------------------
Get-PSSession | Remove-PSSession
    #else ($confirmation -eq 'n')
    
}
else
        {
            Write-Host "Operacja zostala anulowana. Wychodze z programu"
            exit
        }

