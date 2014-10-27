using OziBazaar.Web.Infrastructure.Repository;
using OziBazaar.Web.Models.Admin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OziBazaar.Web.Controllers
{
    public class AdminController : Controller
    {
        IAdminRepository adminRepository;
        public AdminController(IAdminRepository adminRepository)
        {
            this.adminRepository = adminRepository;

        }
        // GET: Admin
        public ActionResult Index()
        {
            return View(adminRepository.GetAllProductGroups());
        }
        public ActionResult Create()
        {
            return View(new ProductGroup());
        }
        public ActionResult Details(int id)
        {
            var productGroup = adminRepository.GetroductGroup(id);
            return View(productGroup);
        }
    }
}