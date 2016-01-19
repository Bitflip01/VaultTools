//
//  SPECIALFooterView.h
//  Vault Tools
//
//  Created by Alexander Heemann on 03/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPECIALFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *remainingPointslabel;
@property (weak, nonatomic) IBOutlet UILabel *hpLabel;
@property (weak, nonatomic) IBOutlet UILabel *apLabel;
@property (weak, nonatomic) IBOutlet UILabel *carryWeightLabel;

@property (nonatomic, assign, readwrite) NSInteger hp;
@property (nonatomic, assign, readwrite) NSInteger ap;
@property (nonatomic, assign, readwrite) NSInteger carryWeight;

@end
