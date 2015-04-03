using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using OziBazaar.Web.Areas.WebAPI.Models;
using OziBazaar.Web.Infrastructure.Repository;

namespace OziBazaar.Web.Areas.WebAPI.Controllers
{
    public class ProductCategoryController : ApiController
    {
        private IProductRepository productRepository;

        public ProductCategoryController()
        {
            productRepository=new ProductRepository(new LookupRepository());
            
        }
        [HttpGet()]
        public IEnumerable<ProductCategory> Get(int level, int parent)
        {
            var lst = productRepository.GetProductCategoryHierarchies(level, parent);
           return lst.Select(x => new ProductCategory()
           {
               Id = x.Id,
               Level = x.LevelId.Value,
               Name = x.Name,
               ParentId = x.ParentId
           }).ToList();
        }
    }
}
