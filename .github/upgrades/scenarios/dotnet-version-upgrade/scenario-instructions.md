# .NET Version Upgrade Scenario

## Preferences
- **Flow Mode**: Guided
- **Target Framework**: net10.0 (LTS - support ends Nov 2028)

## Source Control
- **Source Branch**: step/02-mordernize-mvc-movie-app
- **Working Branch**: step/02-mordernize-mvc-movie-app (using current branch)
- **Commit Strategy**: After Each Task
- **Branch Sync**: Auto (Merge)

## Upgrade Options
**Source**: .github/upgrades/scenarios/dotnet-version-upgrade/upgrade-options.md

### Strategy
- **Upgrade Strategy**: All-at-Once

### Project Structure
- **Project Approach**: Side-by-side
- **System.Web Adapters**: Direct Migration to ASP.NET Core APIs

### Modernization
- **Entity Framework**: Migrate to EF Core

## Key Decisions Log
- **Date**: 2026-07-26 22:18
- **Decision**: Upgrade to .NET 10 LTS for longest support cycle and production readiness
- **Rationale**: User confirmed net10.0 over net8.0 and net9.0 options
- **Date**: 2026-07-26 22:22
- **Decision**: Side-by-side web migration with direct System.Web API migration and simultaneous EF Core migration
- **Rationale**: User chose cleaner, more modern approach over incremental adapters and sequential EF migration

## Strategy
**Selected**: All-at-Once Side-by-Side Web Migration  
**Rationale**: Single web project allows atomic upgrade with side-by-side deployment; direct System.Web → ASP.NET Core API migration + simultaneous EF Core migration will produce clean, modern codebase at completion. High complexity (537 System.Web issues, OWIN middleware, Identity + OAuth) is manageable with this approach.

### Execution Constraints
- Old and new projects run side-by-side; YARP reverse proxy routes requests from new app to old app for unmigrated features during transition
- Direct System.Web → ASP.NET Core API migration without compatibility adapters; no cleanup pass needed
- EF6 → EF Core migration must complete before new data-access code is tested; both migrations are in-phase (simultaneous upgrade)
- Solution must build cleanly after each task before proceeding; all tests must pass before old project can be decommissioned
- Phase 1 (Preparation) must complete before Phase 2 starts; each subsequent phase depends on prior phases completing
- Git commit after each completed task for incremental progress tracking
