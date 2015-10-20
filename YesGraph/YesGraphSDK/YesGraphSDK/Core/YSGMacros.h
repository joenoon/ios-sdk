//
//  YSGMacros.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 03/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#ifdef __cplusplus
#define YSG_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define YSG_EXTERN extern __attribute__((visibility ("default")))
#endif
