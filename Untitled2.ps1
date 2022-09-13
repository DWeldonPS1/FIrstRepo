#find AD users that have not logged in for # days in x department
#list departments
#test if the chosen
#the first user in the array puts it into user in a loop until all users are inspected
#add -whatif as a safety measure that shows you what items would be effected if ran
#create a securestring password with specific parameters

<#
.Synopsis: Seeks for inactive users and stops them from being used
.Description
.Example
    disabl-inactiveuser -department sales -inactivedays 120
    this seeks for sales peopler that have not loggedin for
    120 days and makes ther accounts unusable
.Parameter Department
    this selects the department of target
.Parameter InactiveDays
    this is a measure in days of how long the user has remained
    inactive
.Notes
    general notes
    by creator1
#>

function Disable-InactiveUser {
  [cmdletbinding()]
  Param(
    [string]$Department,
    [int]$InactiveDays 
  )  
  $AllDepartments = Get-ADUser -Filter * -Properties Department |
    Select-Object  -Property Department -Unique |
    Where-Object {$_.department}
   if ($Department -notin $AllDepartments.department) {
    Write-Warning "The department $Department does not exist in AD, you must use one of these: $($Alldepartments.department)"
    break
    }
    $CutOffDate = (Get-Date).AddDays($InactiveDays * -1)
    Write-Verbose "the cutoff date is: $cutoffdate"
    $InactiveUsers = Get-ADUser -Filter * -Properties lastlogondate, department |
        Where-Object {$_.Department -eq $Department -and $_.lastlogondate -lt $CutOffDate}
     Write-Verbose "($inactiveUsers.name)" 

     foreach ($user in $inactiveusers) {
        $Lower = 97..122 | ForEach-Object {[char]$_} | Get-Random -Count 5
        $Upper = 65..90 | ForEach-Object {[char]$_} | Get-Random -Count 2
        $Number = 0..9  | Get-Random -Count 1
        $Special = 33..38 | ForEach-Object {[char]$_}| Get-Random -Count 1
        $SecPassword = ($Lower + $Upper + $Number + $Special |Sort-Object {Get-Random}) -join '' | ConvertTo-SecureString -AsPlainText -Force
        Set-ADUser -Identity $User -Enabled $false -PassThru | Set-ADAccountPassword -NewPassword $SecPassword -Reset
        Write-Verbose "The following users were disabled: $($user.name)" 
        } 
}

Disable-InactiveUser -department 'sales' -InactiveDays 90 -Verbose
#add -verbose for verbose results