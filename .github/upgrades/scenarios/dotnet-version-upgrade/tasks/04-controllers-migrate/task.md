# 04-controllers-migrate: Migrate MVC Controllers to ASP.NET Core

Migrate all controllers from the .NET Framework MvcMovie project to the new ASP.NET Core project.

## Research Findings

### Controllers Identified
- **MvcMovie\Controllers\MoviesController.cs** - Main entity CRUD controller (155 lines)
  - Inherits: System.Web.Mvc.Controller
  - Patterns: Index, Create, Edit, Delete, Details actions; ViewBag; MovieDBContext injection
  - LINQ to Entities queries, ActionResult returns, HttpPost overloads

- **MvcMovie\Controllers\AccountController.cs** - Authentication & authorization
  - Inherits: System.Web.Mvc.Controller
  - Patterns: Login, Register, LogOff (OWIN identity)
  - SignInManager, UserManager, Identity integration

- **MvcMovie\Controllers\ManageController.cs** - User profile management
  - Inherits: System.Web.Mvc.Controller
  - Patterns: AsyncManager, IdentityHelper usage

- **MvcMovie\Controllers\HomeController.cs** - Landing page
  - Simple controller, minimal dependencies

- **MvcMovie\Controllers\HelloWorldController.cs** - Example/test controller
  - Simple view/string returns

### Migration Pattern
All are **MVC controllers** (inherit System.Web.Mvc.Controller, not ApiController)
- Replace: System.Web.Mvc → Microsoft.AspNetCore.Mvc
- Update: FormCollection → Form collection binding with [FromForm]
- Update: HttpPost overloads → Separate route attributes
- Update: Identity patterns from OWIN to ASP.NET Core Identity  
- Update: ActionResult return types (ActionResult<T> or IActionResult preferred)

### Execution Plan
1. Create MvcMovie.Core\Controllers folder
2. Migrate MoviesController (main CRUD, largest, most patterns)
3. Migrate AccountController (auth patterns)
4. Migrate ManageController  
5. Migrate HomeController & HelloWorldController (simple, template pattern)
6. Update Program.cs for controller routing (already done, verify)
7. Build and validate

**Done when**:
- [ ] All public controllers copied to MvcMovie.Core\Controllers
- [ ] Using statements updated to Microsoft.AspNetCore.Mvc
- [ ] All action methods compile without errors
- [ ] ActionResult return types corrected for ASP.NET Core
- [ ] No references to old System.Web.Mvc APIs remaining
- [ ] Controllers resolve all dependency injections
- [ ] Project builds cleanly
