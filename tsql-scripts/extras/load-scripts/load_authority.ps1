Param(
#  [string]$serverName,
#  [string]$databaseName,
#  [string]$authorityCodeFilesPath
)
$servrName = 'LA326861'
$databaseName = 'GNAF'
$authorityCodeFilesPath = 'C:\Developer\data\g-naf_may23_allstates_gda2020_psv_1011\G-NAF\G-NAF MAY 2023\Authority Code'

Get-ChildItem $authorityCodeFilesPath -Filter *.psv |
Foreach-Object {
    $tableName = $_.name.Replace("Authority_Code_", "").Replace("_psv.psv", "")
    write-host "Procesing" $_.Name "into table" $tableName
    bcp $tableName in $_.FullName -d $databaseName -S $serverName -t"|" -c -T -F 2
}