using AutoMapper;
using Domain.Mapping;
using Domain.Models;
using Domain.Utils;
using Microsoft.Extensions.DependencyInjection;
using Domain.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.Models.Settings;
using Service.Services;
using Data.DataBaseConnections;
using DataBaseConnections.OracleSqlDao;

namespace Infrastructure.CrossCutting
{
    public class AllConfigurations
    {
        public static void ConfigureDependencies(IServiceCollection serviceCollection, AppSettingsModel appConfig)
        {
            serviceCollection.AddSingleton(appConfig);
            ConfigureAutoMapper(serviceCollection);
            ConfigureDependenciesService(serviceCollection);
            ConfigureDependenciesRepository(serviceCollection);
            ConfigureDependenciesOuters(serviceCollection);
        }

        public static void ConfigureDependenciesService(IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<IUserService, UserService>();
            serviceCollection.AddTransient<IApiService, ApiService>();
            /*serviceCollection.AddTransient<IDefaultService, DefaultService>();
            serviceCollection.AddTransient<GroupSimilarOrdersService>();
            serviceCollection.AddTransient<InternalService>();*/
        }


        public static void ConfigureDependenciesOuters(IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<Utils>();
        }

        public static void ConfigureDependenciesRepository(IServiceCollection serviceCollection)
        {

            /*serviceCollection.AddTransient<DefaultSqlServerDao>();
            serviceCollection.AddTransient<InternalServicesSqlServerDao>();*/

            serviceCollection.AddTransient<DefaultAccess>();
            serviceCollection.AddTransient<UserDao>();

        }


        public static void ConfigureAutoMapper(IServiceCollection serviceCollection)
        {
            var config = new AutoMapper.MapperConfiguration(cfg =>
            {
                cfg.AddProfile(new DtoToModel());
            });
            IMapper mapper = config.CreateMapper();
            serviceCollection.AddSingleton(mapper);
        }
    }
}
