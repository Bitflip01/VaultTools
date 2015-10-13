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

typedef NS_ENUM(NSUInteger, LoadCharacterViewControllerSection)
{
    LoadCharacterViewControllerSectionCharacters,
    LoadCharacterViewControllerSectionNewCharacter,
};

@interface LoadCharacterViewController ()

@property (nonatomic, strong, readwrite) NSArray *allCharacters;

@end

@implementation LoadCharacterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allCharacters = [[CharacterManager sharedCharacterManager] allCharacters];
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

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
