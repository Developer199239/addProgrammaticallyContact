//
//  ViewController.m
//  AddContactProgrammatically
//
//  Created by Zeeshan Khan on 4/3/18.
//  Copyright © 2018 Murtuza. All rights reserved.
//

#import "ViewController.h"
@import Contacts;
#import "MBProgressHUD.h"

@interface ViewController () {
    NSString *letters;
    int contact;
    MBProgressHUD *loginHud;
    int cont;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    contact = 1738696439;
    cont = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addContactBtnAction:(id)sender {
//    [self addContact:@"murtuza" andContact:@"01738696439"];
    loginHud = [[MBProgressHUD alloc] initWithView:self.view];
    [loginHud setLabelText:NSLocalizedString(@"add contact",nil)];
    [self.view addSubview:loginHud];
    [loginHud show:YES];
    [self generateContact];
}

- (void)generateContact {
    for(int i = 0; i<300; i++) {
        NSString *name = [self randomStringWithLength:10];
        int number = [self getRandomNumberBetween:1738696439 and:1738696539];
        NSString *phoneNumber = [NSString stringWithFormat:@"0%d",number];
        NSLog(@"%@ %@",name,phoneNumber);
        [self addContact:name andContact:phoneNumber];
    }
    loginHud.hidden = YES;
    loginHud = nil;
}

- (void)addContact:(NSString *)name andContact:(NSString *)contact12{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Access to contacts." message:@"This app requires access to contacts because ..." preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"Go to Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // user didn't grant access;
                // so, again, tell user here why app needs permissions in order  to do it's job;
                // this is dispatched to the main queue because this request could be running on background thread
            });
            return;
        }
        
        // create contact
        
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        contact.givenName = name;
        
        CNLabeledValue *homePhone = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:[CNPhoneNumber phoneNumberWithStringValue:contact12]];
        contact.phoneNumbers = @[homePhone];
        
        CNSaveRequest *request = [[CNSaveRequest alloc] init];
        [request addContact:contact toContainerWithIdentifier:nil];
        
        // save it
        NSError *saveError;
        if (![store executeSaveRequest:request error:&saveError]) {
            NSLog(@"error = %@", saveError);
            NSLog(@"success + error %d",cont++);
        }
        NSLog(@"success %d",cont++);
    }];
    
}

#pragma mark randomName generate
-(NSString *) randomStringWithLength: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        
        if(i == 5) {
            [randomString appendFormat: @" "];
        } else {
         [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
        }
    }
    return randomString;
}

-(int)getRandomNumberBetween:(int)from and:(int)to {
    return (int)from + arc4random() % (to-from+1);
}
@end
