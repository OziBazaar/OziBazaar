using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Web.Infrastructure.Repository
{
    public class Lookup
    {
        public int Id { get;  set; }
        public string Name { get;  set; }
       
    }
    public interface ILookupRepository
    {
        IEnumerable<Lookup> GetMainLookups(string lookupType);
        IEnumerable<Lookup> GetLookups(string lookupType, int parentId);
        IEnumerable<Lookup> GetLookups(string lookupType, string parentId);
    }
}
