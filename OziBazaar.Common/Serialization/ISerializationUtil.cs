using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace OziBazaar.Common.Serialization
{
    public interface ISerializationUtil
    {
        T Deserialize<T>(XDocument document);
        XDocument Serialize<T>(T value);
    }
}
