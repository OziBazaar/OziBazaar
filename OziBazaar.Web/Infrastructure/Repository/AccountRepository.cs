using OziBazaar.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.Infrastructure.Repository
{
    public class AccountRepository : IAccountRepository
    {
        private OziBazaarEntities dbContext = new OziBazaarEntities();
        public UserProfile GetUser(string userName)
        {
            UserProfile userProfileModel =
               (from userProfile in dbContext.UserProfiles
                where userProfile.UserName == userName
                select userProfile).FirstOrDefault();
            return userProfileModel;
        }

        public bool ActivateUser(string userName, string emailAddress)
        {
            UserProfile userProfileModel = GetUser(userName);
            if (userProfileModel != null && userProfileModel.EmailAddress == emailAddress)
            {
                userProfileModel.Activated = true;
                dbContext.SaveChanges();
                return true;
            }
            else
            {
                return false;
            }
        }

    }
}