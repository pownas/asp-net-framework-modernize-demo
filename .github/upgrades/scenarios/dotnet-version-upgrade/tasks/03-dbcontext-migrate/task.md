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
