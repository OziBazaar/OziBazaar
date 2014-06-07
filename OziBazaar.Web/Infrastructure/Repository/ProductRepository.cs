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
                            select new ProductFeatureView{DisplayOrder=(int)img.ImageOrder,FeatureName="Image",FeatureValue=img.ImagePath,ProductId=productId,ViewType="" };
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
                         EditorType = property.ControlType,
                         ValueType = property.DataType,
                         IsMandatory = property.IsMandatory.Value,
                         DisplayOrder = (int)productGroupProperty.TabOrder,
                         ValueEnum = productGroupProperty.InitialValue,
                       
                     }).ToList();
               var  productFeatureAdds =productFeatureDetails.Select(x=>new ProductFeatureAdd
                     {
                         PropertyId = x.PropertyId,
                         FeatureName = x.FeatureName,
                         EditorType = x.EditorType,
                         ValueType = x.ValueType,
                         IsMandatory = x.IsMandatory,
                         DisplayOrder = (int)x.DisplayOrder,
                         ValueEnum = ((x.EditorType.ToLower() == "dropdown" || x.EditorType.ToLower() == "radiobutton") &&
                                      !(string.IsNullOrEmpty(x.ValueEnum))) ?
                                      x.ValueEnum.Split(';').ToList<string>() :
                                      null
                     }
                    ).ToList();
                
                return new ProductAddView { Features = productFeatureAdds.OrderBy(feature=>feature.DisplayOrder).ToList() };

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

        private int GetProperty(string propertyName)
        {
            int propertyId = (from property in dbContext.Properties
                              where property.KeyName == propertyName
                              select property.PropertyID).FirstOrDefault();
            return propertyId;
      }

        public ProductEditView EditProduct(int categoryId, int productId)
        {
            var productFeatureDetails =
         (from property in dbContext.Properties
          join productGroupProperty in dbContext.ProductGroupProperties
              on property.PropertyID equals productGroupProperty.PropertyID
          join productProperty in dbContext.ProductProperties 
              on productGroupProperty.ProductGroupPropertyID equals productProperty.ProductGroupPropertyID into filledProperties
          from setProperty in filledProperties.DefaultIfEmpty()
          where productGroupProperty.ProductGroupID == categoryId && setProperty.ProductID==productId
          select new
          {
              PropertyId = productGroupProperty.ProductGroupPropertyID,
              FeatureName = property.KeyName,
              EditorType = property.ControlType,
              ValueType = property.DataType,
              IsMandatory = property.IsMandatory.Value,
              DisplayOrder = (int)productGroupProperty.TabOrder,
              ValueEnum = productGroupProperty.InitialValue,
              CurrentValue=setProperty.Value

          }).ToList();
            var productFeatureEdits = productFeatureDetails.Select(x => new ProductFeatureEdit
            {
                PropertyId = x.PropertyId,
                FeatureName = x.FeatureName,
                EditorType = x.EditorType,
                ValueType = x.ValueType,
                Value = x.CurrentValue,
                IsMandatory = x.IsMandatory,
                DisplayOrder = (int)x.DisplayOrder,
                ValueEnum = ((x.EditorType.ToLower() == "dropdown" || x.EditorType.ToLower() == "radiobutton") &&
                             !(string.IsNullOrEmpty(x.ValueEnum))) ?
                             x.ValueEnum.Split(';').ToList<string>() :
                             null
            }
                 ).ToList();

            return new ProductEditView { Features = productFeatureEdits.OrderBy(feature => feature.DisplayOrder).ToList() };


        }

        public void UpdateProduct(ProductModel product)
        {
            throw new NotImplementedException();
        }
    }
}