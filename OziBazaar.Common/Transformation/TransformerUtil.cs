using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Xsl;

namespace OziBazaar.Common.Transformation
{
    public class TransformerUtil : ITransformerUtil
    {
        public string XmlToHtml(XDocument document, string xlstPath)
        {
            StringBuilder sbXslOutput = new StringBuilder();

            using (XmlWriter xslWriter = XmlWriter.Create(sbXslOutput))
            {
                XslCompiledTransform transformer = new XslCompiledTransform();
                transformer.Load(xlstPath);
                XsltArgumentList args = new XsltArgumentList();
                transformer.Transform(document.CreateReader(), args, xslWriter);
            }
            return sbXslOutput.ToString();
        }
    }
}
