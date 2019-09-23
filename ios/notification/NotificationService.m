//
//  NotificationService.m
//  notification
//
//  Created by Joel Oliveira on 20/09/2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "NotificationService.h"
#import "NotificarePushLib.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
  [[NotificarePushLib shared] fetchAttachment:request.content.userInfo completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
    if (!error) {
      self.bestAttemptContent.attachments = response;
      self.contentHandler(self.bestAttemptContent);
    } else {
      self.contentHandler(self.bestAttemptContent);
    }
  }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
