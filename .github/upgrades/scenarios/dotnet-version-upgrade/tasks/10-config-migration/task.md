# 10-config-migration: Migrate Web.config to appsettings.json

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
