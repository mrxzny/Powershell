[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  

$Form = New-Object System.Windows.Forms.Form    
$Form.Size = New-Object System.Drawing.Size(600,400)  

################## WWN CHECK FUNCTION  ################## START

function wwnCheck {
$datastoreNameInput=$InputBox.text; #Input datastore name there from failover/disk mgmt etc.
$datastoreNameOutput = Get-SCStorageDisk | Where-Object {$_.ClusterDisk -like $datastoreNameInput } | select ClusterDisk, SMLunId | fl | out-string; # Give information about Luns and name of clusterdisk
$outputBox.text=$datastoreNameOutput
                     } #end wwnCheck

################## WWN CHECK FUNCTION  ################## END 

################## TEXT FIELD ##################

$InputBox = New-Object System.Windows.Forms.TextBox 
$InputBox.Location = New-Object System.Drawing.Size(20,50) 
$InputBox.Size = New-Object System.Drawing.Size(150,20)
$InputBox.Text = "Nazwa datastore"
$Form.Controls.Add($InputBox) 

$outputBox = New-Object System.Windows.Forms.TextBox 
$outputBox.Location = New-Object System.Drawing.Size(10,150) 
$outputBox.Size = New-Object System.Drawing.Size(565,200) 
$outputBox.MultiLine = $True 
$outputBox.ScrollBars = "Vertical" 
$Form.Controls.Add($outputBox) 

################## TEXT FIELD ##################

################## BUTTON ##################

$Button = New-Object System.Windows.Forms.Button 
$Button.Location = New-Object System.Drawing.Size(400,30) 
$Button.Size = New-Object System.Drawing.Size(110,80) 
$Button.Text = "WWN CHECK" 
$Button.Add_Click({wwnCheck}) 
$Form.Controls.Add($Button) 

################## BUTTON ##################


$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()