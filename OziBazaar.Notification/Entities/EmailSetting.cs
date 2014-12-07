using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Notification.Entities
{
    public class EmailSetting
    {
        public string MailToAddress { get; set; }
        public string MailFromAddress { get; set; }
        public bool UseSsl { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string ServerName { get; set; }
        public int ServerPort { get; set; }
    }
}
