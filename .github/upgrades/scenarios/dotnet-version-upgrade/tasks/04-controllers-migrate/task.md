# 04-controllers-migrate: Migrate MVC Controllers to ASP.NET Core

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
