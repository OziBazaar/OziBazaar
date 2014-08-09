using OziBazaar.DAL;
using OziBazaar.Web.Infrastructure.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OziBazaar.Web.Controllers
{
    public class MediaController : Controller
    {
        private readonly IProductRepository productRepository;
        public MediaController(IProductRepository productRepository)
        {
            this.productRepository = productRepository;
        }

        [Authorize]
        public ActionResult Index(int adId, int productId)
        {
            ViewBag.AdvertisementId = adId;
            ViewBag.ProductId = productId;
            return View(productRepository.GetAdImages(adId));
        }

        [HttpPost]
        [Authorize]
        public ActionResult Upload(HttpPostedFileBase[] files, int productId, int adId)
        {
            List<ProductImage> images=new List<ProductImage>();
            foreach (HttpPostedFileBase file in files)
            {
                string path = System.IO.Path.Combine(Server.MapPath("~/Content/Image/"), System.IO.Path.GetFileName(file.FileName));
                file.SaveAs(path);
                images.Add(new ProductImage() { ProductID = productId, MimeType = "image", ImagePath = "/Content/Image/" + System.IO.Path.GetFileName(file.FileName), Description = "Description", ImageType = "Image", ImageOrder = 1 });

            }
            productRepository.AddAttachment(images);
            return RedirectToAction("ViewProduct", "Product", new { productId = productId, adId = adId });
        }
        public ActionResult ProductImages(int adId)
        {
               return View(productRepository.GetAdImages(adId));
        }
        public ActionResult Delete(int id,int productId, int adId)
        {
            productRepository.DeleteImage(id);
            return RedirectToAction("Index", new { productId = productId, adId = adId});

        }
        public ActionResult FilpView(int productId)
        {
            return PartialView(productId);
        }
        private IEnumerable<string> Get(int productId)
        {
            return productRepository.GetAdImages(productId).OrderBy(img => img.ImageOrder).Select(img => img.ImagePath);
        }
        public JsonResult GetImages(int id)
        {
            return new JsonResult() { JsonRequestBehavior = JsonRequestBehavior.AllowGet, Data = Get(id) };
        }
	}
}