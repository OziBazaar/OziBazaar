using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.Models
{
    public class EmailSettings
    {
        public string MailToAddress;
        public string MailFromAddress;
        public bool UseSsl;
        public string Username;
        public string Password;
        public string ServerName;
        public int ServerPort;
    }
}