using OziBazaar.DAL;
using OziBazaar.Framework.Specification;
using OziBazaar.Web.Infrastructure.Repository;
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
            ISpecification<Advertisement> spec = new DirectSpecification<Advertisement>(ad => ad.EndDate > DateTime.Now);
            var lst = productRepository.GetAdvertisementsList(spec);
            ViewBag.IsEditable = false;
            return View(lst);
        }

        [Authorize]
        public ActionResult MyAdList()
        {
            int userId= WebSecurity.GetUserId(User.Identity.Name);
            ISpecification<Advertisement> myAdSpec = new DirectSpecification<Advertisement>(ad => ad.OwnerID == userId );
            var lst = productRepository.GetAdvertisementsList(myAdSpec);
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