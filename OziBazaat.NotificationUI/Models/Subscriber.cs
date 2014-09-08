using Microsoft.WindowsAzure.Storage.Table;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace OziBazaat.NotificationUI.Models
{
    public class Subscriber : TableEntity
    {
        [Required]
        public string ListName
        {
            get
            {
                return this.PartitionKey;
            }
            set
            {
                this.PartitionKey = value;
            }
        }

        [Required]
        [Display(Name = "Email Address")]
        public string EmailAddress
        {
            get
            {
                return this.RowKey;
            }
            set
            {
                this.RowKey = value;
            }
        }

        public string SubscriberGUID { get; set; }

        public bool? Verified { get; set; }

    }
}