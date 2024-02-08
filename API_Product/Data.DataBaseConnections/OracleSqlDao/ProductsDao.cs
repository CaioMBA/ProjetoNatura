using Data.DataBaseConnections;
using Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataBaseConnections.OracleSqlDao
{
    public class ProductsDao
    {
        private DefaultAccess _Sql;
        public ProductsDao(DefaultAccess sql)
        {
            _Sql = sql;
        }

        public List<ProductInfo?> GetFutureProduct(string? Type)
        {
            var Obj = new
            {
                P_TYPE = Type
            };
            var Response = _Sql.ExecutaOracleProc<ProductInfo>($"PR_GET_PRODUCT_LIST",
                Obj).Result;

            return Response;
        }

        public List<ProductTypesModel> GetProductTypes()
        {
            var Response = _Sql.ExecutaOracleQuery<ProductTypesModel>($"SELECT DISTINCT P.PRODUCTTYPEID, P.TYPE FROM PRODUCTTYPES p WHERE P.ACTIVE = '1'",
                null).Result;

            return Response;
        }
    }
}
