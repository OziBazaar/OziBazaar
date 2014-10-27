using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.Models.Admin
{
    public class ProductGroup
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public string ViewTemplate { get; set; }

        public string EditTemplate { get; set; }
    }
}