using System;
using System.Xml.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.Common.Serialization;
using OziBazaar.Notification.Entities;

namespace OziBazaar.UnitTest
{
    [TestClass]
    public class SerilizationTests
    {
        [TestMethod]
        public void SerializeEmailContentBase()
        {
            //Arrange
            SerializationUtil serializationUtil = new SerializationUtil();
            EmailContentBase emailContentBase = new EmailContentBase() { Fullname = "OziBazaarUser" };
            //Act
            XDocument result = serializationUtil.Serialize<EmailContentBase>(emailContentBase);
            //Assert
            Assert.AreEqual("OziBazaarUser", result.Element("Parameters").Element("Fullname").Value);
        }

        [TestMethod]
        public void SerializeEmailAdertisementSummary()
        {
            //Arrange
            SerializationUtil serializationUtil = new SerializationUtil();
            AdertisementSummary adertisementSummary = new AdertisementSummary() 
            { Fullname = "OziBazaarUser",
              Code = "OB0001",
              Price = 23.50M,
              Title = "Book reader"
            };
            //Act
            XDocument result = serializationUtil.Serialize<AdertisementSummary>(adertisementSummary);
            //Assert
            Assert.AreEqual("OziBazaarUser", result.Element("Parameters").Element("Fullname").Value);
            Assert.AreEqual("OB0001", result.Element("Parameters").Element("Code").Value);
            Assert.AreEqual(23.50M, Convert.ToDecimal(result.Element("Parameters").Element("Price").Value));
            Assert.AreEqual("Book reader", result.Element("Parameters").Element("Title").Value);
        }

        [TestMethod]
        public void SerializeActivationEmail()
        {
            //Arrange
            SerializationUtil serializationUtil = new SerializationUtil();
            ActivationEmail activationEmail = new ActivationEmail()
            {
                Fullname = "OziBazaarUser",
                ActivationUrl = "www.OziBazzar.com.au/Activate/xxx123"
            };
            //Act
            XDocument result = serializationUtil.Serialize<ActivationEmail>(activationEmail);
            //Assert
            Assert.AreEqual("OziBazaarUser", result.Element("Parameters").Element("Fullname").Value);
            Assert.AreEqual("www.OziBazzar.com.au/Activate/xxx123", result.Element("Parameters").Element("ActivationUrl").Value);
        }

        [TestMethod]
        public void SerializeResetPassword()
        {
            //Arrange
            SerializationUtil serializationUtil = new SerializationUtil();
            ResetPassword resetPassword = new ResetPassword()
            {
                Fullname = "OziBazaarUser",
                NewPassword = "aaccc123@"
            };
            //Act
            XDocument result = serializationUtil.Serialize<ResetPassword>(resetPassword);
            //Assert
            Assert.AreEqual("OziBazaarUser", result.Element("Parameters").Element("Fullname").Value);
            Assert.AreEqual("aaccc123@", result.Element("Parameters").Element("NewPassword").Value);
        }

    }
}
