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

@interface PerksViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) NSArray *perks;
@property (nonatomic, strong, readwrite) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PerksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *perks = [PerksLoader loadPerksFromJSON];
    
    NSMutableArray *mutablePerks = [NSMutableArray array];
    for (int specialType = 0; specialType < perks.count; specialType++)
    {
        NSMutableArray *perkSection = [NSMutableArray array];
        for (int perkId = 0; perkId < [perks[specialType] count]; perkId++)
        {
            NSDictionary *perkDict = perks[specialType][perkId];
            PerkDescription *perk = [PerkDescription new];
            perk.name = perkDict[@"name"];
            perk.minSpecial = perkId + 1;
            perk.specialType = specialType;
            [perkSection addObject:perk];
        }
        [mutablePerks addObject:perkSection];
    }
    
    self.perks = [mutablePerks copy];
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
    return [self.perks[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PerkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PerkCollectionViewCell" forIndexPath:indexPath];
    PerkDescription *perk = self.perks[indexPath.section][indexPath.row];
    cell.perk = perk;
    PerksCollectionViewLayout *const layout = (PerksCollectionViewLayout *)self.collectionView.collectionViewLayout;
    cell.perkTitleLabel.font = [UIFont systemFontOfSize:12 * (layout.itemWidth/80.0)];
    if ([[CharacterManager sharedCharacterManager].currentCharacter canCharacterTakePerk:perk])
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = [UIColor grayColor];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.perks.count;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"didSelectItemAtIndexPath:"
                                                                        message: [NSString stringWithFormat: @"Indexpath = %@", indexPath]
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Dismiss"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: nil];
    
    [controller addAction: alertAction];
    
    [self presentViewController: controller animated: YES completion: nil];
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
