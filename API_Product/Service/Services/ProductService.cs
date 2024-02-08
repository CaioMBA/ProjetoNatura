using AutoMapper;
using DataBaseConnections.OracleSqlDao;
using Domain.Interfaces;
using Domain.Models;
using Domain.Models.Settings;
using Domain.Utils;
using System.Security.Cryptography;
using System.Text.RegularExpressions;

namespace Service.Services
{
    public class ProductService : IProductService
    {
        private ProductsDao _dao;
        private IMapper _map;
        private IApiService _api;
        private Utils _utils;

        public ProductService(ProductsDao dao, IMapper map, IApiService api, Utils utils)
        {
            _dao = dao;
            _map = map;
            _api = api;
            _utils = utils;
        }


        public ProductInfo ProductAI(string? Type)
        {
            List<ProductInfo?> ListProduct = _dao.GetFutureProduct(Type);

            Random rnd = new Random();
            int randIndex = rnd.Next(ListProduct.Count);

            ProductInfo? ResponseObj = ListProduct[randIndex];

            return ResponseObj;
        }

        public List<ProductTypesModel> ProductTypes()
        {
            return _dao.GetProductTypes();
        }
    }
}