
//
//  RootViewController.m
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//
#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    //self.view.backgroundColor = [UIColor clearColor];
    CGRect rx = [ UIScreen mainScreen ].bounds;

    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    [scanButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
//    scanButton.frame = CGRectMake(0, rx.size.height - 60, rx.size.width, 30);
    //x y w h 取消按钮
    scanButton.frame = CGRectMake(rx.size.width / 2 + 60, (rx.size.height - rx.size.width + 40) / 2 + rx.size.width + 30, 60, 60);
    scanButton.backgroundColor = [UIColor clearColor];
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];

    //打开闪光灯按钮
    _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    [_lightButton setImage:[UIImage imageNamed:@"icon_light_off"] forState:UIControlStateNormal];
    //    scanButton.frame = CGRectMake(0, rx.size.height - 60, rx.size.width, 30);
    //x y w h 取消按钮
    _lightButton.frame = CGRectMake(rx.size.width / 2 - 120, (rx.size.height - rx.size.width + 40) / 2 + rx.size.width + 30, 60, 60);
    _lightButton.backgroundColor = [UIColor clearColor];
    [_lightButton addTarget:self action:@selector(lightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lightButton];
    
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0, (rx.size.height - rx.size.width + 40) / 2 + rx.size.width - 60 + 10, rx.size.width, 30)];
    labIntroudction.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
    labIntroudction.numberOfLines=1;
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    if (self.flag == 1) {
        labIntroudction.text=@"请扫描机身二维码进行配网";
    } else {
        labIntroudction.text=@"将二维码放入框内, 即可自动扫描";
    }
    [self.view addSubview:labIntroudction];

    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, (rx.size.height - rx.size.width + 40) / 2, rx.size.width - 60, rx.size.width - 60)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];

    upOrdown = NO;
    num = 0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(40, (rx.size.height - rx.size.width + 80) / 2, rx.size.width - 80, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];

    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{
    CGRect rx = [ UIScreen mainScreen ].bounds;
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(40, (rx.size.height - rx.size.width + 80) / 2 + 2 * num, rx.size.width-80, 2);
        if (2*num >= rx.size.width - 100) {
            upOrdown = YES;
        }
    } else {
        num --;
        _line.frame = CGRectMake(40, (rx.size.height - rx.size.width + 80) / 2 + 2 * num, rx.size.width-80, 2);
        if (num <= 0) {
            upOrdown = NO;
        }
    }

}
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
        [self.delegate passValue:nil];
    }];
}

-(void) lightButtonAction
{
    if (isLightOpen) {//关闭闪光灯
        isLightOpen = false;
        [_lightButton setImage:[UIImage imageNamed:@"icon_light_off"] forState:UIControlStateNormal];
        if ([_device hasTorch]) {
            [_device lockForConfiguration:nil];
            [_device setTorchMode: AVCaptureTorchModeOff];
            [_device unlockForConfiguration];
        }
    } else {//打开闪光灯
        isLightOpen = true;
        [_lightButton setImage:[UIImage imageNamed:@"icon_light_on"] forState:UIControlStateNormal];
        NSError *error = nil;
        if ([_device hasTorch]) {
            BOOL locked = [_device lockForConfiguration:&error];
            if (locked) {
                _device.torchMode = AVCaptureTorchModeOn;
                [_device unlockForConfiguration];
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];

    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }

    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }

    // 条码类型 AVMetadataObjectTypeQRCode
    // _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode];
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];

    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CGRect rx = [ UIScreen mainScreen ].bounds;
    _preview.frame =CGRectMake(0,0,rx.size.width,rx.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];

    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:^
    {
        [timer invalidate];
        NSLog(@"%@",stringValue);
        [self.delegate passValue:stringValue];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
