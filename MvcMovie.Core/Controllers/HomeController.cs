using Microsoft.AspNetCore.Mvc;

namespace MvcMovie.Core.Controllers
{
    /// <summary>
    /// Home/Landing Page Controller
    /// Migrated from: MvcMovie\Controllers\HomeController.cs
    /// Changes:
    /// - System.Web.Mvc → Microsoft.AspNetCore.Mvc
    /// - Minimal changes (simple view returns, no data access)
    /// </summary>
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult About()
        {
            ViewBag.Message = "Your application description page.";
            return View();
        }

        public IActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
            return View();
        }
    }
}
