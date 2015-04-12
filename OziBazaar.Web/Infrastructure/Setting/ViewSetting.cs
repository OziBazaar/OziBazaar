using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace OziBazaar.Web.Infrastructure.Setting
{
    public class ViewSetting : IViewSetting
    {
        public int PageSize { get; set; }

        public ViewSetting()
        {
            this.PageSize = Convert.ToInt32(ConfigurationManager.AppSettings["PageSize"]);
        }
    }
}