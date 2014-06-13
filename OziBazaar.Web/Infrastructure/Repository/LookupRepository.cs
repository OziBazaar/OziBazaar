using OziBazaar.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Web.Infrastructure.Repository
{
    public class LookupRepository : ILookupRepository
    {
        private OziBazaarEntities dbContext = new OziBazaarEntities();

        public IEnumerable<Lookup> GetMainLookups(string lookupType)
        {
            var lst = (from lookup in dbContext.Lookups
                    where lookup.Type == lookupType && !lookup.ParentID.HasValue
                    select new Lookup{Id= lookup.LookupID, Name=lookup.Description}).ToList();
            return lst;
        }

        public IEnumerable<Lookup> GetLookups(string lookupType, int parentId)
        {
            var lst = (from lookup in dbContext.Lookups
                       where lookup.Type == lookupType && lookup.ParentID.HasValue && lookup.ParentID.Value==parentId
                       select new Lookup{Id=lookup.LookupID, Name=lookup.Description}).ToList();
            return lst;
        }
        public IEnumerable<Lookup> GetLookups(string lookupType, string parent)
        {
            int parentId = dbContext.Lookups.Single(l => l.Description == parent).LookupID;
            var lst = (from lookup in dbContext.Lookups
                       where lookup.Type == lookupType && lookup.ParentID.HasValue && lookup.ParentID.Value == parentId
                       select new Lookup { Id = lookup.LookupID, Name = lookup.Description }).ToList();
            return lst;

        }
    }
}
