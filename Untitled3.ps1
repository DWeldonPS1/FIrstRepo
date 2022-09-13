function Disable-InactiveUser {
  [cmdletbinding()]
  Param(
    [string]$Department,
    [int]$InactiveDays 
  )  
  $AllDepartments = Get-ADUser -Filter * -Properties Department |
    Select-Object  -Property Department -Unique |
    Where-Object {$_.department}
   if ($Department -notin $AllDepartments.department){
    Write-Warning "The department $Department does not exist in AD, you must use one of these: $($Alldepartments.department)"
    break
    }
    $CutOffDate = (Get-Date).AddDays($InactiveDays * -1)
    $InactiveUsers = Get-ADUser -Filter * -Properties lastlogondate, department |
        Where-Object {$_.Department -eq $Department -and $_.lastlogondate -lt $CutOffDate}
    $inactiveUsers | ft
}

disable-inactiveuser -department 'sales' -InactiveDays 90