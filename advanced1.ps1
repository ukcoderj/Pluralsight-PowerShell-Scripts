# functions

function Get-FullName([string]$firstname, $lastname)
{
    Write-Host "$firstname $lastname"
}
# dont use parenthesis when calling
Get-FullName "Bob" "Builder"



#can pass by reference
function Set-FVar([ref]$fvar)
{
    $fvar.Value = 33
}
# dont use parenthesis when calling
$fvar = 42
Set-FVar ([ref] $fvar)
Write-Host $fvar


# pipeline function
function Get-PsFiles()
{
    begin { $retval = "PS files `r`n"}
    process{
        if($_.Name -like "*.ps1")
        {
            $retval = $retval + "`t" + $_.Name + "`r`n"
        }        
    }
    end { return $retVal }
}

Set-Location "C:\Users\"  #set proper location here.
Get-ChildItem
Get-ChildItem | Get-PsFiles



#filters - doesnt go through function, just reduces list to what we want.
filter Show-PS1Files
{
    $filename = $_.Name
    if($filename -like "*.ps1")
    {
        return $_
    }
}

Clear-Host
Get-ChildItem | Show-PS1Files

# Can chain filters and functions that use process!


function Get-ChildName()
{
    Write-Output ( Get-ChildItem | Select-Object "Name")
}

Get-ChildName | Where-Object { $_.Name -like "*.ps1" }


# Can use switches to decide whether verbose/debug. Could have custom switches
Clear-Host


# Custom tags within a comment block that get-help will recognise
# We have also added a summary here for get-help

function Get-ChildName()
{
<#

.SYNOPSIS
Returns a list of names for the child items on the current location

.DESCRIPTION
This function is similar to get-childitem, but only returns names

.EXAMPLE
Example 1 Simple Use
Get-ChildName -verbose

#>
    param([switch]$verbose, [switch]$debug)

    if($verbose.IsPresent)
    {
        $VerbosePreference = "Continue"
    }
    else
    {
        $VerbosePreference = "SilentlyContinue"
    }

    if($debug.IsPresent)
    {
        $DebugPreference = "Continue"
    }
    else
    {
        $DebugPreference = "SilentlyContinue"
    }

    Write-Verbose "Verbose message"
    Write-Output ( Get-ChildItem | Select-Object "Name")
    Write-Debug "Debug!"
}

Get-ChildName
Get-ChildName -verbose
Get-ChildName -debug
Get-ChildName -verbose -debug

Clear-Host
Get-Help Get-ChildName
Get-Help Get-ChildName -full


#Error handling

function divideFunc($enum, $denom)
{

    Write-Host "Begin"
    $result = $enum / $denom
    Write-Host "Result $result"
    Write-Host "Done"

    # trap errors at the bottom of the function for clarity

    #trap any errors
    trap [System.DivideByZeroException]
    {
        Write-Host "Div0#!"
        continue #continue to the next line after the error
    }
    trap
    {
        Write-Host "Error Occurred"
        Write-Host $_.ErrorID
        Write-Host $_.Exception.Message        
        break # stop function from running and go to parent, bubble error to parent.
    }
}

divideFunc 10 5
divideFunc 10 0
divideFunc 10 "dave"

&{
    divideFunc 10 "dave"

    trap{
        Write-Host "Inner function fail"
        continue
    }
}


