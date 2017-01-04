//
//  PlaceholderTextView.h
//  全民社区
//
//  Created by 李丹阳 on 2017/1/4.
//  Copyright © 2017年 YCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) UILabel * placeHolderLabel;

@property (nonatomic, copy)   NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;

@property (nonatomic, copy)   NSString* content;

- (void)textChanged:(NSNotification * )notification;

@end
