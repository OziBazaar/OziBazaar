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

namespace OziBazaar.Notification.Controller
{
    public class NotificationController : INotificationController
    {
        private readonly ISmtpEmailUtil _smtpEmailUtil;
        private readonly ITransformerUtil _transformerUtil;
        private readonly ISerializationUtil _serializationUtil;
        private readonly IAccountRepository _accountRepository;

        public NotificationController(
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

        public bool SendAdvertisementSuspend(AdertisementSummary content, string mailTo)
        {
            bool result;
            try
            {
                NotificationTemplate notificationTemplate = _accountRepository.GetNotificationTemplate(
                    NotificationEnum.NotificationType.Email.ToString(),
                    NotificationEnum.NotificationTemplate.AdvertisementSuspend.ToString());
                string body = _transformerUtil.XmlToHtml(_serializationUtil.Serialize<AdertisementSummary>(content), notificationTemplate.TemplatePath);
                _smtpEmailUtil.SendEmail(mailTo, notificationTemplate.Subject, body);
                result = true;
            }
            catch (Exception ex)
            {
                result = false;
            }
            return result;
        }

        public bool SendActivationEmail(ActivationEmail content, string mailTo)
        {
            bool result;
            try
            {
                NotificationTemplate notificationTemplate = _accountRepository.GetNotificationTemplate(
                    NotificationEnum.NotificationType.Email.ToString(),
                    NotificationEnum.NotificationTemplate.ActivationEmail.ToString());
                string body = _transformerUtil.XmlToHtml(_serializationUtil.Serialize<ActivationEmail>(content), notificationTemplate.TemplatePath);
                _smtpEmailUtil.SendEmail(mailTo, notificationTemplate.Subject, body);
                result = true;
            }
            catch (Exception ex)
            {
                result = false;
            }
            return result;
        }

        public bool SendAdertisementSummary(AdertisementSummary content, string mailTo)
        {
            bool result;
            try
            {
                NotificationTemplate notificationTemplate = _accountRepository.GetNotificationTemplate(
                    NotificationEnum.NotificationType.Email.ToString(),
                    NotificationEnum.NotificationTemplate.AdvertisementInsert.ToString());
                string body = _transformerUtil.XmlToHtml(_serializationUtil.Serialize<AdertisementSummary>(content), notificationTemplate.TemplatePath);
                _smtpEmailUtil.SendEmail(mailTo, notificationTemplate.Subject, body);
                result = true;
            }
            catch (Exception ex)
            {
                result = false;
            }
            return result;
        }

        public bool SendResetPassword(ResetPassword content, string mailTo)
        {
            bool result;
            try
            {
                NotificationTemplate notificationTemplate = _accountRepository.GetNotificationTemplate(
                    NotificationEnum.NotificationType.Email.ToString(),
                    NotificationEnum.NotificationTemplate.ResetPassword.ToString());
                string body = _transformerUtil.XmlToHtml(_serializationUtil.Serialize<ResetPassword>(content), notificationTemplate.TemplatePath);
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
