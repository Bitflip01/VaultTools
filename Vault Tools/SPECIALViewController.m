//
//  SPECIALViewController.m
//  Vault Tools
//
//  Created by Alexander Heemann on 01/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "SPECIALViewController.h"
#import "SPECIALTableViewCell.h"
#import "SPECIAL.h"
#import "Character.h"
#import "CharacterManager.h"
#import "SPECIALFooterView.h"

typedef NS_ENUM(NSUInteger, SPECIALCell)
{
    SPECIALCellStrength,
    SPECIALCellPerception,
    SPECIALCellEndurance,
    SPECIALCellCharisma,
    SPECIALCellIntelligence,
    SPECIALCellAgility,
    SPECIALCellLuck,
    SPECIALCellCount,
};

@interface SPECIALViewController ()<SPECIALTableViewCellDataSource, SPECIALTableViewCellDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray *SPECIALArray;

@end

@implementation SPECIALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.SPECIALArray = [NSMutableArray array];
    
    self.tableView.rowHeight = 55;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createSpecialArray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)createSpecialArray
{
    [self.SPECIALArray removeAllObjects];
    for (NSInteger specialType = 0; specialType < SPECIALCellCount; specialType++)
    {
        SPECIAL *special = [[SPECIAL alloc] initWithType:specialType];
        special.value = [[CharacterManager sharedCharacterManager].currentCharacter specialValueForType:specialType];
        [self.SPECIALArray addObject:special];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.SPECIALArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = cell.contentView.backgroundColor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPECIALTableViewCell *cell = (SPECIALTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SPECIALTableViewCell"];
    cell.dataSource = self;
    cell.delegate = self;
    SPECIAL *special = self.SPECIALArray[indexPath.row];
    cell.specialValueStepper.value = special.value;
    cell.specialValue = special.value;
    cell.specialValueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)special.value];
    cell.specialValueStepper.maximumValue = MAX(1, MIN(10, [self canIncreaseSpecial] ? 10 : special.value));
    
    UIView *selectedBGView = [[UIView alloc] init];
    selectedBGView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = selectedBGView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.special = special;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SPECIALFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"SPECIALFooterView" owner:self options:nil] objectAtIndex:0];
    Character *curChar = [CharacterManager sharedCharacterManager].currentCharacter;
    footerView.remainingPointslabel.text = [NSString stringWithFormat:@"%ld Points Remaining",
                                            [curChar.specialPoints integerValue] +
                                            [curChar.perkPoints integerValue]];
    
    footerView.hp = [curChar health];
    footerView.ap = [curChar actionPoints];
    footerView.carryWeight = [curChar carryWeight];
    
    return footerView;
}

#pragma mark SPECIALTableViewCellDataSource

- (BOOL)canIncreaseSpecial
{
    NSInteger specialPoints = [[CharacterManager sharedCharacterManager].currentCharacter.specialPoints integerValue];
    NSInteger perkPoints = [[CharacterManager sharedCharacterManager].currentCharacter.perkPoints integerValue];
    return specialPoints > 0 || perkPoints > 0;
}

#pragma mark SPECIALTableViewCellDelegate

- (void)cell:(SPECIALTableViewCell *)cell changedSpecial:(SPECIAL *)special
{
    [[CharacterManager sharedCharacterManager].currentCharacter setSpecial:special];
    [CharacterManager save];
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
