<#
.SYNOPSIS
A script used to backup all files in a directory to a specified location.

.DESCRIPTION
This script is used to backup all files in a directory to a specified location. The script will create a zip file of the directory and store it in the specified location using the current date and time as the filename.

.PARAMETER SourceDirectory
The directory to backup.

.PARAMETER DestinationDirectory
The directory where the backup zip file will be saved.

.EXAMPLE
.\BackupDirectory.ps1 -SourceDirectory "C:\SourceDirectory" -DestinationDirectory "C:\DestinationDirectory"
#>



# Parameters for source and destination directories
param(
    [Parameter(Mandatory = $true)]
    [string]$SourceDirectory,

    [Parameter(Mandatory = $true)]
    [string]$DestinationDirectory
)

try {
    # Check to ensure the source directory is a valid directory
    if (-not (Test-Path -Path $SourceDirectory -PathType Container)) {
        # If the source directory is invalid, exit the script with an error
        Write-Error "The given source directory is invalid."
        exit 1
    }
    else {
        # Get current time and append to destination directory to create a unique filename
        $currentTime = Get-Date -Format "yyyyMMdd_HHmmss"
        $lowLevelSourceDirectory = Split-Path -Path $SourceDirectory -Leaf
        # The backup file will have the lowest level directory from the source and the current time
        $backupFileName = "Backup_{0}_{1}.zip" -f $lowLevelSourceDirectory, $currentTime

        # Create the destination directory if it doesn't exist
        if (-not (Test-Path -Path $DestinationDirectory -PathType Container)) {
            New-Item -ItemType Directory -Path $DestinationDirectory | Out-Null
        }

        # Create the zip file
        $zipFilePath = Join-Path -Path $DestinationDirectory -ChildPath $backupFileName
        Compress-Archive -Path $SourceDirectory -DestinationPath $zipFilePath

        # Success message
        Write-Output "Backup completed successfully."
        Write-Output "Saved to: $zipFilePath"
    }
}
catch {
    # General error handling
    Write-Error "Backup failed due to the following error: $($_.Exception.Message)"
    exit 1
}