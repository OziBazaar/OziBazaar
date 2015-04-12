using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.DAL;
using OziBazaar.DAL.Models;
using OziBazaar.DAL.Repository;
using OziBazaar.Web.Areas.UserManagement.Controllers;

namespace OziBazaar.IntegrationTest
{
    [TestClass]
    public class DashboardRepositoryTests
    {
        [TestMethod]
        public void GetUserProducts_ProvideUserID_ReturnProdctsInformation()
        {
            // Arrange
            DashboardRepository dashboardRepository = new DashboardRepository();
            int ownerID = 3;
            // Act
            var result = dashboardRepository.GetUserProducts(ownerID);
            // Assert
            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void GetWishListProducts_ProvideUserID_ReturnProdctsInformation()
        {
            // Arrange
            DashboardRepository dashboardRepository = new DashboardRepository();
            int ownerID = 3;
            // Act
            var result = dashboardRepository.GetWishListProducts(ownerID);
            // Assert
            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void Can_Paginate_UserProducts_ProvideValidData_ShouldReturnValidNumberOfRows()
        {
            // Arrange
            DashboardRepository dashboardRepository = new DashboardRepository();
            int ownerID = 3;
            int page = 2;
            int pageSize = 3;
            // Act
            var result = dashboardRepository.GetUserProducts(ownerID, page, pageSize);
            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(pageSize, result.Count);
        }

        [TestMethod]
        public void Can_Paginate_WishListProducts_ProvideValidData_ShouldReturnValidNumberOfRows()
        {
            // Arrange
            DashboardRepository dashboardRepository = new DashboardRepository();
            int ownerID = 3;
            int page = 1;
            int pageSize = 3;
            // Act
            var result = dashboardRepository.GetWishListProducts(ownerID, page, pageSize);
            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(pageSize, result.Count);
        }

    }
}
