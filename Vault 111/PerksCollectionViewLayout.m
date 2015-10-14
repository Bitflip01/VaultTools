//
//  PerksCollectionViewLayout.m
//  Vault 111
//
//  Created by Alexander Heemann on 03/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "PerksCollectionViewLayout.h"

@interface PerksCollectionViewLayout ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *layoutAttributes;
@property (nonatomic, assign, readwrite) CGSize contentSize;

@end

@implementation PerksCollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.layoutAttributes = [NSMutableDictionary dictionary]; // 1
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:path];
    attributes.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, self.itemHeight / 4.0f);
    
    NSString *headerKey = [self layoutKeyForHeaderAtIndexPath:path];
    self.layoutAttributes[headerKey] = attributes; // 2
    
    NSUInteger numberOfSections = [self.collectionView numberOfSections]; // 3
    
    CGFloat yOffset = self.verticalInset;
    CGFloat xOffset = self.horizontalInset;
    
    for (int section = 0; section < numberOfSections; section++)
    {
        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section]; // 3
        yOffset = -50;
        
        for (int item = 0; item < numberOfItems; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath]; // 4
            
            CGSize itemSize = CGSizeZero;
            
            itemSize.width = self.itemWidth;
            itemSize.height = self.itemHeight;
            
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            NSString *key = [self layoutKeyForIndexPath:indexPath];
            self.layoutAttributes[key] = attributes; // 7
            
            yOffset += self.verticalInset;
            yOffset += self.itemHeight;
        }
        
        xOffset += self.itemWidth + [self horizontalSpacing];
    }
    
    self.contentSize = [self collectionViewContentSize];
}

- (CGFloat)horizontalSpacing
{
    return self.itemWidth * 0.2;
}

- (CGSize)collectionViewContentSize
{
    NSUInteger numberOfColumns = [self.collectionView numberOfSections];
    NSUInteger numberOfRows = [self.collectionView numberOfItemsInSection:0];
    CGFloat heigth = numberOfRows * (self.itemHeight + self.verticalInset);
    CGFloat width = (numberOfColumns) * (self.itemWidth + [self horizontalSpacing]) + self.horizontalInset;
    CGSize contentSize = CGSizeMake(width, heigth);
    
    return contentSize;
}

#pragma mark - Invalidate

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}

#pragma mark - Helpers

- (NSString *)layoutKeyForIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
}

- (NSString *)layoutKeyForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"s_%ld_%ld", (long)indexPath.section, (long)indexPath.row];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *headerKey = [self layoutKeyForHeaderAtIndexPath:indexPath];
    return self.layoutAttributes[headerKey];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self layoutKeyForIndexPath:indexPath];
    return self.layoutAttributes[key];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
        UICollectionViewLayoutAttributes *layoutAttribute = self.layoutAttributes[evaluatedObject];
        return CGRectIntersectsRect(rect, [layoutAttribute frame]);
    }];
    
    NSArray *matchingKeys = [[self.layoutAttributes allKeys] filteredArrayUsingPredicate:predicate];
    return [self.layoutAttributes objectsForKeys:matchingKeys notFoundMarker:[NSNull null]];
}


@end
