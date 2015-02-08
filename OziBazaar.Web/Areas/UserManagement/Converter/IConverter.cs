using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Web.Areas.UserManagement.Converter
{
    public interface IConverter<From,To>
    {
        To ConvertTo(From from);
    }
}
