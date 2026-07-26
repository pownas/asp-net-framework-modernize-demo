# Quick Start Guide

## TL;DR - Setup in 30 seconds

### Windows
```bash
cd BookCatalog.Web\App_Data
Initialize-Database.bat
```

### PowerShell
```powershell
cd BookCatalog.Web\App_Data
.\Initialize-Database.ps1
```

### SSMS / Azure Data Studio
1. Connect to: `(LocalDB)\MSSQLLocalDB`
2. Open: `BookCatalog.Web\App_Data\BookCatalog_CreateDatabase.sql`
3. Execute: F5

---

## Connection Strings

| Environment | Connection String |
|---|---|
| **LocalDB** (default) | `Server=(LocalDB)\MSSQLLocalDB;Database=BookCatalog;Integrated Security=True;` |
| **SQL Server Express** | `Server=localhost\SQLEXPRESS;Database=BookCatalog;Integrated Security=True;` |
| **SQL Server** | `Server=SERVER_NAME;Database=BookCatalog;Integrated Security=True;` |

---

## Troubleshooting Quick Links

| Issue | Solution |
|-------|----------|
| LocalDB not found | Run `sqllocaldb info` or install SQL Server tools |
| LocalDB not running | Run `sqllocaldb start mssqllocaldb` |
| Connection refused | Check SQL Server is running in Services |
| Access Denied | Verify Windows credentials or use SQL auth |

---

## Database Contents

The database includes:
- **1 table**: Books (with 7 sample records)
- **2 indexes**: IX_Books_Title, IX_Books_Author
- **Columns**: Id, Title, Author, ISBN, PublishedYear, IsActive, CreatedDate, UpdatedDate, Version

---

## Next Steps

1. ✅ Run database setup (choose one method above)
2. 📁 Verify `BookCatalog` database exists in SQL Server
3. 🚀 Start the application
4. 🔍 Check /Books page shows sample data

---

## Need Help?

See **DATABASE_SETUP.md** for:
- Detailed setup instructions
- Connection string examples
- Complete troubleshooting guide
- Team development setup
