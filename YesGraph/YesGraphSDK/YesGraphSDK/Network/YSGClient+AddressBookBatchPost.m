//
//  YSGClient+BatchPost.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 11/01/16.
//  Copyright © 2016 YesGraph. All rights reserved.
//

#import "YSGClient+AddressBookBatchPost.h"
#import "YSGClient+AddressBook.h"
#import "YSGContactPostOperation.h"

@implementation YSGClient (BatchPost)

- (void)updateAddressBookWithContactList:(YSGContactList *)contactList forUserId:(NSString *)userId completionWaitForFinish:(BOOL)waitForFinish completion:(nullable YSGNetworkFetchCompletion)completion
{
    
    NSMutableArray <YSGContact *> *contacts = contactList.entries.mutableCopy;
    NSUInteger totalCount = contactList.entries.count;
    
    //
    // We now split it up by batches and POST it to the server
    //

    NSOperationQueue *queue = [NSOperationQueue new]; // background thread
    [queue setMaxConcurrentOperationCount:1];
    NSUInteger sentContacts = 0;
    while (sentContacts < totalCount)
    {
        BOOL isFirst = sentContacts == 0;
        NSUInteger toSend = (totalCount - sentContacts);
        if (toSend > YSGBatchCount)
        {
            toSend = YSGBatchCount;
        }
        
        YSGContactList *partialList = [YSGContactList new];
        partialList.useSuggestions = contactList.useSuggestions;
        partialList.source = contactList.source;
        partialList.entries = [contacts subarrayWithRange:NSMakeRange(sentContacts, toSend)];
        
        YSGContactPostOperation *op = [[YSGContactPostOperation alloc] initWithClient:self contactsList:partialList andUserId:userId];
        
        if (isFirst)
        {
            __weak YSGContactPostOperation *weakOp = op;
            op.completionBlock = ^(void)
            {
                
                if (completion)
                {
                    completion(weakOp.responseObject, weakOp.responseError);
                }
            };
        }
        [queue addOperation:op];
        sentContacts += toSend;
    }
}


@end
