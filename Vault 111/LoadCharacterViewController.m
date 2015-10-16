//
//  LoadCharacterViewController.m
//  Vault 111
//
//  Created by Alexander Heemann on 12/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "LoadCharacterViewController.h"
#import "LoadCharacterCell.h"
#import "CharacterManager.h"
#import "NewCharacterCell.h"
#import "Perk.h"
#import "StatsSnapshot.h"

typedef NS_ENUM(NSUInteger, LoadCharacterViewControllerSection)
{
    LoadCharacterViewControllerSectionCharacters,
    LoadCharacterViewControllerSectionNewCharacter,
};

@interface LoadCharacterViewController ()

@property (nonatomic, strong, readwrite) NSMutableArray *allCharacters;

@end

@implementation LoadCharacterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allCharacters = [[[CharacterManager sharedCharacterManager] allCharacters] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case LoadCharacterViewControllerSectionCharacters:
            return self.allCharacters.count;
            
        case LoadCharacterViewControllerSectionNewCharacter:
            return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section)
    {
        case LoadCharacterViewControllerSectionCharacters:
        {
            LoadCharacterCell *loadCharacterCell = [tableView dequeueReusableCellWithIdentifier:@"LoadCharacterCell" forIndexPath:indexPath];
            Character *character = self.allCharacters[indexPath.row];
            loadCharacterCell.characterNameLabel.text = character.name;
            loadCharacterCell.levelLabel.text = [NSString stringWithFormat:@"Level: %ld", [character.level integerValue]];
            
            // First row is always the current character, show checkmark there
            if (indexPath.row == 0)
            {
//                loadCharacterCell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                loadCharacterCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            cell = loadCharacterCell;
            break;
        }
        case LoadCharacterViewControllerSectionNewCharacter:
        {
            NewCharacterCell *newCharacterCell = [tableView dequeueReusableCellWithIdentifier:@"NewCharacterCell" forIndexPath:indexPath];
            cell = newCharacterCell;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case LoadCharacterViewControllerSectionCharacters:
        {
            Character *character = self.allCharacters[indexPath.row];
            character.lastUsed = [NSDate date];
            [character save];
            [CharacterManager sharedCharacterManager].currentCharacter = character;
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }            
        case LoadCharacterViewControllerSectionNewCharacter:
        {
            [[CharacterManager sharedCharacterManager] createNewCharacter];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section != LoadCharacterViewControllerSectionNewCharacter && indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Character *character = self.allCharacters[indexPath.row];
        for (Perk *perk in character.perks)
        {
            [perk MR_deleteEntity];
        }
        for (StatsSnapshot *snapshot in character.snapshots)
        {
            for (Perk *perk in snapshot.perks)
            {
                [perk MR_deleteEntity];
            }
            [snapshot MR_deleteEntity];
        }
        [character MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self.allCharacters removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case LoadCharacterViewControllerSectionCharacters:
            return 60;

        case LoadCharacterViewControllerSectionNewCharacter:
            return 70;
    }
    return 60;
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editTapped:(id)sender
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    [self.tableView setEditing:YES animated:YES];
}

- (void)doneTapped:(id)sender
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTapped:)];
    [self.tableView setEditing:NO animated:YES];
}

@end
