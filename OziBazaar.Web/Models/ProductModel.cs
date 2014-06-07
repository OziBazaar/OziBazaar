using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.Models
{
    public class ProductModel
    {
        public int Id { get; set; }
        public IEnumerable<ProductFeature> Features { get; set; }
    }
    public class AdvertisementModel
    {
        public int Id { get; set; }
        public int Category { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Title { get; set; }
        public IEnumerable<ProductFeature> Features { get; set; }

    }
}