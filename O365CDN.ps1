                                #################
                                # O365CDN.ps1 #
                                #################

#################
# Variables #
#################
# CDN SPO site #

$cdnSite = "https://praveenbattula.sharepoint.com/sites/praveen"
$cdnLib = "assets/SPFx" # => Document library and eventual folders


Write-Host ************************************************************************************** -ForegroundColor Yellow
Write-Host * Reading the cdnBasePath from write-manifests.json and collectiong the bundle files * -ForegroundColor Yellow
Write-Host ************************************************************************************** -ForegroundColor Yellow

$cdnConfig = Get-Content -Raw -Path .\config\copy-assets.json | ConvertFrom-Json
$bundlePath = Convert-Path $cdnConfig.deployCdnPath
$files = Get-ChildItem $bundlePath\*.*

Write-Host **************************************** -ForegroundColor Yellow
Write-Host Uploading the bundle on Office 365 CDN * -ForegroundColor Yellow
Write-Host **************************************** -ForegroundColor Yellow
Write-Host Connecting to SPO

Connect-PnPOnline $cdnSite -Credentials:spoCredentials
foreach ($file in $files) {
    $fullPath = $file.DirectoryName + "\" + $file.Name
    Add-PnPFile -Path $fullPath -Folder $cdnLib
}