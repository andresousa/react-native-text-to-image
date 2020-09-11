
#import "TextToImage.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation TextToImage

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(convert:(NSString *)text fontName:(nonnull NSString *)fontName fontSize:(CGFloat)fontSize color:(NSString *)hexColor callback:(RCTResponseSenderBlock)callback)
{
    [self textToImage:text fontName:fontName fontSize:fontSize color:hexColor callback:callback];
}

- (void)textToImage:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize color:(NSString *)hexColor callback:(RCTResponseSenderBlock)callback {
    // Figure out the dimensions of the string in a given font.
    NSString *textString = text;
//    UIFont* font = [UIFont systemFontOfSize:12.0f];
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    CGSize size = [textString sizeWithFont:font];
    // Create a bitmap context into which the text will be rendered.
    UIGraphicsBeginImageContext(size);
    // Render the text
    NSDictionary *attributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName: [self colorFromHexString:hexColor]};
    [textString drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:attributes];
    // Retrieve the image
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // Convert to JPEG
    NSData* data = UIImagePNGRepresentation(image);
    // Figure out a safe path
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *docDir = [arrayPaths objectAtIndex:0];
    // Write the file
    NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", textString]];
    BOOL success = [data writeToFile:filePath atomically:YES];
    if(!success)
    {
        NSLog(@"Failed to write to file. Perhaps it already exists?");
    }
    else
    {
        NSLog(@"JPEG file successfully written to %@", filePath);
        callback(@[filePath]);
    }
    // Clean up
    UIGraphicsEndImageContext();
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
  
