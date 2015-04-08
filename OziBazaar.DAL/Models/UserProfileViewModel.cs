using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using OziBazaar.DAL;

namespace OziBazaar.DAL.Models
{
    public class UserProfileViewModel
    {
        public int UserId { get; set; }

        [Display(Name = "User name")]
        public string UserName { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [Display(Name = "Fullname")]
        public string FullName { get; set; }

        [Display(Name = "Email Address")]
        public string EmailAddress { get; set; }

        [DataType(DataType.PhoneNumber)]
        [Display(Name = "Phone")]
        public string Phone { get; set; }

        [Required]
        [Display(Name = "Country")]
        public int CountryID { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [Display(Name = "Street Address")]
        public string Address1 { get; set; }

        [DataType(DataType.Text)]
        [Display(Name = "Suburb")]
        public string Address2 { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [Display(Name = "Post Code")]
        public string PostCode { get; set; }

        public List<Country> CountryList { get; set; }
    }
}