using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.Web.WebPages.OAuth;
using OziBazaar.DAL.Models;
using OziBazaar.DAL.Repository;
using OziBazaar.Web.Infrastructure.Setting;
using OziBazaar.Web.Infrastructure.Wrapper;
using WebMatrix.WebData;

namespace OziBazaar.Web.Areas.UserManagement.Controllers
{
    [Authorize]
    public class UserDashboardController : Controller
    {
        private readonly IDashboardRepository _dashboardRepository;
        private readonly IWebSecurityWrapper _webSecurityWrapper;
        private readonly IViewSetting _viewSetting; 

        public UserDashboardController(
            IDashboardRepository dashboardRepository, IWebSecurityWrapper webSecurityWrapper, IViewSetting viewSetting)
        {
            this._dashboardRepository = dashboardRepository;
            this._webSecurityWrapper = webSecurityWrapper;
            this._viewSetting = viewSetting;
        }

        //
        // GET: /UserDashboard/
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetUserAdvertisementList(int page = 1)
        {
            int ownerID = _webSecurityWrapper.GetUserId();
            UserProductsViewModel userProductsViewModel = new UserProductsViewModel()
            {
                UserProductViewModelList = _dashboardRepository
                        .GetUserProducts(ownerID, page, _viewSetting.PageSize),
                PagingInfo = new PagingInfo()
                {
                    CurrentPage = page,
                    ItemsPerPage = _viewSetting.PageSize,
                    TotalItems = _dashboardRepository.GetUserProductsCount(ownerID)
                }
            };
            return View(userProductsViewModel);
        }

        public ActionResult GetWishList(int page = 1)
        {
            int ownerID = _webSecurityWrapper.GetUserId();
            UserWishListsViewModel userWishListsViewModel = new UserWishListsViewModel()
            {
                 UserWishListsViewModelList = _dashboardRepository
                        .GetWishListProducts(ownerID, page, _viewSetting.PageSize),
                PagingInfo = new PagingInfo()
                {
                    CurrentPage = page,
                    ItemsPerPage = _viewSetting.PageSize,
                    TotalItems = _dashboardRepository.GetWishListProductsCount(ownerID)
                }
            };
            return View(userWishListsViewModel);
        }
	}
}