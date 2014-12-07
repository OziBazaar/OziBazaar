using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.Serialization;

namespace OziBazaar.Common.Serialization
{
    public class SerializationUtil : ISerializationUtil
    {
        public T Deserialize<T>(XDocument document)
        {
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(T));

            using (var reader = document.Root.CreateReader())
            {
                return (T)xmlSerializer.Deserialize(reader);
            }
        }

        public XDocument Serialize<T>(T value)
        {
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(T));

            XDocument document = new XDocument();
            using (var writer = document.CreateWriter())
            {
                xmlSerializer.Serialize(writer, value);
            }
            return document;
        }
    }
}
