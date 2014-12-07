using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Notification.Email
{
    public interface ISmtpEmailUtil
    {
        void SendEmail(string mailTo, string subject, string body);
    }
}
