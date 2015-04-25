namespace OziBazaar.Web.Areas.WebAPI.Models
{
    // this class is used for product category hirerachy
    public class ProductCategory
    {
        public short Level { get; set; }
        public int Id { get; set; }

        public int? ParentId { get; set; }

        public string Name { get; set; }

        public bool HasChild { get; set; }

        public int? EditorId { get; set; }
    }
}