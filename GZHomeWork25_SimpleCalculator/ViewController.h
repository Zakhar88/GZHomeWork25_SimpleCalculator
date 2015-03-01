//
//  ViewController.h
//  GZHomeWork25_SimpleCalculator
//
//  Created by 3axap on 19.02.15.
//  Copyright (c) 2015 Garan Zakhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *calcLabel;
@property (strong, nonatomic) NSNumber* firstNumber;
@property (strong, nonatomic) NSNumber* secondNumber;
@property (assign,nonatomic) BOOL thereIsPoint;
@property (assign, nonatomic) int operationNumber;
@property (assign,nonatomic) BOOL needToCleanLabelText;
@property (assign,nonatomic) BOOL thereIsResult;

- (IBAction)numbersAction:(UIButton *)sender;
- (IBAction)operationAction:(UIButton *)sender;
- (IBAction)pointAction:(UIButton *)sender;
- (IBAction)resultAction:(UIButton *)sender;
- (IBAction)cleanAction:(UIButton *)sender;
- (IBAction)signAction:(UIButton *)sender;
- (IBAction)percentAction:(UIButton *)sender;

-(void) numberContraction;
-(void) setFirstNumberFromLabelText;
-(void) setSecondNumberFromLabelText;


@end

