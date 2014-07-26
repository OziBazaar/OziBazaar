using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OziBazaar.Web.Infrastructure.Repository;
using OziBazaar.Web.Models;

namespace OziBazaar.Web.Controllers
{
    public class WishListController : Controller
    {
        private readonly IProductRepository productRepository;

        public WishListController(IProductRepository productRepository)
        {
            this.productRepository = productRepository;

        }

        [Authorize()]
        public ActionResult Index()
        {
            List<WishListViewModel> WishListViewModels =
                productRepository.GetWishList(User.Identity.Name);
            return View(WishListViewModels);
        }
         [Authorize()]
        public ActionResult AddToWishList(int adId)
        {
            productRepository.AddToWishList(adId,User.Identity.Name);
            return RedirectToAction("Index");
        }
         [Authorize()]
         public ActionResult Remove(int adId)
         {
             productRepository.RemoveFromWishList(adId, User.Identity.Name);
             return RedirectToAction("Index");
         }
	}

}