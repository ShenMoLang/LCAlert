//
//  LCAlertView.h
//  Pods
//
//  Created by lcc on 16/10/14.
//
//

#import <UIKit/UIKit.h>

@class LCAlertView;

@protocol LCAlertViewDelegate <NSObject>
- (void)alertView:(LCAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

typedef void (^LCPopupViewTapButtonBlock)(LCAlertView *alertView, NSInteger buttonIndex);

@interface LCAlertView : UIView

@property (nonatomic, assign) id<LCAlertViewDelegate> delegate;
@property (nonatomic, copy) LCPopupViewTapButtonBlock buttonDidTappedBlock;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *closeButton;

- (instancetype)initWithMessage:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitle:(NSString *)otherButtonTitle;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles;

- (instancetype)initWithMessage:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitle:(NSString *)otherButtonTitle
      usingBlockWhenTapButton:(LCPopupViewTapButtonBlock)tapButtonBlock;


- (void)show;

- (void)dismiss;

@end
