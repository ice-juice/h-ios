//
//  AddPaymentViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AddPaymentViewController.h"

#import "AddPaymentMainView.h"

#import "HomeMainViewModel.h"

#import <AVFoundation/AVFoundation.h>
#import "YYImageClipViewController.h"

@interface AddPaymentViewController ()<AddPaymentMainViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YYImageClipDelegate>
@property (nonatomic, strong) AddPaymentMainView *mainView;
@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@property (nonatomic, assign) BOOL isPositive;

@end

@implementation AddPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateView];
}

#pragma mark -  AddPaymentMainViewDelegate
- (void)mainViewWithUploadQRCode {
    //上传收款二维码
    self.isPositive = YES;
    [self uploadIDCardPicture];
}

- (void)mainViewWithAddPayment:(NSString *)bankName address:(NSString *)address {
    //添加收款方式
    [self.mainViewModel fetchAddPayment:bankName address:address result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"添加成功", nil) completionHandle:^{
                [self popViewController];
            }];
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [picker pushViewController:imgCropperVC animated:YES];
}

- (UIView *)findView:(UIView *)aView withName:(NSString *)name {
    if ([name isEqualToString:NSStringFromClass(aView.class)]) {
        return aView;
    }
    for (UIView *view in aView.subviews) {
        if ([name isEqualToString:NSStringFromClass(view.class)]) {
            return view;
        }
    }
    return nil;
}

#pragma mark - YYImageClipDelegate
- (void)imageCropper:(YYImageClipViewController *)clipViewController didFinished:(UIImage *)editedImage {
    [clipViewController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
    [self.mainViewModel fetchUploadIDCardPicture:editedImage isPositive:self.isPositive result:^(BOOL success) {
        if (success) {
            [self.mainView updateImageView];
        }
    }];
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)clipViewController {
    //取消编辑
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [navigationController.navigationBar setShadowImage:nil];
    UIView *PLCropOverlay = [self findView:viewController.view withName:@"PLCropOverlay"];
    [PLCropOverlay setValue:NSLocalizedString(@"裁剪照片", nil) forKey:@"_defaultOKButtonTitle"];
    UIView *PLCropOverlayBottomBar = [self findView:PLCropOverlay withName:@"PLCropOverlayBottomBar"];
    UIView *PLCropOverlayPreviewBottomBar = [self findView:PLCropOverlayBottomBar withName:@"PLCropOverlayPreviewBottomBar"];
    UIButton *userButton = PLCropOverlayPreviewBottomBar.subviews.lastObject;
    [userButton setTitle:NSLocalizedString(@"裁剪照片", nil) forState:UIControlStateNormal];
}

#pragma mark - Event Response
- (void)uploadIDCardPicture {
    //上传身份证照片
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"选择照片", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机
    WeakSelf
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf updateSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选择", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf updateSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [actionSheet addAction:actionCancel];
        [actionSheet addAction:actionCamera];
        [actionSheet addAction:actionPhoto];
    } else {
        UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选择", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf updateSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:actionCancel];
        [actionSheet addAction:actionPhoto];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)updateSourceType:(NSUInteger)sourceType {
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"应用相机权限受限，请在设置中启用", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    //跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - Super Class
- (void)setupNavigation {
    NSString *title = @"";
    if (self.addPaymentType == AddPaymentTypeAlipay) {
        title = @"添加支付宝";
    } else if (self.addPaymentType == AddPaymentTypePayPal) {
        title = @"添加PayPal";
    } else if (self.addPaymentType == AddPaymentTypeWeChat) {
        title = @"添加微信";
    } else if (self.addPaymentType == AddPaymentTypeBankCard) {
        title = @"添加银行卡";
    }
    self.navBar.title = NSLocalizedString(title, nil);
}

#pragma mark - Setter & Getter
- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (AddPaymentMainView *)mainView {
    if (!_mainView) {
        _mainView = [[AddPaymentMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (HomeMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[HomeMainViewModel alloc] initWithAddPaymentType:self.addPaymentType];
    }
    return _mainViewModel;
}

@end
