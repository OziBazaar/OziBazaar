namespace OziBazaar.Web.Areas.WebAPI.Models
{
    public class ProductCategory
    {
        public short Level { get; set; }
        public int Id { get; set; }

        public int? ParentId { get; set; }

        public string Name { get; set; }
    }
}