using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace OziBazaar.Common.Helper
{
    public class URLHelper
    {

        public static string GetInitialUrl()
        {
            StringBuilder initUrl = new StringBuilder();
            initUrl.Append(@"http://");
            initUrl.Append(HttpContext.Current.Request.Url.Host);
            initUrl.Append(":");
            initUrl.Append(HttpContext.Current.Request.Url.Port);
            return initUrl.ToString();
        }

        public static string GetActivationEmailUrl(string activationCode)
        {
            StringBuilder activationUrl = new StringBuilder();
            activationUrl.Append(GetInitialUrl());
            activationUrl.Append("UserManagement/Account/Activation?ActivationCode=");
            activationUrl.Append(activationCode);
            return activationUrl.ToString();
        }
    }
}
