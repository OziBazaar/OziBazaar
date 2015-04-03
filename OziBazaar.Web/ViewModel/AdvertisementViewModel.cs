﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.ViewModel
{
    public class AdvertisementViewModel : IValidatableObject
    {
        public int AdvertisementId { get; set; }

        [Required(ErrorMessage="Title is mandatory field",AllowEmptyStrings=false)]
        public string Title { get; set; }

        public int ProductGroupId { get; set; }

        [DisplayName("Start Date")]
        [Required(ErrorMessage="Start Date is mandatory field")]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}",ApplyFormatInEditMode = true)]
        public DateTime? StartDate { get; set; }

        [DisplayName("Finish Date")]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}",ApplyFormatInEditMode = true)]
        [Required(ErrorMessage = "Finish Date is mandatory field")]
        
        public DateTime? FinishDate { get; set; }

        [DataType(DataType.Currency, ErrorMessage="Price should be in currency format")]
        public decimal Price { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            if (this.FinishDate.HasValue &&
                this.StartDate > this.FinishDate)
                yield return new ValidationResult("Finish Date should be greater or equal than start date");
            
        }

      
    }
}