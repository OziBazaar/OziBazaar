using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace OziBazaar.Notification.Entities
{
    [XmlRoot("Parameters")]
    public class AdertisementSummary : EmailContentBase
    {
        [XmlElement]
        public string Code { get; set; }
        [XmlElement]
        public string Title { get; set; }
        [XmlElement]
        public decimal Price { get; set; }
    }
}
