//
//  CharacterHistoryViewController.m
//  Vault Tools
//
//  Created by Alexander Heemann on 18/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "CharacterHistoryViewController.h"
#import "SnapshotHistoryHelper.h"
#import "HistorySnapshot.h"
#import "Character.h"
#import "CharacterManager.h"
#import "SnapshotChangeCell.h"
#import "HistorySectionHeaderView.h"

@interface CharacterHistoryViewController ()

@property (nonatomic, strong, readwrite) NSArray *snapshots;
@property (nonatomic, strong, readwrite) StatsSnapshot *createdSnapshot;

@end

@implementation CharacterHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSnapshots];
}

- (void)viewWillDisappear:(BOOL)animated
{
    for (Perk *perk in self.createdSnapshot.perks)
    {
        [perk MR_deleteEntity];
    }
    [self.createdSnapshot MR_deleteEntity];
}

- (void)createSnapshots
{
    Character *curChar = [CharacterManager sharedCharacterManager].currentCharacter;
    NSMutableArray *curCharSnapshots = [NSMutableArray arrayWithArray:[curChar.snapshots allObjects]];
    self.createdSnapshot = [curChar snapshotForCurrentLevel];
    [curCharSnapshots addObject:self.createdSnapshot];
    self.snapshots = [SnapshotHistoryHelper snapshotsForHistoryFromSnapshots:curCharSnapshots];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.snapshots.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HistorySnapshot *snapshot = self.snapshots[section];
    if (snapshot.changes[kPerkChanges] && snapshot.changes.count > 0)
    {
        return snapshot.keys.count + [snapshot.changes[kPerkChanges] count] - 1;
    }
    else
    {
        return snapshot.keys.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    HistorySnapshot *snapshot = self.snapshots[section];
    if ([snapshot hasSPECIALChanges])
    {
        return 45;
    }
    else
    {
        return 25;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HistorySnapshot *snapshot = self.snapshots[section];
    HistorySectionHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"HistorySectionHeaderView" owner:self options:nil] objectAtIndex:0];
    headerView.levelLabel.text = [NSString stringWithFormat:@"Level %ld", [snapshot.snapshot.level integerValue]];
    if ([snapshot hasSPECIALChanges])
    {
        headerView.specialOverviewLabel.text = [NSString stringWithFormat:@"S: %ld  P: %ld  E: %ld  C: %ld  I:%ld  A: %ld  L: %ld",
                                                [snapshot.snapshot.strength integerValue],
                                                [snapshot.snapshot.perception integerValue],
                                                [snapshot.snapshot.endurance integerValue],
                                                [snapshot.snapshot.charisma integerValue],
                                                [snapshot.snapshot.intelligence integerValue],
                                                [snapshot.snapshot.agility integerValue],
                                                [snapshot.snapshot.luck integerValue]];
        headerView.specialOverviewLabel.hidden = NO;
    }
    else
    {
        headerView.specialOverviewLabel.hidden = YES;
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SnapshotChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SnapshotChangeCell" forIndexPath:indexPath];
    HistorySnapshot *snapshot = self.snapshots[indexPath.section];
    NSString *key;
    if (indexPath.row < snapshot.keys.count)
    {
        key = snapshot.keys[indexPath.row];
    }
    else
    {
        key = kPerkChanges;
    }
    
    NSString *fullChangeString;
    NSString *changeTypeString;
    if (![key isEqualToString:kPerkChanges])
    {
        NSDictionary *changeDict = snapshot.changes[key];
        NSInteger changeValue = [changeDict[kSpecialChangeRelative] integerValue];
        NSInteger absoluteValue = [changeDict[kSpecialChangeAbsolute] integerValue];
        changeTypeString = [self stringForRelativeChange:changeValue];
        
        NSString *special;
        if ([key isEqualToString:kSnapshotStrength])
        {
            special = @"strength";
        }
        else if ([key isEqualToString:kSnapshotPerception])
        {
            special = @"perception";
        }
        else if ([key isEqualToString:kSnapshotEndurance])
        {
            special = @"endurance";
        }
        else if ([key isEqualToString:kSnapshotCharisma])
        {
            special = @"charisma";
        }
        else if ([key isEqualToString:kSnapshotIntelligence])
        {
            special = @"intelligence";
        }
        else if ([key isEqualToString:kSnapshotAgility])
        {
            special = @"agility";
        }
        else if ([key isEqualToString:kSnapshotLuck])
        {
            special = @"luck";
        }
        
        NSInteger specialOriginal = absoluteValue - changeValue;
        fullChangeString = [NSString stringWithFormat:@"%@ %@ from %ld to %ld", changeTypeString, special, specialOriginal, absoluteValue];
    }
    else
    {
        NSArray *perkChanges = snapshot.changes[kPerkChanges];
        NSDictionary *perkChange = perkChanges[indexPath.row - (snapshot.keys.count - 1)];
        
        NSInteger perkRankChange = [perkChange[kPerkRankChangeRelative] integerValue];
        NSInteger perkRankChangeAbsolute = [perkChange[kPerkRankChangeAbsolute] integerValue];
        
        if ([perkChange[kPerkChange] integerValue] == PerkChangeAdded)
        {
            fullChangeString = [NSString stringWithFormat:@"Added perk %@", perkChange[kPerk]];
            if (labs(perkRankChange) > 1)
            {
                fullChangeString = [NSString stringWithFormat:@"%@ and increased rank to %ld", fullChangeString, perkRankChangeAbsolute];
            }
        }
        else if ([perkChange[kPerkChange] integerValue] == PerkChangeRemoved)
        {
            fullChangeString = [NSString stringWithFormat:@"Removed perk %@", perkChange[kPerk]];
        }
        else if ([perkChange[kPerkChange] integerValue] == PerkChangeRankChanged)
        {
            changeTypeString = [self stringForRelativeChange:perkRankChange];
            NSInteger perkRankOriginal = perkRankChangeAbsolute - perkRankChange;
            fullChangeString = [NSString stringWithFormat:@"%@ rank of perk %@ from %ld to %ld",
                                changeTypeString,
                                perkChange[kPerk],
                                perkRankOriginal,
                                perkRankChangeAbsolute];
        }
    }
    
    
    cell.changeLabel.text = fullChangeString;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)stringForRelativeChange:(NSInteger)change
{
    if (change > 0)
    {
        return @"Increased";
    }
    else
    {
        return @"Decreased";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = cell.contentView.backgroundColor;
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
