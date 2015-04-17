using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OziBazaar.Common.Provider;

namespace OziBazaar.DAL.Repository
{
    public class CountryRepository : ICacheRepository<Country>
    {
        private Entities dbContext = new Entities();

        public ICacheProvider Cache { get; set; }

        public CountryRepository()
            : this(new DefaultCacheProvider())
        {
        }

        public CountryRepository(ICacheProvider cacheProvider)
        {
            this.Cache = cacheProvider;
        }

        public IList<Country> GetAll()
        {
            IList<Country> countryList = Cache.Get("Countries") as IList<Country>;
            if (countryList == null)
            {
                countryList = dbContext.Countries.OrderBy(c => c.Description).ToList();
                if (countryList.Any())
                {
                    Cache.Set("Countries", countryList, 30);
                }
            }
            return countryList;
        }

        public int GetIdByDescription(string description)
        {
            return GetAll().Where(r => r.Description == description).FirstOrDefault().CountryID;
        }

        public void ClearCache()
        {
            Cache.Invalidate("Countries");
        }
    }
}
