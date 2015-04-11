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

        public List<UserProductViewModel> GetUserProducts(int UserID, int page = 1, int pageSize = 10)
        {
            List<UserProductViewModel> definedProductsViewModels =
                (from a in dbContext.Advertisements
                 join p in dbContext.Products on a.ProductID equals p.ProductID
                 join i in dbContext.ProductImages on p.ProductID equals i.ProductID
                 where a.OwnerID == UserID && i.IsThumbnail == true && a.IsActive == true
                 select new UserProductViewModel
                 {
                     AdvertisementID = a.AdvertisementID,
                     ProductID = a.ProductID,
                     Price = a.Price,
                     Description = p.Description,
                     ImagePath = i.ImagePath,
                     StartDate = a.StartDate,
                     EndDate = a.EndDate
                 }
                 ).OrderBy(r => r.AdvertisementID).Skip((page - 1) * pageSize).Take(pageSize).ToList();
            return definedProductsViewModels;
        }

        public List<UserProductViewModel> GetWishListProducts(int UserID, int page = 1, int pageSize = 10)
        {
            List<UserProductViewModel> definedProductsViewModels =
                (from w in dbContext.WishLists 
                 join a in dbContext.Advertisements on w.AdvertizementID equals a.AdvertisementID
                 join p in dbContext.Products on a.ProductID equals p.ProductID
                 join i in dbContext.ProductImages on p.ProductID equals i.ProductID
                 where a.OwnerID == UserID && i.IsThumbnail == true
                 select new UserProductViewModel
                 {
                     AdvertisementID = a.AdvertisementID,
                     ProductID = a.ProductID,
                     Price = a.Price,
                     Description = p.Description,
                     ImagePath = i.ImagePath,
                     StartDate = a.StartDate,
                     EndDate = a.EndDate
                 }
                 ).OrderBy(r => r.AdvertisementID).Skip((page - 1) * pageSize).Take(pageSize).ToList();
            return definedProductsViewModels;
        }    
    }
}
