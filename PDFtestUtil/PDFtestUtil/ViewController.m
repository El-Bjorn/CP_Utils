//
//  ViewController.m
//  PDFtestUtil
//
//  Created by BjornC on 10/29/14.
//  Copyright (c) 2014 Builtlight. All rights reserved.
//

#import "ViewController.h"
#import <MEssageUI/MFMailComposeViewController.h>


@interface ViewController () <UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate,
                                MFMailComposeViewControllerDelegate>

//@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

-(IBAction) takePictureOfBill:(id)sender {
    NSLog(@"You takee pwetty pictia now.");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    picker.showsCameraControls = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker
                    didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self sendPDF:image];
}

-(void) sendPDF:(UIImage*)img {
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"CoPatientTstPDF"];
    
    UIGraphicsBeginPDFContextToFile(path, CGRectZero, nil);
    //UIGraphicsBeginPDFPageWithInfo(CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, img.size.width, img.size.height), nil);
    
    [img drawAtPoint:CGPointZero];
    UIGraphicsEndPDFContext();
    
    // send mail
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    [mailVC setSubject:@"CP PDF test"];
    [mailVC addAttachmentData:[NSData dataWithContentsOfFile:path]
                     mimeType:@"application/pdf" fileName:@"tstPDF"];
    [self presentViewController:mailVC animated:YES completion:nil];

    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
