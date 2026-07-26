# Task 04: Controllers Migration - Research & Planning

**Status**: RESEARCH COMPLETE - Ready for Execution  
**Date**: 2026-07-26

## Summary

Task 04 requires migrating 5 MVC controllers from the legacy .NET Framework project to ASP.NET Core. Research is complete; controllers have been inventoried and migration patterns documented.

## Controllers to Migrate

1. **MoviesController** (155 lines) - Primary CRUD controller
   - Patterns: Index (GET/POST), Create, Edit, Delete, Details
   - Current: System.Web.Mvc.Controller, MovieDBContext injection
   - Migration: FormCollection → [FromForm], ActionResult → IActionResult

2. **AccountController** - Authentication
   - Patterns: Login, Register, LogOff with OWIN SignInManager
   - Migration: SignInManager/UserManager pattern update to ASP.NET Core Identity

3. **ManageController** - User management
   - Patterns: AsyncManager, IdentityHelper
   - Migration: Async patterns, Identity integration

4. **HomeController** - Landing
   - Simple: Index action returning view (minimal migration)

5. **HelloWorldController** - Example/test
   - Simple: View and string returns (minimal migration)

## Key Changes Required

Per **migrating-mvc-controllers** skill:

✅ **Required Changes**:
- Replace all `System.Web.Mvc` → `Microsoft.AspNetCore.Mvc`
- Update FormCollection parameters → [FromForm] binding
- Update ActionResult returns → IActionResult or ActionResult<T>
- Remove direct MovieDBContext injection → use DI with IMovieService or similar
- Update OWIN identity patterns → ASP.NET Core Identity services
- Update Response helpers (Request.CreateResponse → Ok(), etc.)
- No [ApiController] needed (these are MVC, not API)

✅ **No Longer Needed**:
- System.Web references
- OWIN middleware
- EF6 direct context access
- FormCollection (replace with IFormCollection or [FromForm])

## Next Steps (Execution Phase)

1. Run `dotnet new mvc -n Controllers -o MvcMovie.Core/Controllers` to scaffold folder
2. Copy each controller file and update imports/patterns
3. Fix MovieDBContext → inject MovieDbContext (new EF Core version)
4. Fix AccountController → use ASP.NET Core identity services (bootstrapped in Program.cs)
5. Fix ManageController async patterns
6. Build and resolve compilation errors
7. Verify routing works (Program.cs already has MapDefaultControllerRoute)

## Risks & Notes

- **FormCollection** → Migrate to IFormCollection or parameters
- **OWIN Services** → MovedInto ASP.NET Core DI (HttpContext.User already available)
- **ViewBag/TempData** → Still supported in ASP.NET Core MVC
- **[Authorize]** → Attribute remains; behavior unchanged with Identity setup
- **Session** → Requires registration in Program.cs (not done yet; may be needed for AccountController)
- **External Auth** → Google/Facebook/Microsoft OAuth already wired in Program.cs (add providers as needed)

## Skill Applied

- `migrating-mvc-controllers` - MVC vs WebAPI classification, return type mapping, attribute migration
- `building-projects` - Build validation and error resolution

---

**Next action**: Execute controller copying and pattern updates; build and validate compilation.
