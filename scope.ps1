#vars outside script block available inside block
Clear-Host
$var = 42
& { Write-Host $var}

#If you ASSIGN NEW VALUE within a script block, A COPY of the variable is made
Clear-Host
$var = 42
& { 
    $var = 32
    Write-Host $var #32
  }
Write-Host $var #42


# set within a script block - use SCOPE to set value outside of script block 1 = parent, 2 = grandparent...
# Get-Variable and Set-Variable have scope.
# Bad practice though. Should return from script block!
Clear-Host
$var = 42
& { 
    Set-Variable var -Scope 1 10
    Write-Host $var #10
  }
Write-Host $var #10!


#can make a global variable from anywhere accessible anywhere
$global:var50 = 50

#private variables can be made in the same way. e.g.
& {
    $private:privateVar = 50;
  }
Write-Host $private:privateVar #null











