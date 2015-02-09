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

        public NotificationTemplate GetNotificationTemplate(string notificationType, string templateDescription)
        {
            NotificationTemplate result = (from template in dbContext.NotificationTemplates
                                                where template.Description == templateDescription && template.NotificationType.Description == notificationType
                                                select template).FirstOrDefault();
            return result;
        }

        public int UpdateUserProfile(UserProfile userProfile)
        {
            if (userProfile == null)
                throw new ArgumentNullException();
            UserProfile savedRow = GetUser(userProfile.UserName);
            if (savedRow == null)
                throw new KeyNotFoundException();
            savedRow.Address1 = userProfile.Address1;
            savedRow.Address2 = userProfile.Address2;
            savedRow.CountryID = userProfile.CountryID;
            savedRow.Phone = userProfile.Phone;
            savedRow.PostCode = userProfile.PostCode;
            return dbContext.SaveChanges();
        }
    }
}