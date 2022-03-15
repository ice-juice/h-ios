//
//  UploadPhotosViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "UploadPhotosViewController.h"

#import "UploadPhotosMainView.h"

#import "HomeMainViewModel.h"

#import <AVFoundation/AVFoundation.h>
#import "YYImageClipViewController.h"

@interface UploadPhotosViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, YYImageClipDelegate, UploadPhotosMainViewDelegate>
@property (nonatomic, strong) UploadPhotosMainView *mainView;

@property (nonatomic, assign) BOOL isPositive;

@end

@implementation UploadPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UploadPhotosMainViewDelegate
- (void)mainViewWithUploadPortrait {
    //上传证件带头像照片
    self.isPositive = YES;
    [self uploadIDCardPicture];
}

- (void)mainViewWithUploadNationalEmblem {
    //上传手持证件带头像照片
    self.isPositive = NO;
    [self uploadIDCardPicture];
}

- (void)mainViewWithRealVerify {
    //实名认证
    [self.mainViewModel fetchRealNameVerifyWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"提交成功", nil) completionHandle:^{
                [self.navigationController popToRootViewControllerAnimated:YES];                
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
    self.navBar.title = NSLocalizedString(@"上传照片", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (UploadPhotosMainView *)mainView {
    if (!_mainView) {
        _mainView = [[UploadPhotosMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

@end
