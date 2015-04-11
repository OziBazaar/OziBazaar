using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.DAL;
using OziBazaar.DAL.Repository;

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
    }
}
