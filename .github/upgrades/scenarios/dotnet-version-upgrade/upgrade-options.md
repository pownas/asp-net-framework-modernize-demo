# Upgrade Options — MvcMovie

Assessment: 1 ASP.NET MVC project on .NET Framework 4.8; 40 incompatible packages; 715 breaking API changes; high complexity (System.Web, OWIN, EF6, Identity).

## Strategy

### Upgrade Strategy

Single project solution targeting .NET Framework 4.8.

| Value | Description |
|-------|-------------|
| **All-at-Once** (selected) | Upgrade all projects simultaneously in a single atomic pass. Fastest approach with no multi-targeting overhead. |

## Project Structure

### Project Approach

MvcMovie is an ASP.NET MVC web project with System.Web dependency and moderate surface area (controllers, views, authentication pipeline).

| Value | Description |
|-------|-------------|
| **Side-by-side** (selected) | Create new ASP.NET Core project alongside existing Framework project. Migrate controllers/views incrementally while old project stays live. Lower risk for continuous deployment scenarios. |
| In-place rewrite | Replace the Framework project entirely in one pass. Higher risk, faster for small projects. Not recommended here due to auth complexity. |

### System.Web Adapters

System.Web, HttpContext.Current, and OWIN Bootstrap detected in startup/auth pipeline.

| Value | Description |
|-------|-------------|
| Use System.Web Adapters | Add Microsoft.AspNetCore.SystemWebAdapters package for HttpContext.Current/HttpRequest/HttpResponse compatibility shims. Enables incremental auth/middleware migration. Requires cleanup pass after migration. |
| **Direct Migration to ASP.NET Core APIs** (selected) | No adapter shims. Replace System.Web usage immediately with native ASP.NET Core equivalents. Cleaner long-term but more upfront work. |

## Modernization

### Entity Framework

Entity Framework 6.1.3 detected in project; upgrading to .NET 10.

| Value | Description |
|-------|-------------|
| EF6 | EF6 6.3+ is compatible with .NET Core. Complete the .NET 10 upgrade first; evaluate EF Core migration as a separate follow-on effort. Lowest risk and most stable debugging path. |
| **Migrate to EF Core** (selected) | Migrate Entity Framework simultaneously with .NET upgrade. Two sources of breaking changes at once. Only recommended for small data layers; this project has multiple DbContexts and would benefit from sequential migration. |
