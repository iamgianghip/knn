Param(
[string]$FilePath
)

$File = Import-Csv $FilePath

$File|Select-Object|Sort-Object 'OrganizationalUnit' -Unique|Select-Object 'OrganizationalUnit'|ForEach-Object {
    New-ADOrganizationalUnit $_.'Organizational Unit'
}

$File|Select-Object|Sort-Object 'Group' -Unique|Select-Object 'Group'|ForEach-Object {
    New-ADGroup $_.Group
}

$File|ForEach-Object {
    New-ADUser `
    -Name ($_.'Given Name'+' '+$_.Surname) `
    -AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -Force) `
    -City $_.City `
    -Company $_.Company `
    -OtherAttributes @{co=$_.Country}`
    -DisplayName ($_.'Given Name'+' '+$_.Surname) `
    -EmailAddress $_.'E-Mail' `
    -Enabled $true `
    -GivenName $_.'Given Name' `
    -HomeDirectory '\\dc2\Homes\%username%' `
    -HomeDrive 'H:\' `
    -PasswordNeverExpires $true `
    -Path ("ou="+$_."organizational unit"+",dc=wsi2024,dc=fr") `
    -SamAccountName $_.IDuser `
    -Surname $_.Surname
}

