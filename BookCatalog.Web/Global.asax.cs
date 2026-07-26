using System;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using BookCatalog.Web.Models;

namespace BookCatalog.Web
{
    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            // Use NullDatabaseInitializer to prevent automatic database creation/migration
            // This allows the app to work with pre-created databases (including manually created ones)
            Database.SetInitializer<ApplicationDbContext>(null);

            try
            {
                // Ensure database and seed data exist
                using (var db = new ApplicationDbContext())
                {
                    // Test connection
                    db.Database.Connection.Open();
                    db.Database.Connection.Close();

                    // If no books exist, seed the data
                    if (!db.Books.Any())
                    {
                        BookCatalogInitializer.SeedBooks(db);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't crash the application
                System.Diagnostics.Debug.WriteLine($"Database initialization warning: {ex.Message}");
            }

            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }
    }
}

