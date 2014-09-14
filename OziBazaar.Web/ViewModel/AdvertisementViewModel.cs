using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.ViewModel
{
    public class AdvertisementViewModel
    {
        public int AdvertisementId { get; set; }

        [Required(ErrorMessage="Title is mandatory field",AllowEmptyStrings=false)]
        public string Title { get; set; }

        public int CategoryId { get; set; }

        [DisplayName("Start Date")]
        [Required(ErrorMessage="Start Date is mandatory field",AllowEmptyStrings=false)]
        public string StartDate { get; set; }

        [DisplayName("Finish Date")]
        [Required(ErrorMessage = "Finish Date is mandatory field", AllowEmptyStrings = false)]
        public string FinishDate { get; set; }

        [DataType(DataType.Currency, ErrorMessage="Price should be in currency format")]
        public decimal Price { get; set; }
    }
}