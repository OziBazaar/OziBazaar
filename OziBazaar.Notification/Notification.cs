using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OziBazaar.Common.Serialization;
using OziBazaar.Common.Transformation;
using OziBazaar.DAL;
using OziBazaar.DAL.Repository;
using OziBazaar.Notification.Email;
using OziBazaar.Notification.Entities;
using OziBazaar.Notification.Enums;

namespace OziBazaar.Notification
{
    public class Notification
    {
        private readonly ISmtpEmailUtil _smtpEmailUtil;
        private readonly ITransformerUtil _transformerUtil;
        private readonly ISerializationUtil _serializationUtil;
        private readonly IAccountRepository _accountRepository;

        public Notification(
            ISmtpEmailUtil smtpEmailUtil,
            ITransformerUtil transformerUtil,
            ISerializationUtil serializationUtil,
            IAccountRepository accountRepository)
        {
            this._smtpEmailUtil = smtpEmailUtil;
            this._transformerUtil = transformerUtil;
            this._serializationUtil = serializationUtil;
            this._accountRepository = accountRepository;
        }

        public bool SendAccountDisable(EmailContentBase content, string mailTo)
        {
            bool result;
            try
            {
                NotificationTemplate notificationTemplate = _accountRepository.GetNotificationTemplate(
                    NotificationEnum.NotificationType.Email.ToString(),
                    NotificationEnum.NotificationTemplate.AccountDisable.ToString());
                string body = _transformerUtil.XmlToHtml(_serializationUtil.Serialize<EmailContentBase>(content), notificationTemplate.TemplatePath);
                _smtpEmailUtil.SendEmail(mailTo, notificationTemplate.Subject, body);
                result = true;
            }
            catch (Exception ex)
            {
                result = false;
            }
            return result;
        }


        public bool SendAccountDisable(EmailContentBase content, string mailTo)
        {
            bool result;
            try
            {
                NotificationTemplate notificationTemplate = _accountRepository.GetNotificationTemplate(
                    NotificationEnum.NotificationType.Email.ToString(),
                    NotificationEnum.NotificationTemplate.AccountDisable.ToString());
                string body = _transformerUtil.XmlToHtml(_serializationUtil.Serialize<EmailContentBase>(content), notificationTemplate.TemplatePath);
                _smtpEmailUtil.SendEmail(mailTo, notificationTemplate.Subject, body);
                result = true;
            }
            catch (Exception ex)
            {
                result = false;
            }
            return result;
        }

    }
}
