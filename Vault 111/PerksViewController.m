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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *zoomButton;
@property (nonatomic, assign, readwrite) BOOL zoomedOut;
@property (nonatomic, readwrite, assign) CGFloat itemWidth;
@property (nonatomic, readwrite, assign) CGFloat originalItemWidth;

@end

@implementation PerksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemWidth = 80;
    self.originalItemWidth = self.itemWidth;
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
    UIFont *font = [UIFont fontWithName:@"Futura-Medium" size:12 * (self.itemWidth/80.0)];
    
    if (indexPath.row == 0)
    {
        SpecialCollectionViewCell *specialCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialCollectionViewCell" forIndexPath:indexPath];
        specialCell.specialTitleLabel.text = [SPECIAL nameForType:indexPath.section];
        specialCell.specialTitleLabel.font = font;
        cell = specialCell;
    }
    else
    {
        PerkCollectionViewCell *perkCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PerkCollectionViewCell" forIndexPath:indexPath];
        PerkDescription *perk = self.perkDescriptions[indexPath.section][indexPath.row - 1];
        perkCell.perk = perk;
        perkCell.perkTitleLabel.font = font;
        
        perkCell.minWidthConstraint.constant = self.itemWidth;
        
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
    
    self.itemWidth = MAX(40, MIN(100, self.originalItemWidth * pinchRecogniser.scale));
    layout.itemWidth = self.itemWidth;
    layout.itemHeight = self.itemWidth;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    
    if (pinchRecogniser.state == UIGestureRecognizerStateEnded)
    {
        self.originalItemWidth = self.itemWidth;
    }
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (IBAction)zoomButtonTapped:(id)sender
{
    if (self.zoomedOut)
    {
        // Zoom back in
        self.itemWidth = 80;
        self.zoomButton.image = [UIImage imageNamed:@"zoom_out_button"];
    }
    else
    {
        // Zoom out
        self.itemWidth = 40;
        self.zoomButton.image = [UIImage imageNamed:@"zoom_button"];
    }
    self.zoomedOut = !self.zoomedOut;
    self.originalItemWidth = self.itemWidth;
    
    PerksCollectionViewLayout *const layout = (PerksCollectionViewLayout *)self.collectionView.collectionViewLayout;
    layout.itemWidth = self.itemWidth;
    layout.itemHeight = self.itemWidth;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
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
