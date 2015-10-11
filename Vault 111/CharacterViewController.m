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

typedef NS_ENUM(NSUInteger, CharacterViewControllerSection)
{
    CharacterViewControllerSectionOverview,
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
            
            
        default:
            break;
    }
    
    
    
    return cell;
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
