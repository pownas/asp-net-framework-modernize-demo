using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MvcMovie.Core.Models;

namespace MvcMovie.Core.Data
{
    /// <summary>
    /// ASP.NET Core Identity DbContext using EF Core
    /// Migrated from: MvcMovie\Models\IdentityModels.cs (ApplicationDbContext)
    /// 
    /// This context handles user identity, roles, claims, and logins.
    /// Inherits from IdentityDbContext which provides all the Identity tables.
    /// </summary>
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            // Add any additional Identity configuration here
            // Example: Configure table names, indexes, etc.
        }
    }
}
