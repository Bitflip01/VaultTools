//
//  CharacterHistoryViewController.m
//  VaultApp
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
        
        fullChangeString = [NSString stringWithFormat:@"%@ %@ by %ld to %ld", changeTypeString, special, labs(changeValue), absoluteValue];
    }
    else
    {
        NSArray *perkChanges = snapshot.changes[kPerkChanges];
        NSDictionary *perkChange = perkChanges[indexPath.row - (snapshot.keys.count - 1)];
        
        if ([perkChange[kPerkChange] integerValue] == PerkChangeAdded)
        {
            fullChangeString = [NSString stringWithFormat:@"Added Perk %@", perkChange[kPerk]];
        }
        else if ([perkChange[kPerkChange] integerValue] == PerkChangeRemoved)
        {
            fullChangeString = [NSString stringWithFormat:@"Removed Perk %@", perkChange[kPerk]];
        }
        else if ([perkChange[kPerkChange] integerValue] == PerkChangeRankChanged)
        {
            NSInteger perkRankChange = [perkChange[kPerkRankChangeRelative] integerValue];
            NSInteger perkRankChangeAbsolute = [perkChange[kPerkRankChangeAbsolute] integerValue];
            changeTypeString = [self stringForRelativeChange:perkRankChange];
            fullChangeString = [NSString stringWithFormat:@"%@ rank of perk %@ by %ld to %ld",
                                changeTypeString,
                                perkChange[kPerk],
                                perkRankChange,
                                perkRankChangeAbsolute];
        }
    }
    
    
    cell.changeLabel.text = fullChangeString;
    
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
