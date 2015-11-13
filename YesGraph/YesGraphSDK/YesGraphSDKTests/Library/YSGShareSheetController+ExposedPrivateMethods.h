//
//  YSGShareSheetController+ExposedPrivateMethods.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 30/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareSheetController.h"

@import Foundation;
@class YSGShareSheetServiceCell;

@interface YSGShareSheetController (ExposedPrivateMethods)

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UILabel *referralLabel;
@property (nonatomic, strong) UIButton *cpyButton;

- (void)viewDidLoad;
- (void)setupHeader;
- (void)setupShareServicesView;
- (void)setupFooter;
- (void)setupConstraints;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (void)copy:(UIButton *)sender;
- (BOOL)isModal;
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;
- (void)fadeCell:(YSGShareSheetServiceCell *)cell forService:(YSGShareService *)service;
- (void)unfadeCell:(YSGShareSheetServiceCell *)cell forService:(YSGShareService *)service;

@end

