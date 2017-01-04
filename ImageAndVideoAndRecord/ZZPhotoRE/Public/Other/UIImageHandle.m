//
//  UIImageHandle.m
//  ZZFramework
//
//  Created by Yuan on 16/1/4.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import "UIImageHandle.h"

@implementation UIImageHandle

+(UIImage*)scaleImage:(UIImage *)image multiple:(CGFloat) multiple
{
    CGSize size = CGSizeMake(image.size.width * multiple, image.size.height * multiple);
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    
    UIImage*newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


+(UIImage *)compressImage:(UIImage *)artWork
{

    NSData *data2 = UIImageJPEGRepresentation(artWork, 0.7);
    UIImage *image = [UIImage imageWithData:data2];

    return image;
}

+(UIImage*)cutRectangleImage:(UIImage *)image rect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    CGRect cutBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(cutBounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, cutBounds, subImageRef);
    
    UIImage* cutImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    return cutImage;
}


@end
