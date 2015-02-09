using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OziBazaar.DAL;
using OziBazaar.Web.Areas.UserManagement.Models;

namespace OziBazaar.Web.Areas.UserManagement.Converter
{
    public class UserProfileConverter : IConverter<UserProfileViewModel, UserProfile>
    {
        public UserProfile ConvertTo(UserProfileViewModel from)
        {
            if (from == null)
                throw new ArgumentNullException();
            return new UserProfile()
            {
                Address1 = from.Address1,
                Address2 = from.Address2,
                CountryID = from.CountryID,
                EmailAddress = from.EmailAddress,
                FullName = from.FullName,
                Phone = from.Phone,
                PostCode = from.PostCode,
                UserId = from.UserId,
                UserName = from.UserName
            };
        }
    }
}