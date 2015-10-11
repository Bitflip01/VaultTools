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

typedef NS_ENUM(NSUInteger, CharacterViewControllerSection)
{
    CharacterViewControllerSectionOverview,
    CharacterViewControllerSectionPerks,
    CharacterViewControllerSectionCount
};

typedef NS_ENUM(NSUInteger, CharacterOverviewRow)
{
    CharacterOverviewRowName,
    CharacterOverviewRowLevel,
    CharacterOverviewRowCount
};

@interface CharacterViewController () <CharacterLevelCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *nameTextField;
@property (nonatomic, strong, readwrite) NSArray *perks;

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
    [self.tableView reloadData];
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
                    break;
                }
                
                case CharacterOverviewRowLevel:
                {
                    CharacterLevelCell *characterLevelCell = (CharacterLevelCell *)[tableView dequeueReusableCellWithIdentifier:@"CharacterLevelCell"
                                                                                                                   forIndexPath:indexPath];
                    characterLevelCell.delegate = self;
                    characterLevelCell.levelLabel.text = [NSString stringWithFormat:@"%ld", [curChar.level integerValue]];
                    cell = characterLevelCell;
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
            Perk *perk = self.perks[indexPath.row];
            characterPerkCell.perkNameLabel.text = perk.name;
            
            cell = characterPerkCell;
        }
            
            
        default:
            break;
    }
    
    
    
    return cell;
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
            return 60;
        
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
