//
//  ViewController.m
//  AJWaveView
//
//  Created by Chuan-Jie Jhuang on 2022/4/7.
//

#import "ViewController.h"
#import "AJWaveView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet AJWaveView *waveView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)magicButtonAction:(UIButton *)sender {
    [self.waveView animateShfitingColorsToAJWaveColorType:_waveView.color == AJWaveColorTypeBlue ? AJWaveColorTypeOrange : AJWaveColorTypeBlue
                                              andDuration:3
                                           withCompletion:^{
            
    }];
}

@end
