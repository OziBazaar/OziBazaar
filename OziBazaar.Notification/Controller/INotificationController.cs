using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OziBazaar.Notification.Entities;

namespace OziBazaar.Notification.Controller
{
    public interface INotificationController
    {
        bool SendAccountDisable(EmailContentBase content, string mailTo);
        bool SendAdvertisementSuspend(AdertisementSummary content, string mailTo);
        bool SendActivationEmail(ActivationEmail content, string mailTo);
        bool SendAdertisementSummary(AdertisementSummary content, string mailTo);
        bool SendResetPassword(ResetPassword content, string mailTo);
    }
}
