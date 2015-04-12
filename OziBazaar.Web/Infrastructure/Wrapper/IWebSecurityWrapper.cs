using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OziBazaar.DAL.Models;

namespace OziBazaar.Web.Infrastructure.Wrapper
{
    public interface IWebSecurityWrapper
    {
        int GetUserId();
        bool Login(string userName, string password, bool rememberMe);
        void Logout();
        string CreateUserAndAccount(RegisterModel model);
        string GeneratePasswordResetToken(string userName);
        bool ResetPassword(string token, string newPassword);
        string CreateAccount(string userName, string newPassword);
        bool ChangePassword(string userName, string oldPassword, string newPassword);
    }
}
