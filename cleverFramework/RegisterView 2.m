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
//#import "cleverframework-Swift.h"

@implementation RegisterView

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

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
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(registrationUpdateEvent:)
												 name:kLinphoneRegistrationUpdate
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(configureStateUpdateEvent:)
												 name:kLinphoneConfiguringStateUpdate
											   object:nil];

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
	_loginButton.enabled = !invalidInputs;
}


#pragma mark - Action Functions


- (void)onLoginClick:(id)sender {
	if (!linphone_core_is_network_reachable(LC)) {
        [PhoneMainView.instance presentViewController:[LinphoneUtils networkErrorView] animated:YES completion:nil];
		return;
	}

	_waitView.hidden = NO;
    
    @try {

        
//        Query *query = Query("register_login_device", 5);
//        query.AddVarchar(position: 0, FieldValue: "b1e6a2edc6b47674");
//        query.AddVarchar(position: 1, FieldValue: "1001");
//        query.AddInt(position: 2, FieldValue: 1);
//        query.AddInt(position: 3, FieldValue: 0);
//        query.AddVarchar(position: 4, FieldValue: "");
        
        
        
        
        
            /*
             
             let val0:PostgresValueConvertible = "b1e6a2edc6b47674"
             let val1:PostgresValueConvertible = "1001"
             let val2:PostgresValueConvertible = 1
             let val3:PostgresValueConvertible = 0
             let val4:PostgresValueConvertible = ""
             Params[4] = val4
             Params[1] = val1
             Params[2] = val2
             Params[3] = val3
             Params[0] = val0
             */
            
            
            
//             query.ExecData(){ result in
//                 let cursor:Cursor = try result.get();
//                 let defaults = UserDefaults.standard;
//                 defaults.setValue(Config.default.ClientID, forKey:"u_ClientID");
//
//                    for row in cursor {
//                        let columns = try row.get().columns;
//                        /*defaults.setValue(try columns[0].string(), forKey:"u_sipuser")
//                        defaults.setValue(try columns[1].string(), forKey:"u_sippass")
//                        defaults.setValue(try columns[2].string(), forKey:"c_pbx")*/
//
//                        defaults.setValue("202", forKey:"u_sipuser");
//                        defaults.setValue("Clever15321", forKey:"u_sippass");
//                        defaults.setValue("10.4.90.73", forKey:"c_pbx");
//                    }
//            }
        
     }
     @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
     }
     @finally {
        NSLog(@"finally");
     }
    
    
        
    
    
    linphone_core_clear_proxy_config(LC);
    linphone_core_clear_all_auth_info(LC);
    
   
    
    NSString *domain = @"cleverphone.ver-tex.co.za:5076";
    NSString *username = @"600";
    NSString *displayName = @"600";
    NSString *pwd = @"asd78238fds7tcrf83247ewgcuy897fbds87cg23bc8g6df2b3ecg962g3cg632b37wqg623gsbad7623bd6238n";
    NSString *transport = @"udp";
    LinphoneProxyConfig *config = linphone_core_create_proxy_config(LC);
    LinphoneAddress *addr = linphone_address_new(NULL);
    LinphoneAddress *tmpAddr = linphone_address_new([NSString stringWithFormat:@"sip:%@",domain].UTF8String);
    if (tmpAddr == nil) {
        //[self displayAssistantConfigurationError];
        return;
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
    

    linphone_proxy_config_enable_publish(config, FALSE);
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
          //[self displayAssistantConfigurationError];
        }
    } else {
      //[self displayAssistantConfigurationError];
    }
    
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

@end
