//
//  ContentHeightTextView.h
//  Example-Static
//
//  Created by Miha Gresak on 18/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentHeightTextView : UITextView

@end


@interface ContentHeightTextView ()

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end
