using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using OziBazaar.Web.Models;

namespace OziBazaar.Web.Infrastructure.Email
{
    public class SmtpEmail : ISmtpEmail
    {
        private readonly EmailSettings _emailSettings;

        public SmtpEmail()
        {
            _emailSettings = new EmailSettings()
            {
                MailFromAddress = ConfigurationManager.AppSettings["MailFromAddress"],
                Password = ConfigurationManager.AppSettings["Password"],
                Username = ConfigurationManager.AppSettings["Username"],
                ServerName = ConfigurationManager.AppSettings["ServerName"],
                ServerPort = int.Parse(ConfigurationManager.AppSettings["ServerPort"]),
                UseSsl = bool.Parse(ConfigurationManager.AppSettings["UseSsl"])
            };
        }

        public void SendActivationEmail(string activationCode, string fullName, string mailTo)
        {
            _emailSettings.MailToAddress = mailTo;
            using (var smtpClient = new SmtpClient())
            {
                smtpClient.EnableSsl = _emailSettings.UseSsl;
                smtpClient.Host = _emailSettings.ServerName;
                smtpClient.Port = _emailSettings.ServerPort;
                smtpClient.UseDefaultCredentials = false;
                smtpClient.Credentials =
                    new NetworkCredential(_emailSettings.Username, _emailSettings.Password);
                smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                StringBuilder body = new StringBuilder()
                .Append("Hello ")
                .Append(fullName.Trim())
                .Append(",")
                .Append("<br /><br />Please click the following link to activate your account")
                .Append("<br />")
                .Append("<a href = \"http://")
                .Append(HttpContext.Current.Request.Url.Host)
                .Append(":")
                .Append(HttpContext.Current.Request.Url.Port)
                .Append("/Account/Activation?ActivationCode=")
                .Append(activationCode)
                .Append("\">Click here to activate your account.</a>")
                .Append("<br /><br />Thanks");
                MailMessage mailMessage = new MailMessage(
                    _emailSettings.MailFromAddress,
                    _emailSettings.MailToAddress,
                    "Account Activation",
                    body.ToString());
                mailMessage.IsBodyHtml = true;
                smtpClient.Send(mailMessage);
            }
        }

        public void SendResetPasswordEmail(string newPassword, string fullName, string mailTo)
        {
            _emailSettings.MailToAddress = mailTo;
            using (var smtpClient = new SmtpClient())
            {
                smtpClient.EnableSsl = _emailSettings.UseSsl;
                smtpClient.Host = _emailSettings.ServerName;
                smtpClient.Port = _emailSettings.ServerPort;
                smtpClient.UseDefaultCredentials = false;
                smtpClient.Credentials =
                    new NetworkCredential(_emailSettings.Username, _emailSettings.Password);
                smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                StringBuilder body = new StringBuilder()
                .Append("Hello ")
                .Append(fullName.Trim())
                .Append(",")
                .Append("<br /><br />Your password has been reset to: <b>")
                .Append(newPassword)
                .Append("</b>")
                .Append("<br /><br />Thanks");
                MailMessage mailMessage = new MailMessage(
                    _emailSettings.MailFromAddress,
                    _emailSettings.MailToAddress,
                    "Reset Password",
                    body.ToString());
                mailMessage.IsBodyHtml = true;
                smtpClient.Send(mailMessage);
            }
        }
    }
}