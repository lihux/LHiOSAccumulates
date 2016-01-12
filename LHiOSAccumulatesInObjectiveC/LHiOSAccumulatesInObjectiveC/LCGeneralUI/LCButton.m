//
//  LCButton.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/12.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCButton.h"

@interface LCButton ()

@property (nonatomic, strong) NSMutableDictionary *stateBackgroundColorDictionary;
@property (nonatomic, strong) NSMutableDictionary *stateBorderColorDictionary;

@end

@implementation LCButton

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateStateBackgroundColor];
    [self updateStateBorderColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateStateBackgroundColor];
    [self updateStateBorderColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [self setBackgroundColor:backgroundColor forState:UIControlStateNormal];
    [super setBackgroundColor:backgroundColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self.stateBackgroundColorDictionary setObject:backgroundColor forKey:[self colorKeyForState:state]];
    [self updateStateBackgroundColor];
}

- (void)updateStateBackgroundColor
{
    UIColor *color = [self backgroundColorForState:self.state];
    if (color) {
        [super setBackgroundColor:color];
    }
}

- (void)updateStateBorderColor
{
    UIColor *color = [self borderColorForState:self.state];
    if (color) {
        self.layer.borderColor = color.CGColor;
    }
}

- (UIColor *)backgroundColorForState:(UIControlState)state
{
    return [self.stateBackgroundColorDictionary objectForKey:[self colorKeyForState:state]];
}

- (NSString *)colorKeyForState:(UIControlState)state
{
    return [NSString stringWithFormat:@"LH_Button_State_%lu", (unsigned long)state];
}

- (void)setBorderCorder:(UIColor *)borderColor forState:(UIControlState)state
{
    [self.stateBorderColorDictionary setObject:borderColor forKey:[self colorKeyForState:state]];
    if (![self borderColorForState:UIControlStateNormal]) {
        [self.stateBorderColorDictionary setObject:[UIColor colorWithCGColor:self.layer.borderColor] forKey:[self colorKeyForState:UIControlStateNormal]];
    }
    [self updateStateBorderColor];
}

- (UIColor *)borderColorForState:(UIControlState)state
{
    return [self.stateBorderColorDictionary objectForKey:[self colorKeyForState:state]];
}

- (NSMutableDictionary *)stateBackgroundColorDictionary
{
    if (!_stateBackgroundColorDictionary) {
        _stateBackgroundColorDictionary = [NSMutableDictionary dictionary];
    }
    return _stateBackgroundColorDictionary;
}

- (NSMutableDictionary *)stateBorderColorDictionary
{
    if (!_stateBorderColorDictionary) {
        _stateBorderColorDictionary = [NSMutableDictionary dictionary];
    }
    return _stateBorderColorDictionary;
}

@end
