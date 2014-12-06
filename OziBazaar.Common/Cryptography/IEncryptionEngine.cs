using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Common.Cryptography
{
    public interface IEncryptionEngine
    {
        string DESDecrypt(string stringToDecrypt);
        string DESEncrypt(string stringToEncrypt);
    }
}
