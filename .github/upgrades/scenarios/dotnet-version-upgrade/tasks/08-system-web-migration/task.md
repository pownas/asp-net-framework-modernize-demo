# 08-system-web-migration: Replace System.Web APIs with ASP.NET Core equivalents

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
