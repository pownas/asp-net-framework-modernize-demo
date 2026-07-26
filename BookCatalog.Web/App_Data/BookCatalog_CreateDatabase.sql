-- BookCatalog Database Creation Script
-- This script creates the BookCatalog database and initializes it with sample data
-- 
-- Usage:
-- 1. Open SQL Server Management Studio or Azure Data Studio
-- 2. Connect to (LocalDB)\MSSQLLocalDB
-- 3. Execute this script (F5 or execute from File menu)
-- 4. The database will be created with the Books table and sample data

-- Drop database if it exists (for fresh start)
IF EXISTS (SELECT * FROM sys.databases WHERE name = N'BookCatalog')
BEGIN
	ALTER DATABASE [BookCatalog] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [BookCatalog];
END
GO

-- Create the database
CREATE DATABASE [BookCatalog]
GO

-- Use the newly created database
USE [BookCatalog]
GO

-- Create the __MigrationHistory table (required by Entity Framework)
-- This allows EF to track database schema version
CREATE TABLE [dbo].[__MigrationHistory] (
	[MigrationId] NVARCHAR(150) NOT NULL PRIMARY KEY,
	[ContextKey] NVARCHAR(300) NOT NULL,
	[Model] VARBINARY(MAX) NOT NULL,
	[ProductVersion] NVARCHAR(32) NOT NULL
)
GO

-- Create the Books table
CREATE TABLE [dbo].[Books] (
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[Title] NVARCHAR(255) NOT NULL,
	[Author] NVARCHAR(255) NOT NULL,
	[ISBN] NVARCHAR(20),
	[PublishedYear] INT,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
	[UpdatedDate] DATETIME NULL,
	[Version] ROWVERSION
)
GO

-- Create indexes
CREATE INDEX [IX_Books_Title] ON [dbo].[Books]([Title])
GO

CREATE INDEX [IX_Books_Author] ON [dbo].[Books]([Author])
GO

-- Insert sample data
INSERT INTO [dbo].[Books] ([Title], [Author], [ISBN], [PublishedYear], [IsActive], [CreatedDate])
VALUES 
	(N'The Hitchhiker''s Guide to the Galaxy', N'Douglas Adams', N'9780345391803', 1979, 1, '2001-03-15'),
	(N'Design Patterns: Elements of Reusable OO Software', N'Gamma, Helm, Johnson, Vlissides', N'9780201633610', 1994, 1, '2000-06-01'),
	(N'The Pragmatic Programmer', N'David Thomas, Andrew Hunt', N'9780135957059', 1999, 1, '2001-01-10'),
	(N'Clean Code', N'Robert C. Martin', N'9780132350884', 2008, 1, '2008-08-11'),
	(N'The Lord of the Rings', N'J.R.R. Tolkien', N'9780618640157', 1954, 1, '1999-12-01'),
	(N'Jurassic Park', N'Michael Crichton', N'9780345370778', 1990, 1, '2001-07-22'),
	(N'The Matrix: The Shooting Script', N'Andy & Larry Wachowski', N'9781557044488', 2001, 0, '2001-11-06')
GO

-- Verify data
SELECT * FROM [dbo].[Books]
GO

PRINT 'BookCatalog database created successfully!'

