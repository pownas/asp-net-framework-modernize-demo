#!/usr/bin/env pwsh
<#
.SYNOPSIS
	BookCatalog Database Setup Script

.DESCRIPTION
	This script sets up the BookCatalog database on LocalDB or SQL Server Express.
	It will create the database, tables, and seed sample data.

.PARAMETER SqlInstance
	The SQL Server instance to connect to. 
	Default: (LocalDB)\MSSQLLocalDB
	Examples: 
	- (LocalDB)\MSSQLLocalDB (default)
	- localhost\SQLEXPRESS
	- servername\INSTANCENAME
	- servername (for default instance)

.PARAMETER DatabaseName
	The name of the database to create.
	Default: BookCatalog

.PARAMETER ScriptPath
	Optional: Direct path to the SQL script. 
	If not provided, script looks in the same directory as this script.

.EXAMPLE
	.\Initialize-Database.ps1
	Creates BookCatalog database on LocalDB

.EXAMPLE
	.\Initialize-Database.ps1 -SqlInstance "localhost\SQLEXPRESS"
	Creates BookCatalog database on SQL Server Express

.EXAMPLE
	.\Initialize-Database.ps1 -SqlInstance "localhost\SQLEXPRESS" -DatabaseName "CatalogDb"
	Creates CatalogDb database on SQL Server Express

.NOTES
	Prerequisites:
	- SQL Server or LocalDB must be installed
	- User must have appropriate permissions to create databases
	- Run from the App_Data directory or provide -ScriptPath parameter
#>

param(
	[string]$SqlInstance = ".", # or LocalDB param: "(LocalDB)\MSSQLLocalDB"
	[string]$DatabaseName = "BookCatalog",
	[string]$ScriptPath = ""
)

# Script configuration
$ErrorActionPreference = "Stop"

# Determine the script directory with multiple fallback methods
$scriptDir = $null

# Method 1: Try using $PSScriptRoot (most reliable in PowerShell 3.0+)
if ($PSScriptRoot) {
	$scriptDir = $PSScriptRoot
}
# Method 2: Try using MyInvocation.MyCommand.Path (works when script is called directly)
elseif ($MyInvocation.MyCommand.Path) {
	$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
}
# Method 3: Use current directory as fallback
else {
	$scriptDir = (Get-Location).Path
	Write-Host "Note: Using current directory. Consider running from the script directory." -ForegroundColor Yellow
}

# If ScriptPath is provided, use it; otherwise look for the SQL script in the script directory
if ($ScriptPath -and (Test-Path $ScriptPath)) {
	$sqlScriptPath = $ScriptPath
}
else {
	$sqlScriptPath = Join-Path $scriptDir "BookCatalog_CreateDatabase.sql"
}

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "BookCatalog Database Setup" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if SQL script exists
if (-not (Test-Path $sqlScriptPath)) {
	Write-Host "ERROR: SQL script not found at: $sqlScriptPath" -ForegroundColor Red
	Write-Host ""
	Write-Host "Troubleshooting:" -ForegroundColor Yellow
	Write-Host "  1. Ensure you are running this script from the App_Data directory"
	Write-Host "  2. Verify BookCatalog_CreateDatabase.sql exists in the same directory"
	Write-Host "  3. Or provide the full path using: .\Initialize-Database.ps1 -ScriptPath 'C:\path\to\BookCatalog_CreateDatabase.sql'"
	Write-Host ""
	exit 1
}

Write-Host "Configuration:" -ForegroundColor Green
Write-Host "  SQL Instance: $SqlInstance"
Write-Host "  Database Name: $DatabaseName"
Write-Host "  SQL Script: $sqlScriptPath"
Write-Host ""

# Verify SQL Server accessibility
Write-Host "Step 1: Verifying SQL Server connection..." -ForegroundColor Yellow

try {
	$connection = New-Object System.Data.SqlClient.SqlConnection
	$connection.ConnectionString = "Server=$SqlInstance;Integrated Security=True;Connection Timeout=5;"
	$connection.Open()
	$connection.Close()
	Write-Host "  ✓ Successfully connected to $SqlInstance" -ForegroundColor Green
}
catch {
	Write-Host "  ✗ Failed to connect to $SqlInstance" -ForegroundColor Red
	Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
	Write-Host ""
	Write-Host "Troubleshooting:" -ForegroundColor Yellow
	Write-Host "  - Ensure SQL Server/LocalDB is installed and running"
	Write-Host "  - For LocalDB: Run 'sqllocaldb start mssqllocaldb' in Command Prompt"
	Write-Host "  - For SQL Server Express: Start the service from SQL Server Configuration Manager"
	exit 1
}

# Execute SQL script
Write-Host ""
Write-Host "Step 2: Executing database setup script..." -ForegroundColor Yellow

try {
	$sqlContent = Get-Content $sqlScriptPath -Raw
	$connection = New-Object System.Data.SqlClient.SqlConnection
	$connection.ConnectionString = "Server=$SqlInstance;Integrated Security=True;"
	$connection.Open()

	# Split script by GO commands (simplified)
	$sqlBatches = $sqlContent -split "GO\s*`n" | Where-Object { $_.Trim() -ne "" }

	$batchCount = 0
	foreach ($batch in $sqlBatches) {
		if ($batch.Trim() -ne "") {
			$command = $connection.CreateCommand()
			$command.CommandText = $batch
			$command.CommandTimeout = 30
			$command.ExecuteNonQuery() | Out-Null
			$batchCount++
		}
	}

	$connection.Close()
	Write-Host "  ✓ Database setup completed successfully ($batchCount batches executed)" -ForegroundColor Green
}
catch {
	Write-Host "  ✗ Failed to execute database setup script" -ForegroundColor Red
	Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
	exit 1
}

# Verify database creation
Write-Host ""
Write-Host "Step 3: Verifying database and tables..." -ForegroundColor Yellow

try {
	$connection = New-Object System.Data.SqlClient.SqlConnection
	$connection.ConnectionString = "Server=$SqlInstance;Database=$DatabaseName;Integrated Security=True;"
	$connection.Open()

	$command = $connection.CreateCommand()
	$command.CommandText = "SELECT COUNT(*) as BookCount FROM Books"
	$bookCount = $command.ExecuteScalar()

	$connection.Close()
	Write-Host "  ✓ Database verified - Found $bookCount books in the Books table" -ForegroundColor Green
}
catch {
	Write-Host "  ✗ Failed to verify database" -ForegroundColor Red
	Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
	exit 1
}

# Success message
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Connection String:" -ForegroundColor Green
Write-Host "  Server=$SqlInstance;Database=$DatabaseName;Integrated Security=True;"
Write-Host ""
Write-Host "You can now start the BookCatalog application." -ForegroundColor Green
Write-Host ""
