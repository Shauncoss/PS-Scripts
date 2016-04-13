#Author: Shaun Coss
#Automatically populates IP Reservations under a specified DHCP Scope by csv file and inputs a router IP specified by user
#CSV only needs one column called "ip"
#MAC Address is only a placeholder

$allscopes = Get-DhcpServerv4Scope
$allscopes
$scope = Read-Host -Prompt `n"Please Select a ScopeID" 
$gateway = Read-Host -Prompt `n"Please enter a Router IP for the reservations"


if ($scope -notlike $allscopes.ScopeId)
{
    Write-Error "Invalid Scope Selection"
    return
}

$csvpath = Read-Host -Prompt "Type in csv file path"
$iplist = Import-Csv -Path $csvpath | Select-Object ip

$mac = 00000000

Write-Host `n"Adding Reservations..."

foreach( $ip in $iplist )
{
    #adds in a placeholder MAC address
    $mac += 1
    $macstring = '{0:D8}' -f $mac

    Add-DhcpServerv4Reservation -ScopeId $scope -IPAddress $ip.ip -ClientId $macstring 
    Set-DhcpServerv4OptionValue -ReservedIP $ip.ip -Router $gateway

}