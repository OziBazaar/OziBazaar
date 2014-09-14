using OziBazaar.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.ViewModel
{
    public class AdView
    {
       
        public string AdTitle { get; set; }
        public ProductView Product { get; set; }
    }
}