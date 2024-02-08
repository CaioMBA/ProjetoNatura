using Data.DataBaseConnections;
using Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataBaseConnections.OracleSqlDao
{
    public class OutsideAppsCredentialsDao
    {
        private DefaultAccess _sql;
        public OutsideAppsCredentialsDao(DefaultAccess sql)
        {
            _sql = sql;
        }

        public List<CredentialsModel> GetCredentials()
        {
            var ResponseData = _sql.ExecutaOracleQuery<CredentialsModel>("SELECT NOTIFYCREDENTIALID, CREDENTIAL, PASSWORD, TYPE, PROTOCOL, ACTIVE FROM NOTIFYCREDENTIALS WHERE ACTIVE = 1", null).Result;
            return ResponseData;
        }
    }
}
