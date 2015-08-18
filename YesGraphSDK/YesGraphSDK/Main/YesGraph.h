//
//  YesGraph.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

@import Foundation;

@interface YesGraph : NSObject

/*!
 *  Shared instance to YesGraph
 *
 *  @return instance of YesGraph SDK
 */
+ (nonnull instancetype)shared;

@end

@interface YesGraph (Initialization)

/*!
 *  Configure YesGraph SDK with a client key that you receive from your trusted backend using YesGraph Secret Key.
 *  @note: https://docs.yesgraph.com/v0/docs/connecting-apps
 *
 *  @param key client string that is received from YesGraph backend on your trusted backend.
 */
- (void)configureWithClientKey:(nonnull NSString *)key;

@end
