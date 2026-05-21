import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:supertokens_flutter/dio.dart'; // exports `addSupertokensInterceptor` extension
import 'package:supertokens_flutter/supertokens.dart';

/// One-time SuperTokens init. Synchronous despite the surrounding async main().
/// `apiBasePath: '/auth'` matches where kuru BE mounts the SuperTokens
/// middleware (see `gen-barcode/be/core/app.ts:102` — `app.use(middleware())`
/// before the `/api/v1` mount). Header-mode token transfer is the SDK default
/// for native clients (no cookies).
void initSuperTokens() {
  SuperTokens.init(apiDomain: Env.apiBaseUrl, apiBasePath: '/auth');
}

/// Attach SuperTokens' dio interceptor. Call this on the dio singleton AT
/// CONSTRUCTION TIME and BEFORE any other interceptors so token attachment
/// + refresh-on-401 wraps every subsequent request.
void wireSuperTokensToDio(Dio dio) {
  dio.addSupertokensInterceptor();
}
