using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.Models
{
    public class ProductFeatureAdd
    {
        public int ProductId { get; set; }
        public int PropertyId { get; set; }
        public string FeatureName { get; set; }
        public string Title { get; set; }
        public string EditorType { get; set; }
        public string ValueType { get; set; }
        public int DisplayOrder { get; set; }
        public bool IsMandatory { get; set; }
        public string DependsOn { get; set; }
        public List<string> ValueEnum { get; set; }
    }
    public class ProductFeatureEdit : ProductFeatureAdd
    {
        public string Value { get; set; }
    }
    public class ProductFeature
    {
        public string Key { get; set; }
        public string Value { get; set; }
    }
}