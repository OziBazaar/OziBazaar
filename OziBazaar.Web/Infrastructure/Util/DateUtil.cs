using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.Infrastructure.Util
{
    public static class DateUtil
    {
        public static DateTime ConvertToDate(this string str)
        {
            string[] formats= { "dd/MM/yyyy" };
            var dateTime = DateTime.Parse(str, new CultureInfo("en-AU"),DateTimeStyles.AssumeLocal);
            return dateTime;
        }
    }
}