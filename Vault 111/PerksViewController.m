//
//  PerksViewController.m
//  Vault 111
//
//  Created by Alexander Heemann on 03/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "PerksViewController.h"
#import "PerkCollectionViewCell.h"
#import "PerkDescription.h"
#import "PerksCollectionViewLayout.h"
#import "PerksLoader.h"
#import "CharacterManager.h"
#import "PerksDetailViewController.h"
#import "SpecialCollectionViewCell.h"

@interface PerksViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) NSArray *perkDescriptions;
@property (nonatomic, strong, readwrite) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PerksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.perkDescriptions = [PerksLoader loadPerkDescriptionsFromJSON];
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    self.pinchGestureRecognizer.delegate = self;
    self.pinchGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:self.pinchGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.perkDescriptions[section] count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (indexPath.row == 0)
    {
        SpecialCollectionViewCell *specialCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialCollectionViewCell" forIndexPath:indexPath];
        specialCell.specialTitleLabel.text = [SPECIAL nameForType:indexPath.section];
        PerksCollectionViewLayout *const layout = (PerksCollectionViewLayout *)self.collectionView.collectionViewLayout;
        specialCell.specialTitleLabel.font = [UIFont systemFontOfSize:14 * (layout.itemWidth/80.0)];
        cell = specialCell;
    }
    else
    {
        PerkCollectionViewCell *perkCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PerkCollectionViewCell" forIndexPath:indexPath];
        PerkDescription *perk = self.perkDescriptions[indexPath.section][indexPath.row - 1];
        perkCell.perk = perk;
        PerksCollectionViewLayout *const layout = (PerksCollectionViewLayout *)self.collectionView.collectionViewLayout;
        perkCell.perkTitleLabel.font = [UIFont systemFontOfSize:12 * (layout.itemWidth/80.0)];
        if ([[CharacterManager sharedCharacterManager].currentCharacter hasEnoughSpecialPointsForPerk:perk])
        {
            perkCell.backgroundColor = [UIColor flatGreenColor];
        }
        else
        {
            perkCell.backgroundColor = [UIColor flatGrayColorDark];
        }
        cell = perkCell;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.perkDescriptions.count;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        [self performSegueWithIdentifier:@"ShowPerksDetailViewControllerSeque" sender:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PerksDetailViewController *perksDetailViewController = segue.destinationViewController;
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    PerkDescription *perkDescription = self.perkDescriptions[indexPath.section][indexPath.row - 1];
    perksDetailViewController.perkDescription = perkDescription;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinchRecogniser
{
    PerksCollectionViewLayout *const layout = (PerksCollectionViewLayout *)self.collectionView.collectionViewLayout;
    
    CGFloat itemWidth = MAX(30, MIN(100, layout.itemWidth * pinchRecogniser.scale));
    layout.itemWidth = itemWidth;
    layout.itemHeight = itemWidth;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = 30;
    return CGSizeMake(picDimension, picDimension);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat leftRightInset = 10;
    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
