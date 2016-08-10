//
//  HWUserProfileController+ImagePicker.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileController+ImagePicker.h"
#import "UIImage+Scale.h"

@interface HWUserProfileController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation HWUserProfileController (ImagePicker)

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (image) {
        
        UIImage *resizedImage = [image imageByScalingAndCroppingForSize:CGSizeMake(300.f, 300.f)];
        
        if (self.photoCompletion) {
            [picker dismissViewControllerAnimated:YES completion:nil];
            self.photoCompletion(resizedImage);
            self.photoCompletion = nil;
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)presentChangePhotoActionSheetWithCompletion:(PhotoSelectionCompletion)completion
{
    self.photoCompletion = completion;
    
    WEAK_SELF;
    UIAlertController *changePhotoActionSheet = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Select photo") preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Take photo") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf takeNewPhotoFromCamera];
    }];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Select from gallery") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf choosePhotoFromExistingImages];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [changePhotoActionSheet addAction:cameraAction];
    [changePhotoActionSheet addAction:galleryAction];
    [changePhotoActionSheet addAction:cancelAction];
    
    [self presentViewController:changePhotoActionSheet animated:YES completion:nil];
}

/**
 *  If camera source type is available - show camera.
 */
- (void)takeNewPhotoFromCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [HWAlertService showAlertWithMessage:LOCALIZED(@"Camera is not available") forController:self withCompletion:nil];
        return;
    } else {
        [self showImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
    }
}

/**
 *  Choose photo from photo library
 */
- (void)choosePhotoFromExistingImages
{
    [self showImagePickerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

/**
 *  Setup UIImagePickerController
 *
 *  @param type Chosen type
 */
- (void)showImagePickerWithType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.sourceType = type;
    picker.mediaTypes = @[(NSString*)kUTTypeImage];
    [self presentViewController:picker animated:YES completion:nil];
}

@end
