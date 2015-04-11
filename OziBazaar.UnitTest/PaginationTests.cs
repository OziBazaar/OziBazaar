using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OziBazaar.DAL.Models;
using OziBazaar.Web.Infrastructure.Helper;
using System.Web.Mvc;

namespace OziBazaar.UnitTest
{
    [TestClass]
    class PaginationTests
    {
        [TestMethod]
        public void Can_Generate_Page_Links()
        {
            HtmlHelper myHelper = null;
            // Arrange
            PagingInfo pagingInfo = new PagingInfo
            {
                CurrentPage = 2,
                TotalItems = 28,
                ItemsPerPage = 10
           };
           Func<int, string> pageUrlDelegate = i => "Page" + i;
           // Act
           MvcHtmlString result = myHelper.PageLinks(pagingInfo, pageUrlDelegate);
           // Assert
           Assert.AreEqual(@"<a class=""btn btn-default"" href=""Page1"">1</a>"
                           + @"<a class=""btn btn-default btn-primary selected"" href=""Page2"">2</a>"
                           + @"<a class=""btn btn-default"" href=""Page3"">3</a>",
                           result.ToString());
        }
    }
}
