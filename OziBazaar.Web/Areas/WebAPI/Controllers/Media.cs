using OziBazaar.Web.Infrastructure.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace OziBazaar.Web.Areas.API.Controllers
{
    public class MediaController : ApiController
    {
        
        public ILookupRepository lookupRepository { get; set; }
        // GET api/<controller>/toyota
        public IEnumerable<string> Get()
        {

            yield return "/Content/Image/mazda1.jpg";
            yield return "/Content/Image/mazda2.jpg";
        }

        // POST api/<controller>
        public void Post([FromBody]string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}