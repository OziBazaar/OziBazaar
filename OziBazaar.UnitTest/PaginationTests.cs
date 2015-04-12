using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.DAL.Models;
using OziBazaar.Web.Infrastructure.Helper;
using System.Web.Mvc;
using OziBazaar.DAL.Repository;
using Moq;
using OziBazaar.Web.Areas.UserManagement.Controllers;
using OziBazaar.Web.Infrastructure.Wrapper;
using OziBazaar.Web.Infrastructure.Setting;

namespace OziBazaar.UnitTest
{
    [TestClass]
    public class PaginationTests
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
        public void GetUserAdvertisementList_Can_Send_Pagination_View_Model()
        {
            // Arrange
            int pageSize = 4;
            int userProductsCount = 4;
            int page = 1;
            Mock<IDashboardRepository> mockDashboardRepository = new Mock<IDashboardRepository>();
            mockDashboardRepository.Setup(m => m.GetUserProducts(It.IsAny<int>(), It.IsAny<int>(), pageSize))
                .Returns(new List<UserProductViewModel>()
                {
                    new UserProductViewModel { AdvertisementID = 1, Description = "Advertise1", Price = 100},
                    new UserProductViewModel { AdvertisementID = 2, Description = "Advertise2", Price = 200},
                    new UserProductViewModel { AdvertisementID = 3, Description = "Advertise3", Price = 300},
                    new UserProductViewModel { AdvertisementID = 4, Description = "Advertise4", Price = 400}
            });
            mockDashboardRepository.Setup(m => m.GetUserProductsCount(It.IsAny<int>()))
                .Returns(userProductsCount);
            Mock<IWebSecurityWrapper> mockWebSecurityWrapper = new Mock<IWebSecurityWrapper>();
            mockWebSecurityWrapper.Setup(m => m.GetUserId()).Returns(1);
            Mock<IViewSetting> mockViewSetting = new Mock<IViewSetting>();
            mockViewSetting.Setup(m => m.PageSize).Returns(pageSize);
            UserDashboardController controller = new UserDashboardController
                (mockDashboardRepository.Object,
                 mockWebSecurityWrapper.Object,
                 mockViewSetting.Object);
            // Act
            UserProductsViewModel result = (UserProductsViewModel)(controller.GetUserAdvertisementList(page) as ViewResult).Model;
            // Assert
            Assert.AreEqual(pageSize, result.PagingInfo.ItemsPerPage);
            Assert.AreEqual(userProductsCount, result.PagingInfo.TotalItems);
            Assert.AreEqual(1, result.PagingInfo.TotalPages);
            Assert.AreEqual(page, result.PagingInfo.CurrentPage);
        }

        [TestMethod]
        public void GetWishListProducts_Can_Send_Pagination_View_Model()
        {
            // Arrange
            int pageSize = 4;
            int userWishListsCount = 4;
            int page = 1;
            Mock<IDashboardRepository> mockDashboardRepository = new Mock<IDashboardRepository>();
            mockDashboardRepository.Setup(m => m.GetWishListProducts(It.IsAny<int>(), It.IsAny<int>(), pageSize))
                .Returns(new List<UserWishListViewModel>()
                {
                    new UserWishListViewModel { WishListID = 1, AdvertisementID = 1, Description = "Advertise1", Price = 100},
                    new UserWishListViewModel { WishListID = 2, AdvertisementID = 2, Description = "Advertise2", Price = 200},
                    new UserWishListViewModel { WishListID = 3, AdvertisementID = 3, Description = "Advertise3", Price = 300},
                    new UserWishListViewModel { WishListID = 4, AdvertisementID = 4, Description = "Advertise4", Price = 400}
            });
            mockDashboardRepository.Setup(m => m.GetWishListProductsCount(It.IsAny<int>()))
                .Returns(userWishListsCount);
            Mock<IWebSecurityWrapper> mockWebSecurityWrapper = new Mock<IWebSecurityWrapper>();
            mockWebSecurityWrapper.Setup(m => m.GetUserId()).Returns(1);
            Mock<IViewSetting> mockViewSetting = new Mock<IViewSetting>();
            mockViewSetting.Setup(m => m.PageSize).Returns(pageSize);
            UserDashboardController controller = new UserDashboardController
                (mockDashboardRepository.Object,
                 mockWebSecurityWrapper.Object,
                 mockViewSetting.Object);
            // Act
            UserWishListsViewModel result = (UserWishListsViewModel)(controller.GetWishList(page) as ViewResult).Model;
            // Assert
            Assert.AreEqual(pageSize, result.PagingInfo.ItemsPerPage);
            Assert.AreEqual(userWishListsCount, result.PagingInfo.TotalItems);
            Assert.AreEqual(1, result.PagingInfo.TotalPages);
            Assert.AreEqual(page, result.PagingInfo.CurrentPage);
        }
    }
}
