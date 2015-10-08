//
//  YSGNetworkDefines.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGNetworkResponse.h"

typedef void (^YSGNetworkRequestCompletion)(YSGNetworkResponse * _Nullable response, NSError * _Nullable error);
typedef void (^YSGNetworkFetchCompletion)(id _Nullable responseObject, NSError * _Nullable error);