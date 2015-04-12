using System;
using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.DAL;
using OziBazaar.DAL.Models;
using OziBazaar.Web.Areas.UserManagement.Converter;
using OziBazaar.Web.Infrastructure.Helper;

namespace OziBazaar.UnitTest
{
    [TestClass]
    public class UserProfileConverterTests
    {
        [TestMethod]
        public void Can_Generate_Page_Links()
        {
            HtmlHelper myHelper = null;
            // Arrange
            PagingInfo pagingInfo = new PagingInfo
            {
                CurrentPage = 2,
                TotalItems = 28,
                ItemsPerPage = 10
            };
            Func<int, string> pageUrlDelegate = i => "Page" + i;
            // Act
            MvcHtmlString result = myHelper.PageLinks(pagingInfo, pageUrlDelegate);
            // Assert
            Assert.AreEqual(@"<a class=""btn btn-default"" href=""Page1"">1</a>"
                            + @"<a class=""btn btn-default btn-primary selected"" href=""Page2"">2</a>"
                            + @"<a class=""btn btn-default"" href=""Page3"">3</a>",
                            result.ToString());
        }

        [TestMethod]
        public void ConvertTo_ProvideValidData_ShouldReturnUserProfile()
        {
            // Arrange
            UserProfileViewModel from = new UserProfileViewModel()
            {
                Address1 = "Address 1",
                Address2 = "Address 2",
                CountryID = 1,
                EmailAddress = "test@unittest.com",
                FullName = "test",
                Phone = "12345678",
                PostCode = "TST",
                UserId = 1000,
                UserName = "TestF TestS"
            };
            IConverter<UserProfileViewModel, UserProfile> converter = new UserProfileConverter();
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
            UserProfileViewModel from = null;
            IConverter<UserProfileViewModel, UserProfile> converter = new UserProfileConverter();
            // Act
            var result = converter.ConvertTo(from);
            // Assert
        }
    }
}
