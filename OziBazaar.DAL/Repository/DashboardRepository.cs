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

        public List<UserProductViewModel> GetUserProducts(int UserID)
        {
            List<UserProductViewModel> definedProductsViewModels =
                (from a in dbContext.Advertisements
                 join p in dbContext.Products on a.ProductID equals p.ProductID
                 join i in dbContext.ProductImages on p.ProductID equals i.ProductID
                 where a.OwnerID == UserID && i.IsThumbnail == true
                 select new UserProductViewModel
                 {
                     Price = a.Price,
                     Description = p.Description,
                     ImagePath = i.ImagePath,
                     StartDate = a.StartDate,
                     EndDate = a.EndDate
                 }
                 ).ToList();
            return definedProductsViewModels;
        }

        public List<UserProductViewModel> GetWishListProducts(int UserID)
        {
            List<UserProductViewModel> definedProductsViewModels =
                (from w in dbContext.WishLists 
                 join a in dbContext.Advertisements on w.AdvertizementID equals a.AdvertisementID
                 join p in dbContext.Products on a.ProductID equals p.ProductID
                 join i in dbContext.ProductImages on p.ProductID equals i.ProductID
                 where a.OwnerID == UserID && i.IsThumbnail == true
                 select new UserProductViewModel
                 {
                     Price = a.Price,
                     Description = p.Description,
                     ImagePath = i.ImagePath,
                     StartDate = a.StartDate,
                     EndDate = a.EndDate
                 }
                 ).ToList();
            return definedProductsViewModels;
        }    
    }
}
