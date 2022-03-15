//
//  AppealViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/28.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AppealViewController.h"
#import "FiatOrderDetailViewController.h"

#import "AppealMainView.h"

#import "FiatMainViewModel.h"

#import <AVFoundation/AVFoundation.h>
#import "YYImageClipViewController.h"

@interface AppealViewController ()<AppealMainViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YYImageClipDelegate>
@property (nonatomic, strong) AppealMainView *mainView;
@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation AppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - AppealMainViewDelegate
- (void)collection:(UICollectionView *)collectionView didSelectIndex:(NSInteger)index {
    [self uploadCertificate];
}

- (void)submitAppeal {
    //提交申诉
    [self.mainViewModel fetchSubmitAppealWithResult:^(BOOL success) {
        if (success) {
//            FiatOrderDetailViewController *detailVC = [[FiatOrderDetailViewController alloc] init];
//            detailVC.orderNo = self.orderNo;
//            [self.navigationController pushViewController:detailVC animated:YES];
            [self popViewController];
        }
    }];
}

- (void)uploadCertificate {
    //上传凭证
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"选择照片", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机
    WeakSelf
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:NSLocalizedString(@"手机拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf updateSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"相册选取", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf updateSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [actionSheet addAction:actionCancel];
        [actionSheet addAction:actionCamera];
        [actionSheet addAction:actionPhoto];
    } else {
        UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"相册选取", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [picker pushViewController:imgCropperVC animated:YES];
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
    [self.mainViewModel fetchUploadImage:editedImage result:^(BOOL success) {
        if (success) {
            [self.mainView updateImageView];
        }
    }];
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)clipViewController {
    //取消编辑
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"申诉", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (AppealMainView *)mainView {
    if (!_mainView) {
        _mainView = [[AppealMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
        _mainView.orderType = self.orderType;
    }
    return _mainView;
}

- (FiatMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[FiatMainViewModel alloc] initWithOrderNo:self.orderNo];
    }
    return _mainViewModel;
}

@end
