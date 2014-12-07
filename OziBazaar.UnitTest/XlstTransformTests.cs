using System;
using System.Xml.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.Common.Serialization;
using OziBazaar.Common.Transformation;
using OziBazaar.Notification.Entities;

namespace OziBazaar.UnitTest
{
    [TestClass]
    public class XlstTransformTests
    {
        [TestMethod]
        public void TransformEmailContentBase()
        {
            //Arrange
            SerializationUtil serializationUtil = new SerializationUtil();
            TransformerUtil transformerUtil = new TransformerUtil();
            EmailContentBase emailContentBase = new EmailContentBase() { Fullname = "OziBazaarUser" };
            string fullPath = @"C:\Data\OziBazaar\OziBazaar\OziBazaar.Notification\Templates\AccountDisable.xslt";
            XDocument serializedClass = serializationUtil.Serialize<EmailContentBase>(emailContentBase);
            //Act
            string result = transformerUtil.XmlToHtml(serializedClass, fullPath);
            //Assert
            Assert.IsTrue(result.Contains("<html>"));
            Assert.IsTrue(result.Contains("</html>"));
            Assert.IsTrue(result.Contains("<body>"));
            Assert.IsTrue(result.Contains("</body>"));
            Assert.IsTrue(result.Contains("OziBazaarUser"));
        }

        [TestMethod]
        public void TransformAdertisementSummary()
        {
            //Arrange
            SerializationUtil serializationUtil = new SerializationUtil();
            TransformerUtil transformerUtil = new TransformerUtil();
            AdertisementSummary adertisementSummary = new AdertisementSummary()
            {
                Fullname = "OziBazaarUser",
                Code = "OB0001",
                Price = 23.50M,
                Title = "Book reader"
            };
            string fullPath = @"C:\Data\OziBazaar\OziBazaar\OziBazaar.Notification\Templates\AdvertisementInsert.xslt";
            XDocument serializedClass = serializationUtil.Serialize<AdertisementSummary>(adertisementSummary);
            //Act
            string result = transformerUtil.XmlToHtml(serializedClass, fullPath);
            //Assert
            Assert.IsTrue(result.Contains("<html>"));
            Assert.IsTrue(result.Contains("</html>"));
            Assert.IsTrue(result.Contains("<body>"));
            Assert.IsTrue(result.Contains("</body>"));
            Assert.IsTrue(result.Contains("OziBazaarUser"));
            Assert.IsTrue(result.Contains("OB0001"));
            Assert.IsTrue(result.Contains("23.50"));
            Assert.IsTrue(result.Contains("Book reader"));
        }

        [TestMethod]
        public void TransformActivationEmail()
        {
            //Arrange
            SerializationUtil serializationUtil = new SerializationUtil();
            TransformerUtil transformerUtil = new TransformerUtil();
            ActivationEmail activationEmail = new ActivationEmail()
            {
                Fullname = "OziBazaarUser",
                ActivationUrl = "www.OziBazzar.com.au/Activate/xxx123"
            };
            //Act
            string fullPath = @"C:\Data\OziBazaar\OziBazaar\OziBazaar.Notification\Templates\ActivationEmail.xslt";
            XDocument serializedClass = serializationUtil.Serialize<ActivationEmail>(activationEmail);
            //Act
            string result = transformerUtil.XmlToHtml(serializedClass, fullPath);
            //Assert
            Assert.IsTrue(result.Contains("<html>"));
            Assert.IsTrue(result.Contains("</html>"));
            Assert.IsTrue(result.Contains("<body>"));
            Assert.IsTrue(result.Contains("</body>"));
            Assert.IsTrue(result.Contains("OziBazaarUser"));
            Assert.IsTrue(result.Contains("www.OziBazzar.com.au/Activate/xxx123"));
        }

        [TestMethod]
        public void TransformResetPassword()
        {
            //Arrange
            SerializationUtil serializationUtil = new SerializationUtil();
            TransformerUtil transformerUtil = new TransformerUtil();
            ResetPassword resetPassword = new ResetPassword()
            {
                Fullname = "OziBazaarUser",
                NewPassword = "aaccc123@"
            };
            string fullPath = @"C:\Data\OziBazaar\OziBazaar\OziBazaar.Notification\Templates\ResetPassword.xslt";
            XDocument serializedClass = serializationUtil.Serialize<ResetPassword>(resetPassword);
            //Act
            string result = transformerUtil.XmlToHtml(serializedClass, fullPath);
            //Assert
            //Assert
            Assert.IsTrue(result.Contains("<html>"));
            Assert.IsTrue(result.Contains("</html>"));
            Assert.IsTrue(result.Contains("<body>"));
            Assert.IsTrue(result.Contains("</body>"));
            Assert.IsTrue(result.Contains("OziBazaarUser"));
            Assert.IsTrue(result.Contains("aaccc123@"));
        }
    }
}
