//
//  YSGClient+BatchPost.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 11/01/16.
//  Copyright © 2016 YesGraph. All rights reserved.
//

#import "YSGClient+AddressBookBatchPost.h"
#import "YSGClient+AddressBook.h"

@implementation YSGClient (BatchPost)

- (void)updateAddressBookWithContactList:(YSGContactList *)contactList forUserId:(NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion completionWaitForFinish:(BOOL)waitForFinish
{
    // we'll make a copy of the contacts and shuffle them around
    NSMutableArray <YSGContact *> *contacts = contactList.entries.mutableCopy;
    NSUInteger totalCount = contactList.entries.count;
    NSUInteger range = totalCount - 1;
    for (NSUInteger index = 0; index < totalCount; ++index)
    {
        NSUInteger swapWith = arc4random_uniform((uint32_t)range) + 1;
        [contacts exchangeObjectAtIndex:index withObjectAtIndex:swapWith];
    }
    
    NSLog(@"Starting batch send with: %lu contacts", totalCount);
    
    // we now split it up by batches and POST it to the server
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^
    {
        __block BOOL wasInvoked = NO;
        dispatch_semaphore_t waitingLock = dispatch_semaphore_create(0);
        NSUInteger sentContacts = 0;

        while (sentContacts < totalCount)
        {
            NSUInteger toSend = (totalCount - sentContacts);
            if (toSend > YSGBatchPOSTCount)
            {
                toSend = YSGBatchPOSTCount;
            }
            NSLog(@"Sending: %lu, starting at: %lu", toSend, sentContacts);
            YSGContactList *partialList = [YSGContactList new];
            partialList.useSuggestions = contactList.useSuggestions;
            partialList.source = contactList.source;
            partialList.entries = [contacts subarrayWithRange:NSMakeRange(sentContacts, toSend)];
            [self updateAddressBookWithContactList:partialList forUserId:userId completion:^(id  _Nullable responseObject, NSError * _Nullable error)
            {
                if (!wasInvoked && completion && !waitForFinish)
                {
                    completion(responseObject, error);
                    wasInvoked = YES;
                }
                else if (!wasInvoked && completion && waitForFinish && (sentContacts + toSend) == totalCount)
                {
                    completion(responseObject, error);
                    wasInvoked = YES;
                }
                dispatch_semaphore_signal(waitingLock);
            }];
            dispatch_semaphore_wait(waitingLock, DISPATCH_TIME_FOREVER);
            sentContacts += toSend;
        }
    });
}


@end
