# 05-views-migrate: Migrate Razor Views and update ViewModels

Migrate all Razor views (.cshtml files) from the Framework project to the new ASP.NET Core project. This involves:
- Copy view files maintaining folder structure (Views/Home, Views/Account, Views/Manage, etc.)
- Update `@model` directives to reference new ViewModel namespaces
- Replace `@Html` helpers with ASP.NET Core TagHelpers or `Html` helpers (slightly different API)
- Replace bundling (System.Web.Optimization `@Scripts.Render`, `@Styles.Render`) with direct `<link>` and `<script>` tags pointing to content files
- Update any custom HTML helpers to new syntax
- Migrate ViewModels to new project, update namespaces and any System.Web references

Assessment context: MVC Movie has standard views + layout + shared views; moderate complexity with account management views.

**Done when**:
- [ ] All view files (.cshtml) copied to Views folder maintaining structure
- [ ] View models compiled and referenced correctly
- [ ] @model directives point to new namespace
- [ ] All bundling references replaced with static links
- [ ] Views compile in new project (no Razor errors)
- [ ] HTML/TagHelper syntax updated (Asp.Net Core)
