//
//  CharacterViewController.m
//  Vault 111
//
//  Created by Alexander Heemann on 10/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "CharacterViewController.h"
#import "CharacterLevelCell.h"
#import "CharacterManager.h"
#import "CharacterNameCell.h"
#import "PerksDetailViewController.h"
#import "CharacterPerkCell.h"
#import "PerksLoader.h"
#import "CharacterSpecialCell.h"
#import "CharacterResetCell.h"
#import "CharacterStatsCell.h"

typedef NS_ENUM(NSUInteger, CharacterViewControllerSection)
{
    CharacterViewControllerSectionOverview,
    CharacterViewControllerSectionPerks,
    CharacterViewControllerSectionReset,
    CharacterViewControllerSectionCount
};

typedef NS_ENUM(NSUInteger, CharacterOverviewRow)
{
    CharacterOverviewRowName,
    CharacterOverviewRowLevel,
    CharacterOverviewRowSpecial,
    CharacterOverviewRowStats,
    CharacterOverviewRowCount
};

@interface CharacterViewController () <CharacterLevelCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *nameTextField;
@property (nonatomic, strong, readwrite) NSArray *perks;
@property (nonatomic, strong, readwrite) NSArray *perkDescriptions;

@end

@implementation CharacterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Sort perks in alphabetic order
    self.perks = [[[CharacterManager sharedCharacterManager].currentCharacter.perks allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Perk *perk1 = obj1;
        Perk *perk2 = obj2;
        return [perk1.name compare:perk2.name];
    }];
    
    self.perkDescriptions = [self generatePerkDescriptions];
    
    [self.tableView reloadData];
}

- (NSArray *)generatePerkDescriptions
{
    NSMutableArray *mutablePerkDescriptions = [NSMutableArray array];
    for (Perk *perk in self.perks)
    {
        [mutablePerkDescriptions addObject:[PerksLoader perkDescriptionForName:perk.name]];
    }
    return [mutablePerkDescriptions copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return CharacterViewControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case CharacterViewControllerSectionOverview:
            return CharacterOverviewRowCount;
            
        case CharacterViewControllerSectionPerks:
            return self.perks.count;
            
        case CharacterViewControllerSectionReset:
            return 1;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    Character *curChar = [CharacterManager sharedCharacterManager].currentCharacter;
    
    switch (indexPath.section)
    {
        case CharacterViewControllerSectionOverview:
        {
            switch (indexPath.row)
            {
                case CharacterOverviewRowName:
                {
                    CharacterNameCell *characterNameCell = (CharacterNameCell *)[tableView dequeueReusableCellWithIdentifier:@"CharacterNameCell"
                                                                                                                forIndexPath:indexPath];
                    characterNameCell.characterNameTextField.delegate = self;
                    self.nameTextField = characterNameCell.characterNameTextField;
                    if ([curChar.name length] > 0)
                    {
                        characterNameCell.characterNameTextField.text = curChar.name;
                    }
                    cell = characterNameCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                
                case CharacterOverviewRowLevel:
                {
                    CharacterLevelCell *characterLevelCell = (CharacterLevelCell *)[tableView dequeueReusableCellWithIdentifier:@"CharacterLevelCell"
                                                                                                                   forIndexPath:indexPath];
                    characterLevelCell.delegate = self;
                    characterLevelCell.levelLabel.text = [NSString stringWithFormat:@"%ld", [curChar.level integerValue]];
                    cell = characterLevelCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                case CharacterOverviewRowSpecial:
                {
                    CharacterSpecialCell *characterSpecialCell = (CharacterSpecialCell *)[tableView dequeueReusableCellWithIdentifier:@"CharacterSpecialCell" forIndexPath:indexPath];
                    characterSpecialCell.strengthLabel.text = [NSString stringWithFormat:@"%ld", [curChar.strength integerValue]];
                    characterSpecialCell.perceptionLabel.text = [NSString stringWithFormat:@"%ld", [curChar.perception integerValue]];
                    characterSpecialCell.enduranceLabel.text = [NSString stringWithFormat:@"%ld", [curChar.endurance integerValue]];
                    characterSpecialCell.charismaLabel.text = [NSString stringWithFormat:@"%ld", [curChar.charisma integerValue]];
                    characterSpecialCell.intelligenceLabel.text = [NSString stringWithFormat:@"%ld", [curChar.intelligence integerValue]];
                    characterSpecialCell.agilityLabel.text = [NSString stringWithFormat:@"%ld", [curChar.agility integerValue]];
                    characterSpecialCell.luckLabel.text = [NSString stringWithFormat:@"%ld", [curChar.luck integerValue]];
                    cell = characterSpecialCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                case CharacterOverviewRowStats:
                {
                    CharacterStatsCell *characterStatsCell = (CharacterStatsCell *)[tableView dequeueReusableCellWithIdentifier:@"CharacterStatsCell" forIndexPath:indexPath];
                                                            
                    characterStatsCell.hp = [curChar health];
                    characterStatsCell.ap = [curChar actionPoints];
                    characterStatsCell.carryWeight = [curChar carryWeight];
                    cell = characterStatsCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
        case CharacterViewControllerSectionPerks:
        {
            CharacterPerkCell *characterPerkCell = (CharacterPerkCell *)[tableView dequeueReusableCellWithIdentifier:@"CharacterPerkCell"
                                                                                                        forIndexPath:indexPath];
            PerkDescription *perkDescription = self.perkDescriptions[indexPath.row];
            Perk *perk = self.perks[indexPath.row];
            characterPerkCell.perkNameLabel.text = perkDescription.name;
            characterPerkCell.maxRank = perkDescription.maxRank;
            characterPerkCell.rank = [perk.rank integerValue];
            
            UIView *backgroundView = [[UIView alloc] init];
            backgroundView.backgroundColor = [UIColor flatGrayColor];
            characterPerkCell.selectedBackgroundView = backgroundView;
            
            cell = characterPerkCell;
            break;
        }
        case CharacterViewControllerSectionReset:
        {
            CharacterResetCell *characterResetCell = (CharacterResetCell *)[tableView dequeueReusableCellWithIdentifier:@"CharacterResetCell" forIndexPath:indexPath];
            cell = characterResetCell;
            break;
        }
            
            
        default:
            break;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case CharacterViewControllerSectionPerks:
            [self performSegueWithIdentifier:@"ShowPerksDetailViewControllerFromCharacterSeque"
                                      sender:indexPath];
            break;
        
        case CharacterViewControllerSectionReset:
            [self resetTapped];
            break;
        
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[NSIndexPath class]])
    {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        if (indexPath.section == CharacterViewControllerSectionPerks)
        {
            PerksDetailViewController *perksDetailViewController = segue.destinationViewController;
            PerkDescription *perkDescription = self.perkDescriptions[indexPath.row];
            perksDetailViewController.perkDescription = perkDescription;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case CharacterViewControllerSectionOverview:
            return @"Overview";
            break;
        case CharacterViewControllerSectionPerks:
            return @"Perks";
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case CharacterViewControllerSectionOverview:
        {
            switch (indexPath.row)
            {
                case CharacterOverviewRowStats:
                    return 75;
                    
                default:
                    return 60;
            }
        }
        
        case CharacterViewControllerSectionPerks:
            return 60;
        default:
            break;
    }
    return 60;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.nameTextField resignFirstResponder];
}

- (void)resetTapped
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reset Character"
                                                                             message:@"Are you sure you want to reset your character? This will reset SPECIAL stats, perks and level."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action)
    {
        NSIndexPath *resetIndexPath = [NSIndexPath indexPathForRow:0 inSection:CharacterViewControllerSectionReset];
        [self.tableView deselectRowAtIndexPath:resetIndexPath animated:YES];
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"Reset"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action)
    {
        [[CharacterManager sharedCharacterManager].currentCharacter reset];
        [[CharacterManager sharedCharacterManager].currentCharacter save];
        self.perks = @[];
        [self.tableView reloadData];
    }];
    [alertController addAction:resetAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark CharacterLevelCellDelegate

- (void)characterLevelCellDidTapLevelUp:(CharacterLevelCell *)cell
{
    Character *curChar = [CharacterManager sharedCharacterManager].currentCharacter;
    NSInteger oldLevel = [curChar.level integerValue];
    curChar.level = @(oldLevel + 1);
    NSInteger oldPerkPoints = [curChar.perkPoints integerValue];
    curChar.perkPoints = @(oldPerkPoints + 1);
    
    [self.tableView reloadData];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [CharacterManager sharedCharacterManager].currentCharacter.name = textField.text;
    [[CharacterManager sharedCharacterManager].currentCharacter save];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
