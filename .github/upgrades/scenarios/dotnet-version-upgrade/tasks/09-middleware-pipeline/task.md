# 09-middleware-pipeline: Configure ASP.NET Core middleware pipeline

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
