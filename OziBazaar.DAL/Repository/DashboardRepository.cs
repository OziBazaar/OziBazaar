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
        private readonly OziBazaarEntities _dbContext = new OziBazaarEntities();

        public List<UserProductViewModel> GetUserProducts(int UserID, int page = 1, int pageSize = 10)
        {
            List<UserProductViewModel> definedProductsViewModels =
                (from a in _dbContext.Advertisements
                 join p in _dbContext.Products on a.ProductID equals p.ProductID
                 join i in _dbContext.ProductImages on p.ProductID equals i.ProductID
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

        public int GetUserProductsCount(int UserID)
        {
            int userProductsCount =
                (from a in _dbContext.Advertisements
                 join p in _dbContext.Products on a.ProductID equals p.ProductID
                 join i in _dbContext.ProductImages on p.ProductID equals i.ProductID
                 where a.OwnerID == UserID && i.IsThumbnail == true && a.IsActive == true
                 select a)
                 .Count();
            return userProductsCount;
        }

        public List<UserWishListViewModel> GetWishListProducts(int UserID, int page = 1, int pageSize = 10)
        {
            List<UserWishListViewModel> UserWishListViewModels =
                (from w in _dbContext.WishLists
                 join a in _dbContext.Advertisements on w.AdvertizementID equals a.AdvertisementID
                 join p in _dbContext.Products on a.ProductID equals p.ProductID
                 join i in _dbContext.ProductImages on p.ProductID equals i.ProductID
                 where a.OwnerID == UserID && i.IsThumbnail == true
                 select new UserWishListViewModel
                 {
                     WishListID = w.WishListID,
                     AdvertisementID = a.AdvertisementID,
                     ProductID = a.ProductID,
                     Price = a.Price,
                     Description = p.Description,
                     ImagePath = i.ImagePath,
                     StartDate = a.StartDate,
                     EndDate = a.EndDate
                 }
                 ).OrderBy(r => r.WishListID).Skip((page - 1) * pageSize).Take(pageSize).ToList();
            return UserWishListViewModels;
        }

        public int GetWishListProductsCount(int UserID)
        {
            int wishListProductsCount =
                (from w in _dbContext.WishLists
                 join a in _dbContext.Advertisements on w.AdvertizementID equals a.AdvertisementID
                 join p in _dbContext.Products on a.ProductID equals p.ProductID
                 join i in _dbContext.ProductImages on p.ProductID equals i.ProductID
                 where a.OwnerID == UserID && i.IsThumbnail == true
                 select w
                 ).Count();
            return wishListProductsCount;
        }    
    }
}
