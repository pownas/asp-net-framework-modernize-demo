# BookCatalog Database Setup

This folder contains the database initialization script for the BookCatalog application.

## Quick Start

### Option 1: Using LocalDB (Recommended for Development)

1. **Ensure LocalDB is installed**
   - LocalDB comes with Visual Studio
   - To verify: Open a command prompt and run `sqllocaldb info`
   - If not installed, download from: https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/sql-server-express-localdb

2. **Create and seed the database**
   - Open SQL Server Management Studio (SSMS) or Azure Data Studio
   - Connect to: `(LocalDB)\MSSQLLocalDB`
   - Open `BookCatalog_CreateDatabase.sql` from this folder
   - Execute the script (F5)

3. **Start the application**
   - The application will now connect to your local BookCatalog database
   - The database includes 7 sample books pre-loaded

### Option 2: Using SQL Server Express

If you prefer SQL Server Express instead of LocalDB:

1. **Install SQL Server Express**
   - Download from: https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/sql-server-express

2. **Update the connection string**
   - Open `Web.config` in the BookCatalog.Web project root
   - Uncomment the SQL Server Express connection string
   - Comment out the LocalDB connection string

3. **Create and seed the database**
   - Open the database management tool and connect to `localhost\SQLEXPRESS`
   - Execute `BookCatalog_CreateDatabase.sql`

## Connection Strings

### LocalDB (Default)
```
Server=(LocalDB)\MSSQLLocalDB;Database=BookCatalog;Integrated Security=True;
```

### SQL Server Express
```
Server=localhost\SQLEXPRESS;Database=BookCatalog;Integrated Security=True;
```

### SQL Server (Named Instance)
```
Server=localhost\INSTANCENAME;Database=BookCatalog;Integrated Security=True;
```

## Database Schema

The script creates:
- **Books table** with columns:
  - Id: Primary key (auto-increment)
  - Title: Book title (required)
  - Author: Author name (required)
  - ISBN: ISBN-10 or ISBN-13
  - PublishedYear: Year the book was published
  - IsActive: Boolean flag for active status
  - CreatedDate: Timestamp when record was created
  - UpdatedDate: Timestamp when record was last updated
  - Version: Row version for concurrency control

## Resetting the Database

To completely reset the database and start fresh:

1. Execute `BookCatalog_CreateDatabase.sql` again
2. The script includes logic to drop and recreate the database

## Troubleshooting

### "Cannot connect to (LocalDB)\MSSQLLocalDB"
- Ensure LocalDB is running: `sqllocaldb start mssqllocaldb`
- Verify LocalDB is installed: `sqllocaldb info`

### "Database already exists"
- The script automatically drops the existing database if present
- Run the script again to reset

### "Login failed for user"
- Ensure "Integrated Security" is enabled in your connection string
- Verify you're running with appropriate Windows credentials

## For Production

For production environments:
- Use a dedicated SQL Server instance
- Update the connection string in `Web.config` or use environment variables
- Implement proper backup and recovery procedures
- Use SQL Server authentication if appropriate for your environment
