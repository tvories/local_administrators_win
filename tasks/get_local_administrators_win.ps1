# Puppet Task Name: get_local_administrators_win
#

$admins = get-wmiobject -computername $env:computername -Credential $Credential -query "select * from win32_groupuser where GroupComponent=""Win32_Group.Domain='$env:computername',Name='administrators'""" | % {$_.partcomponent}

    foreach ($admin in $admins) {
                $admin = $admin.replace("\\$env:computername\root\cimv2:Win32_UserAccount.Domain=","") # trims the results for a user
                $admin = $admin.replace("\\$env:computername\root\cimv2:Win32_Group.Domain=","") # trims the results for a group
                $admin = $admin.replace('Name="',"")
                $admin = $admin.Replace("`"","")
                $admin = $admin.split(",")

                $objOutput = New-Object PSObject -Property @{
                    Fullname = ("$($admin[0])\$($admin[1])")
                    DomainName  =$admin[0]
                    UserName = $admin[1]
                }#end object
        $objreport+=@($objoutput)
    }#end for

    ConvertTo-Json -InputObject $objreport -Compress