using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace OziBazaar.Notification.Entities
{
    [XmlRoot("Parameters")]
    public class ResetPassword : EmailContentBase
    {
        [XmlElement]
        public string NewPassword { get; set; }
    }
}
