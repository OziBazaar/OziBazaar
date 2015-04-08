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
            // Act
            var result = dashboardRepository.GetUserProducts(1);
            // Assert
            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void GetWishListProducts_ProvideUserID_ReturnProdctsInformation()
        {
            // Arrange
            DashboardRepository dashboardRepository = new DashboardRepository();
            // Act
            var result = dashboardRepository.GetWishListProducts(1);
            // Assert
            Assert.IsNotNull(result);
        }
    }
}
