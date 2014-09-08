using Microsoft.WindowsAzure.Storage.Table;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace OziBazaat.NotificationUI.Models
{
    public class MailingList : TableEntity
    {
        public MailingList()
        {
            this.RowKey = "mailinglist";
        }

        [Required]
        [RegularExpression(@"[\w]+",
         ErrorMessage = @"Only alphanumeric characters and underscore (_) are allowed.")]
        [Display(Name = "List Name")]
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
        [Display(Name = "'From' Email Address")]
        public string FromEmailAddress { get; set; }

        public string Description { get; set; }
    }
}