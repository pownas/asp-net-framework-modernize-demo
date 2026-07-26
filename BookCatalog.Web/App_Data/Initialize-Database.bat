@echo off
REM BookCatalog Database Setup Batch File
REM This script sets up the BookCatalog database using sqlcmd

setlocal enabledelayedexpansion

echo.
echo ================================================
echo BookCatalog Database Setup
echo ================================================
echo.

REM Check if sqlcmd is available
where sqlcmd >nul 2>nul
if errorlevel 1 (
	echo ERROR: sqlcmd not found. Please ensure SQL Server tools are installed.
	echo.
	echo To install SQL Server command-line tools:
	echo - Download SQL Server Management Studio from: https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms
	echo - Or download SQL Server Command Line Utilities
	echo.
	pause
	exit /b 1
)

echo Configuration:
echo   SQL Instance: (LocalDB)\MSSQLLocalDB
echo   Database Name: BookCatalog
echo.

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0

echo Step 1: Testing connection to (LocalDB)\MSSQLLocalDB...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "SELECT @@VERSION" >nul 2>nul
if errorlevel 1 (
	echo ERROR: Cannot connect to (LocalDB)\MSSQLLocalDB
	echo.
	echo Troubleshooting:
	echo - Ensure LocalDB is installed with Visual Studio
	echo - Run "sqllocaldb start mssqllocaldb" in Command Prompt to start LocalDB
	echo - Run "sqllocaldb info" to check if LocalDB is installed
	echo.
	pause
	exit /b 1
)
echo   [OK] Connected successfully

echo.
echo Step 2: Creating database and tables...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -i "%SCRIPT_DIR%BookCatalog_CreateDatabase.sql"
if errorlevel 1 (
	echo ERROR: Failed to create database
	pause
	exit /b 1
)

echo.
echo Step 3: Verifying database...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d "BookCatalog" -Q "SELECT COUNT(*) as BookCount FROM Books"
if errorlevel 1 (
	echo ERROR: Failed to verify database
	pause
	exit /b 1
)

echo.
echo ================================================
echo Setup Complete!
echo ================================================
echo.
echo Connection String:
echo   Server=(LocalDB)\MSSQLLocalDB;Database=BookCatalog;Integrated Security=True;
echo.
echo You can now start the BookCatalog application.
echo.
pause
