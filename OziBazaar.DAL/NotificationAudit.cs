//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace OziBazaar.DAL
{
    using System;
    using System.Collections.Generic;
    
    public partial class NotificationAudit
    {
        public int NotificationAuditID { get; set; }
        public Nullable<int> NotificationConfigurationID { get; set; }
        public string Sender { get; set; }
        public string Receiver { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public byte[] Version { get; set; }
    
        public virtual NotificationTemplate NotificationTemplate { get; set; }
    }
}
