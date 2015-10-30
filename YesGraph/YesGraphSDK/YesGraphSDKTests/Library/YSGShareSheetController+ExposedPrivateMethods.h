//
//  YSGShareSheetController+ExposedPrivateMethods.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 30/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareSheetController.h"

@import Foundation;

@interface YSGShareSheetController (ExposedPrivateMethods)

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


@end

