# 11-testing-validate: Run tests and validate functionality

Execute all application tests to ensure the new ASP.NET Core app is functionally equivalent to the old Framework version:

- Run unit tests (if any exist in original solution)
- Run integration tests against new app + EF Core database
- Manual smoke tests: login, basic CRUD operations, view rendering
- Verify authentication flows (login, logout, password reset)
- Verify data access (movie creation, read, update, delete)
- Test static file serving (CSS, JS, images)
- Test error handling and exception views
- Verify YARP reverse proxy correctly handles unmigrated routes

**Done when**:
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Manual smoke tests successful
- [ ] No regressions in core workflows
- [ ] New app can handle all previously working scenarios
- [ ] Unmigrated routes successfully proxy to old app via YARP
