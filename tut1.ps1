cls
Get-Command

#verb search
Get-Command -verb "Get"
Get-Command -Noun "Service"

# Getting Help
Get-Help Get-Command
Get-Help Get-Command -examples
Get-Help Get-Command -detailed

Get-Command -? - examples

#Changing path
Set-Location "C:\Temp"

#Pipelining lets you push objects into another query $_ = current object
Get-ChildItem | Where-Object { $_.Length -gt 100kb }
Get-ChildItem | Where-Object { $_.Length -gt 100mb }

Get-ChildItem | Where-Object { $_.Length -gt 100kb } | Sort-Object Length

#can split across lines if you use the pipe as the end char
Get-ChildItem | 
    Where-Object { $_.Length -gt 100kb } | 
    Sort-Object Length


Get-ChildItem | 
    Where-Object { $_.Length -gt 100kb } | 
    Sort-Object Length |
    Format-Table -Property Name, Length -AutoSize


# can specify properties to view using Select-Object - Folders have length, so have blank l
Get-ChildItem | Select-Object Name, Length | Sort-Object Length

# Providers are .NET objects that are called to do the job.
# Find providers for each drive.
Clear-Host
Get-PSDrive

#Get environment vars
Clear-Host
Set-Location env:
Get-ChildItem

Get-Help -verb "Alias"
Get-Alias


# Add new providers via snap-ins
Get-PSSnapin
Get-PSSnapin -Name "*power*"

#all varibales begin with $, but then we can use .net functions. e.g. 
$a = "Just learning powershell"
$a
$a.Length
$a.GetType()



#######################################################
# Variables
#######################################################

$hi = "Hello world"
Write-Host $hi
#short form output
$hi

# fully mutable
$hi.GetType()
$hi = 6
$hi.GetType()

#type safe
[int]$myInt = 12 #strongly typed
$myInt
$myInt = "This cannot happen!"

# Can use any .NET extension meothd - e.g.
(42).GetType()
"pluralsight rocks".ToUpper()


$var = 42
$var  -gt 40
$var -lt 40
$var -eq 42

# -le ge, string -Match -NotMatch Like, -NotLIke

#Powershell will convert data type from right to left
# eg.  this works
42 -eq "42" #true
42 -eq "042" #true
"042" -eq 0 #false


#variable commandlets (actually being called under the hood)
Remove-Variable var
New-Variable -name var -value 123
$var

#view
Get-Variable var -ValueOnly
Get-Variable var
Get-Variable #all variables!

#Assign new value
Set-Variable -Name var -Value 789
$var

#Clear contents of variable
Clear-Variable -Name var
$var
Get-Variable -Name var


# remove variable completely
Remove-Variable -Name var
Get-Variable -Name var # error
$var # this would create a new variable!

Clear-Host
# can use single or double quotes. Use like js to mix
"This is a 'string' right"
'This is another "string" right'
"This is a doubled up ""string"" right"

# use backtick for escape sequence special commands within strings e.g. 
"plural`bsight" #doesn't come out in this output but does in reality.
"new`nline" # 2 lines
"plural`r`nsight" #clrf
"plural`tsight" #tabs

# here strings use @" "@ to make multiple lines (can do with single quotes)
$heretext = @"
This is a test
Of some text

and now we're done
"@ #must be on new line!

$heretext

#string interpolation (only works double quotes). To print the variable name exact, use backtick to escape
$items = (Get-ChildItem).Count
$loc = Get-Location
"There are $items items in the folder $loc"

"I can add directly -> 5 + 1 = $(5+1)"
"There are {0} items in location {1}" -f $items, $loc
[string]::Format("Ther eare {0} items", $items) #dotnet syntax!
"The 20% tip of a 33.33 dollar bill is {0:0.00} dollars" -f (33.33 * 0.2)

"Pluralsight" -like "Plural*" # string match *,? (single char .eg. ?lural) and Plural*[s-v] - ends in chars between s and v)
# can also use regex!
"888-368-1240" -match "[0-9]{3}-[0-9]{3}-[0-9]{4}" #us phone regex

#array
$arr1 = "ty", "toys"
$arr1[0]
$arr1.GetType()
$arr1
$arr1[0] = "test"
$arr1

$arr1 = @("plural", "sight")
$arr1 = @() #empty array

#shortcut numeric
$arr1 = 1..5
$arr1

$arr1 -contains 3
$arr1 -notcontains 3 #confusing double negative


#hash tables
$hash1 = @{"Key"          = "Value";
            "Pluralsight" = "pluralisight.com";
            "Google"      = "google.com" }
$hash1
$hash1["Pluralsight"]
$hash1."Pluralsight"
$mykey = "Pluralsight"
$hash1.$mykey
#new value
$hash1["NewKey"] = "NewValue"
$hash1

$hash1.Remove("NewKey")
$hash1

# key exists?
$hash1.ContainsKey("NewKey")
$hash1.ContainsValue("NewValue")


#list keys and vlaues
$hash1.Keys
$hash1.Values

$hash1.Keys -contains "Pluralsight"

#Built in variables - in powershell by default

$false
$true
$NULL
$pwd #working dir
$home # users home dir
$host #machine info
$pid # prociess id
$PSVersionTable #current version powershell

#current object
Get-ChildItem | Where-Object {$_.Name -like "*.ps1"}



################################################################################
#### Programming ###############################################################
################################################################################

#if/else - there is no elseif

Clear-Host

$var = 2
if($var -eq 1)
{
    "If branch"
}
else
{
    "Else branch"
    if($var -eq 2)
    {
        "2"
    }
    else
    {
        "Something else"
    }
}


# swtich (can also pass in arrays)
# Comparisons are case INsenitive unless you use swtich -caseinsensitive
# remember will fall through without breaks. Don't get the for free!
Clear-Host

$var = 42
switch($var)
{
    41 {"Fourty One"; break}
    42 {"Fourty Two" ;break }
    "42" {"Fourty Two String"; break}
    43 {"Fourty Three"; break}
    default {"default"; break}
}

#wildcard switch - all here will match (and fall through without break.
Clear-Host
switch -Wildcard ("Pluralsight")
{
    "plural*" {"*"}
    "?luralsight" {"?"}
    "?luralsi???" {"???"}
}


# Loops

$i = 1
while  ($i -le 5)
{
    "`$i = $i"
    $i++
}

#has do-while and a do/until loop (e.g. until x > 5)

#for loop
for($f = 0; $f -le 5; $f++)
{
    "`$f = $f"
}


#iterate array
Clear-Host
$array = 11..15

for($i=0; $i -lt $array.Length; $i++)
{
    "`array[$i]=" + $array[$i]
}


#foreach
Clear-Host
foreach($row in $array)
{
    "`$row = $row"
}


#foreach on objects with filter.
foreach($file in Get-ChildItem)
{
    if($file.Name -like "*.json")
    {
        $file.Name
        #break/ continue possible
    }    
}

#breaking works normally, but an inner loop can exit an outer loop with "labelling"
#labelling loops and exiting them!
Clear-Host
:outsideloop foreach($outside in 1..3)
{
    "`$outside=$outside"
    foreach($inside in 4..6)
    {
        "     `$inside=$inside"
        break outsideloop #can continue outsideloop also!
    }
}
















