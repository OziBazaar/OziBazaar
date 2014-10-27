using OziBazaar.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Admin=OziBazaar.Web.Models.Admin;

namespace OziBazaar.Web.Infrastructure.Repository
{
    public interface IAdminRepository
    {
         IEnumerable<Admin.ProductGroup> GetAllProductGroups();
         Admin.ProductGroup GetroductGroup(int Id);
        
    }
    public class AdminRepository : IAdminRepository 
    {
        private OziBazaarEntities dbContext = new OziBazaarEntities();
       

        public IEnumerable<Admin.ProductGroup> GetAllProductGroups()
        {
            return dbContext.ProductGroups.Select(pg => new Admin.ProductGroup() { Id = pg.ProductGroupID, Name = pg.Description, ViewTemplate = pg.ViewTemplate, EditTemplate = pg.EditTemplate }).ToList();
        }

        public Admin.ProductGroup GetroductGroup(int Id)
        {
            var productGroup= dbContext.ProductGroups.Single(pg=> pg.ProductGroupID == Id);
            return  new Admin.ProductGroup() { Id = productGroup.ProductGroupID, Name = productGroup.Description, ViewTemplate = productGroup.ViewTemplate, EditTemplate = productGroup.EditTemplate };
        }
    }
   
}