# Elements

This document describes elements and classes of the YesGraph SDK.

# Sections

Code in YesGraph SDK is divided into multiple sections. The sections correspond to folder structure inside the SDK.

- [Address Book](#address-book) - Contains contact list UI that displays contacts form.
- [Core](#core) - Contains error codes, constants and share sheet implementation.
- [Main](#main) - Convenience API's and configuration API's.
- [Model](#model) - Data models used for YesGraph API communication and local storage.
- [Network](#network) - Networking code used for YesGraph API communication.
- [Service](#service) - Sharing services that can be used with YesGraph SDK share sheet.
- [Theme](#theme) - Support for stying and theming share sheet and contact list UI.

Each of the sections contains multiple classes that can also be used outside

### YSGClient
**YSGClient** provides direct API access to YesGraph API which needs to be configured with your **YesGraph clientKey**.
Because YesGraph treats mobile devices as untrusted clients, first you need a trusted backend to generate client keys.

[Read more about connecting apps](https://docs.yesgraph.com/docs/connecting-apps#mobile-apps)
[Read more about creating client keys](https://docs.yesgraph.com/docs/create-client-keys)

###YSGLocalContactSource
**YSGLocalContactSource** is a wrapper class that handles all the logic from requesting permission to users address book to fetching local contact list.

There are two steps when requesting permissions for users address book. First a custom alert view is show where developers can configure the title and message that is shown to the user.

*Objective-C*
```objective-c
YSGLocalContactSource *localContactSource = [[YSGLocalContactSource alloc] init];
localContactSource.contactAccessPromptTitle = @"Access prompt title";
localContactSource.contactAccessPromptMessage = @"Access prompt message";
```

*Swift*
```swift
let localContactSource = YSGLocalContactSource()
localContactSource.contactAccessPromptTitle = @"Access prompt title"
localContactSource.contactAccessPromptMessage = "Access prompt message"
```

###YSGCacheContactSource
**YSGCacheContactSource** if configured 

###YSGOnlineContactSource
**YSGOnlineContactSource** is a wrapper class that handles fetching and syncing contact list to YesGraph API.

YSGOnlineContactSource is configured with `YSGClient` object, `YSGLocalContactSource` object and optionally `YSGCacheContactSource` which handles caching of contact list retrived from the YesGraph API.

Also a **user ID** must be set for the `YSGOnlineContactSource`. If user is not known, you can generate a random user ID by using `YSGUtility` class and `randomUserId` method.

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


##Using YesGraph SDK suggestions and contact list with custom UI

1. Configure **YSGLocalContactSource**

	*Objective-C*
	```objective-c
	YSGLocalContactSource *localContactSource = [[YSGLocalContactSource alloc] init];
    localContactSource.contactAccessPromptMessage = @"Share contacts with MyApp to invite friends?";
    ```
    *Swift*
	```swift
	let localContactSource = YSGLocalContactSource()
    localContactSource.contactAccessPromptMessage = "Share contacts with MyApp to invite friends?"
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
