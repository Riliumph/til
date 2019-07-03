function prompt () {  
  Write-Host "[$($env:USERNAME)@$($env:COMPUTERNAME): " -NoNewLine -ForegroundColor "Green"
  Write-Host (Get-Location).Path -ForegroundColor "Yellow"
  return "PS> "
}