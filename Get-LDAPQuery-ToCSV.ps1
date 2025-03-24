function Get-LDAPQuery-ToCSV {
    param (
        [string]$query="(&(objectclass=us\65r)(!objectclass=UATtest1))",
        [string]$exportpath
    )
    $searchAD = New-Object DirectoryServices.DirectorySearcher([adsi]"")
    $SearchAD.Filter = $query
    $SearchAD.PageSize=1000

    $users=$SearchAD.FindAll()
    if($users.Count -eq 0){break}
    $props = [System.Collections.Generic.HashSet[String]]::new([System.StringComparer]::InvariantCultureIgnoreCase)
    $uniqueKey=''
    foreach($user in $users.Properties){
    $Keys = $user.GetEnumerator() | %{$_.Key} 
    foreach($key in $keys){$props.add($key)}
    }

    foreach($user in $users.Properties){
    $userData = @{}
    foreach($prop in $props){
    $enc = [System.Text.Encoding]::UTF8
    if($user.$prop){
    $userData[$prop] = $user.$prop[0]}else{
    $userData[$prop] = ""}
    }
    $userCustomObject = [PSCustomObject]$userData
    $userCustomObject | Export-CSV -Path $exportpath -NoTypeInformation -Append
    }

}