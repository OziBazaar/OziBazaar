using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Web.Infrastructure.Email
{
    public interface ISmtpEmail
    {
        void SendActivationEmail(string activationCode, string fullName, string mailTo);
        void SendResetPasswordEmail(string newPassword, string fullName, string mailTo);
    }
}
