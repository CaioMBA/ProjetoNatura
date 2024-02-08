using AutoMapper;
using DataBaseConnections.OracleSqlDao;
using Domain.Interfaces;
using Domain.Models;
using Domain.Models.Settings;
using Domain.Utils;
using System.Text.RegularExpressions;

namespace Service.Services
{
    public class UserService : IUserService
    {
        private UserDao _dao;
        private IMapper _map;
        private IApiService _api;
        private Utils _utils;

        public UserService(UserDao dao, IMapper map, IApiService api, Utils utils)
        {
            _dao = dao;
            _map = map;
            _api = api;
            _utils = utils;
        }


        public GetExtraInfoUserModel? ExtraInfoUsuario(string? Credencial)
        {
            var Response = _dao.GetExtraInfoUser(Credencial);

            return Response;
        }
    }
}