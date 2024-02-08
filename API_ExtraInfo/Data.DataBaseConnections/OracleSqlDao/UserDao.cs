using Data.DataBaseConnections;
using Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataBaseConnections.OracleSqlDao
{
    public class UserDao
    {
        private DefaultAccess _Sql;
        public UserDao(DefaultAccess sql)
        {
            _Sql = sql;
        }

        public GetExtraInfoUserModel? GetExtraInfoUser(string? Credencial)
        {
            var Obj = new
            {
                P_CREDENTIAL = Credencial
            };
            var Response = _Sql.ExecutaOracleProcFirstOrDefault<GetExtraInfoUserModel>($"PR_GET_EXTRA_INFO_USER",
                Obj).Result;

            return Response;
        }
    }
}
