Invoke-Command -ComputerName LON-dc1 -ScriptBlock {
$Recyclebin = Get-ADOptionalFeature 'recycle bin feature'
if ($Recyclebin.enabledscopes.count -eq 0){
Enable-ADOptionalFeature 'recycle bin feature' -Scope ForestOrConfigurationSet -Target adatum.com -Confirm:$false
}
}


Invoke-Command -ComputerName LON-DC1 -ScriptBlock {  
  Get-ADUser -Filter * -Properties Department | Where-Object {$_.Department -in @('Sales','Mareting','Managers')} | Get-Random -Count 10 | Remove-ADUser -Confirm:$false
  }  

#this is used to restore a user(s) from the recyclebin
#shift alt down arrow include two spaces

Function Restore-DeletedADObjects {
  $DeletedObjects = Get-ADObject -LDAPFilter:"(msDS-LastKnownRDN=*)" -IncludeDeletedObjects | Where-Object {$_.Deleted -eq $true} 
  $ADObjectschosen = $DeletedObjects | Out-GridView -OutputMode Multiple
  $ADObjectschosen | Restore-ADObject -Confirm:$false
  $RestoredADObjects = Get-ADObject -Filter * | Where-Object {$_.objectguid -in $ADObjectschosen.objectguid} 
  return $restoredADObjects
}
restore-deletedadobjects