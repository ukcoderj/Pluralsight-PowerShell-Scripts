# File handling

Clear-Host
Set-Location "C:\Users\...path here...\Pluralsight-PowerShell-Scripts"

Get-ChildItem "*.md"

# Read contents into a variable - reads into an array!
Get-Content "README.md"
$a = Get-Content "README.md"
Clear-Host
$a

$a.GetType()

Clear-Host

for($i = 0; $i -le $a.Count; $i++)
{
    Write-Host "`t`t" + $a[$i]
}

# Combine from array of text to one big lot of text
$separator = [System.Environment]::NewLine # could have been `r`n
$all  = [string]::Join($separator, $a)
$all
$all.GetType()



# Write to a file
$fileToWriteTo = "readme-copy.txt"
Get-ChildItem $fileToWriteTo
$allU = $all + "`r`nDONE!!!!!!!!!!!!!!!!!"

# destructive set - overwrites existing file.
Set-Content -Value $allU -Path $fileToWriteTo

# Update a file
Add-Content -Value "`r`nMore from Powershell" -Path $fileToWriteTo


# clean up
Remove-Item $fileToWriteTo




# CSV -----------------------------------------------------
#Pump the data from Get-Process into a csv
$csvFileName = "processes.csv"
Get-Process | Export-CSV $csvFileName #warning: This created a wierd top row we had to delete

# read the data out
$header = "Name","SI","Handles","VM","WS","PM","NPM","Path","Company","CPU","FileVersion","ProductVersion","Description","Product","__NounName","BasePriority","ExitCode","HasExited","ExitTime","Handle","SafeHandle","HandleCount","Id","MachineName","MainWindowHandle","MainWindowTitle","MainModule","MaxWorkingSet","MinWorkingSet","Modules","NonpagedSystemMemorySize","NonpagedSystemMemorySize64","PagedMemorySize","PagedMemorySize64","PagedSystemMemorySize","PagedSystemMemorySize64","PeakPagedMemorySize","PeakPagedMemorySize64","PeakWorkingSet","PeakWorkingSet64","PeakVirtualMemorySize","PeakVirtualMemorySize64","PriorityBoostEnabled","PriorityClass","PrivateMemorySize","PrivateMemorySize64","PrivilegedProcessorTime","ProcessName","ProcessorAffinity","Responding","SessionId","StartInfo","StartTime","SynchronizingObject","Threads","TotalProcessorTime","UserProcessorTime","VirtualMemorySize","VirtualMemorySize64","EnableRaisingEvents","StandardInput","StandardOutput","StandardError","WorkingSet","WorkingSet64","Site","Container"
$processes = Import-Csv $csvFileName -Header $header
$processes


#XML FIles
$courseTemplate = @"
<courses version="1.0">
    <course>
        <name></name>
        <course></course>
    </course>
</courses>
"@

# Create an XML file
$xmlFileName = "C:\Users\...path here...\Pluralsight-PowerShell-Scripts\Courses.xml" #full path needed for load
$xmlFileNameU = "C:\Users\...path here...\\Pluralsight-PowerShell-Scripts\Courses-updated.xml" #full path needed for load
$courseTemplate | Out-File $xmlFileName

# Create a new XML variable and load it from the file
$courseXML = New-Object xml
$courseXML.Load($xmlFileName)

# Grab the template
$newCourse = (@($courseXML.courses.course)[0]).Clone()

$header = "Name", "Course"
$coursecsv = Import-Csv "courses.csv" -header $header

for($i = 0; $i -lt $coursecsv.Count; $i++)
{
    $newCourse = $newCourse.Clone()
    $newCourse.Name = $coursecsv[$i].Name
    $newCourse.Course = $coursecsv[$i].Course
    $courseXML.Courses.AppendChild($newCourse) > $null # >$null - don't echo to screen
}

$courseXML.Courses.Course |
    Where-Object { $_.Name -eq "" } |
    ForEach-Object { [void]$courseXML.Courses.RemoveChild($_) }

#save to xml
$courseXML.Save($xmlFileNameU);

#open it and show as plain text
$testXML = Get-Content $xmlFileNameU
$testXML

#open it and use it as xml - NOTE: Specify xml type!
[xml]$myCourseXML = Get-Content $xmlFileNameU
foreach($course in $myCourseXML.Courses.Course)
{
    Write-Host $course.Name "made a course on " $course.Course
}














