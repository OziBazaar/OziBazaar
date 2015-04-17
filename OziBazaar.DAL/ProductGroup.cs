//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace OziBazaar.DAL
{
    using System;
    using System.Collections.Generic;
    
    public partial class ProductGroup
    {
        public ProductGroup()
        {
            this.Products = new HashSet<Product>();
            this.ProductGroupProperties = new HashSet<ProductGroupProperty>();
        }
    
        public int ProductGroupID { get; set; }
        public string Description { get; set; }
        public string ViewTemplate { get; set; }
        public string EditTemplate { get; set; }
        public Nullable<int> CategoryID { get; set; }
        public byte[] Version { get; set; }
    
        public virtual ICollection<Product> Products { get; set; }
        public virtual ICollection<ProductGroupProperty> ProductGroupProperties { get; set; }
    }
}
