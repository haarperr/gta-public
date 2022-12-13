import { EnvService } from './env.service';

export const EnvServiceFactory = () => {
  const env: any = new EnvService();
  const _env: any = '_env';
  const browserWindow: any = window || {};
  const browserWindowEnv = browserWindow['_env'] || {};
  
  for(const key in browserWindowEnv) {
    var _key: any = key;
    if (browserWindowEnv.hasOwnProperty(key)) {
      env[key] = window[_env][_key];
    }
  }
  
  return env;
}

/**
  * @ngdoc service
  * @name EnvServiceProvider
  * 
  * @description
  * Récupère l'URL de l'API dans le fichier env.js
**/
export const EnvServiceProvider = {
  provide: EnvService,
  useFactory: EnvServiceFactory,
  deps: []
}
