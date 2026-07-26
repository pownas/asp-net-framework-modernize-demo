# 01-project-setup: Scaffold ASP.NET Core project with YARP proxy

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
