# 06-authentication-reconfig: Migrate ASP.NET Identity and OWIN to ASP.NET Core Authentication

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
