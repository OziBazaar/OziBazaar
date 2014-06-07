using OziBazaar.Framework.RenderEngine;
using OziBazaar.Web.Infrastructure.Repository;
using OziBazaar.Web.Models;
using OziBazaar.Web.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OziBazaar.Web.Controllers
{
    public class ProductController : Controller
    {
        private string[] reservedKeys = new string[5] {"CategoryId", "Title", "StartDate", "FinishDate", "__RequestVerificationToken" };
        private readonly IRenderEngine renderEngine;
        private readonly IProductRepository productRepository;

        public ProductController(IRenderEngine renderEngine, IProductRepository productRepository) 
        {
            this.renderEngine = renderEngine;
            this.productRepository = productRepository;
        }
        //
        // GET: /Product/
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult ViewProduct(int productId)
        {
            var productview = productRepository.GetProduct(productId);
            ViewBag.ProductInfo = renderEngine.Render(productview);
            return View();
        }
        public ActionResult EditProduct(int categoryId,int productId)
        {
            var productview = productRepository.EditProduct(categoryId,productId);
            ViewBag.ProductInfo = renderEngine.Render(productview);
            return View();
        }
        public ActionResult AddProduct(AdvertisementViewModel  advertisemnt)
        {
            var productAdd = productRepository.AddProduct(advertisemnt.CategoryId);
            ViewBag.ProductInfo = renderEngine.Render(productAdd);
            return View(advertisemnt);
        }
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
            //DateTime.TryParse(Request.Form["StartDate"],out startDate);
            //DateTime.TryParse(Request.Form["FinishDate"], out endDate);
            AdvertisementModel ad = new AdvertisementModel() { Features = features };
            ad.StartDate = startDate;
            ad.EndDate = endDate;
            ad.Title = Request.Form["Title"];
            ad.Category = Int32.Parse(Request.Form["CategoryId"]);

            productRepository.AddAdvertisement(ad);
            return RedirectToAction("AdList", "Ad");
        }
        public  ActionResult UpdateProduct()
        {
            var keys = Request.Form.AllKeys;
            List<ProductFeature> features = new List<ProductFeature>();
            foreach (var key in keys)
            {
                features.Add(new ProductFeature { Key = key, Value = Request[key] });
            }
            ProductModel prod = new ProductModel() { Features = features };
            productRepository.UpdateProduct(prod);
            return RedirectToAction("Index");
        }

	}
}