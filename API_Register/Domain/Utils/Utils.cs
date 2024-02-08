using Domain.Models;
using Domain.Models.Settings;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Utils
{
    public class Utils
    {
        private AppSettingsModel _AppConfig;
        public Utils(AppSettingsModel AppConfig)
        {
            _AppConfig = AppConfig;
        }

        public DataBaseConnections GetDataBase(string? sDataBaseID)
        {
            var sConection = (from v in _AppConfig.DataBaseConnections
                              where v.Name == sDataBaseID
                              select v).FirstOrDefault();
            return sConection;
        }

        public ApiConnections GetAPI(string? sApiID)
        {
            var sConection = (from v in _AppConfig.ApiConnections
                              where v.Name == sApiID
                              select v).FirstOrDefault();
            return sConection;
        }
    }
}
