using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OziBazaar.DAL.Models;
using WebMatrix.WebData;

namespace OziBazaar.Web.Infrastructure.Wrapper
{
    public class WebSecurityWrapper : IWebSecurityWrapper
    {
        public int GetUserId()
        {
            return WebSecurity.GetUserId(HttpContext.Current.User.Identity.Name);
        }

        public bool Login(string userName, string password, bool rememberMe)
        {
            return WebSecurity.Login(userName, password, persistCookie: rememberMe);
        }

        public void Logout()
        {
            WebSecurity.Logout();
        }

        public string CreateUserAndAccount(RegisterModel model)
        {
            return WebSecurity.CreateUserAndAccount(
                model.UserName,
                model.Password,
                new
                {
                    FullName = model.FullName,
                    EmailAddress = model.EmailAddress,
                    Phone = model.Phone,
                    Activated = false,
                    CountryID = model.CountryID,
                    Address1 = model.Address1,
                    Address2 = model.Address2,
                    PostCode = model.PostCode
                },
                false);
        }

        public string GeneratePasswordResetToken(string userName)
        {
            return WebSecurity.GeneratePasswordResetToken(userName);
        }

        public bool ResetPassword(string token, string newPassword)
        {
            return WebSecurity.ResetPassword(token, newPassword);
        }

        public string CreateAccount(string userName, string newPassword)
        {
            return WebSecurity.CreateAccount(userName, newPassword);
        }

        public bool ChangePassword(string userName, string oldPassword, string newPassword)
        {
            return WebSecurity.ChangePassword(userName, oldPassword, newPassword);
        }
    }
}