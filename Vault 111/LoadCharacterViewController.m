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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allCharacters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadCharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadCharacterCell" forIndexPath:indexPath];
    Character *character = self.allCharacters[indexPath.row];
    cell.characterNameLabel.text = character.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CharacterManager sharedCharacterManager].currentCharacter = self.allCharacters[indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
