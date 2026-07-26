using Microsoft.AspNetCore.Identity;

namespace MvcMovie.Core.Models
{
    /// <summary>
    /// Application user model for ASP.NET Core Identity
    /// Migrated from: MvcMovie\Models\IdentityModels.cs (ApplicationUser)
    /// 
    /// In ASP.NET Core, IdentityUser is the base class and requires minimal customization.
    /// Custom claims and properties can be added here.
    /// </summary>
    public class ApplicationUser : IdentityUser
    {
        // Add any additional user properties here
        // Example: public string FullName { get; set; }
    }
}
