//
//  PerksCollectionViewLayout.h
//  Vault Tools
//
//  Created by Alexander Heemann on 03/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerksCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, readonly) CGFloat horizontalInset;
@property (nonatomic, readonly) CGFloat verticalInset;

@property (nonatomic, readonly) CGFloat minimumItemWidth;
@property (nonatomic, readonly) CGFloat maximumItemWidth;
@property (nonatomic, assign, readwrite) CGFloat itemHeight;
@property (nonatomic, assign, readwrite) CGFloat itemWidth;

@end
