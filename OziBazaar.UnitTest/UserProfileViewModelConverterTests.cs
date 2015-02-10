using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.DAL;
using OziBazaar.Web.Areas.UserManagement.Converter;
using OziBazaar.Web.Areas.UserManagement.Models;

namespace OziBazaar.UnitTest
{
    [TestClass]
    public class UserProfileViewModelConverterTests
    {
        [TestMethod]
        public void ConvertTo_ProvideValidData_ShouldReturnUserProfileViewModel()
        {
            // Arrange
            UserProfile from = new UserProfile()
            {
                Address1 = "Address 1",
                Address2 = "Address 2",
                CountryID = 1,
                EmailAddress = "test@unittest.com",
                FullName = "TestF TestS",
                Phone = "12345678",
                PostCode = "TST",
                UserId = 1000,
                UserName = "test"
            };
            IConverter<UserProfile,UserProfileViewModel> converter = new UserProfileViewModelConverter();
            // Act
            var result = converter.ConvertTo(from);
            // Assert
            Assert.AreEqual(from.Address1,result.Address1);
            Assert.AreEqual(from.Address2,result.Address2);
            Assert.AreEqual(from.CountryID,result.CountryID);
            Assert.AreEqual(from.EmailAddress,result.EmailAddress);
            Assert.AreEqual(from.FullName,result.FullName);
            Assert.AreEqual(from.Phone,result.Phone);
            Assert.AreEqual(from.PostCode,result.PostCode);
            Assert.AreEqual(from.UserId,result.UserId);
            Assert.AreEqual(from.UserName,result.UserName);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void ConvertTo_ProvideValidData_ShouldThrowException()
        {
            // Arrange
            UserProfile from = null;
            IConverter<UserProfile, UserProfileViewModel> converter = new UserProfileViewModelConverter();
            // Act
            var result = converter.ConvertTo(from);
            // Assert
        } 
    }
}