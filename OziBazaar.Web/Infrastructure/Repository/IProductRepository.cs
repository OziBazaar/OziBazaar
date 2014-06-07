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
        ProductAddView        AddProduct(int CategoryId);
        ProductEditView       EditProduct(int CategoryId,int productId);       
        IEnumerable<Ad>       GetAdvertisementsList();
        IEnumerable<Category> GetAllCategories();
        void                  AddAdvertisement(AdvertisementModel advertisement);
        void                  UpdateAdvertisement(AdvertisementModel advertisement);
        AdvertisementModel GetAdvertisementById(int advertisementId);
    }
   
}
