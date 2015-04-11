using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.Web.WebPages.OAuth;
using OziBazaar.DAL.Models;
using OziBazaar.DAL.Repository;
using WebMatrix.WebData;

namespace OziBazaar.Web.Areas.UserManagement.Controllers
{
    [Authorize]
    public class UserDashboardController : Controller
    {
        private readonly IDashboardRepository _dashboardRepository;

        public UserDashboardController(
            IDashboardRepository dashboardRepository)
        {
            this._dashboardRepository = dashboardRepository;
        }
        //
        // GET: /UserDashboard/
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetUserAdvertisementList()
        {
            UserProductsViewModel userProductsViewModel = new UserProductsViewModel()
            {
                UserProductViewModelList = _dashboardRepository.GetUserProducts(WebSecurity.GetUserId(User.Identity.Name))
            };
            return View(userProductsViewModel);
        }

        public ActionResult GetWishList()
        {
            return View();
        }
	}
}