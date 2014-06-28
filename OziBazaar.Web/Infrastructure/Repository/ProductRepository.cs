using OziBazaar.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OziBazaar.DAL;

namespace OziBazaar.Web.Infrastructure.Repository
{
    public class ProductRepository : IProductRepository
    {
        
        private OziBazaarEntities dbContext = new OziBazaarEntities();
        private readonly ILookupRepository lookupRepository;
        public ProductRepository(ILookupRepository lookupRepository)
        {
            this.lookupRepository = lookupRepository;
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
                                                            FeatureValue=img.ImagePath,
                                                            ProductId=productId,ViewType="" };

            return new ProductView { Features = productFeatureViews.Union(imglist.Take(1)).ToList() };
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
        
        public IEnumerable<Ad> GetAdvertisementsList()
        {
                List<Ad> ads = (from advertisement in dbContext.Advertisements
                                select new Ad
                                {
                                    Id = advertisement.AdvertisementID,
                                    ProductId = advertisement.ProductID,
                                    CategoryId=advertisement.Product.ProductGroupID.Value,
                                    Title = advertisement.Title,
                                    StartDate = advertisement.StartDate,
                                    EndDate = advertisement.EndDate,
                                    IsActive = advertisement.IsActive.Value,
                                    UserId = advertisement.OwnerID
                                }).ToList<Ad>();
                return ads;
          
        }

        public IEnumerable<Category> GetAllCategories()
        {
                List<Category> categories = (from productGroup in dbContext.ProductGroups
                                             select new Category
                                             {
                                                 Id = productGroup.ProductGroupID,
                                                 Name = productGroup.Description
                                             }).ToList<Category>();
                return categories;
          
        }

        public void AddAdvertisement(AdvertisementModel ad)
        {
                if (ad.Features == null || ad.Features.Count() == 0)
                    throw new ArgumentNullException();
                Advertisement adv = new Advertisement();
                adv.StartDate = ad.StartDate;
                adv.EndDate = ad.EndDate;

                Product product = new Product() { ProductGroupID=ad.Category,Description=ad.Title};
                foreach (ProductFeature productFeature in ad.Features)
                {
                    product.ProductProperties.Add(new ProductProperty()
                    {
                        ProductGroupPropertyID =Int32.Parse( productFeature.Key),
                        Value = productFeature.Value
                    });
                }
                adv.Product = product;
                adv.OwnerID = 1;
                adv.Price = "1000";
                adv.Title = ad.Title;
                adv.IsActive = true;

                dbContext.Advertisements.Add(adv);
                dbContext.SaveChanges();
        }
        
        public ProductEditView EditProduct(int categoryId, int productId)
        {
           var q=from p in dbContext.ProductProperties
                  where p.ProductID==productId
                      select p;
         var productFeatureDetails =
                                     (from property in dbContext.Properties
                                      join productGroupProperty in dbContext.ProductGroupProperties
                                          on property.PropertyID equals productGroupProperty.PropertyID
                                      join productProperty in q
                                          on productGroupProperty.ProductGroupPropertyID equals productProperty.ProductGroupPropertyID into filledProperties
                                      from setProperty in filledProperties.DefaultIfEmpty()
                                      where productGroupProperty.ProductGroupID == categoryId 
                                      select new
                                      {
                                          PropertyId = productGroupProperty.ProductGroupPropertyID,
                                          FeatureName = property.KeyName,
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

            return new ProductEditView { Features = productFeatureEdits.OrderBy(feature => feature.DisplayOrder).ToList() };


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
            ad.OwnerID = 1;
            ad.Price = "1000";
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
                                                            EndDate=ad.EndDate
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
        public IEnumerable<ProductImage> GetProductImages(int productId)
        {
          return  dbContext.ProductImages.Where(pi => pi.ProductID == productId).ToArray();
        }
        public void DeleteImage(int productImageId)
        {
            var toBeDeletedImage = dbContext.ProductImages.Single(pi => pi.ProductImageID == productImageId);
            dbContext.ProductImages.Remove(toBeDeletedImage);
            dbContext.SaveChanges();
        }
    }
}