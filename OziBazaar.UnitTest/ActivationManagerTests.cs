using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.Common.Cryptography;

namespace OziBazaar.UnitTest
{
    [TestClass]
    public class ActivationManagerTests
    {
        [TestMethod]
        public void GenerateCode_ProvideValidData_ShouldReturnGeneratedActivationCode()
        {
            // Arrange
            ActivationManager activationManager = new ActivationManager(new EncryptionEngine());
            string[] input = { "test1", "test2" };
            // Act
            var result = activationManager.GenerateCode(input);
            // Assert
            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void InterpretCode_ProvideGeneratedCode_ShouldReturnSplitedValue()
        {
            // Arrange
            ActivationManager activationManager = new ActivationManager(new EncryptionEngine());
            string[] input = { "test1", "test2" };
            string generatedCode = activationManager.GenerateCode(input);
            // Act
            var result = activationManager.InterpretCode(generatedCode);
            // Assert
            Assert.AreEqual(input[0], result[0]);
            Assert.AreEqual(input[1], result[1]);
        }
    }
}
