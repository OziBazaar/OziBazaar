using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.DAL;
using OziBazaar.DAL.Repository;
using OziBazaar.Notification.Enums;

namespace OziBazaar.IntegrationTest
{
    [TestClass]
    public class AccountRepositoryTests
    {
        [TestMethod]
        public void GetNotificationTemplate_ProvideValidParameters_ShouldReturnTemplate()
        {
            //Arrange
            AccountRepository accountRepository = new AccountRepository();
            //Act
            NotificationTemplate result = accountRepository.GetNotificationTemplate(
                NotificationEnum.NotificationType.Email.ToString(), 
                NotificationEnum.NotificationTemplate.AccountDisable.ToString());
            //Assert
            Assert.IsNotNull(result);
        }
    }
}
