using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using OziBazaar.Notification.Entities;

namespace OziBazaar.Notification.Email
{
    public class SmtpEmailUtil : ISmtpEmailUtil
    {
        private readonly EmailSetting _emailSetting;

        public SmtpEmailUtil()
        {
            _emailSetting = new EmailSetting()
            {
                MailFromAddress = ConfigurationManager.AppSettings["MailFromAddress"],
                Password = ConfigurationManager.AppSettings["Password"],
                Username = ConfigurationManager.AppSettings["AccountUsername"],
                ServerName = ConfigurationManager.AppSettings["ServerName"],
                ServerPort = int.Parse(ConfigurationManager.AppSettings["ServerPort"]),
                UseSsl = bool.Parse(ConfigurationManager.AppSettings["UseSsl"])
            };
        }

        public void SendEmail(string mailTo, string subject, string body)
        {
            _emailSetting.MailToAddress = mailTo;
            using (var smtpClient = new SmtpClient())
            {
                smtpClient.EnableSsl = _emailSetting.UseSsl;
                smtpClient.Host = _emailSetting.ServerName;
                smtpClient.Port = _emailSetting.ServerPort;
                smtpClient.UseDefaultCredentials = false;
                smtpClient.Credentials = new NetworkCredential(_emailSetting.Username, _emailSetting.Password);
                smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                MailMessage mailMessage = new MailMessage(
                    _emailSetting.MailFromAddress,
                    _emailSetting.MailToAddress,
                    subject,
                    body);
                mailMessage.IsBodyHtml = true;
                smtpClient.Send(mailMessage);
            }
        }
    }
}
