using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Notification.Enums
{
    public static class NotificationEnum
    {
        public enum NotificationType
        {
            Email,
            Sms
        };

        public enum NotificationTemplate
        {
            AccountDisable,
            ActivationEmail,
            AdvertisementInsert,
            AdvertisementSuspend,
            ResetPassword
            
        };
    }
}
