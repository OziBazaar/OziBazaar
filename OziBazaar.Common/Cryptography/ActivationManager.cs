using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Common.Cryptography
{
    public class ActivationManager : IActivationManager
    {
        const char separator = ';';
        private readonly IEncryptionEngine _encryptionEngine;

        public ActivationManager(IEncryptionEngine encryptionEngine)
        {
            this._encryptionEngine = encryptionEngine;
        }

        public string GenerateCode(string[] values)
        {
            string activationCode = _encryptionEngine.DESEncrypt(values[0] + separator.ToString() + values[1]);
            return activationCode;
        }

        public string[] InterpretCode(string activationCode)
        {
            string decActivatioCode = _encryptionEngine.DESDecrypt(activationCode);
            string[] values = decActivatioCode.Split(separator);
            return values;
        }
    }
}
