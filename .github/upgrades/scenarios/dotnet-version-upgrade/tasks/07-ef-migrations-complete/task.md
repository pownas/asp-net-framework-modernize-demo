# 07-ef-migrations-complete: Create and apply EF Core migrations

Generate and apply all Entity Framework Core migrations to establish the database schema. This includes:
- Create initial migration if no migrations existed: `Add-Migration Initial`
- Apply pending migrations: `Update-Database`
- Verify schema matches original Framework database
- Test that migrations run cleanly without constraints or conflicts
- Document any manual schema adjustments (if applicable)

**Done when**:
- [ ] Initial migration created (`MigrationHistory` table + data tables)
- [ ] All pending migrations applied to development database
- [ ] Database schema verified against original
- [ ] Migration can be re-created from scratch cleanly
