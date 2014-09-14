﻿using Microsoft.WindowsAzure.Storage.Table;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Notification.Common.Models
{
    public class SendEmail : TableEntity
    {
        public long MessageRef { get; set; }
        public string EmailAddress { get; set; }
        public DateTime? ScheduledDate { get; set; }
        public String FromEmailAddress { get; set; }
        public string SubjectLine { get; set; }
        public bool? EmailSent { get; set; }
        public string SubscriberGUID { get; set; }
        public string ListName { get; set; }
    }
}
