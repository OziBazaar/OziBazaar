using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.Models
{
    public class ProductFeatureView
    {
        public int ProductId { get; set; }
        public string FeatureName { get; set; }
        public string Title { get; set; }
        public string FeatureValue { get; set; }
        public string ViewType { get; set; }
        public int DisplayOrder { get; set; }
    }
}