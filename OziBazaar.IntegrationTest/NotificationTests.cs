using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.Common.Serialization;
using OziBazaar.Common.Transformation;
using OziBazaar.DAL.Repository;
using OziBazaar.Notification;
using OziBazaar.Notification.Controller;
using OziBazaar.Notification.Email;
using OziBazaar.Notification.Entities;

namespace OziBazaar.IntegrationTest
{
    [TestClass]
    public class NotificationTests
    {
        [TestMethod]
        public void SendAccountDisable_ProvideValidParameters_ShouldSendEmail()
        {
            //Arrange
            NotificationController noificationController = new NotificationController
            (
                new SmtpEmailUtil(),
                new TransformerUtil(),
                new SerializationUtil(),
                new AccountRepository()
            );
            //Act
            bool result = noificationController.SendAccountDisable(
                new EmailContentBase()
                {
                    Fullname = "Ali Parvin"
                },
                "sami_bh2000@yahoo.com"
                );
            //Assert
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void SendActivationEmail_ProvideValidParameters_ShouldSendEmail()
        {
            //Arrange
            NotificationController noificationController = new NotificationController
            (
                new SmtpEmailUtil(),
                new TransformerUtil(),
                new SerializationUtil(),
                new AccountRepository()
            );
            //Act
            bool result = noificationController.SendActivationEmail(
                new ActivationEmail()
                {
                    Fullname = "Ali Parvin",
                    ActivationUrl  = "wwww.OziBazaar.com/Activate/123"
                },
                "sami_bh2000@yahoo.com"
                );
            //Assert
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void SendAdertisementSummary_ProvideValidParameters_ShouldSendEmail()
        {
            //Arrange
            NotificationController noificationController = new NotificationController
            (
                new SmtpEmailUtil(),
                new TransformerUtil(),
                new SerializationUtil(),
                new AccountRepository()
            );
            //Act
            bool result = noificationController.SendAdertisementSummary(
                new AdertisementSummary
                {
                    Fullname = "Ali Parvin",
                    Code = "OZ001",
                    Title = "Toyota",
                    Price = 23000
                },
                "sami_bh2000@yahoo.com"
                );
            //Assert
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void SendAdvertisementSuspend_ProvideValidParameters_ShouldSendEmail()
        {
            //Arrange
            NotificationController noificationController = new NotificationController
            (
                new SmtpEmailUtil(),
                new TransformerUtil(),
                new SerializationUtil(),
                new AccountRepository()
            );
            //Act
            bool result = noificationController.SendAdvertisementSuspend(
                new AdertisementSummary
                {
                    Fullname = "Ali Parvin",
                    Code = "OZ001",
                    Title = "Toyota",
                    Price = 23000
                },
                "sami_bh2000@yahoo.com"
                );
            //Assert
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void SendResetPassword_ProvideValidParameters_ShouldSendEmail()
        {
            //Arrange
            NotificationController noificationController = new NotificationController
            (
                new SmtpEmailUtil(),
                new TransformerUtil(),
                new SerializationUtil(),
                new AccountRepository()
            );
            //Act
            bool result = noificationController.SendResetPassword(
                new ResetPassword
                {
                    Fullname = "Ali Parvin",
                    NewPassword = "A@xcdfDSER34"
                },
                "sami_bh2000@yahoo.com"
                );
            //Assert
            Assert.IsTrue(result);
        }

    }
}
