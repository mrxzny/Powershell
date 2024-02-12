#Powershell - ADD NEW DISK VM TO REPLICATION
#Owner: MRXZNY

Get-VMHardDiskDrive -VMName 'VM-Name' | Format-Table -AutoSize #LIST-DISK CONTROLLER 

# Set current disk's + new one

Set-VMreplication "VM-NAME" -ReplicatedDisks (Get-VMHardDiskDrive "VM-NAME" -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 0), (Get-VMHardDiskDrive "VM-NAME" -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 2), (Get-VMHardDiskDrive "VM-NAME" -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 3)