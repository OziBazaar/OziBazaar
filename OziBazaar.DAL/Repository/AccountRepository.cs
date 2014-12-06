using OziBazaar.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OziBazaar.DAL.Repository
{
    public class AccountRepository : IAccountRepository
    {
        private OziBazaarEntities dbContext = new OziBazaarEntities();
        public UserProfile GetUser(string userToken)
        {
            UserProfile userProfileModel =
               (from userProfile in dbContext.UserProfiles
                where userProfile.UserName == userToken || userProfile.EmailAddress == userToken
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


        public UserProfile GetUserByEmail(string emailAddress)
        {
            UserProfile userProfileModel =
              (from userProfile in dbContext.UserProfiles
               where userProfile.EmailAddress == emailAddress
               select userProfile).FirstOrDefault();
            return userProfileModel;
        }

        public string GetUserNameByEmail(string emailAddress)
        {
            var userName = (from usr in dbContext.UserProfiles
                            where usr.EmailAddress == emailAddress
                            select usr.UserName).SingleOrDefault();
            return userName;
        }
    }
}