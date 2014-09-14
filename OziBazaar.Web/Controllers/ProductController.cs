using OziBazaar.Framework.RenderEngine;
using OziBazaar.Web.Infrastructure.Repository;
using OziBazaar.Web.Models;
using OziBazaar.Web.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebMatrix.WebData;
using OziBazaar.Web.Infrastructure.Util;
namespace OziBazaar.Web.Controllers
{
    public class ProductController : Controller
    {
        private string[] reservedKeys = new string[7] { "AdvertisementId", "CategoryId", "Title", "StartDate", "FinishDate","Price", "__RequestVerificationToken" };
        private readonly IRenderEngine renderEngine;
        private readonly IProductRepository productRepository;

        public ProductController(IRenderEngine renderEngine, IProductRepository productRepository) 
        {
            this.renderEngine = renderEngine;
            this.productRepository = productRepository;
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ViewProduct(int adId)
        {
            int productId,categoryId;
            var productview = productRepository.GetAd(adId,out productId,out categoryId);
            
            if (!User.Identity.IsAuthenticated)
                ViewBag.IsAdOwner = false;
            else
            {
                if (productRepository.IsAdOwner(WebSecurity.GetUserId(User.Identity.Name), adId))
                    ViewBag.IsAdOwner = true;
                else ViewBag.IsAdOwner = false;
            }
                        
            ViewBag.AdvertisementId = adId;
            ViewBag.ProductId = productId;
            ViewBag.CategoryId = categoryId;
            ViewBag.ProductInfo = renderEngine.Render(productview.Product);
            return View(productview);
        }

        [Authorize]
        public ActionResult EditProduct(int advertisementId, int categoryId, int productId)
        {
            var advertisement = productRepository.GetAdvertisementById(advertisementId);
            AdvertisementViewModel adViewModel = new AdvertisementViewModel
            {
                AdvertisementId=advertisement.Id
                ,Title = advertisement.Title
                ,Price=advertisement.Price
                ,StartDate = advertisement.StartDate.ToString("dd/MM/yyy")
                ,FinishDate = advertisement.EndDate.ToString("dd/MM/yyy")
            };
            var productview = productRepository.EditProduct(categoryId,productId);
            ViewBag.ProductInfo = renderEngine.Render(productview);
            ViewBag.ProductId = productId;
            ViewBag.AdvertisementId = advertisementId;
            return View(adViewModel);
        }
        
        [Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult CreateProduct()
        {
            var keys = Request.Form.AllKeys;
            List<ProductFeature> features = new List<ProductFeature>();
            foreach (var key in keys.Where(x => !reservedKeys.Contains( x)))
            {
                features.Add(new ProductFeature { Key = key, Value = Request[key] });
            }
            DateTime startDate=DateTime.Now;
            DateTime endDate = DateTime.Now.AddMonths(1);
            startDate = Request.Form["StartDate"].ConvertToDate();
            endDate = Request.Form["FinishDate"].ConvertToDate();
            AdvertisementModel ad = new AdvertisementModel() { Features = features };
            ad.StartDate = startDate;
            ad.EndDate = endDate;
            ad.Title = Request.Form["Title"];
            decimal adPrice = 0;
            decimal.TryParse(Request.Form["Price"], out adPrice);
            ad.Price = adPrice;
            ad.Category = Int32.Parse(Request.Form["CategoryId"]);

            var newAd =   productRepository.AddAdvertisement(WebSecurity.GetUserId(User.Identity.Name), ad);

            return RedirectToAction("Index", "Media", new { adId = newAd.Id, productId=newAd.ProductId });
        }

        [Authorize]
        [ValidateAntiForgeryToken]
        public  ActionResult UpdateProduct()
        {
            var keys = Request.Form.AllKeys;
            List<ProductFeature> features = new List<ProductFeature>();
            foreach (var key in keys.Where(x => !reservedKeys.Contains(x)))
            {
                features.Add(new ProductFeature { Key = key, Value = Request[key] });
            }
            DateTime startDate = DateTime.Now;
            DateTime endDate = DateTime.Now.AddMonths(1);
            startDate = Request.Form["StartDate"].ConvertToDate();
            endDate = Request.Form["FinishDate"].ConvertToDate();
            AdvertisementModel ad = new AdvertisementModel() { Features = features };
            ad.StartDate = startDate;
            ad.EndDate = endDate;
            ad.Title = Request.Form["Title"];
            ad.Id =Int32.Parse( Request.Form["AdvertisementId"]);
            ad.Category = Int32.Parse(Request.Form["CategoryId"]);
            decimal adPrice = 0;
            decimal.TryParse(Request.Form["Price"], out adPrice);
            ad.Price = adPrice;
            productRepository.UpdateAdvertisement(ad);
            return RedirectToAction("MyAdList", "Ad");
        }       
	}   
}