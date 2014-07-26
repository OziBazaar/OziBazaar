using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OziBazaar.Web.Infrastructure.Graphic;

namespace OziBazaar.Web.Controllers
{
    public class HelperController : Controller
    {
        public ActionResult generateCaptcha()
        {
            string  rootFolder=@"\Temp\";
            bool isdirExists = System.IO.Directory.Exists(Server.MapPath("~") + rootFolder);
            if (!isdirExists)
                System.IO.Directory.CreateDirectory(Server.MapPath("~") + rootFolder);
            System.Drawing.FontFamily family = new System.Drawing.FontFamily("Arial");
            CaptchaImage img = new CaptchaImage(150, 50, family);
            string text = img.CreateRandomText(4) + " " + img.CreateRandomText(3);
            img.SetText(text);
            img.GenerateImage();
            img.Image.Save(Server.MapPath("~") + rootFolder + this.Session.SessionID.ToString() + ".png", System.Drawing.Imaging.ImageFormat.Png);
            Session["captchaText"] = text;
            return Json(@"/OziBazaar.Web/Temp/"+this.Session.SessionID.ToString() + ".png?t=" + DateTime.Now.Ticks, JsonRequestBehavior.AllowGet);
        }
	}
}