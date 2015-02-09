using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Common.Cryptography
{
    public interface IActivationManager
    {
        string GenerateCode(string[] values);
        string[] InterpretCode(string activationCode);
    }
}
