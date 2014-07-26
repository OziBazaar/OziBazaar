using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.Models
{
    public class WishListViewModel
    {
        public int WishListId { get; set; }
        public int AdvertisementId { get; set; }
        public int ProductId { get; set; }
        public string ProductGroupDescription { get; set; }
        public string ProductDescription { get; set; }
        public decimal Price { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }
}