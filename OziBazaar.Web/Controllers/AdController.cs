﻿using OziBazaar.DAL;
using OziBazaar.Framework.RenderEngine;
using OziBazaar.Framework.Specification;
using OziBazaar.Web.Infrastructure.Repository;
using OziBazaar.Web.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebMatrix.WebData;

namespace OziBazaar.Web.Controllers
{
    public class AdController : Controller
    {
        private readonly IProductRepository productRepository;
        private readonly IRenderEngine renderEngine;
      
        public AdController(IProductRepository productRepository,
                            IRenderEngine renderEngine)
        {
            this.productRepository = productRepository;
            this.renderEngine = renderEngine;

        }
        public ActionResult Index()
        {
            return View();
        }
    
        public ActionResult AdList()
        {
            ISpecification<Advertisement> notEnded = new DirectSpecification<Advertisement>(ad => ad.EndDate > DateTime.Now);
            ISpecification<Advertisement> started = new DirectSpecification<Advertisement>(ad => ad.StartDate <= DateTime.Now);
            AndSpecification<Advertisement>  dateRange= new AndSpecification<Advertisement>(notEnded,started);
            var lst = productRepository.GetAdvertisementsList(dateRange);
            ViewBag.OwnerView = false;
            return View(lst);
        }

        [Authorize]
        public ActionResult MyAdList()
        {
            int userId= WebSecurity.GetUserId(User.Identity.Name);
            ISpecification<Advertisement> myAdSpec = new DirectSpecification<Advertisement>(ad => ad.OwnerID == userId );
            var lst = productRepository.GetAdvertisementsList(myAdSpec);
            ViewBag.OwnerView = true;
            return View("AdList",lst);
        }

        [Authorize]
        public ActionResult AddAd()
        {
             ViewBag.Categories= new SelectList( productRepository.GetAllCategories(),"Id","Name");
             return View(new AdvertisementViewModel());
        }

        [Authorize]
        public ActionResult CreateAd(AdvertisementViewModel advertisemnt)
        {
            if (ModelState.IsValid)
            {
                var productAdd = productRepository.AddProduct(advertisemnt.CategoryId);
                ViewBag.ProductInfo = renderEngine.Render(productAdd);
                return View("AddAdDetail",advertisemnt);
            }
            else
            {
                ViewBag.Categories = new SelectList(productRepository.GetAllCategories(), "Id", "Name");
                return View("AddAd", advertisemnt);
            }
        }

        public ActionResult DeleteAd(int adId, int productId)
        {
            productRepository.DeleteAd(adId, productId);
            return RedirectToAction("MyAdList");
        }
	}
}