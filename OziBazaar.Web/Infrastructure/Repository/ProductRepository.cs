﻿using OziBazaar.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OziBazaar.DAL;
using OziBazaar.Framework.Specification;
using OziBazaar.Web.ViewModel;

namespace OziBazaar.Web.Infrastructure.Repository
{
    public class ProductRepository : IProductRepository
    {
        
        private Entities dbContext = new Entities();

        private readonly ILookupRepository lookupRepository;
        public ProductRepository(ILookupRepository lookupRepository)
        {
            this.lookupRepository = lookupRepository;
        }

        public AdView GetAd(int adId, out int productId, out int categoryId,out int productGroupId)
        {
            var adInfo = (from ad in dbContext.Advertisements
                          join p in dbContext.Products on ad.ProductID equals p.ProductID
                          where ad.AdvertisementID == adId
                          select new {ad.ProductID, p.ProductGroupID,p.CategoryID, ad.Title }).SingleOrDefault();

           productId = adInfo.ProductID;
           productGroupId = adInfo.ProductGroupID.Value;
           categoryId = adInfo.CategoryID.Value;

           int localProdutId=adInfo.ProductID;

           List<ProductFeatureView> productFeatureViews =
                                                        (
                                                            from productProperty in dbContext.ProductProperties
                                                                where productProperty.ProductID == localProdutId
                                                                join productGroupProperty in dbContext.ProductGroupProperties
                                                                    on productProperty.ProductGroupPropertyID equals productGroupProperty.ProductGroupPropertyID
                                                                join property in dbContext.Properties
                                                                    on productGroupProperty.PropertyID equals property.PropertyID
                                                                join productGroup in dbContext.ProductGroups
                                                                    on productGroupProperty.ProductGroupID equals productGroup.ProductGroupID
                                                                select new ProductFeatureView
                                                                {
                                                                    DisplayOrder = (int)productGroupProperty.TabOrder,
                                                                    FeatureName = property.KeyName,
                                                                    Title=property.Title,
                                                                    FeatureValue = productProperty.Value,
                                                                    ProductId = productProperty.ProductID,
                                                                    ViewType = productGroup.ViewTemplate
                                                                }
                                                        ).ToList<ProductFeatureView>();

            var imglist = from img in dbContext.ProductImages
                          where img.ProductID == localProdutId
                          orderby img.ImageOrder
                          select new ProductFeatureView
                          {
                              DisplayOrder = (int)img.ImageOrder,
                              FeatureName = "Image",
                              Title="Image",
                              FeatureValue = img.ImagePath,
                              ProductId = localProdutId,
                              ViewType = ""
                          };

            return new AdView() {
                                     AdTitle = adInfo.Title,
                                     Product = new ProductView(productFeatureViews.First().ViewType) { 
                                                                Features =   productFeatureViews.Union(imglist).ToList() }
                                };
      }
        public  ProductView GetProduct(int productId)
        {

            List<ProductFeatureView> productFeatureViews =
                (from productProperty in dbContext.ProductProperties
                    where productProperty.ProductID == productId
                    join productGroupProperty in dbContext.ProductGroupProperties
                        on productProperty.ProductGroupPropertyID equals productGroupProperty.ProductGroupPropertyID
                    join property in dbContext.Properties
                        on productGroupProperty.PropertyID equals property.PropertyID
                    join productGroup in dbContext.ProductGroups
                        on productGroupProperty.ProductGroupID equals productGroup.ProductGroupID
                    select new ProductFeatureView
                    {
                        DisplayOrder = (int)productGroupProperty.TabOrder,
                        FeatureName = property.KeyName,
                        Title=property.Title,
                        FeatureValue = productProperty.Value,
                        ProductId = productProperty.ProductID,
                        ViewType = productGroup.ViewTemplate
                    }).ToList<ProductFeatureView>();
            var imglist = from img in dbContext.ProductImages
                            where img.ProductID == productId
                            orderby img.ImageOrder
                            select new ProductFeatureView{
                                                            DisplayOrder=(int)img.ImageOrder,
                                                            FeatureName="Image",
                                                            Title="Image",
                                                            FeatureValue=img.ImagePath,
                                                            ProductId=productId,ViewType="" };

            return new ProductView { Features = productFeatureViews.Union(imglist).ToList() };
        }

        public ProductAddView AddProduct(int CategoryId)
        {
            var productFeatureDetails =
                    (from property in dbContext.Properties
                     join productGroupProperty in dbContext.ProductGroupProperties
                         on property.PropertyID equals productGroupProperty.PropertyID
                     where productGroupProperty.ProductGroupID == CategoryId
                     select new 
                     {
                         PropertyId = productGroupProperty.ProductGroupPropertyID,
                         FeatureName = property.KeyName,
                         Title=property.Title,
                         EditorType = property.ControlType,
                         ValueType = property.DataType,
                         IsMandatory=productGroupProperty.IsMandatory,
                         DisplayOrder = (int)productGroupProperty.TabOrder,
                         ValueEnum = productGroupProperty.InitialValue,
                         DataType = property.DataType,
                         LookupType = property.LookupType,
                         DependsOn=property.DependsOn
                       
                     }).ToList();
               var  productFeatureAdds =productFeatureDetails.Select(x=>new ProductFeatureAdd
                     {
                         PropertyId = x.PropertyId,
                         FeatureName = x.FeatureName,
                         Title=x.Title,
                         EditorType = x.EditorType,
                         ValueType = x.ValueType,
                         IsMandatory = x.IsMandatory??false,
                         DisplayOrder = (int)x.DisplayOrder,
                         DependsOn = x.DependsOn,
                         ValueEnum = ((x.EditorType.ToLower() == "dropdown" || x.EditorType.ToLower() == "radiobutton") 
                                       ?GetEnumValue(x.DataType,x.LookupType,x.DependsOn,x.ValueEnum)
                                       :null)
                     }
                    ).ToList();
                
                return new ProductAddView { Features = productFeatureAdds.OrderBy(feature=>feature.DisplayOrder).ToList() };

        }
        
        private List<string> GetEnumValue(string dataType,string lookupType,string dependsOn,string valueString)
        {
            if( dataType!=null &&  dataType.ToLower()=="lookup")
            {
                if (!string.IsNullOrEmpty(dependsOn))
                    return null;
                return lookupRepository.GetMainLookups(lookupType).Select(x => x.Name).ToList();
            }
            else
            {
               return !(string.IsNullOrEmpty(valueString)) ?
                                      valueString.Split(';').ToList<string>() :
                                      null;
            }
        }
        
        //public IEnumerable<Ad> GetAdvertisementsList()
        //{
        //        List<Ad> ads = (from advertisement in dbContext.Advertisements
        //                        select new Ad
        //                        {
        //                            Id = advertisement.AdvertisementID,
        //                            ProductId = advertisement.ProductID,
        //                            CategoryId=advertisement.Product.ProductGroupID.Value,
        //                            Title = advertisement.Title,
        //                            StartDate = advertisement.StartDate,
        //                            EndDate = advertisement.EndDate,
        //                            IsActive = advertisement.IsActive.Value,
        //                            UserId = advertisement.OwnerID
        //                        }).ToList<Ad>();
        //        return ads;
          
        //}

        public IEnumerable<ProductCategory> GetAllCategories()
        {
                List<ProductCategory> categories = (from productGroup in dbContext.ProductGroups
                                             select new ProductCategory
                                             {
                                                 Id = productGroup.ProductGroupID,
                                                 Name = productGroup.Description
                                             }).ToList<ProductCategory>();
                return categories;
          
        }

        public Ad AddAdvertisement(int userId, AdvertisementModel ad)
        {
                if (ad.Features == null || ad.Features.Count() == 0)
                    throw new ArgumentNullException("Invalid argument");
                Advertisement adv = new Advertisement();
                adv.StartDate = ad.StartDate;
                adv.EndDate = ad.EndDate;

                Product product = new Product()
                {
                    ProductGroupID=ad.ProductGroupId,
                    Description=ad.Title,
                    CategoryID = ad.CategoryId
                };
                foreach (ProductFeature productFeature in ad.Features)
                {
                    product.ProductProperties.Add(new ProductProperty()
                    {
                        ProductGroupPropertyID =Int32.Parse( productFeature.Key),
                        Value = productFeature.Value
                    });
                }
                adv.Product = product;
                adv.OwnerID = userId;
                adv.Price = ad.Price;
                adv.Title = ad.Title;
                adv.IsActive = true;

                dbContext.Advertisements.Add(adv);
                dbContext.SaveChanges();
                return new Ad() { 
                                    Id=adv.AdvertisementID,
                                    ProductId=adv.ProductID
                                };
        }

        public ProductEditView EditProduct(int productGroupId, int productId)
        {
           var q = from p in dbContext.ProductProperties
                  where p.ProductID==productId
                      select p;
         var productFeatureDetails =
                                     (from property in dbContext.Properties
                                      join productGroupProperty in dbContext.ProductGroupProperties
                                          on property.PropertyID equals productGroupProperty.PropertyID
                                      join productProperty in q
                                          on productGroupProperty.ProductGroupPropertyID equals productProperty.ProductGroupPropertyID into filledProperties
                                      from setProperty in filledProperties.DefaultIfEmpty()
                                      where productGroupProperty.ProductGroupID == productGroupId 
                                            && property.DataType !="Image"
                                      select new
                                      {
                                          PropertyId = productGroupProperty.ProductGroupPropertyID,
                                          FeatureName = property.KeyName,
                                          Title=property.Title,
                                          EditorType = property.ControlType,
                                          ValueType = property.DataType,
                                          IsMandatory = productGroupProperty.IsMandatory.Value,
                                          DisplayOrder = (int)productGroupProperty.TabOrder,
                                          ValueEnum = productGroupProperty.InitialValue,
                                          CurrentValue=setProperty.Value,
                                          DataType = property.DataType,
                                          LookupType = property.LookupType,
                                          DependsOn = property.DependsOn

                                      })
          .ToList();
            var productFeatureEdits = productFeatureDetails.Select(x => new ProductFeatureEdit
            {
                PropertyId = x.PropertyId,
                FeatureName = x.FeatureName,
                Title=x.Title,
                EditorType = x.EditorType,
                ValueType = x.ValueType,
                Value = x.CurrentValue,
                IsMandatory = x.IsMandatory,
                DisplayOrder = (int)x.DisplayOrder,
                DependsOn = x.DependsOn,
                ValueEnum = ((x.EditorType.ToLower() == "dropdown" || x.EditorType.ToLower() == "radiobutton")
                                       ? GetEnumValue(x.DataType, x.LookupType, x.DependsOn, x.ValueEnum)
                                       : null)
            }
                 ).ToList();

            return   new ProductEditView
                              {
                                  Features = productFeatureEdits.OrderBy(feature => feature.DisplayOrder).ToList()
                              };
        }

        public void UpdateAdvertisement(AdvertisementModel advertisementModel)
        {
            if (advertisementModel.Features == null || advertisementModel.Features.Count() == 0)
                throw new ArgumentNullException();

            var ad =( from adv in dbContext.Advertisements
                                            .Include("Product")
                                            .Include("Product.ProductProperties")
                      where adv.AdvertisementID == advertisementModel.Id
                      select adv).Single();
 
            var properties = dbContext.ProductProperties.Where(pp => pp.ProductID == ad.ProductID);
            var product = dbContext.Products.Single(p => p.ProductID == ad.ProductID);
            dbContext.ProductProperties.RemoveRange(properties);

            ad.StartDate = advertisementModel.StartDate;
            ad.EndDate = advertisementModel.EndDate;
            ad.Price = advertisementModel.Price;
            ad.Title = advertisementModel.Title;
            ad.IsActive = true;
            
            product.Description = advertisementModel.Title ;
            foreach (ProductFeature productFeature in advertisementModel.Features)
            {
                product.ProductProperties.Add(new ProductProperty()
                {
                    ProductGroupPropertyID = Int32.Parse(productFeature.Key),
                    Value = productFeature.Value
                });
            }
            dbContext.SaveChanges();
        }

        public AdvertisementModel GetAdvertisementById(int advertisementId)
        {
            var query = from ad in dbContext.Advertisements
                        where ad.AdvertisementID == advertisementId
                        select new AdvertisementModel() { 
                                                            Id=advertisementId,
                                                            Title=ad.Title,
                                                            StartDate=ad.StartDate,
                                                            EndDate=ad.EndDate,
                                                            Price=ad.Price
                                                        };
            return query.Single();
        }
        public void AddAttachment(List<ProductImage> images)
        {

            foreach (var image in images)
            {
                dbContext.ProductImages.Add(image);
            }
            dbContext.SaveChanges();
        }
        public IEnumerable<ProductImage> GetAdImages(int adId)
        {
            int productId = dbContext.Advertisements.Single(ad => ad.AdvertisementID == adId).ProductID;
          return  dbContext.ProductImages.Where(pi => pi.ProductID == productId).ToArray();
        }
        public void DeleteImage(int productImageId)
        {
            var toBeDeletedImage = dbContext.ProductImages.Single(pi => pi.ProductImageID == productImageId);
            dbContext.ProductImages.Remove(toBeDeletedImage);
            dbContext.SaveChanges();
        }
        
        public UserProfile GetUser(string userName)
        {
                 UserProfile userProfileModel =
                    (from userProfile in dbContext.UserProfiles
                     where userProfile.UserName == userName
                     select userProfile).FirstOrDefault();
                return userProfileModel;
        }

        public bool ActivateUser(string userName, string emailAddress)
        { 
                UserProfile userProfileModel = GetUser(userName);
                if (userProfileModel != null && userProfileModel.EmailAddress == emailAddress)
                {
                    userProfileModel.Activated = true;
                    dbContext.SaveChanges();
                    return true;
                }
                else
                {
                    return false;
                }         
        }

        public List<WishListViewModel> GetWishList(int userId)
        {
            try
            {
                List<WishListViewModel> wishListViewModels =
                    (from userProfile in dbContext.UserProfiles
                     where userProfile.UserId == userId
                     join wishList in dbContext.WishLists
                         on userProfile.UserId equals wishList.UserID
                     join advertisement in dbContext.Advertisements
                         on wishList.AdvertizementID equals advertisement.AdvertisementID
                     join product in dbContext.Products
                         on advertisement.ProductID equals product.ProductID
                     join productGroup in dbContext.ProductGroups
                         on product.ProductGroupID equals productGroup.ProductGroupID
                     select new WishListViewModel
                     {
                         WishListId = wishList.WishListID,
                         AdvertisementId = wishList.AdvertizementID,
                         ProductId = advertisement.ProductID,
                         ProductDescription = product.Description,
                         ProductGroupDescription = productGroup.Description,
                         Price = advertisement.Price,
                         StartDate = advertisement.StartDate,
                         EndDate = advertisement.EndDate
                     }).ToList<WishListViewModel>();
                return wishListViewModels;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<ProductGroup> GetProductGroupList()
        {
            List<ProductGroup> productGroups;

            productGroups = dbContext.ProductGroups.ToList<ProductGroup>();
            return productGroups;
        }

        public List<SearchViewModel> SearchProduct(string tag)
        {
            List<SearchViewModel> searchResult =
            (from advertisement in dbContext.Advertisements
             join product in dbContext.Products
             on advertisement.ProductID equals product.ProductID
             join productProperty in dbContext.ProductProperties
             on product.ProductID equals productProperty.ProductID
             where advertisement.IsActive == true && productProperty.Value == tag
             select new SearchViewModel
             {
                 ProductId = product.ProductID,
                 ProductDescription = product.Description,
            //     Price = advertisement.Price,
                 StartDate = advertisement.StartDate,
                 EndDate = advertisement.EndDate
             }
            ).Distinct().ToList();
            return searchResult;
        }

        public void AddToWishList(int adId,int userId)
        {
            var newItem= new WishList(){AdvertizementID=adId,UserID = userId};
            if (!dbContext.WishLists.Any(wi => wi.UserID == userId && wi.AdvertizementID == adId))
            {
                dbContext.WishLists.Add(newItem);
                dbContext.SaveChanges();
            }
        }

        public void RemoveFromWishList(int adId, int userId)
        {
             var deletedItem=dbContext.WishLists.SingleOrDefault(item => item.AdvertizementID == adId && item.UserID== userId);

             if (deletedItem != null)
             {
                 dbContext.WishLists.Remove(deletedItem);
                 dbContext.SaveChanges();
             }
        }

        public void ClearWishList( int userId)
        {  
            var deletedItems = dbContext.WishLists.Where(item => item.UserID == userId);

            if (deletedItems.Any())
            {
                foreach (var item in deletedItems)
                {
                    dbContext.WishLists.Remove(item);    
                }                
                dbContext.SaveChanges();
            }
        }
        
        public IEnumerable<Ad> GetAdvertisementsList(int? categoryId,ISpecification<Advertisement> specification)
        {
            var query = from advertisement in dbContext.Advertisements
                select advertisement;

            if (categoryId.HasValue)
                query = query.Where(a => a.Product.CategoryID == categoryId);

            List<Ad> ads = (from advertisement in query
                                .Where(specification.SatisfiedBy())
                             select new Ad
                            {
                                Id = advertisement.AdvertisementID,
                                ProductId = advertisement.ProductID,
                                CategoryId = advertisement.Product.CategoryID.Value,
                                ProductGroupId = advertisement.Product.ProductGroupID.Value,
                                Title = advertisement.Title,
                                StartDate = advertisement.StartDate,
                                EndDate = advertisement.EndDate,
                                IsActive = advertisement.IsActive.Value,
                                UserId = advertisement.OwnerID
                            }).ToList<Ad>();
            return ads;
        }
        public bool IsAdOwner(int userId, int adId)
        { 
              bool isOwner = (from advertisement in dbContext.Advertisements
                             where advertisement.OwnerID == userId && advertisement.AdvertisementID == adId
                             select advertisement.AdvertisementID).Any();
            return isOwner;

        }
        
        public void DeleteAd(int adId, int productId, int userId)
        {
            if(!IsAdOwner(userId,adId))
                throw new UnauthorizedAccessException("You can not delete this advertisement");
            var images=dbContext.ProductImages.Where(pi => pi.ProductID == productId).ToList();
            foreach (var image in images)
            {
                dbContext.ProductImages.Remove(image);
            }

            var productProperties = dbContext.ProductProperties.Where(pp => pp.ProductID == productId).ToList();
            foreach (var property in productProperties)
            {
                dbContext.ProductProperties.Remove(property);
            }

            var product=dbContext.Products.SingleOrDefault( p => p.ProductID == productId);
            if (product != null)
                dbContext.Products.Remove(product);

            var advertisement = dbContext.Advertisements.SingleOrDefault(ad => ad.AdvertisementID == adId);
            if (advertisement != null)
                dbContext.Advertisements.Remove(advertisement);
            dbContext.SaveChanges();
        }


        public IEnumerable<ProductCategoryHierarchy> GetProductCategoryHierarchies(int level, int parentId)
        {
            var q = from item in dbContext.ProductCategoryHierarchies
                where item.LevelId == level && item.ParentId == parentId
                select item;
            return q.ToList();
        }
    }
}