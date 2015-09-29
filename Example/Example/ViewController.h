//
//  ViewController.h
//  Example
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *introTextField;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *additionalTextView;

@end

// Javascript code that should be added to Parse.com Cloud Code section
//
// 'Authorization' in headers argument is a secret key generated by Yes Graph for our Example application
//

//Parse.Cloud.define("YGgetClientKey", function(request, response) {
//    var httpOptions = {
//    url: 'https://api.yesgraph.com/v0/client-key',
//    method: 'POST',
//    headers: {  'Authorization': 'Bearer live-WzEsMCwiRXhhbXBsZUFwcGxpY2F0aW9uIl0.COFZjA.iMmR8fez8lBRpoEtQS1DAyK8lZ4',
//        'Content-Type': 'application/json'
//    },
//    body: {'user_id': request.params.userId}
//    }
//
//    Parse.Cloud.httpRequest(httpOptions).then(
//                                              function(httpResponse) {
//                                                  response.success(httpResponse.text);
//                                              },
//                                              function(httpResponse) {
//                                                  console.log(httpResponse);
//                                                  var error = new Error();
//                                                  error.code = httpResponse.status;
//                                                  error.message = httpResponse.text;
//                                                  response.error(error);
//                                              }
//                                              );
//});