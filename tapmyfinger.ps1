if(!(Test-Path -Path (join-path $env:USERPROFILE fingered))){
    Write-Verbose "Making Fingered Directory"
    New-Item -Path (join-path $env:USERPROFILE fingered) -ItemType Directory | out-null
}

if (!(test-path (join-path $env:USERPROFILE fingered\taplist.csv))) {
    Write-Verbose "Making taplist"
    set-content (join-path $env:USERPROFILE fingered\taplist.csv) ""
}

$onTap = Get-Content (join-path $env:USERPROFILE fingered\taplist.csv)

function Finger-Someone {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String[]]
        $User
    )
    
    begin {

        
    }
    
    process {
        foreach ($finger in $user) {
            if (!(Test-Path -Path (join-path $env:USERPROFILE "fingered\$finger"))) {
                Write-Verbose "No finger profile for $finger, making directory."   
                New-Item -Path (join-path $env:USERPROFILE "fingered\$finger") -ItemType Directory | out-null
            }

            $content = finger $finger | select -SkipLast 2
            $archive = Get-ChildItem -Path (join-path $env:USERPROFILE "fingered\$finger")

            if ($archive.Length -eq 0) {
                Write-Verbose "Daddy made you some content, open wide!"   
                $timestamp = Get-Date -UFormat %s
                $content | Out-File -FilePath (join-path $env:USERPROFILE "fingered\$finger\$timestamp.txt")
                Write-Output (Get-Childitem (join-path $env:USERPROFILE "fingered\$finger\$timestamp.txt")),$Content
            } else {
                $lastFinger = $archive[$archive.count - 1]
                $content | out-file -filepath  (join-path $env:TEMP "temp.txt")
                $dif = Compare-Object -ReferenceObject (get-content $lastFinger.fullname) -DifferenceObject (get-content (join-path $env:TEMP temp.txt))

                if($dif){
                    Write-Verbose "Daddy made you some content, open wide!"   
                    $timestamp = Get-Date -UFormat %s
                    $content | Out-File -FilePath (join-path $env:USERPROFILE "fingered\$finger\$timestamp.txt")
                    Write-Output (Get-Childitem (join-path $env:USERPROFILE "fingered\$finger\$timestamp.txt")),$Content
                } else {
                    Write-Verbose "Here is the last thing posted by $finger"   
                    Write-Output $lastFinger.fullName,$Content
                }
            }
        }
    }
    
    end {
        
    }
}

function Tap-Someone {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $tapList = (join-path $env:USERPROFILE 'fingered\tapList.csv'),
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $user
    )
    
    begin {
        
    }
    
    process {
        add-content -Value $user -Path $tapList
        write-output (get-content $tapList)
    }
    
    end {
        
    }
}

function Check-Taps {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $tapList = (join-path $env:USERPROFILE 'fingered\tapList.csv')
    )
    
    begin {
        $newContent = @()
        $taps = Get-Content $tapList
        $timespan = new-timespan -Minutes 5
        foreach ($user in $taps) {
            if($user -eq ""){

            } else {
                Write-Verbose "Checking $user"
                $finger = Finger-Someone -User $user
                $lastWriteTime = (gci $finger[0]).LastWriteTime
                if (((get-date) - $lastwritetime) -gt $timespan) {
                } else {
                    $update = [PSCustomObject]@{
                        user = $user
                        content = $finger[0]
                    }
                    $newContent += $update
                }
            }
        }   
        if($newContent.length -eq 0){
            Write-Verbose "No new content."
            write-output $newContent
        } else{
            write-output $newContent
        }
        
    }
    
    process {
        
    }
    
    end {
        
    }
}

function Publish-PlanFile {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $Path,
        # Credentials
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]
        $Credentail = $host.UI.PromptForCredential('Log into HappyNetBox.com','Please Enter your HappyNetBox Handle and Password Credentials','','')
    )
    
    begin {
        $request = Invoke-WebRequest 'https://www.happynetbox.com/claim' -SessionVariable my_session
        $Content = Get-Content $Path
        $form = $request.forms[0]
        $form.Fields['handle'] = $Credentail.UserName
        $form.Fields['password'] = $Credentail.GetNetworkCredential().Password
        $request = Invoke-WebRequest -uri 'https://www.happynetbox.com/claim' -WebSession $my_session -Method POST -Body $form.Fields

        if ($request.content -like "*password mismatch*") {
            Write-Error -Message "Password Mismatch"
            return
        }
    }
    
    process {
        $form = $request.forms[0]
        $form.fields['content'] = $content
        $uri = "https://www.happynetbox.com" + $form.action
        $request = Invoke-WebRequest -Uri $uri -WebSession $my_session -Method $form.method -Body $form.fields
    }
    
    end {
        
    }
}