#putting script in a block means it wont run when you execute #e.g.
{Clear-Host; "Powershell"}

$var1 = {Clear-Host; "Powershell in var"}

#use an ampersand to execute it e.g.
& $var1
& {Clear-Host; "Powershell - straight out"}


$coolwall = {"Fiesta. Really?"}
for($i = 0; $i -lt 3; $i++)
{
    &$coolwall
}


$fourtyTwo = {41 + 1}
&$fourtyTwo

1 + (&$fourtyTwo)


# Remeber a script block will return the first value that isnt consumed by default
# e.g.
$value = {42; Write-Host "PluralSight"}
&$value #writes "42, pluralsight" (but returns 42)
1 + (&$value) #43!

$fourtyTwo = &$value
$fourtyTwo

# you have to return a value (as with C#) - return at end, obvs
$value = { 42; Write-Host "PL"; return 9}
$nine = &$value
$nine

### PARAMETERS/ ARGS 1 -> can pass arguments like so (allows for null checking if unsure of number args in)
$qa = {
    $question = $args[0]
    $answer = $args[1]
    Write-Host "Question = $question, Answer = $answer"
}

&$qa "Which ice cream?" "Solero"


### PARAMETERS/ ARGS 2 -> can pass arguments like so (clearer)
$qa = {
    param($question, $answer)
    Write-Host "Question = $question, Answer = $answer"
}

&$qa "Which ice cream now?" "Still Solero"

&$qa -question "Do you like powershell?" -answer "Very much!"



















