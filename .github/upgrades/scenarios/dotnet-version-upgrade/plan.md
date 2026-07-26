# .NET 10 Upgrade Plan — MvcMovie

## Overview

**Scenario**: .NET Version Upgrade (dotnet-version-upgrade)

**Target Framework**: .NET 10.0 LTS

**Upgrade Strategy**: All-at-Once side-by-side web migration with direct System.Web → ASP.NET Core API migration and simultaneous EF6 → EF Core migration.

**Assessment Summary**: 
- 1 ASP.NET MVC 5 project on .NET Framework 4.8
- 40 incompatible NuGet packages (57% of packages)
- 715 breaking API changes (704 binary incompatible, 11 source incompatible)
- 16 binding redirect issues
- Key technologies: System.Web, OWIN, ASP.NET Identity, Entity Framework 6

**Complexity**: High — multiple middleware, OWIN bootstrap, custom identity config, EF6 context, and authentication pipeline changes required.

---

## Strategy Declaration

**Strategy Name**: All-at-Once Side-by-Side Web Migration  
**Rationale**: Single web project; side-by-side approach allows live old app during migration; direct System.Web API migration + simultaneous EF Core migration will produce clean, modern codebase at completion.

### Execution Constraints
- Old and new projects run side-by-side; YARP reverse proxy routes requests from new app back to old app for unmigrated features
- Direct System.Web → ASP.NET Core API migration (no compatibility adapters); no cleanup pass needed
- EF6 → EF Core migration must complete before data-access code is tested against new app
- Solution must build successfully after each task before proceeding to next
- All tests must pass in new ASP.NET Core app before old project can be decommissioned
- Git commits after each task for incremental progress tracking

---

## Tasks - Phase 1: Preparation & Infrastructure

### 01-project-setup: Scaffold ASP.NET Core project with YARP proxy

Create a new ASP.NET Core 10 web project alongside the existing .NET Framework MvcMovie project. Configure YARP reverse proxy to route requests from the new app to the old Framework app, enabling incremental migration of controllers and views. This establishes the foundation for side-by-side deployment.

The new project will:
- Target .NET 10.0
- Use ASP.NET Core MVC (Controllers + Razor Views)
- Include YARP NuGet package configured to proxy requests to old app
- Maintain same URL structure (port, routes) as old app
- Enable gradual migration: finish new route → remove from YARP proxy fallback

**Done when**:
- [ ] New ASP.NET Core project created and added to solution
- [ ] YARP reverse proxy configured and routing requests successfully
- [ ] Solution builds without errors
- [ ] Can start old app on one port and new app on another; YARP successfully proxies requests

---

### 02-dependencies-modernize: Update NuGet packages and resolve incompatibilities

Upgrade all NuGet packages to versions compatible with .NET 10. The assessment detected 40 incompatible packages including Entity Framework 6, ASP.NET Identity, OWIN, and Microsoft.ApplicationInsights. This task updates all packages to modern equivalents and removes packages no longer needed in ASP.NET Core.

Key package migrations:
- **Entity Framework** 6.1.3 → 8.x (EF Core)
- **Microsoft.AspNet.Identity** 2.2.x → Microsoft.AspNetCore.Identity (built-in)
- **Microsoft.Owin** 3.0.1 / 4.2.2 → native ASP.NET Core middleware
- **Microsoft.AspNet.Mvc** → none (built into ASP.NET Core)
- **System.Web.Optimization** → static file serving
- **Microsoft.ApplicationInsights** 2.2 → 2.23+
- Deprecated packages (jQuery 3.5.0, etc.) → modern equivalents or removal

**Done when**:
- [ ] New ASP.NET Core MvcMovie.csproj (or MvcMovie.Core) has all packages updated
- [ ] No incompatible packages remain
- [ ] All deprecated packages replaced or removed
- [ ] New project builds successfully with all package references resolved
- [ ] No NuGet/package errors in Error List

---

### 03-dbcontext-migrate: Migrate Entity Framework 6 DbContext to EF Core

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

## Tasks - Phase 2: Core MVC Migration

### 04-controllers-migrate: Migrate MVC Controllers to ASP.NET Core

Migrate all controllers from the .NET Framework MvcMovie project to the new ASP.NET Core project. This involves:
- Source files: AccountController, ManageController, HomeController, MoviesController, etc.
- Replace `System.Web.Mvc` using statements with `Microsoft.AspNetCore.Mvc`
- Update ActionResult return types → ActionResult<T> or IActionResult
- Migrate authentication/authorization attributes: `[Authorize]` remains, but SignIn/SignOut now use ASP.NET Core authentication service
- Replace `Request`, `Response`, `User` properties with `HttpContext.Request`, `HttpContext.Response`, `User` (from base controller)
- Migrate any custom action filters or `IActionFilter` implementations

Assessment context: MVC Movie has multiple controllers (at least 4-5 main controllers: Account, Manage, Movies, Home); moderate complexity with auth/DI usage.

**Done when**:
- [ ] All public controllers (Account, Manage, Movies, Home, etc.) copied to new project
- [ ] Using statements updated to Microsoft.AspNetCore.Mvc
- [ ] All action methods compile without errors
- [ ] ActionResult return types corrected for ASP.NET Core
- [ ] No references to old System.Web.Mvc APIs remaining
- [ ] Controllers resolve all dependency injections (no missing services)

---

### 05-views-migrate: Migrate Razor Views and update ViewModels

Migrate all Razor views (.cshtml files) from the Framework project to the new ASP.NET Core project. This involves:
- Copy view files maintaining folder structure (Views/Home, Views/Account, Views/Manage, etc.)
- Update `@model` directives to reference new ViewModel namespaces
- Replace `@Html` helpers with ASP.NET Core TagHelpers or `Html` helpers (slightly different API)
- Replace bundling (System.Web.Optimization `@Scripts.Render`, `@Styles.Render`) with direct `<link>` and `<script>` tags pointing to content files
- Update any custom HTML helpers to new syntax
- Migrate ViewModels to new project, update namespaces and any System.Web references

Assessment context: MVC Movie has standard views + layout + shared views; moderate complexity with account management views.

**Done when**:
- [ ] All view files (.cshtml) copied to Views folder maintaining structure
- [ ] View models compiled and referenced correctly
- [ ] @model directives point to new namespace
- [ ] All bundling references replaced with static links
- [ ] Views compile in new project (no Razor errors)
- [ ] HTML/TagHelper syntax updated (Asp.Net Core)

---

### 06-authentication-reconfig: Migrate ASP.NET Identity and OWIN to ASP.NET Core Authentication

Migrate from ASP.NET Identity + OWIN to ASP.NET Core Identity and native middleware. This is a major middleware pipeline restructuring:

**Current stack** (Framework):
- `Microsoft.AspNet.Identity.Owin`
- `IdentityConfig.cs` with `ApplicationUserManager`, `ApplicationSignInManager`
- `Startup.Auth.cs` registering OWIN middleware for cookies, Google OAuth
- `Startup.cs` OWIN bootstrap with `[OwinStartup]` attribute
- Custom claims identity setup in Account/Manage controllers

**New stack** (ASP.NET Core):
- `Microsoft.AspNetCore.Identity` (built-in)
- Register services in `Program.cs`: `AddIdentity<ApplicationUser, IdentityRole>()` + `AddEntityFrameworkStores`
- `AddAuthentication().AddCookie()` + OAuth providers (Google, Facebook, Microsoft)
- Move pipeline config to middleware chain: `app.UseAuthentication()` + `app.UseAuthorization()`
- Move User creation/password reset logic from controllers to `UserManager<ApplicationUser>` NuGet injections
- Update `AccountController` and `ManageController` to inject `UserManager`, `SignInManager`, `RoleManager` via constructor DI

Assessment context: Assessment detected ASP.NET Identity + OWIN with cookie + Google OAuth + role-based auth. 16 binding issues, likely from OWIN version mismatches — clean slate in Core.

**Done when**:
- [ ] `Program.cs` has `AddIdentity()`, `AddEntityFrameworkStores()`, `AddAuthentication()` configured
- [ ] User table created in EF Core migrations
- [ ] `[Authorize]` attributes work (users can be validated)
- [ ] Login/logout flows functional in new project
- [ ] OAuth providers configured (Google, etc. if originally present)
- [ ] Roles and role-based authorization working
- [ ] No OWIN references remaining in new project

---

## Tasks - Phase 3: Data Access & Advanced Features

### 07-ef-migrations-complete: Create and apply EF Core migrations

Generate and apply all Entity Framework Core migrations to establish the database schema. This includes:
- Create initial migration if no migrations existed: `Add-Migration Initial`
- Apply pending migrations: `Update-Database`
- Verify schema matches original Framework database
- Test that migrations run cleanly without constraints or conflicts
- Document any manual schema adjustments (if applicable)

**Done when**:
- [ ] Initial migration created (`MigrationHistory` table + data tables)
- [ ] All pending migrations applied to development database
- [ ] Database schema verified against original
- [ ] Migration can be re-created from scratch cleanly

---

### 08-system-web-migration: Replace System.Web APIs with ASP.NET Core equivalents

Direct migration of System.Web references (no System.Web Adapters). This includes:
- **HttpContext.Current** → inject `IHttpContextAccessor`, call `httpContextAccessor.HttpContext`
- **Request/Response** → `HttpContext.Request`, `HttpContext.Response`
- **Server.MapPath** → inject `IWebHostEnvironment`, use `webHostEnvironment.ContentRootPath` or `WebRootPath`
- **Session** → `IDistributedCache` or `ISession` (configure in Program.cs)
- **Application state** → Singleton services in DI container or hosted background service
- **Routing (routes.MapRoute)** → Endpoint routing in Program.cs or `MapControllers()` / `MapControllerRoute()`

Assessment context: 537 issues related to ASP.NET Framework (System.Web) detected. Direct migration will replace all ~537 instances.

**Done when**:
- [ ] No `System.Web` using statements remain (except `System.Web.Http` which might be legacy API references)
- [ ] All `HttpContext.Current` calls replaced with injected `IHttpContextAccessor`
- [ ] Server/Path APIs use `IWebHostEnvironment`
- [ ] Session access uses `ISession` or `IDistributedCache`
- [ ] Application-level state moved to DI services
- [ ] No compiler errors related to System.Web
- [ ] New project compiles cleanly

---

### 09-middleware-pipeline: Configure ASP.NET Core middleware pipeline

Set up the complete ASP.NET Core middleware chain in `Program.cs` to replace the OWIN bootstrap and Global.asax initialization:

- Convert OWIN pipeline setup to middleware chain
- Configure routing: `app.MapControllers()` + `app.MapControllerRoute()` for conventional routing
- Enable authentication/authorization: `app.UseAuthentication()` + `app.UseAuthorization()`
- Configure dependency injection: register all services (DbContext, UserManager, custom services)
- Static files: `app.UseStaticFiles()`
- CORS (if needed): `app.UseCors()`
- Error handling: `app.UseExceptionHandler()` + dev exception page
- Move any custom middleware from Global.asax.cs events to middleware implementations

Assessment context: OWIN bootstrap with custom `[OwinStartup]` class; will be replaced with Modern `.NET 10` Program.cs minimal hosting model or traditional startup.

**Done when**:
- [ ] `Program.cs` fully configured with all middleware
- [ ] Services registered (DbContext, Identity, DI containers)
- [ ] Routing works (controllers respond on expected routes)
- [ ] Authentication middleware operational
- [ ] Static files served correctly
- [ ] Error handling functional

---

## Tasks - Phase 4: Configuration & Environment

### 10-config-migration: Migrate Web.config to appsettings.json

Migrate configuration from `Web.config` to `appsettings.json` and environment-specific files:

- Connection strings → `appsettings.json` under `"ConnectionStrings"` key
- AppSettings → `appsettings.json` under custom sections
- Email, encryption, custom Settings → migrate to `appsettings.json`
- Environment-specific values → `appsettings.Development.json`, `appsettings.Production.json`
- Remove or archive old `Web.config` (not used in ASP.NET Core)
- Update code to use `IConfiguration` to read settings instead of `ConfigurationManager`

Assessment context: Legacy ASP.NET project likely has custom Web.config sections, connection strings, and application settings.

**Done when**:
- [ ] `appsettings.json` created with all connection strings and settings
- [ ] `appsettings.Development.json` / `appsettings.Production.json` created
- [ ] Code reads from `IConfiguration` (no `ConfigurationManager` calls)
- [ ] Connection string correctly injected into DbContext
- [ ] All settings accessible in new project
- [ ] No Web.config references in .NET Core project

---

## Tasks - Phase 5: Validation & Completion

### 11-testing-validate: Run tests and validate functionality

Execute all application tests to ensure the new ASP.NET Core app is functionally equivalent to the old Framework version:

- Run unit tests (if any exist in original solution)
- Run integration tests against new app + EF Core database
- Manual smoke tests: login, basic CRUD operations, view rendering
- Verify authentication flows (login, logout, password reset)
- Verify data access (movie creation, read, update, delete)
- Test static file serving (CSS, JS, images)
- Test error handling and exception views
- Verify YARP reverse proxy correctly handles unmigrated routes

**Done when**:
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Manual smoke tests successful
- [ ] No regressions in core workflows
- [ ] New app can handle all previously working scenarios
- [ ] Unmigrated routes successfully proxy to old app via YARP

---

### 12-project-cleanup: Remove .NET Framework project from solution (post-upgrade)

After the new ASP.NET Core project is fully functional and deployed, remove the old .NET Framework MvcMovie project from the solution. This is a **post-upgrade step** (not part of the main upgrade):

- Ensure all features migrated and working in Core version
- Verify no callers remain on old project
- Remove old project file from solution
- Delete old project folder (or archive)
- Update any build scripts or documentation referencing old project

**Done when**:
- [ ] New ASP.NET Core app in production
- [ ] Old Framework app decommissioned and confirmed not needed
- [ ] Old project file removed from solution
- [ ] Solution builds with only Core project

---

## Risk Assessment

| Risk | Mitigation |
|------|-----------|
| **System.Web APIs spread across codebase (537 issues)** | Direct migration will find all instances; systematic replacement with ASP.NET Core equivalents (IHttpContextAccessor, IWebHostEnvironment, ISession) |
| **OWIN → Middleware pipeline restructuring** | New Program.cs built from scratch; OWIN concepts map cleanly to ASP.NET Core middleware |
| **EF6 → EF Core simultaneous migration** | May introduce multiple sources of breaking changes; mitigated by comprehensive unit/integration tests; fallback: keep EF6 and do EF Core migration as follow-on |
| **Identity user/role data transfer** | EF Core migrations handle schema creation; manual data seed if needed after migration |
| **Authentication state during side-by-side run** | YARP routes to old app; users logged in old app will see "not authenticated" in new app initially; manual re-auth expected during cutover |
| **Package incompatibility cascades** | Comprehensive package audit (step 02) upfront ensures no hidden incompatibilities during later phases |

---

## Success Criteria (All Must Pass)

- ✅ New ASP.NET Core 10 project builds cleanly
- ✅ All 40 incompatible packages updated/replaced
- ✅ EF Core DbContext compiles and migrations apply
- ✅ All MVC controllers migrated and routable
- ✅ All Razor views migrated and render
- ✅ ASP.NET Identity + authentication functional
- ✅ System.Web APIs entirely replaced
- ✅ Configuration migrated to appsettings.json
- ✅ All unit tests pass
- ✅ All integration tests pass
- ✅ Manual smoke tests successful
- ✅ YARP serves as fallback for unmigrated features
- ✅ Old Framework project decommissioned (post-upgrade)

---

## Next Steps

1. **Review and approve plan** (Guided mode: pause here for user approval)
2. **Execute Phase 1** — Scaffold ASP.NET Core project + YARP proxy setup
3. **Execute Phase 2** — Migrate controllers, views, Identity config
4. **Execute Phase 3** — Data access and System.Web migration
5. **Execute Phase 4** — Configuration migration
6. **Execute Phase 5** — Validation and cleanup
