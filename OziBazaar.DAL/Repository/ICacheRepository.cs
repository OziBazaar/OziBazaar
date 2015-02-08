using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.DAL.Repository
{
    public interface ICacheRepository<T>
    {
        IList<T> GetAll();
        int GetIdByDescription(string description);
        void ClearCache();
    }
}
