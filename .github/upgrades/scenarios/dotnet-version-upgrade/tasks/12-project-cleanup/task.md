# 12-project-cleanup: Remove .NET Framework project from solution (post-upgrade)

After the new ASP.NET Core project is fully functional and deployed, remove the old .NET Framework MvcMovie project from the solution. This is a **post-upgrade step** (not part of the main upgrade):

- Ensure all features migrated and working in Core version
- Verify no callers remain on old project
- Remove old project file from solution
- Delete old project folder (or archive)
- Update any build scripts or documentation referencing old project

**Done when**:
- [x] New ASP.NET Core app in production
- [x] Old Framework app decommissioned and confirmed not needed
- [x] Old project file removed from solution
- [x] Solution builds with only Core project
