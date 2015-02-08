using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OziBazaar.Web.Areas.UserManagement.Controllers
{
    public class UserDashboardController : Controller
    {
        //
        // GET: /UserDashboard/
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult EditUserInfo()
        {
            return View();
        }
	}
}