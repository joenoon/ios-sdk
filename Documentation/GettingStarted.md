# YesGraph iOS SDK - Getting Started

This document details the process of using the YesGraph SDK in your iOS application without using the SDK's default UI.

Before you can use suggestions and contact list with YesGraph API, you need to configure the app with your **YesGraph client key**. Because YesGraph treats mobile devices as untrusted clients, first you need a trusted backend to generate client keys.

[Read more about connecting apps](https://docs.yesgraph.com/docs/connecting-apps#mobile-apps)
[Read more about creating client keys](https://docs.yesgraph.com/docs/create-client-keys)


##Using YesGraph SDK suggestions and contact list with custom UI

- **YSGClient** provides direct API access to YesGraph API.
- **YSGLocalContactSource** handles permissions requests and fetching user's local contact list.
- **YSGOnlineContactSource** handles fetching and syncing contact list to YesGraph API.

1. Configure **YSGLocalContactSource**

	*Objective-C*
	```objective-c
	YSGLocalContactSource *localContactSource = [[YSGLocalContactSource alloc] init];
    localContactSource.contactAccessPromptMessage = @"Share contacts with MyApp to invite friends?";
    ```
    *Swift*
	```swift
	let localSource = YSGLocalContactSource()
    localSource.contactAccessPromptMessage = "Share contacts with MyApp to invite friends?"
	```

2. Configure **YSGClient** with received **client key**

	*Objective-C*
	```objective-c
	YSGClient *client = [[YSGClient alloc] init];
	client.clientKey = clientKey;
	```
	*Swift*
	```swift
	let client = YSGClient()
	client.clientKey = clientKey
	```

3. Configure **YSGOnlineContactSource** with your **user ID**

	*Objective-C*
	```objective-c
	YSGOnlineContactSource *onlineContactSource = [[YSGOnlineContactSource alloc] initWithClient:client localSource:localContactSource cacheSource:[YSGCacheContactSource new]];
    onlineContactSource.userId = userId;
	```
	*Swift*
	```swift
	let onlineContactSource = YSGOnlineContactSource(client: client, localSource: localContactSource, cacheSource: YSGCacheContactSource())
   	onlineContactSource.userId = userId
	```

3. Fetch user's contactList with configured **YSGOnlineContactSource**

	*Objective-C*
	```objective-c
	[onlineContactSource requestContactPermission:^(BOOL granted, NSError *error) {
        if (granted) {
            NSLog(@"contact permission granted");
            [onlineContactSource fetchContactListWithCompletion:^(YSGContactList *contactList, NSError *error) {
            	if (!error) {
                    NSLog(@"contact list fetched");
                    NSArray<YSGContact *> *suggestedContacts = [contactList suggestedEntriesWithNumberOfSuggestions:YSGDefaultInviteNumberOfSuggestions];
                    //display suggested contacts and contact list with your custom UI
                }
            }];
        }
    }];
	```
	*Swift*
	```swift
	onlineContactSource.fetchContactListWithCompletion { (contactList, error) -> Void in
		if  !error {
			print("contact list fetched")
			let suggestedContacts = contactList?.suggestedEntriesWithNumberOfSuggestions(YSGDefaultInviteNumberOfSuggestions)
			//display suggested contacts and contact list with your custom UI
		}
   	}
	```
4. Every time the suggestions list is shown it must be sent to the **YesGraph API** via **YSGOnlineContactSource**

	*Objective-C*
	```objective-c
	[onlineContactSource sendShownSuggestions:suggestedContacts];
	```
	*Swift*
	```swift
	onlineContactSource.sendShownSuggestions(suggestedContacts)
	```
