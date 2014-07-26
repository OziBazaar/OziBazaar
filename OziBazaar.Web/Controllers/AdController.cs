using OziBazaar.Web.Infrastructure.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OziBazaar.Web.Controllers
{
    public class AdController : Controller
    {
        private readonly IProductRepository productRepository;
        //
        // GET: /Ad/
        public AdController(IProductRepository productRepository)
        {
            this.productRepository = productRepository;

        }
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult AdList()
        {
            var lst = productRepository.GetAdvertisementsList();
            ViewBag.IsEditable = false;
            return View(lst);
        }

        [Authorize]
        public ActionResult MyAdList()
        {
            var lst = productRepository.GetAdvertisementsList(User.Identity.Name);
            ViewBag.IsEditable = true;
            return View("AdList",lst);
        }

        [Authorize]
        public ActionResult AddAd()
        {
             ViewBag.Categories= new SelectList( productRepository.GetAllCategories(),"Id","Name");
            
            return View();
        }
	}
}