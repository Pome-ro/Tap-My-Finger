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
                Write-Output $content
            } else {
                $lastFinger = $archive[$archive.count - 1]
                $content | out-file -filepath  (join-path $env:TEMP "temp.txt")
                $dif = Compare-Object -ReferenceObject (get-content $lastFinger.fullname) -DifferenceObject (get-content (join-path $env:TEMP temp.txt))

                if($dif){
                    Write-Verbose "Daddy made you some content, open wide!"   
                    $timestamp = Get-Date -UFormat %s
                    $content | Out-File -FilePath (join-path $env:USERPROFILE "fingered\$finger\$timestamp.txt")
                    Write-Output $Content
                } else {
                    Write-Verbose "Here is the last thing posted by $finger"   
                    write-output $content
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
        $tapList = (join-path $env:USERPROFILE "fingered") + 'tapList.csv',
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $user
    )
    
    begin {
        
    }
    
    process {
        add-content -Value $user -Path $tapList
        write-output $tapList
    }
    
    end {
        
    }
}

function Check-Taps {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $tapList = (join-path $env:USERPROFILE 'tapList.csv')
    )
    
    begin {
        $newContent = @()
        Convertfrom-CSV -Path $tapList
        foreach ($user in $tapList) {
            $content
        }
        
    }
    
    process {
        
    }
    
    end {
        
    }
}
