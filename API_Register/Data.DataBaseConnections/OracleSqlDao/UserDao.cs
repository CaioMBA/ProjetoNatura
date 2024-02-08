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

        public DefaultResponseModel? RegisterUser(CreateUserRequestModel Obj)
        {
            var Response = _Sql.ExecutaOracleProcFirstOrDefault<DefaultResponseModel>($"PR_CREATE_USER",
                Obj).Result;

            return Response;
        }

        public DefaultResponseModel? ValidateUser(ValidateUserRequestModel Obj)
        {
            var Response = _Sql.ExecutaOracleProcFirstOrDefault<DefaultResponseModel>($"PR_VALIDATE_USER",
                Obj).Result;

            return Response;
        }

        public DefaultResponseModel? ChangePassword(ChangePasswordRequestModel Obj)
        {
            var ResponseData = _Sql.ExecutaOracleProcFirstOrDefault<DefaultResponseModel>($"PR_CHANGE_PASSWORD",Obj).Result;

            return ResponseData;
        }

        public DefaultResponseModel? ChangePhoto(string? LoginCredential, string? Photo)
        {
            var Obj = new
            {
                P_CREDENTIAL = LoginCredential,
                P_NEWPHOTO = Photo
            };
            var ResponseData = _Sql.ExecutaOracleProcFirstOrDefault<DefaultResponseModel>($"PR_UPDATE_USER_PHOTO", Obj).Result;

            return ResponseData;
        }

        public DefaultResponseModel? ChangeUserDetails(ChangeUserDetailsModel Obj)
        {
            var ResponseData = _Sql.ExecutaOracleProcFirstOrDefault<DefaultResponseModel>($"PR_UPDATE_USER_DETAILS", Obj).Result;

            return ResponseData;
        }

        public dynamic? GetPasswordAndMailandPhone(string? LoginCredential)
        {
            var ResponseData = _Sql.ExecutaOracleFirstOrDefault<dynamic?>($"SELECT U.PASSWORD, U.EMAIL, U.PHONE FROM USERS U WHERE U.ACTIVE = 1 AND (UPPER(U.LOGIN) = UPPER('{LoginCredential}') OR UPPER(U.CPF_CNPJ) = UPPER('{LoginCredential}') OR UPPER(U.EMAIL) = UPPER('{LoginCredential}') OR UPPER(U.PHONE) = UPPER('{LoginCredential}'))", null).Result;

            return ResponseData;
        }
    }
}
