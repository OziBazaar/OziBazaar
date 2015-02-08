using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OziBazaar.DAL;
using OziBazaar.Web.Areas.UserManagement.Models;

namespace OziBazaar.Web.Areas.UserManagement.Converter
{
    public class UserProfileViewModelConverter : IConverter<UserProfile,UserProfileViewModel>
    {
        public UserProfileViewModel ConvertTo(UserProfile from)
        {
            if (from == null)
                throw new ArgumentNullException();
            return new UserProfileViewModel()
            {
                Address1 = from.Address1,
                Address2 = from.Address2,
                CountryID = from.CountryID == null ? 0 : from.CountryID.Value,
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