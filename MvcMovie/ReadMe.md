# MvcMovie - ASP.NET Core Modernized Application

A modernized ASP.NET Core application demonstrating migration from ASP.NET Framework MVC to contemporary .NET 10 with Entity Framework Core.

## Overview

MvcMovie is a classic movie database application showcasing:
- **ASP.NET Core MVC** architecture
- **Entity Framework Core** for data access
- **ASP.NET Core Identity** for authentication and authorization
- **Bootstrap 5** and **jQuery** for responsive UI
- **SQL Server LocalDB** for data persistence
- Two separate DbContexts: `ApplicationDbContext` (Identity) and `MovieDbContext` (Movie data)

## Prerequisites

- .NET 10 SDK or later
- Visual Studio 2026 (Community or higher) or Visual Studio Code
- SQL Server LocalDB (included with Visual Studio)
- PowerShell 5.0 or higher

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/pownas/asp-net-framework-modernize-demo
cd asp-net-framework-modernize-demo/MvcMovie
```

### 2. Restore Dependencies

```powershell
dotnet restore
```

### 3. Database Setup

The application automatically runs migrations on startup, which:
- Creates the `aspnet-MvcMovie-Identity` database for Identity data
- Creates the `aspnet-MvcMovie` database for Movie data
- Applies all pending Entity Framework Core migrations
- Seeds initial movie data

#### Connection Strings

Connection strings are configured in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=(LocalDb)\\MSSQLLocalDB;Initial Catalog=aspnet-MvcMovie-Identity;Integrated Security=true;",
    "MovieDbConnection": "Data Source=(LocalDb)\\MSSQLLocalDB;Initial Catalog=aspnet-MvcMovie;Integrated Security=true;"
  }
}
```

### 4. Run the Application

```powershell
dotnet run --project MvcMovie
```

The application will start at `https://localhost:5001` by default.

## Database Management

### Running Migrations

Migrations are applied automatically on application startup. If you need to manually apply migrations:

```powershell
# Apply migrations to a specific DbContext
dotnet ef database update --context MovieDbContext
dotnet ef database update --context ApplicationDbContext
```

### Creating a New Migration

```powershell
# For MovieDbContext
dotnet ef migrations add MigrationName --context MovieDbContext --output-dir Data/Migrations/Movie

# For ApplicationDbContext
dotnet ef migrations add MigrationName --context ApplicationDbContext --output-dir Data/Migrations/Identity
```

### Resetting the Database

If you encounter migration errors or need to reset the databases, drop them using:

```powershell
# Delete the MovieDbContext database
sqlcmd -S "(LocalDb)\MSSQLLocalDB" -Q "DROP DATABASE [aspnet-MvcMovie]"

# Delete the ApplicationDbContext database (Identity)
sqlcmd -S "(LocalDb)\MSSQLLocalDB" -Q "DROP DATABASE [aspnet-MvcMovie-Identity]"
```

Then restart the application - migrations will automatically recreate the databases.

## Project Structure

```
MvcMovie/
├── Controllers/          # MVC Controllers (MovieController, AccountController, etc.)
├── Models/              # Domain models (Movie, ApplicationUser, ViewModels)
├── Views/               # Razor views and layouts
├── Data/
│   ├── ApplicationDbContext.cs    # Identity DbContext
│   ├── MovieDbContext.cs          # Movie data DbContext
│   └── Migrations/                # EF Core migrations
├── wwwroot/             # Static files (CSS, JS, images)
│   └── lib/             # Client libraries (Bootstrap, jQuery)
├── Program.cs           # Application startup configuration
├── appsettings.json     # Configuration settings
└── ReadMe.md           # This file
```

## Features

### Movie Management
- **Browse** all movies in the database
- **Search** movies by title or genre
- **Filter** by genre with dropdown
- **Create** new movie entries
- **Edit** existing movies
- **Delete** movies from the database

### Authentication & Authorization
- User registration
- Secure login with ASP.NET Core Identity
- Password validation (min length 6, requires uppercase, lowercase, and digit)
- Session management

### UI Components
- Responsive Bootstrap 5 layout
- jQuery for interactive elements
- Validation scripts for form inputs

## Key Technologies

- **Framework:** ASP.NET Core (.NET 10)
- **ORM:** Entity Framework Core
- **Authentication:** ASP.NET Core Identity
- **Database:** SQL Server LocalDB
- **Frontend:** Bootstrap 5, jQuery
- **Build Tool:** .NET CLI

## Migration from ASP.NET Framework

This project demonstrates modernization from ASP.NET Framework MVC to ASP.NET Core:
- System.Web.Mvc → Microsoft.AspNetCore.Mvc
- EF6 → Entity Framework Core
- Web.config → appsettings.json
- Global.asax → Program.cs
- Traditional dependency injection → Built-in DI container

## Troubleshooting

### "Invalid object name 'Movies'" Error
This indicates the MovieDbContext database wasn't created or migrations failed to apply.

**Solution:** Drop and recreate the database:
```powershell
sqlcmd -S "(LocalDb)\MSSQLLocalDB" -Q "DROP DATABASE [aspnet-MvcMovie]"
```
Then restart the application.

### "String or binary data would be truncated" Error
This occurs when migration seed data exceeds column length constraints.

**Solution:** Ensure seed data in migrations respects column length constraints and rebuild.

### Database Connection Issues
Verify SQL Server LocalDB is installed and running:
```powershell
# Check LocalDB instances
sqllocaldb info

# Start LocalDB if not running
sqllocaldb start MSSQLLocalDB
```

## Configuration

### Development Settings

Modify `appsettings.Development.json` for development-specific settings:
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
```

### Connection Strings

Update connection strings in `appsettings.json` or via user secrets:
```powershell
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your-connection-string"
dotnet user-secrets set "ConnectionStrings:MovieDbConnection" "your-connection-string"
```

## Building

```powershell
# Build the project
dotnet build

# Publish for deployment
dotnet publish -c Release -o ./publish
```

## Testing

Run tests (if available):
```powershell
dotnet test
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

This project is part of an educational demonstration for ASP.NET Framework modernization.

## Support

For issues or questions, please open an issue in the repository.

---

**Last Updated:** 2026  
**Target Framework:** .NET 10  
**Status:** Modernization Complete
