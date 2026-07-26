# 03-dbcontext-migrate: Migrate Entity Framework 6 DbContext to EF Core

Convert the existing Entity Framework 6 DbContext(s) and entity models to Entity Framework Core. This includes:
- Rename/create EF Core DbContext inheriting from DbContext (Microsoft.EntityFrameworkCore)
- Migrate entity configurations from EDMX/Data Annotations to EF Core conventions or Fluent API
- Update DbContext constructor and dependency injection setup for EF Core (IServiceProvider, options pattern)
- Migrate any existing Database Initializers (SetInitializer) to EF Core migrations
- Create EF Core migrations from existing DB schema if DB-First, or update/create Code-First migrations

The new ASP.NET Core project will reference the migrated DbContext and use it for all data access.

**Done when**:
- [ ] New ASP.NET Core project has EF Core DbContext compiling without errors
- [ ] Entity models compile and are recognized by EF Core
- [ ] EF Core migrations created or generated from schema
- [ ] DbContext can be instantiated with test connection string
- [ ] Basic CRUD operations (Create, Read queries) execute without errors

---

## Research Findings

### Projects Affected

1. **Legacy Project**: `MvcMovie/MvcMovie.csproj` (Target: .NET Framework 4.8)
   - Contains EF6 DbContexts and migration history
   - Will not be modified; serves as reference source

2. **New Project**: `MvcMovie.Core/MvcMovie.Core.csproj` (Target: .NET 10.0)
   - EF Core packages already added (Task 02)
   - Will receive migrated DbContexts

### Current EF6 Architecture

#### DbContexts Identified
| Class | Type | Location | Purpose |
|-------|------|----------|---------|
| `ApplicationDbContext` | IdentityDbContext<ApplicationUser> | MvcMovie\Models\IdentityModels.cs | ASP.NET Identity (users, roles, claims) |
| `MovieDBContext` | DbContext | MvcMovie\Models\Movie.cs | Application data (Movie entities) |

#### Entity Models
- **ApplicationUser** (extends IdentityUser)
  - Location: MvcMovie\Models\IdentityModels.cs
  - Properties: Inherited from IdentityUser (Id, UserName, Email, etc.)
  - Relationships: One-to-many to IdentityRole, IdentityUserLogin, etc. (handled by ASP.NET Identity framework)

- **Movie** (Application domain entity)
  - Location: MvcMovie\Models\Movie.cs
  - Properties: ID (int), Title (string, 60 char max), Genre (string, 30 char), ReleaseDate (DateTime), Price (decimal), Rating (string, 5 char)
  - Validation: Data annotations on all properties (Required, StringLength, RegularExpression, Range, DataType)

#### Connection Strings (from web.config)
| Name | Purpose | Connection String |
|------|---------|-------------------|
| DefaultConnection | ASP.NET Identity | Data Source=(LocalDb)\MSSQLLocalDB;Initial Catalog=aspnet-MvcMovie-{GUID};Integrated Security=SSPI;AttachDBFilename=\|DataDirectory\|\aspnet-MvcMovie-{GUID}.mdf |
| MovieDBContext | Movie data | Data Source=(LocalDb)\MSSQLLocalDB;Initial Catalog=aspnet-MvcMovie;Integrated Security=SSPI;AttachDBFilename=\|DataDirectory\|\Movies.mdf |

#### EF6 Configuration & Initialization
- **Configuration class**: MvcMovie\Migrations\Configuration.cs (inherits DbMigrationsConfiguration<MovieDBContext>)
  - AutomaticMigrationsEnabled = false
  - Seed method applies AddOrUpdate() for hardcoded movie data
  - **Note**: No custom initializer visible; default is CreateDatabaseIfNotExists (implicit from Entity Framework)
  - **Action**: EF Configuration class will be deleted; seed data migrated to EF Core HasData() or separate seed method in Program.cs

#### EF6-Specific APIs Found
- `System.Data.Entity` namespace usage
- `DbContext` base class (from EF6)
- `DbSet<T>` properties
- Data annotation attributes (no custom configurations detected yet)
- `AddOrUpdate()` in seed method (EF6-specific; will use EF Core SaveChangesAsync patterns)

#### Migrations History
- Location: MvcMovie\Migrations\
- Files: 
  - 201711171155592_Initial.cs
  - 201711171332278_Rating.cs
  - 201711171339356_DataAnnotations.cs
  - Configuration.cs
- **Action**: EF6 migrations will be deleted; baseline EF Core migration will be created

### Files to Modify

#### Shared Models (to be migrated to Core project)
| File | Action | Rationale |
|------|--------|-----------|
| Create: MvcMovie.Core\Models\Movie.cs | Migrate entity | Migrate Movie entity class to Core project |
| Create: MvcMovie.Core\Models\ApplicationUser.cs | Extract identity user | Extract ApplicationUser from IdentityModels (ASP.NET Core Identity has built-in user model) |

#### DbContext Files (to be created in Core project)
| File | Action | Rationale |
|------|--------|-----------|
| Create: MvcMovie.Core\Data\ApplicationDbContext.cs | New context | ASP.NET Core Identity context with EF Core |
| Create: MvcMovie.Core\Data\MovieDbContext.cs | New context | Movie data context with EF Core |

#### Configuration & Registration (Core project)
| File | Action | Rationale |
|------|--------|-----------|
| Update: MvcMovie.Core\appsettings.json | Add connection strings | Migrate from web.config ConnectionStrings section |
| Update: MvcMovie.Core\Program.cs | Register DbContexts | Replace EF6 initializers with EF Core registration and migrations |

#### Migrations (Core project)
| Directory | Action | Rationale |
|-----------|--------|-----------|
| Create: MvcMovie.Core\Data\Migrations\ | Create EF Core baseline | Initialize EF Core migration infrastructure |
| Create: MvcMovie.Core\Data\Migrations\{timestamp}_InitialCreate.cs | Create initial migration | Baseline schema snapshot for current database state |

### Packages Verified
- ✅ Microsoft.EntityFrameworkCore 10.0.10 (added Task 02)
- ✅ Microsoft.EntityFrameworkCore.SqlServer 10.0.10 (added Task 02)
- ✅ Microsoft.EntityFrameworkCore.Tools 10.0.10 (added Task 02)
- ✅ Microsoft.AspNetCore.Identity.EntityFrameworkCore 10.0.10 (added Task 02)

### API Changes / Migration Patterns

| EF6 Pattern | EF Core Replacement | Notes |
|------------|-------------------|-------|
| `using System.Data.Entity;` | `using Microsoft.EntityFrameworkCore;` | Namespace change |
| `DbContext` base class | `DbContext` (from EF Core) | Same name, different assembly |
| `DbSet<T>` properties | `DbSet<T>` properties | Unchanged |
| Constructor: `base("name=ConnString")` | Constructor: `base(DbContextOptions<T> options)` | DI pattern required |
| `Database.SetInitializer()` | `context.Database.Migrate()` in Program.cs | Initialization moved to startup |
| `AddOrUpdate()` in seed | `SaveChanges()` or `HasData()` in OnModelCreating | EF Core seed patterns |
| Data annotations | Data annotations | Fully compatible (required, string length, etc.) |

### Dependencies & Risks

**Cross-Project Impact:**
- Controllers in MvcMovie.Core will inject `MovieDbContext` → must register in Program.cs
- Application services will depend on DbContexts → will use constructor injection
- Tests may need to mock DbContexts → test project will need EF Core test infrastructure

**Breaking Change Risks:**
1. Lazy loading disabled by default in EF Core → may need `.Include()` or enable proxies
2. Decimal precision requires explicit configuration → will add HasPrecision() for Price property
3. AddOrUpdate() → EF Core has no direct equivalent; will use EF Core SaveChanges patterns
4. IValidatableObject not called automatically → skip (application layer will handle validation)

**Migration Blockers:**
- Database must already exist before creating migrations (otherwise empty schema)
- EF6 migrations must be applied to database first (prerequisite: user confirmation)
- No EDMX files detected → proceeding with Code-First approach (no need for additional tooling)

### Decisions Made

1. **Dual DbContext Strategy**: Keep separate contexts (`ApplicationDbContext` for Identity, `MovieDbContext` for application data) following ASP.NET Core Identity patterns. Keeps concerns separated and matches future scalability.

2. **Connection String Management**: Migrate from web.config to appsettings.json with separate entries for ApplicationDb and MovieDb. Enables environment-specific configuration.

3. **Seed Data Migration**: Move EF6 Configuration.cs seed data to EF Core HasData() in OnModelCreating or separate seed method called in Program.cs. Simpler than preserving EF6 Configuration class.

4. **Migrations Baseline**: Delete EF6 migrations folder and create fresh EF Core migration. EF6 and EF Core migrations are incompatible; fresh baseline is cleaner than migration.

5. **No Lazy Loading Proxies**: Use explicit Include() for navigation properties. Lazy loading adds runtime overhead; explicit is more performant and predictable in ASP.NET Core.

---

## Execution Plan

### Phase 1: Prepare Core Project Structure
1. Create MvcMovie.Core\Data\ folder
2. Create MvcMovie.Core\Models\ folder

### Phase 2: Migrate Entity Models
1. Migrate Movie.cs to MvcMovie.Core\Models\Movie.cs
2. Create ApplicationUser.cs in MvcMovie.Core\Models\ (for Identity)

### Phase 3: Migrate DbContexts
1. Create ApplicationDbContext.cs (EF Core) in MvcMovie.Core\Data\
2. Create MovieDbContext.cs (EF Core) in MvcMovie.Core\Data\

### Phase 4: Update Configuration
1. Add connection strings to MvcMovie.Core\appsettings.json
2. Register DbContexts in Program.cs

### Phase 5: Create EF Core Migrations
1. Generate initial EF Core migration
2. Verify migration schema matches current database

### Phase 6: Validation
1. Build project (should compile cleanly)
2. Verify DbContext can instantiate with options
3. Confirm no EF6 references remain
