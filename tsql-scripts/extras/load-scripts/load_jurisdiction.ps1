Param(
    # [string]$serverName,
    # [string]$databaseName,
    # [string]$jurisdictionFilesPath
)

# --- orig

#Param(
#  [string]$serverName,
#  [string]$databaseName,
#  [string]$jurisdictionFilesPath,
#  [string]$jurisdictionName
#)

#$filter = $jurisdictionName+"_*.psv"

#Get-ChildItem $jurisdictionFilesPath -Filter $filter |
#Foreach-Object {
#    $tableName = $_.name.Replace($jurisdictionName+"_", "").Replace("_psv.psv", "")
#    write-host "Procesing" $_.Name "into table" $tableName
#    bcp $tableName in $_.FullName -d $databaseName -S $serverName -t"|" -c -T -F 2
#}

# --- updated

$serverName = 'localhost'
$databaseName = 'GNAF'
$jurisdictionFilesPath = 'C:\Users\AndrewWoodall\Development\sql-learning\gnaf-loader\g-naf_may23_allstates_gda2020_psv_1011\G-NAF\G-NAF MAY 2023\Standard'


$jurisdictionName = @("ACT", "QLD", "NSW", "NT", "OT", "SA", "TAS", "VIC", "WA")
foreach ($node in $jurisdictionName) {
    $filter = $node + "_*.psv"

    Get-ChildItem $jurisdictionFilesPath -Filter $filter |
    Foreach-Object {
        $tableName = $_.name.Replace($node + "_", "").Replace("_psv.psv", "")
        write-host "Procesing" $_.Name "into table" $tableName
        bcp $tableName in $_.FullName -d $databaseName -S $serverName -t"|" -c -T -F 2
    }
}