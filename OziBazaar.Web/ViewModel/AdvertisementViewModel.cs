using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.ViewModel
{
    public class AdvertisementViewModel
    {
        public int AdvertisementId { get; set; }
        
        public string Title { get; set; }

        public int CategoryId { get; set; }

        [DisplayName("Start Date")]
        public string StartDate { get; set; }

        [DisplayName("Finish Date")]
        public string FinishDate { get; set; }

        public decimal Price { get; set; }
    }
}