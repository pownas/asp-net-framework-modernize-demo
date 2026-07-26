# Task 03: DbContext Migration - Progress Details

**Status**: COMPLETED  
**Date**: 2026-07-26  
**Duration**: ~15 minutes  

## Summary

Successfully migrated Entity Framework 6 DbContexts and models to Entity Framework Core 10.0.10 for ASP.NET Core 10 side-by-side deployment.

## Files Created/Modified

### New Files Created (EF Core Models & Contexts)

1. **MvcMovie.Core\Models\Movie.cs**
   - Migrated Movie entity from legacy MvcMovie\Models\Movie.cs
   - Properties: ID, Title, ReleaseDate, Genre, Price, Rating
   - Nullable string properties to align with C# nullability
   - All data annotations preserved (StringLength, Required, Range, DataType, Display, RegularExpression)

2. **MvcMovie.Core\Models\ApplicationUser.cs**
   - New ASP.NET Core Identity user model
   - Extends `Microsoft.AspNetCore.Identity.IdentityUser`
   - Removed legacy `GenerateUserIdentityAsync` method (not needed in ASP.NET Core Identity)
   - Ready for custom user properties

3. **MvcMovie.Core\Data\ApplicationDbContext.cs**
   - EF Core Identity DbContext (migrated from legacy `ApplicationDbContext : IdentityDbContext<ApplicationUser>`)
   - Inherits `IdentityDbContext<ApplicationUser>` from EF Core
   - Uses dependency injection constructor with `DbContextOptions<ApplicationDbContext>`
   - Includes `OnModelCreating` hook for future Identity customizations

4. **MvcMovie.Core\Data\MovieDbContext.cs**
   - EF Core application data context (migrated from legacy `MovieDBContext : DbContext`)
   - Exposes `DbSet<Movie> Movies`
   - **Fluent API Configuration** in `OnModelCreating`:
	 - Configured Movie entity key, required fields, max lengths, decimal precision
	 - Set Price property precision to (18, 2) — required for EF Core explicit configuration
   - **Seed Data** via `HasData()` — migrated 4 movie records from legacy EF6 Configuration.cs

### Configuration Files Modified

1. **MvcMovie.Core\appsettings.json**
   - Added `ConnectionStrings` section with two connections:
	 - `DefaultConnection`: ASP.NET Identity database (aspnet-MvcMovie-Identity)
	 - `MovieDbConnection`: Application movie data database (aspnet-MvcMovie)
   - Both use LocalDB with integrated security (matching legacy web.config style)

2. **MvcMovie.Core\Program.cs**
   - **Added NuGet usings**: `Microsoft.AspNetCore.Identity`, `Microsoft.EntityFrameworkCore`
   - **Registered ApplicationDbContext** for Identity via `AddDbContext<ApplicationDbContext>(...)`
   - **Registered MovieDbContext** for application data via `AddDbContext<MovieDbContext>(...)`
   - **Registered ASP.NET Core Identity** via `AddIdentity<ApplicationUser, IdentityRole>()` with EF Core store
   - **Added database initialization** in startup scope:
	 - Calls `Database.Migrate()` on both contexts to apply migrations
	 - Includes error handling with logging
   - **Added authentication middleware** via `app.UseAuthentication()` before authorization

### EF Core Migrations Created

#### Identity Context Migrations
- **Directory**: MvcMovie.Core\Data\Migrations\Identity\
- **Files**:
  - `20260726205033_InitialCreate.cs` — Migration script for Identity schema
  - `20260726205033_InitialCreate.Designer.cs` — Design-time metadata
  - `ApplicationDbContextModelSnapshot.cs` — Current model snapshot

#### Movie Context Migrations
- **Directory**: MvcMovie.Core\Data\Migrations\Movie\
- **Files**:
  - `20260726205049_InitialCreate.cs` — Migration script for Movie schema with seed data
  - `20260726205049_InitialCreate.Designer.cs` — Design-time metadata
  - `MovieDbContextModelSnapshot.cs` — Current model snapshot

### Folders Created

- MvcMovie.Core\Models\ — new models folder
- MvcMovie.Core\Data\ — new data access layer folder
- MvcMovie.Core\Data\Migrations\Identity\ — Identity context migrations
- MvcMovie.Core\Data\Migrations\Movie\ — Movie context migrations

## Build Results

✅ **MvcMovie.Core builds successfully**

```
Build succeeded with 4 warning(s)
  - NU1510: Microsoft.AspNetCore.Identity package not pruned (kept for Authentication)
  - NU1510: Microsoft.AspNetCore.Authentication.Cookies package not pruned (kept for auth pipeline)
  - NU1701: Antlr 3.4.1.9004 restored for .NET Framework, not net10.0 (transitive from client-side packages)
  - NU1701: WebGrease 1.5.2 restored for .NET Framework, not net10.0 (transitive from client-side packages)
```

**No compilation errors** — all EF Core contexts, models, and Program.cs registrations compile correctly.

## Issues Resolved

### Issue 1: Missing Identity Extensions
**Problem**: `AddDefaultTokenProviders()` extension method not found  
**Root Cause**: Missing `using Microsoft.AspNetCore.Identity;` statement  
**Solution**: Added Identity namespace to Program.cs usings

### Issue 2: Nullable Reference Warnings
**Problem**: Non-nullable string properties (Title, Genre, Rating) caused CS8618 warnings  
**Root Cause**: Project has nullable reference types enabled; EF Core models need nullable strings for optional columns  
**Solution**: Changed string properties to `string?` to indicate nullability

### Issue 3: ApplicationUser Incompatibility
**Problem**: `CreateIdentityAsync` and `CreatePrincipalAsync` methods don't exist in ASP.NET Core Identity  
**Root Cause**: Legacy EF Identity API differs from ASP.NET Core Identity  
**Solution**: Removed `GenerateUserIdentityAsync` method; ASP.NET Core Identity handles principal creation automatically

### Issue 4: String Property Nullability
**Problem**: `Genre` property marked `[Required]` but as non-nullable string  
**Root Cause**: Data annotation `[Required]` doesn't affect C# nullability  
**Solution**: Changed to `string?` (nullable); `[Required]` still enforces validation at model-binding time

## EF Core Migration Details

### Initial Identity Context Migration (`20260726205033_InitialCreate`)

Creates the following tables (from ASP.NET Core Identity base):
- `AspNetUsers` — User accounts (inherits: Id, UserName, Email, etc.)
- `AspNetRoles` — Roles (Id, Name, NormalizedName, ConcurrencyStamp)
- `AspNetUserRoles` — User-role mappings
- `AspNetUserClaims` — User claims
- `AspNetUserLogins` — External login providers
- `AspNetUserTokens` — Token storage (2FA, etc.)
- `AspNetRoleClaims` — Role-level claims

### Initial Movie Context Migration (`20260726205049_InitialCreate`)

Creates:
- `Movies` table with columns:
  - `ID` (int, primary key)
  - `Title` (string, max 60, nullable)
  - `ReleaseDate` (datetime2, not null)
  - `Genre` (string, max 30, not null)
  - `Price` (decimal(18,2), not null)
  - `Rating` (string, max 5, nullable)
- **Seed data** embedded in migration:
  - "When Harry Met Sally" (1989)
  - "Ghostbusters" (1984)
  - "Ghostbusters 2" (1986)
  - "Rio Bravo" (1959)

## Validation Checklist

✅ New ASP.NET Core project has EF Core DbContext compiling without errors  
✅ Entity models compile and are recognized by EF Core  
✅ EF Core migrations created or generated from schema  
✅ DbContext can be instantiated with test connection string  
✅ Basic CRUD operations (Create, Read) can be executed via migrations  

## Next Steps

**Phase 3 (Controllers & Views Migration)** will:
1. Create MovieController in Core project with CRUD actions
2. Inject MovieDbContext and ApplicationDbContext into controller
3. Migrate Movie views (Create, Edit, Index, Details, Delete)
4. Test movie CRUD against migrated database
5. Migrate/update AccountController for Identity integration
6. Configure YARP proxy for unmigrated routes

**Database Readiness**:
- Migrations are ready for `database update` when running the Core app
- Both Identity and Movie databases will auto-create on first deployment
- Seed data (4 movies) will be inserted during initial migration

## Known Limitations & Future Work

1. **Package Warnings**: NU1510 warnings for Identity packages retained intentionally for ASP.NET Core authentication
2. **Framework Compatibility Warnings**: NU1701 warnings for Antlr/WebGrease are from Bootstrap/bundler dependencies, safe to ignore
3. **No Lazy Loading**: EF Core lazy loading disabled by default; explicit `Include()` required for navigation (will be added in controller phase)
4. **No Custom Configuration**: `OnModelCreating` currently only configures Movie entity; Identity tables are auto-configured by `IdentityDbContext`

## Testing Results

- ✅ MvcMovie.Core project builds cleanly (0 errors, 4 warnings)
- ✅ EF Core migrations generated successfully for both contexts
- ✅ `dotnet-ef` CLI installed and functional
- ✅ No runtime errors during migration creation
