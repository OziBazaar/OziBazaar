﻿using OziBazaar.DAL;
using OziBazaar.Web.Models;
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
        ProductView           GetAd(int adId,out int productId);
        ProductAddView        AddProduct(int CategoryId);
        ProductEditView       EditProduct(int CategoryId,int productId);       
        IEnumerable<Ad>       GetAdvertisementsList();
        IEnumerable<Ad> GetAdvertisementsList( string userName);

        IEnumerable<Category> GetAllCategories();
        void                  AddAdvertisement(string userName, AdvertisementModel advertisement);
        void                  UpdateAdvertisement(AdvertisementModel advertisement);
        AdvertisementModel GetAdvertisementById(int advertisementId);
        void AddAttachment(List<ProductImage> images);

        IEnumerable<ProductImage> GetAdImages(int productId);

        void DeleteImage(int productImageId);
        List<WishListViewModel> GetWishList(string userName);
        List<ProductGroup> GetProductGroupList();
        List<SearchViewModel> SearchProduct(string tag);

        void AddToWishList(int adId, string userName);
        void RemoveFromWishList(int adId, string userName);

        void ClearWishList(string userName);

        bool IsAdOwner(string userName, int adId);
       

    }
   
}
