using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace OziBazaar.Common.Transformation
{
    public interface ITransformerUtil
    {
        string XmlToHtml(XDocument document, string xlstPath);
    }
}
