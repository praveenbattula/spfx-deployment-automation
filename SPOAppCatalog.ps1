                             ###########################
                                # SPOAppCatalog.ps1 #
                             ###########################

#################
# Variables #
#################
# App Catalog site #
$catalogSite = "https://praveenbattula.sharepoint.com/sites/praveen" 


Write-Host ***************************************** -ForegroundColor Yellow
Write-Host * Uploading the sppkg on the AppCatalog * -ForegroundColor Yellow
Write-Host ***************************************** -ForegroundColor Yellow

$currentLocation = Get-Location | Select-Object -ExpandProperty Path

Write-Host ($currentLocation + "\config\package-solution.json")

$packageConfig = Get-Content -Raw -Path ($currentLocation + "\config\package-solution.json") | ConvertFrom-Json
$packagePath = Join-Path ($currentLocation + "\sharepoint\") $packageConfig.paths.zippedPackage -Resolve 

Write-Host "packagePath: $packagePath"

$skipFeatureDeployment = $packageConfig.solution.skipFeatureDeployment
Connect-PnPOnline $catalogSite -Credentials:spoCredentials

# Adding and publishing the App package
If ($skipFeatureDeployment -ne $true) {
  Write-Host "skipFeatureDeployment = false"
  Add-PnPApp -Path $packagePath -Scope Site -Overwrite -Publish
  Write-Host *************************************************** -ForegroundColor Yellow
  Write-Host * The SPFx solution has been succesfully uploaded and published to the AppCatalog * -ForegroundColor Yellow
  Write-Host *************************************************** -ForegroundColor Yellow
}
Else {
  Write-Host "skipFeatureDeployment = true"
  Add-PnPApp -Path $packagePath -SkipFeatureDeployment -Publish -Overwrite
  Write-Host *************************************************** -ForegroundColor Yellow
  Write-Host * The SPFx solution has been succesfully uploaded and published to the AppCatalog * -ForegroundColor Yellow
  Write-Host *************************************************** -ForegroundColor Yellow
}