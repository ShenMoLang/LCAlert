//
//  LCAlertView.m
//  Pods
//
//  Created by lcc on 16/10/14.
//
//

#import "LCAlertView.h"
#import "Masonry.h"

CGFloat const kMinAlertHeight = 150;//弹出框最小宽度
CGFloat const kAlertWidth = 260;//弹出框宽度
CGFloat const kButtonHeight = 40;//按钮高度
CGFloat const kMessageMargin = 10;
#define kFont [UIFont systemFontOfSize:14]//默认字体
#define kHSeparatorColor [UIColor colorWithRed:0.724 green:0.727 blue:0.731 alpha:1.000]
#define kVSeparatorColor [UIColor colorWithRed:0.724 green:0.727 blue:0.731 alpha:1.000]
#define kOpinionzBlueTitleColor      [UIColor colorWithRed:0.071 green:0.431 blue:0.965 alpha:1]
#define kOpinionzLightBlueTitleColor [UIColor colorWithRed:0.071 green:0.431 blue:0.965 alpha:0.4]
#define SINGLE_LINE_HEIGHT  (1 / [UIScreen mainScreen].scale)

@interface LCAlertView ()

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSArray *otherButtonTitles;

@end

@implementation LCAlertView

-(instancetype)initWithMessage:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitle:(NSString *)otherButtonTitle {
    return [self initWithTitle:nil
                       message:message
                      delegate:nil
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:@[otherButtonTitle]];
}

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles {
    return [self initWithTitle:title
                       message:message
                      delegate:nil
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:otherButtonTitles];
}

- (instancetype)initWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle usingBlockWhenTapButton:(LCPopupViewTapButtonBlock)tapButtonBlock {
    self = [self initWithTitle:nil
                       message:message
                      delegate:nil
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:@[otherButtonTitle]];
    
    self.buttonDidTappedBlock = tapButtonBlock;
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id /*<LCAlertView>*/)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles {
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = otherButtonTitles;
        
        self.delegate = delegate;
        
        //初始化
        [self config];
    }
    return self;
}



- (void)config {
    
    CGSize screenSize = [self screenSize];//屏幕尺寸
    
    // self
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // alert view
    CGFloat messageHeight = [self boundingRectHeightWithText:self.message font:kFont];
    if (messageHeight < kMinAlertHeight - kButtonHeight) {
        messageHeight = kMinAlertHeight - kButtonHeight;
    } else if (messageHeight > screenSize.height - 40 - kButtonHeight) {
        messageHeight = screenSize.height - 40 - kButtonHeight;
    }
    
    NSInteger btnCount;
    if (self.otherButtonTitles.count == 0 || self.otherButtonTitles.count == 1) {
        btnCount = 1;
    } else {
        btnCount = 1 + self.otherButtonTitles.count;
    }
    CGFloat alertHeight = messageHeight + kButtonHeight*btnCount;//弹出框高度
    if (self.title.length > 0) {
        alertHeight += 40;
    }
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - kAlertWidth)/2,
                                                              (screenSize.height - alertHeight)/2, kAlertWidth, alertHeight)];
    [self.alertView setBackgroundColor:[UIColor clearColor]];
    self.alertView.layer.masksToBounds = YES;
    self.alertView.layer.cornerRadius = 5;
    [self addSubview:self.alertView];
    
    // background effect
    if (NSClassFromString(@"UIVisualEffectView") != nil) {
        
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = self.alertView.bounds;
        [self.alertView addSubview:visualEffectView];
    } else {
        
        [self.alertView setBackgroundColor:[UIColor whiteColor]];
    }
    
    //title view
    CGFloat titleHeight = 0;//标题高度
    if (self.title.length > 0) {
        titleHeight = 40;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kAlertWidth, titleHeight)];
        titleLabel.text = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:titleLabel];
        
        // horizontal separator
        CALayer *horizontalBorder = [self separatorAt:CGRectMake(0, titleHeight,  kAlertWidth, SINGLE_LINE_HEIGHT)];
        [titleLabel.layer addSublayer:horizontalBorder];
        _titleLabel = titleLabel;
    }
    
    // message view
    UITextView *messageView = [[UITextView alloc] initWithFrame:CGRectMake(kMessageMargin,titleHeight, CGRectGetWidth(self.alertView.bounds) - kMessageMargin*2, alertHeight - titleHeight - kButtonHeight*btnCount)];
    [messageView setText:self.message];
    [messageView setTextColor:[UIColor blackColor]];
    [messageView setTextAlignment:NSTextAlignmentCenter];
    [messageView setFont:kFont];
    [messageView setEditable:NO];
    if ([self boundingRectHeightWithText:self.message font:kFont] <= screenSize.height - 40 - kButtonHeight) {
        [messageView setUserInteractionEnabled:NO];
    }
    [messageView setDataDetectorTypes:UIDataDetectorTypeNone];
    [messageView setBackgroundColor:[UIColor clearColor]];
    [self contentSizeToFit:messageView];
    [self.alertView addSubview:messageView];
    _messageView = messageView;
    
    
    // buttons view
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, alertHeight - kButtonHeight*btnCount, kAlertWidth, kButtonHeight*btnCount)];
    [buttonView setBackgroundColor:[UIColor clearColor]];
    [self.alertView addSubview:buttonView];

    // horizontal separator
    CALayer *horizontalBorder = [self separatorAt:CGRectMake(0, 0,  kAlertWidth, SINGLE_LINE_HEIGHT)];
    [buttonView.layer addSublayer:horizontalBorder];
    // adds border between 2 buttons
    if ((self.cancelButtonTitle && [self.otherButtonTitles count] == 1) ||
        ([self.otherButtonTitles count] == 2 && !self.cancelButtonTitle)) {
        CALayer *centerBorder = [CALayer layer];
        centerBorder.frame = CGRectMake((CGRectGetWidth(buttonView.frame) - SINGLE_LINE_HEIGHT)/2, kMessageMargin, SINGLE_LINE_HEIGHT, CGRectGetHeight(buttonView.frame) - kMessageMargin*2);
        centerBorder.backgroundColor = kVSeparatorColor.CGColor;
        [buttonView.layer addSublayer:centerBorder];
    }
    
    // setup cancel button
    if (self.cancelButtonTitle) {
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([self.otherButtonTitles count] == 1) {
            // Cancel button & 1 other button
            cancelButton.frame = CGRectMake(0, 0, kAlertWidth/2, kButtonHeight);
        }
        else {
            // Cancel button + multiple other buttons
            cancelButton.frame = CGRectMake(0, 0, kAlertWidth, kButtonHeight);
        }
        
        [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:kOpinionzBlueTitleColor forState:UIControlStateNormal];
        [cancelButton setTitleColor:kOpinionzLightBlueTitleColor forState:UIControlStateHighlighted];
        [cancelButton setTitleColor:kOpinionzLightBlueTitleColor forState:UIControlStateSelected];
        [cancelButton setBackgroundColor:[UIColor clearColor]];
        cancelButton.titleLabel.font = kFont;
        [cancelButton addTarget:self action:@selector(alertButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTag:0];
        [buttonView addSubview:cancelButton];
        _cancelButton = cancelButton;
        
        if (btnCount > 1) {
            CALayer *horizontalBorder = [CALayer layer];
            CGFloat borderY = CGRectGetMaxY(_cancelButton.frame)-SINGLE_LINE_HEIGHT;
            horizontalBorder.frame = CGRectMake(0.0f, borderY, buttonView.frame.size.width, SINGLE_LINE_HEIGHT);
            horizontalBorder.backgroundColor = [UIColor colorWithRed:0.724 green:0.727 blue:0.731 alpha:1.000].CGColor;
            [buttonView.layer addSublayer:horizontalBorder];
        }
    }
    
    // setup other buttons
    for (int i = 0; i < [self.otherButtonTitles count]; i++) {
        UIButton *otherTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([self.otherButtonTitles count] == 1 && !self.cancelButtonTitle) {
            // 1 other button and no cancel button
            otherTitleButton.frame = CGRectMake(0, 0, kAlertWidth, kButtonHeight);
            otherTitleButton.tag = 0;
        }
        else if (([self.otherButtonTitles count] == 2 && !self.cancelButtonTitle) ||
                 ([self.otherButtonTitles count] == 1 && self.cancelButtonTitle)) {
            // 2 other buttons, no cancel or 1 other button and cancel
            otherTitleButton.tag = i+1;
            otherTitleButton.frame = CGRectMake(kAlertWidth/2, 0, kAlertWidth/2, kButtonHeight);
        }
        else if ([self.otherButtonTitles count] >= 2) {
            if (self.cancelButtonTitle) {
                otherTitleButton.frame = CGRectMake(0, (i*kButtonHeight)+kButtonHeight+SINGLE_LINE_HEIGHT, kAlertWidth, kButtonHeight);
                otherTitleButton.tag = i+1;
            }
            else {
                otherTitleButton.frame = CGRectMake(0, i*kButtonHeight, kAlertWidth, kButtonHeight);
                otherTitleButton.tag = i;
            }
            CALayer *horizontalBorder = [CALayer layer];
            CGFloat borderY = CGRectGetMaxY(otherTitleButton.frame)-SINGLE_LINE_HEIGHT;
            horizontalBorder.frame = CGRectMake(0.0f, borderY, buttonView.frame.size.width, SINGLE_LINE_HEIGHT);
            horizontalBorder.backgroundColor = [UIColor colorWithRed:0.724 green:0.727 blue:0.731 alpha:1.000].CGColor;
            [buttonView.layer addSublayer:horizontalBorder];
        }
        
        [otherTitleButton addTarget:self action:@selector(alertButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [otherTitleButton setTitle:self.otherButtonTitles[i] forState:UIControlStateNormal];
        [otherTitleButton setTitleColor:kOpinionzBlueTitleColor forState:UIControlStateNormal];
        [otherTitleButton setTitleColor:kOpinionzLightBlueTitleColor forState:UIControlStateHighlighted];
        [otherTitleButton setTitleColor:kOpinionzLightBlueTitleColor forState:UIControlStateSelected];
        [otherTitleButton setBackgroundColor:[UIColor clearColor]];
        otherTitleButton.titleLabel.font = kFont;
        [buttonView addSubview:otherTitleButton];
        if (i == 0) {
            _sureButton = otherTitleButton;
        }
    }
    
    // Motion effects
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    [self.alertView addMotionEffect:group];

    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setTitle:@"x" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.hidden = YES;
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.top.equalTo(self.alertView);
        make.right.equalTo(self.alertView);
    }];
}

// MARK: alert button handler

- (void)alertButtonDidTapped:(UIButton *)button {
    if (self.delegate != nil) {
        [self.delegate alertView:self clickedButtonAtIndex:button.tag];
    }
    
    if (self.buttonDidTappedBlock != nil) {
        self.buttonDidTappedBlock(self, button.tag);
    }
    
    [self dismiss];
}

// MARK: show/dismiss methods

- (void)show {
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            [window addSubview:self];
            break;
        }
    }
    
    self.alertView.layer.opacity = 0.5f;
    self.alertView.layer.transform = CATransform3DMakeScale(1.1f, 1.1f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.alertView.layer.opacity = 1.0f;
                         self.alertView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alertView.transform = CGAffineTransformScale(self.alertView.transform, 0.8f, 0.8f);
                         self.alertView.alpha = 0.0f;
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [self performSelector:@selector(removeFromSuperview) withObject:self];
                     }];
}





#pragma mark -- 获取横屏竖屏不同情况下的屏幕尺寸
- (CGSize)screenSize
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

#pragma mark -- 根据font和text获取实际尺寸
- (CGFloat)boundingRectHeightWithText:(NSString *)text font:(UIFont *)font {
    CGSize maximumSize = CGSizeMake(kAlertWidth - 2 * kMessageMargin, CGFLOAT_MAX);
    CGRect boundingRect = [text boundingRectWithSize:maximumSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName : font} context:nil];
    return boundingRect.size.height + 10;
}

// Helper function: line for buttons
- (CALayer *)separatorAt:(CGRect)rect {
    CALayer *border = [CALayer layer];
    border.frame = rect;
    border.backgroundColor = kHSeparatorColor.CGColor;
    return border;
}

- (void)contentSizeToFit:(UITextView *)answerTextView {
    if([answerTextView.text length]>0) {
        CGFloat height = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            CGRect textFrame=[[answerTextView layoutManager]usedRectForTextContainer:[answerTextView textContainer]];
            height = textFrame.size.height;
        }else {
            height = answerTextView.contentSize.height;
        }
//        CGSize contentSize = answerTextView.contentSize;
        //NSLog(@"w:%f h%f",contentSize.width,contentSize.height);
        UIEdgeInsets offset;
//        CGSize newSize = contentSize;
        if(height <= answerTextView.frame.size.height) {
            CGFloat offsetY = (answerTextView.frame.size.height - height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
//        else {
//            newSize = answerTextView.frame.size;
//            offset = UIEdgeInsetsZero;
//            CGFloat fontSize = 18;
//            while (contentSize.height > answerTextView.frame.size.height) {
//                [answerTextView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
//                contentSize = answerTextView.contentSize;
//            }
//            newSize = contentSize;
//        }
//        [answerTextView setContentSize:newSize];
        [answerTextView setContentInset:offset];
    }
}

@end
