//
//  UIColor+PennyColor.m
//  Pennypot
//
//  Created by Matthew Nydam on 30/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "UIColor+PennyColor.h"


@implementation UIColor (PennyColor)

#pragma mark - General

+ (UIColor *)deleteColor
{
  return [UIColor colorWithRed:0.776 green:0.157 blue:0.157 alpha:1] /*#c62828*/;
}

+ (UIColor *)increaseColor
{
    return [UIColor colorWithRed:0.404 green:0.227 blue:0.718 alpha:1] /*#673ab7*/;
}

#pragma mark - Progress

+ (UIColor *)progressZero
{
    return [UIColor colorWithRed:0.835 green:0 blue:0 alpha:1]; /*#d50000*/
}

+ (UIColor *)progressTen
{
    return [UIColor colorWithRed:0.847 green:0.263 blue:0.082 alpha:1]; /*#d84315*/
}

+ (UIColor *)progressTwenty
{
    return [UIColor colorWithRed:0.957 green:0.318 blue:0.118 alpha:1]; /*#f4511e*/
}

+ (UIColor *)progressThirty
{
    return [UIColor colorWithRed:0.937 green:0.424 blue:0 alpha:1]; /*#ef6c00*/
}

+ (UIColor *)progressForty
{
    return [UIColor colorWithRed:1 green:0.596 blue:0 alpha:1]; /*#ff9800*/
}

+ (UIColor *)progressFifty
{
    return [UIColor colorWithRed:0.984 green:0.753 blue:0.176 alpha:1]; /*#fbc02d*/
}

+ (UIColor *)progressSixty
{
    return [UIColor colorWithRed:0.804 green:0.863 blue:0.224 alpha:1]; /*#cddc39*/
}

+ (UIColor *)progressSeventy
{
    return [UIColor colorWithRed:0.682 green:0.835 blue:0.506 alpha:1]; /*#aed581*/
}

+ (UIColor *)progressEighty
{
    return [UIColor colorWithRed:0.545 green:0.765 blue:0.29 alpha:1]; /*#8bc34a*/
}

+ (UIColor *)progressNinety
{
    return [UIColor colorWithRed:0.298 green:0.686 blue:0.314 alpha:1]; /*#4caf50*/
}

+ (UIColor *)progressBackground
{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.12]; /*#000000*/
}

@end
