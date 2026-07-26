# 02-dependencies-modernize: Update NuGet packages and resolve incompatibilities

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
