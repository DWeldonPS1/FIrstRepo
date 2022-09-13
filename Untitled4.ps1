#write a pipeline that displays all running services and show the following properties sorted by the starttype and then by the name
#properties to show status, startype, name, displayname

Get-Service | Where-Object {$_.Status -eq 'running'}|Sort-Object -Property starttype, name | Select-Object -Property status, starttype, name, displayname


#Write a pipeline that will show the some properties of the BIOS information using a CimInstance command

Get-CimClass -ClassName *bios*

get-ciminstance -ClassName win32_BIOS | select-object -Property version,releasedate,cimclass

Get-Module

get-date
