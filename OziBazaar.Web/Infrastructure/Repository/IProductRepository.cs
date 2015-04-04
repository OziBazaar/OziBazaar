﻿using OziBazaar.DAL;
using OziBazaar.Framework.Specification;
using OziBazaar.Web.Models;
using OziBazaar.Web.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Web.Infrastructure.Repository
{
    public interface IProductRepository
    {
        ProductView           GetProduct(int productId);
        AdView           GetAd(int adId, out int productId,out int categoryId);
        ProductAddView        AddProduct(int CategoryId);
        ProductEditView EditProduct(int productGroupId, int productId);       
        IEnumerable<Ad>       GetAdvertisementsList(int? categoryId, ISpecification<Advertisement> specification);

        IEnumerable<Category> GetAllCategories();
        Ad                  AddAdvertisement(int userId, AdvertisementModel advertisement);
        void                  UpdateAdvertisement(AdvertisementModel advertisement);

        AdvertisementModel GetAdvertisementById(int advertisementId);

        void AddAttachment(List<ProductImage> images);

        IEnumerable<ProductImage> GetAdImages(int productId);

        void DeleteImage(int productImageId);
        List<WishListViewModel> GetWishList(int userId);
        List<ProductGroup> GetProductGroupList();
        List<SearchViewModel> SearchProduct(string tag);

        void AddToWishList(int adId, int userId);
        void RemoveFromWishList(int adId, int userId);

        void ClearWishList(int userId);

        bool IsAdOwner(int userId, int adId);

        void DeleteAd(int userId,int adId, int productId);

        IEnumerable<ProductCategoryHierarchy> GetProductCategoryHierarchies(int level, int parentId);

    }
}
