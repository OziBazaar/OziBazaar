using Microsoft.Practices.ServiceLocation;
using Microsoft.Practices.Unity;
using OziBazaar.Web.Infrastructure.Repository;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using WebMatrix.WebData;
using OziBazaar.DAL.Repository;

namespace OziBazaar.Web.Areas.UserManagement.Security
{
    public class ExtendedSimpleMembershipProvider : SimpleMembershipProvider
    {
        public override bool ValidateUser(string login, string password)
        {
            // check to see if the login passed is an email address
            if (IsValidEmail(login))
            {
                string actualUsername = GetUserNameByEmail(login);
                return base.ValidateUser(actualUsername, password);
            }
            else
            {
                return base.ValidateUser(login, password);
            }
        }
 
        public override string GetUserNameByEmail(String email)
        {
            IAccountRepository _accountRepository = ServiceLocator.Current.GetInstance<IAccountRepository>();
            return   _accountRepository.GetUserNameByEmail(email);
        }
        private bool IsValidEmail(string strIn)
        {
            // Return true if strIn is in valid e-mail format.
            return Regex.IsMatch(strIn, @"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
        }
       
    }
}