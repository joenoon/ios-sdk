//
//  YSGShareSheetServiceCell.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 20/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;

/*!
 *  Share sheet displays service
 */
@interface YSGShareSheetServiceCell : UICollectionViewCell

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, copy) UIImage *icon;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, copy) NSString *cellShape;


@end
