//
//  ScreenShotLib.m
//  ScreenShotLib
//
//  Created by abhisek mishra on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#include "FlashRuntimeExtensions.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <stdio.h>
UIKIT_EXTERN CGImageRef UIGetScreenImage();



void getScreenShotPNGImpl(NSString *imgPath)
{
    
    NSLog(@"entering the PNG method");
    CGImageRef screen  = UIGetScreenImage();
    UIImage *image = [UIImage imageWithCGImage:screen];
    CGImageRelease(screen);
    [UIImagePNGRepresentation(image) writeToFile:imgPath atomically:YES];
    NSLog(@"exiting the method");
}

void getScreenShotJPEGImpl(NSString *imgPath, CGFloat compressionQuality )
{
    NSLog(@"entering the JPEG method");
    CGImageRef screen  = UIGetScreenImage();
    UIImage *image = [UIImage imageWithCGImage:screen];
    CGImageRelease(screen);
    [UIImageJPEGRepresentation(image, compressionQuality)  writeToFile:imgPath atomically:YES];
    NSLog(@"exiting the method");
}



FREObject getScreenShotPNG(FREContext ctx, void* funcData,uint32_t argc, FREObject argv[])
{
     NSLog(@"Inside PNG method new one11");
    
    NSLog(@"no of arg recieved = %d",argc);
   // NSLog(@"param receieved is %@ %@",argv[0],argv[1]);
    
    uint32_t stringSize;
    //int res = FREGetObjectAsUint32(argv[1], stringSize);
    
     //NSLog(@"output is  %d, %d",res,*stringSize);
   
    
    //const uint8_t *imgName= (uint8_t*) malloc(sizeof(uint8_t)*(int)stringSize); 
    const uint8_t *imgName; 
    
    FREObject retVal = nil;
    uint32_t result =0;
    
    
   if(FRE_OK == FREGetObjectAsUTF8(argv[0], &stringSize,&imgName))
   {
    
         
    // NSLog(@"name of screenshot file received from AS side is %@",*imgName );
    
       NSString *tempName = [NSString stringWithUTF8String:(char *)(imgName)];
       NSLog(@"okkkkkkkkk");
       NSLog(@"name of screenshot file without suffix is  is %@",tempName );
       NSString *prefix = @"/";
       NSString *temp = [prefix stringByAppendingString:tempName];
    
       NSLog(@"name of screenshot file is %@",temp );
    
    
    
    
       NSString *pngPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:temp];

       // NSString *pngPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"abhipng.png"];
    
    
    
       getScreenShotPNGImpl(pngPath);
   }
   else {
       result = result+1;
   }
    FRENewObjectFromUint32(result,&retVal);
    return retVal;
    
    //return NULL;
     
}

FREObject getScreenShotJPEG(FREContext ctx, void* funcData,uint32_t argc, FREObject argv[])
{
    
    
    NSLog(@"Inside JPEG method new one11");
    
    NSLog(@"no of arg recieved = %d",argc);
    
    uint32_t stringSize;
    
    FREObject retVal = nil;
    uint32_t result =0;
    
    
    const uint8_t *imgName;
    
    if(FRE_OK == FREGetObjectAsUTF8(argv[0], &stringSize,&imgName))
    {
        
        
   
        NSLog(@"output of JPEG string part is  is   %d",result);
    
        NSString *tempName = [NSString stringWithUTF8String:(char *)imgName];
        NSString *prefix = @"/";
        NSString *temp = [prefix stringByAppendingString:tempName];
    
        NSLog(@"name of screenshot file is %@",temp );
    
        //NSString *jpgPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/abhiImage.jpeg"];
        NSString *jpgPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:temp];
    
        double *qualitity;
        if(FRE_OK ==FREGetObjectAsDouble(argv[1], qualitity))
        {
            
            
    
            CGFloat compressionQuality= (CGFloat)(*qualitity);
            getScreenShotJPEGImpl(jpgPath,compressionQuality);
        }
        else {
            result = result +1; // will return non zero value in case of error
        }
    }
    else {
        result = result +1; // will return non zero value in case of error
    }
    
    FRENewObjectFromUint32(result,&retVal);
    return retVal;
    
    //return NULL;
}


void ContextInitializer(void * extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
	NSLog(@"In ContextInitializer Function");
	*numFunctionsToTest = 2;
	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction)*(*numFunctionsToTest));
	
	func[0].name = (const uint8_t*)"getScreenShotPNG";
	func[0].functionData = NULL;
	func[0].function = &getScreenShotPNG;
	
	func[1].name = (const uint8_t*)"getScreenShotJPEG";
	func[1].functionData = NULL;
	func[1].function = &getScreenShotJPEG;
    
	
	
	*functionsToSet = func;
}

void ContextFinalizer(FREContext ctx)
{
	return;
}

void ExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	NSLog(@"in ExtInitializer");
	*extDataToSet = NULL;
	*ctxInitializerToSet = &ContextInitializer;
	*ctxFinalizerToSet = &ContextFinalizer;
}

void ExtFinalizer(void * extData)
{
	return;
}
