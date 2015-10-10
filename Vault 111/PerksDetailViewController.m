//
//  PerksDetailViewController.m
//  Vault 111
//
//  Created by Alexander Heemann on 08/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "PerksDetailViewController.h"
#import "PerkDescriptionCell.h"
#import "RankTableViewCell.h"
#import "PerkRank.h"
#import "TakePerkTableViewCell.h"
#import "CharacterManager.h"

typedef NS_ENUM(NSUInteger, PerksDetailViewControllerSection)
{
    PerksDetailViewControllerSectionTakePerk,
    PerksDetailViewControllerSectionDescription,
    PerksDetailViewControllerSectionRanks,
    PerksDetailViewControllerSectionNotes,
    PerksDetailViewControllerSectionCount,
};

@interface PerksDetailViewController ()<TakePerkTableViewCellDelegate>

@property (nonatomic, strong, readwrite) Perk *perk;

@end

@implementation PerksDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.perkDescription.name;
    Character *currentChar = [CharacterManager sharedCharacterManager].currentCharacter;
    self.perk = [currentChar perkForPerkDescription:self.perkDescription];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return PerksDetailViewControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case PerksDetailViewControllerSectionTakePerk:
            return 1;
        case PerksDetailViewControllerSectionDescription:
            return 1;
        case PerksDetailViewControllerSectionRanks:
            return self.perkDescription.maxRank;
        case PerksDetailViewControllerSectionNotes:
            return 0;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section)
    {
        case PerksDetailViewControllerSectionTakePerk:
        {
            TakePerkTableViewCell *takePerkCell = (TakePerkTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TakePerkTableViewCell"];
            Character *currentChar = [CharacterManager sharedCharacterManager].currentCharacter;
            takePerkCell.perkPointsLabel.text = [NSString stringWithFormat:@"Perk Points: %ld", [currentChar.perkPoints integerValue]];
            takePerkCell.delegate = self;
            if (self.perk)
            {
                if (self.perkDescription.maxRank > [self.perk.rank integerValue] && [currentChar canCharacterTakePerk:self.perkDescription
                                                                                                               atRank:self.perkDescription.rank + 1])
                {
                    takePerkCell.takePerkButton.enabled = YES;
                }
                else
                {
                    takePerkCell.takePerkButton.enabled = NO;
                }
                
                if ([self.perk.rank integerValue] > 0)
                {
                    takePerkCell.removePerkButton.enabled = YES;
                }
                else
                {
                    takePerkCell.removePerkButton.enabled = NO;
                }
            }
            else
            {
                takePerkCell.removePerkButton.enabled = NO;
                
                if ([currentChar canCharacterTakePerk:self.perkDescription atRank:1])
                {
                    takePerkCell.takePerkButton.enabled = YES;
                }
                else
                {
                    takePerkCell.takePerkButton.enabled = NO;
                }
            }
            
            cell = takePerkCell;
            break;
        }
            
        case PerksDetailViewControllerSectionDescription:
        {
            PerkDescriptionCell *perkDescriptionCell = (PerkDescriptionCell *)[self.tableView dequeueReusableCellWithIdentifier:@"PerkDescriptionCell"];
            perkDescriptionCell.perkDescriptionLabel.text = self.perkDescription.name;
            cell = perkDescriptionCell;
            break;
        }
            
        case PerksDetailViewControllerSectionRanks:
        {
            RankTableViewCell *rankTableViewCell = (RankTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"RankTableViewCell"];
            
            PerkRank *rank = self.perkDescription.ranks[indexPath.row];
            rankTableViewCell.rankDescriptionLabel.text = rank.rankDescription;
            rankTableViewCell.rankTaken = self.perkDescription.rank > indexPath.row;
            cell = rankTableViewCell;
            break;
        }
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PerksDetailViewControllerSectionDescription:
            return 55;
        case PerksDetailViewControllerSectionRanks:
            return 70;
            
        default:
            return 55;
    }
}

- (void)takePerkTableViewCellDidTakePerk:(TakePerkTableViewCell *)cell
{
    self.perkDescription.rank++;
    Character *curChar = [CharacterManager sharedCharacterManager].currentCharacter;
    if (self.perk)
    {
        self.perk.rank = @(self.perkDescription.rank);
    }
    else
    {
        self.perk = [Perk MR_createEntity];
        [self.perk setupWithPerkDescription:self.perkDescription];
        [curChar addPerksObject:self.perk];
    }
    curChar.perkPoints = @([curChar.perkPoints integerValue] - 1);
    [curChar save];
    [self.tableView reloadData];
}

- (void)takePerkTableViewCellDidRemovePerk:(TakePerkTableViewCell *)cell
{
    self.perkDescription.rank--;
    Character *curChar = [CharacterManager sharedCharacterManager].currentCharacter;
    if (self.perk)
    {
        if (self.perkDescription.rank == 0)
        {
            [curChar removePerksObject:self.perk];
            self.perk = nil;
        }
        else
        {
            self.perk.rank = @(self.perkDescription.rank);
        }
    }
    curChar.perkPoints = @([curChar.perkPoints integerValue] + 1);
    [curChar save];
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
