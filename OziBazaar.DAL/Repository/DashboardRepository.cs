using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OziBazaar.DAL.Models;

namespace OziBazaar.DAL.Repository
{
    public class DashboardRepository : IDashboardRepository
    {
        private OziBazaarEntities dbContext = new OziBazaarEntities();

        public List<DefinedProductsViewModel> GetUserProducts(int UserID)
        {
            List<DefinedProductsViewModel> definedProductsViewModels =
                (from a in dbContext.Advertisements
                 join p in dbContext.Products on a.ProductID equals p.ProductID
                 join i in dbContext.ProductImages on p.ProductID equals i.ProductID
                 where a.OwnerID == UserID && i.IsThumbnail == true
                 select new DefinedProductsViewModel
                 {
                     Price = a.Price,
                     Description = p.Description,
                     ImagePath = i.ImagePath
                 }
                 ).ToList();
            return definedProductsViewModels;
        }

        public List<DefinedProductsViewModel> GetWishListProducts(int UserID)
        {
            List<DefinedProductsViewModel> definedProductsViewModels =
                (from w in dbContext.WishLists 
                 join a in dbContext.Advertisements on w.AdvertizementID equals a.AdvertisementID
                 join p in dbContext.Products on a.ProductID equals p.ProductID
                 join i in dbContext.ProductImages on p.ProductID equals i.ProductID
                 where a.OwnerID == UserID && i.IsThumbnail == true
                 select new DefinedProductsViewModel
                 {
                     Price = a.Price,
                     Description = p.Description,
                     ImagePath = i.ImagePath
                 }
                 ).ToList();
            return definedProductsViewModels;
        }    
    }
}
