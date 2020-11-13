/*
 * Copyright (c) 2010-2020 Belledonne Communications SARL.
 *
 * This file is part of linphone-iphone
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import "LinphoneManager.h"
#import "RegisterView.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"
#import "XMLRPCHelper.h"
//#import "Query.h"
//#include "zdb.h"
//#import "cleverframework-Swift.h"
#import <libpq/libpq-fe.h>


@implementation RegisterView

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

static void
exit_nicely(PGconn *conn)
{
    PQfinish(conn);
    //exit(1);
}

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:nil
                                                               sideMenu:nil
                                                             fullscreen:false
                                                         isLeftFragment:YES
                                                           fragmentWith:nil];
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}

#pragma mark - ViewController Functions

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Set observer
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(registrationUpdateEvent:)
//                                                 name:kLinphoneRegistrationUpdate
//                                               object:nil];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(configureStateUpdateEvent:)
//                                                 name:kLinphoneConfiguringStateUpdate
//                                               object:nil];

    // Update on show
    const MSList *list = linphone_core_get_proxy_config_list([LinphoneManager getLc]);
    if (list != NULL) {
        LinphoneProxyConfig *config = (LinphoneProxyConfig *)list->data;
        if (config) {
        }
    }

    
    NSString *siteUrl =
        [[LinphoneManager instance] lpConfigStringForKey:@"first_login_view_url"] ?: @"http://www.linphone.org";
    account_creator = linphone_account_creator_new([LinphoneManager getLc], siteUrl.UTF8String);

    [_extField
        showError:[AssistantView
                      errorForLinphoneAccountCreatorUsernameStatus:LinphoneAccountCreatorUsernameStatusInvalid]
             when:^BOOL(NSString *inputEntry) {
               LinphoneAccountCreatorUsernameStatus s =
                   linphone_account_creator_set_username(account_creator, inputEntry.UTF8String);
        _extField.errorLabel.text = [AssistantView errorForLinphoneAccountCreatorUsernameStatus:s];
               return s != LinphoneAccountCreatorUsernameStatusOk;
             }];

    

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLinphoneRegistrationUpdate object:nil];
}

- (void)shouldEnableNextButton {
    BOOL invalidInputs = NO;
    for (UIAssistantTextField *field in @[ _extField ]) {
        invalidInputs |= (field.isInvalid || field.lastText.length == 0);
    }
    
    if(invalidInputs)
    {
        _extField.errorLabel.text = @"Invalid Extention";
    }
    
    _loginButton.enabled = !invalidInputs;
}


#pragma mark - Action Functions


- (void)onLoginClick:(id)sender {
    if (!linphone_core_is_network_reachable(LC)) {
        [PhoneMainView.instance presentViewController:[LinphoneUtils networkErrorView] animated:YES completion:nil];
        return;
    }
    
    _waitView.hidden = NO;
    
#pragma mark - get Details
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *serial = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        int SipPort = 5076;
        NSString *server = @"cleverphone.ver-tex.co.za";
        NSString *domain = [NSString stringWithFormat:@"%s:%d", server.UTF8String,SipPort];
        NSString *username = @"600";
        NSString *displayName = @"600";
        NSString *pwd = @"asd78238fds7tcrf83247ewgcuy897fbds87cg23bc8g6df2b3ecg962g3cg632b37wqg623gsbad7623bd6238n";
        NSString *transport = @"udp";
        
        
        @try {
            //Register_login
            PGconn *_pgconn = PQconnectdb([NSString stringWithFormat:@"hostaddr=%@ port=%@ user=%@ password=%@ dbname=%@ connect_timeout=600",NSLocalizedString(@"ClientDBServer", "localhost"),NSLocalizedString(@"ClientDBServerPort", ""),NSLocalizedString(@"ClientDBServerUN", ""),NSLocalizedString(@"ClientDBServerPass", ""),NSLocalizedString(@"ClientDB", "")].UTF8String);
            
            if (PQstatus(_pgconn) != CONNECTION_OK) {
                exit_nicely(_pgconn);
                [NSException raise:@"Unable to connect to Postgresql Server" format:@"Connection to database failed: %s",
                PQerrorMessage(_pgconn)];
            }
            
            
            PGresult *res = NULL;
            char command[] = "select * from register_login_device ($1, $2, $3::bigint, $4::bigint,$5);";//Function exec
            const int nParams = 5;//Number of params
            char *paramValues[nParams];//parms
            int paramLengths[nParams];//lenght of params
            int paramFormats[nParams];//formats of params (0:text;1:binary)
            
            paramValues[0] = (char*)serial.UTF8String;//serial no
            paramLengths[0] = sizeof(paramValues[0]);//serial no
            paramFormats[0] = 0;//serial no
            
            paramValues[1] = (char*)_extField.text.UTF8String;//ext
            paramLengths[1] = sizeof(paramValues[0]);//ext
            paramFormats[1] = 0;//ext
            
            paramValues[2] = (char*)@"2".UTF8String;//clientid
            paramLengths[2] = sizeof(paramValues[1]);//clientid
            paramFormats[2] = 0;//clientid
            
            paramValues[3] = (char*)@"0".UTF8String;//edituser
            paramLengths[3] = sizeof(paramValues[2]);//edituser
            paramFormats[3] = 0;//edituser
            
            paramValues[4] = (char*)@"".UTF8String;//ip
            paramLengths[4] = sizeof(paramValues[3]);//ip
            paramFormats[4] = 0;//ip
            
            const char *const paramValues2[] = {(char*)serial.UTF8String,(char*)_extField.text.UTF8String,(char*)@"2".UTF8String,(char*)@"0".UTF8String,(char*)@"".UTF8String};
            
//            int resultFormat = 0;
            
            res = PQprepare(_pgconn, "login_register", command, nParams, NULL);
            if (PQresultStatus(res) != PGRES_COMMAND_OK) {
              PQclear(res);
                [NSException raise:@"Prepare Statement failed" format:@"PQprepare failed: %s",
                 PQresultErrorMessage(res)];
            } else {
              PQclear(res);
                
//                const char *const paramValues[] = {cid, name};
                res = PQexecPrepared(_pgconn, "login_register", nParams, paramValues2, paramLengths,
                                   paramFormats,0);
              if (PQresultStatus(res) != PGRES_TUPLES_OK) {
                  PQclear(res);
                  [NSException raise:@"Execute Statement Failed" format:@"PQexecPrepared failed: %s",
                   PQresultErrorMessage(res)];
              }
              else{
                  SipPort = atoi( PQgetvalue(res, 0, 3));
                  server = [[NSString alloc] initWithUTF8String:PQgetvalue(res, 0, 2)];
                  domain = [NSString stringWithFormat:@"%s:%d", server.UTF8String,SipPort];
                  username = [[NSString alloc] initWithUTF8String:PQgetvalue(res, 0, 0)];
                  displayName = [[NSString alloc] initWithUTF8String:PQgetvalue(res, 0, 0) ];
                  pwd = [[NSString alloc] initWithUTF8String:PQgetvalue(res, 0, 1)];
                  
//                  if([username  isEqual: @"unknown"])
//                  {
//                      [NSException raise:@"User Does not Exist." format:@"Please create me."];
//                  }
              }
              PQclear(res);
            }

            PQfinish(_pgconn);
         
        
        
            
        
        
        linphone_core_clear_proxy_config(LC);
        linphone_core_clear_all_auth_info(LC);
        
       
        
        
        LinphoneProxyConfig *config = linphone_core_create_proxy_config(LC);
        LinphoneAddress *addr = linphone_address_new(NULL);
        LinphoneAddress *tmpAddr = linphone_address_new([NSString stringWithFormat:@"sip:%@",domain].UTF8String);
        if (tmpAddr == nil) {
            [NSException raise:@"An error has occured." format:@"Invalid Domain Address"];
        }
        
        linphone_address_set_username(addr, username.UTF8String);
        linphone_address_set_port(addr, linphone_address_get_port(tmpAddr));
        linphone_address_set_domain(addr, linphone_address_get_domain(tmpAddr));
        if (displayName && ![displayName isEqualToString:@""]) {
            linphone_address_set_display_name(addr, displayName.UTF8String);
        }
        linphone_proxy_config_set_identity_address(config, addr);
        // set transport
        linphone_proxy_config_set_route(
            config,
            [NSString stringWithFormat:@"%s;transport=%s", domain.UTF8String, transport.UTF8String]
                .UTF8String);
        linphone_proxy_config_set_server_addr(
            config,
            [NSString stringWithFormat:@"%s;transport=%s", domain.UTF8String, transport.UTF8String]
                .UTF8String);
        

        linphone_proxy_config_enable_publish(config, TRUE);
        linphone_proxy_config_enable_register(config, TRUE);

        LinphoneAuthInfo *info =
            linphone_auth_info_new(linphone_address_get_username(addr), // username
                                   NULL,                                // user id
                                   pwd.UTF8String,                        // passwd
                                   NULL,                                // ha1
                                   linphone_address_get_domain(addr),   // realm - assumed to be domain
                                   linphone_address_get_domain(addr)    // domain
                                   );
        linphone_core_add_auth_info(LC, info);
        linphone_address_unref(addr);
        linphone_address_unref(tmpAddr);
//        [self setBool:YES forKey:@"account_substitute_+_by_00_preference"];
            
            
            //keep alive in background

        if (config) {
            [[LinphoneManager instance] configurePushTokenForProxyConfig:config];
            if (linphone_core_add_proxy_config(LC, config) != -1) {
                linphone_core_set_default_proxy_config(LC, config);
                linphone_core_refresh_registers(LC);
                
                
                
                // reload address book to prepend proxy config domain to contacts' phone number
                // todo: STOP doing that!
                [[LinphoneManager.instance fastAddressBook] fetchContactsInBackGroundThread];
                [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
            } else {
                [NSException raise:@"An error has occured." format:@"Creating Proxy Configuration failed"];
            }
        } else {
            [NSException raise:@"An error has occured." format:@"Creating Configuration failed"];
        }
            
        }
        @catch (NSException * e) {
           NSLog(@"Exception: %@", e);
            //ShowErrorMessage(@"An error has occured.",e.reason);
            UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"An error has occured.", nil)
                              message:NSLocalizedString(e.reason, nil)
                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action) {}];

            [errView addAction:defaultAction];
            [PhoneMainView.instance presentViewController:errView animated:YES completion:nil];
            return;
        }
        @finally {
           NSLog(@"finally");
            _waitView.hidden = YES;
        }

        //dispatch_async(dispatch_get_main_queue(), ^(void) {
             //stop your HUD here
             //This is run on the main thread
            //_waitView.hidden = YES;

       // });
    //
    
//});
}

#pragma mark - UITextFieldDelegate Functions

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
     if (textField.returnKeyType == UIReturnKeyDone) {
        [_loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIAssistantTextField *atf = (UIAssistantTextField *)textField;
    [atf textFieldDidEndEditing:atf];
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    UIAssistantTextField *atf = (UIAssistantTextField *)textField;
    [atf textField:atf shouldChangeCharactersInRange:range replacementString:string];
    [self shouldEnableNextButton];
    return YES;
}

-(void) ShowErrorMessage:(NSString*)title :(NSString*)message
{
    UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, nil)
                      message:NSLocalizedString(message, nil)
                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                    style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action) {}];

    [errView addAction:defaultAction];
    [PhoneMainView.instance presentViewController:errView animated:YES completion:nil];
    _waitView.hidden = YES;
}


@end


