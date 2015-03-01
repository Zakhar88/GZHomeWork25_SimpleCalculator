//
//  ViewController.m
//  GZHomeWork25_SimpleCalculator
//
//  Created by 3axap on 19.02.15.
//  Copyright (c) 2015 Garan Zakhar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(event.type == UIEventSubtypeMotionShake)
    {
        UIColor* newColor =[self randomColor];
        
        for (UIView* tmpView in self.view.subviews){
            tmpView.backgroundColor = newColor;
        }
    }
}

-(UIColor*) randomColor{
    CGFloat r = (arc4random()%256)/255.f;
    CGFloat g = (arc4random()%256)/255.f;
    CGFloat b = (arc4random()%256)/255.f;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstNumber=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)numbersAction:(UIButton *)sender {
    
    if (self.needToCleanLabelText) {//якщо треба очистити екран(до цього було натиснуто кнопку з операцією)
        self.calcLabel.text=@"";//екарн стає порожнім рядком
        self.needToCleanLabelText=NO;//прапор очистки екрану вимкнено
    }
    
    if ([self.calcLabel.text length]>=9) return;//якщо введено 9 символів - більше не приймати
    
    if ([self.calcLabel.text isEqualToString:@"0"]){//якщо на екрані 0
        
     self.calcLabel.text=[NSString stringWithFormat:@"%d",sender.tag];//текст екрану = цифрі, на кнопку якої було натиснуто
        [self setSecondNumberFromLabelText];
        return;
    }

    self.calcLabel.text=[self.calcLabel.text stringByAppendingString:[NSString stringWithFormat:@"%d",sender.tag]];//в інших випадках - додати цифру натиснутої клавіші в кінець рядка на екрані
    
    self.thereIsResult=NO;//прапор чи було натиснуто "=" - "НІ", для можливості введення крапки
    
    [self setSecondNumberFromLabelText];
}

- (IBAction)operationAction:(UIButton *)sender {//натиснуто кнопку з операцією
    
    [self setFirstNumberFromLabelText];//встановити число з екарну в перше число
    
    self.operationNumber=sender.tag;//записати номер операції у відповідну властивіть self
    
    switch (self.operationNumber) {//виводимо на екран символ відповідної операції
        case 10:
            self.calcLabel.text=@"+";
            break;
            
        case 11:
            self.calcLabel.text=@"-";
            break;
            
        case 12:
            self.calcLabel.text=@"×";
            break;
            
        case 13:
            self.calcLabel.text=@"÷";
            break;
            
        default:
            break;
    }
    
    self.needToCleanLabelText=YES;//встановлюємо потребу очищення екрану при введенні нового числа після натискання операції
    
    self.thereIsPoint=NO;//встановлюємо прапор наявності крапки в числі в НІ
}

- (IBAction)pointAction:(UIButton *)sender {//натиснута крапка
    
    if ([self.calcLabel.text isEqualToString:@"+"]||[self.calcLabel.text isEqualToString:@"-"]||[self.calcLabel.text isEqualToString:@"×"]||[self.calcLabel.text isEqualToString:@"÷"]||self.thereIsResult) {//якщо на екрані символ операції, або виведено результат попередньої дії:
        
        self.calcLabel.text=@"0.";//встановити на екрані текст "0."
        self.thereIsPoint=YES;//прапор наявності крапки "ТАК"
        self.needToCleanLabelText=NO;//прапор необхідності очищення екрану "НІ"
       }
    
    if (!self.thereIsPoint) self.calcLabel.text=[self.calcLabel.text stringByAppendingString:[NSString stringWithFormat:@"."]];//якщо крапки ще немає на екрані - поставити її в кінець рядка
    
    self.thereIsPoint=YES;
}

- (IBAction)resultAction:(UIButton *)sender {
    
    if(!self.firstNumber) return;//якщо не встановлено перше число - нічого не робити
    
    NSMutableString* resultString=[[NSMutableString alloc]init];//рядок в якому буде результат (mutable для видалення зайвих нулів після крапки)
    
    switch (self.operationNumber) {//виконати оперцію з числами
        case 10:
            resultString = [NSMutableString stringWithFormat:@"%.7f",[self.firstNumber doubleValue]+[self.secondNumber doubleValue]];
            break;
            
        case 11:
            resultString=[NSMutableString stringWithFormat:@"%.7f",[self.firstNumber doubleValue]-[self.secondNumber doubleValue]];
            break;
            
        case 12:
            resultString=[NSMutableString stringWithFormat:@"%.7f",[self.firstNumber doubleValue]*[self.secondNumber doubleValue]];
            break;
            
        case 13:
            resultString=[NSMutableString stringWithFormat:@"%.7f",[self.firstNumber doubleValue]/[self.secondNumber doubleValue]];
            break;
            
        default:
            break;
    }

    self.calcLabel.text=resultString;
    
    [self numberContraction];
    
    [self setFirstNumberFromLabelText];//записуємо результат в перше число

    self.needToCleanLabelText=YES;//прапор очищення екрану "ТАК"
    
    self.thereIsResult=YES;//прапор що на екрані результат "ТАК"

}

- (IBAction)cleanAction:(UIButton *)sender {
    self.calcLabel.text=@"0";
    self.operationNumber=0;
    self.thereIsPoint=NO;
    self.firstNumber=self.secondNumber=nil;
    self.thereIsResult=NO;
}

- (IBAction)signAction:(UIButton *)sender {
    
    if ([self.calcLabel.text isEqualToString:@"0"]) return;
    
    [self setSecondNumberFromLabelText];
    
    self.calcLabel.text = [NSString stringWithFormat:@"%.7f",[self.secondNumber doubleValue]*(-1)];
    
    [self setSecondNumberFromLabelText];
    
    [self numberContraction];
    
    self.firstNumber=nil;
}

- (void) numberContraction{//обтинання зайвих нулів після крапки
    
    NSArray* numbersSeparatedByPoint = [self.calcLabel.text componentsSeparatedByString:@"."];//розділяємо крапокю рядок з числом на 2 частини
    
    if ([[numbersSeparatedByPoint objectAtIndex:1] isEqualToString:@"0000000"]){//якщо після крапки тільки нулі
        
        self.calcLabel.text=[numbersSeparatedByPoint objectAtIndex:0];//текст на екрані буде рівним тільки першій цілій частині числа
    }
    
    else {
        
        NSString* fractionString=[[NSString alloc]initWithString:[numbersSeparatedByPoint objectAtIndex:1]];//створюємо рядок з цифрами після крапки
        
        for (int i = [fractionString length]; i>=0; i--) {//цикл кількістю символів в цьому рядку
            
            NSString* tmp = [fractionString substringFromIndex:[fractionString length]-1];//тимчасовий рядок з останнього символу
            
            if ([tmp isEqualToString:@"0"]) fractionString=[fractionString substringToIndex:[fractionString length]-1];//якщо останній символ "0" - витерти його
            
            else break;
        }
        
        NSArray* resultArray = [[NSArray alloc] initWithObjects:[numbersSeparatedByPoint objectAtIndex:0], fractionString, nil];//створити масив з цілим числом та обтятим числом після крапки
        
        self.calcLabel.text = [resultArray componentsJoinedByString:@"."];//обєднати ці рядки на екрані з розділювачем "."
    }
}

- (IBAction)percentAction:(UIButton *)sender {
    
    if(!self.firstNumber){//якщо до цього не було встановлено перше число (тобто не обрано жодної операції)
        
        [self setSecondNumberFromLabelText];//встановити друге число
        
        NSMutableString* resultString=[[NSMutableString alloc]initWithFormat:@"%.7f",[self.secondNumber doubleValue]/100];//розділити його на 100 та записати в рядок
        
        self.calcLabel.text=resultString;//вивести рядок з результатом на екран
        
        [self numberContraction];//обтяти нулі після крапки
    }
    
    else{
        
        self.calcLabel.text = [NSString stringWithFormat:@"%.7f",[self.firstNumber doubleValue]/100*[self.secondNumber doubleValue]];
        
        [self numberContraction];//обтяти нулі після крапки
        
        [self setSecondNumberFromLabelText];
    }
}

-(void) setFirstNumberFromLabelText{
    NSNumberFormatter* NumberFormatter = [[NSNumberFormatter alloc] init];
    NumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.firstNumber=[NumberFormatter numberFromString:self.calcLabel.text];
}

-(void) setSecondNumberFromLabelText{
    NSNumberFormatter* NumberFormatter = [[NSNumberFormatter alloc] init];
    NumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.secondNumber=[NumberFormatter numberFromString:self.calcLabel.text];
}
@end
