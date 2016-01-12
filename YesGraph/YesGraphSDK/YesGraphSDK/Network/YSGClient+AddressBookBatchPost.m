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
    //
    // We'll make a copy of the contacts and shuffle them around
    //
    
    NSMutableArray <YSGContact *> *contacts = contactList.entries.mutableCopy;
    NSUInteger totalCount = contactList.entries.count;
    NSUInteger range = totalCount - 1;
    
    for (NSUInteger index = 0; index < totalCount; ++index)
    {
        NSUInteger swapWith = arc4random_uniform((uint32_t)range) + 1;
        [contacts exchangeObjectAtIndex:index withObjectAtIndex:swapWith];
    }
    
    //
    // We now split it up by batches and POST it to the server
    //

    NSOperationQueue *queue = [NSOperationQueue new]; // background thread
    NSUInteger sentContacts = 0;
    while (sentContacts < totalCount)
    {
        BOOL isFirst = sentContacts == 0;
        NSUInteger toSend = (totalCount - sentContacts);
        if (toSend > YSGBatchCount)
        {
            toSend = YSGBatchCount;
        }
        BOOL isLast = (sentContacts + toSend) == totalCount;
        
        YSGContactList *partialList = [YSGContactList new];
        partialList.useSuggestions = contactList.useSuggestions;
        partialList.source = contactList.source;
        partialList.entries = [contacts subarrayWithRange:NSMakeRange(sentContacts, toSend)];
        
        YSGContactPostOperation *op = [[YSGContactPostOperation alloc] initWithClient:self contactsList:partialList andUserId:userId];
        
        // the Queue operates as FILO, so we have to invert the choice; when we
        // want the completion to fire when all the operations are done, we have to push
        // the completion block as part of the "first" operation - it's first to be added
        // to the queue, but it'll be executed last;
        // when we want to execute the completion block when the first operation is dones,
        // we have to push it last - as that operation is executed first
        
        if ((isFirst && waitForFinish) || (isLast && !waitForFinish))
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
