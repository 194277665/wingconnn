/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CDVURLProtocol.h"
#import "CDVCommandQueue.h"
#import "CDVViewController.h"

// Contains a set of NSNumbers of addresses of controllers. It doesn't store
// the actual pointer to avoid retaining.
static NSMutableSet* gRegisteredControllers = nil;

NSString* const kCDVAssetsLibraryPrefixes = @"assets-library://";
NSString* const kCDVRemoteJavascriptHader = @"http://wingconn/";

@implementation CDVURLProtocol


+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
{
    
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//        NSLog(@"cookie%@", cookie);
//    }
    //获取request中的url
    NSURL* theUrl = [theRequest URL];
    //判断url的开头是否是我们约定好的 如果是返回yes自己处理 否者返回no系统处理
    if ([[theUrl absoluteString] hasPrefix:kCDVAssetsLibraryPrefixes] ||
        [[theUrl absoluteString] hasPrefix:kCDVRemoteJavascriptHader]) {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request
{
    //因为我们不需要对当前的请求做出处理，所以返回的当前的request不做任何改变
    return request;
}

- (void)startLoading
{
    // NSLog(@"%@ received %@ - start", self, NSStringFromSelector(_cmd));
    NSURL* url = [[self request] URL];
    
    if ([[url absoluteString] hasPrefix:kCDVAssetsLibraryPrefixes]) {
        ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset* asset) {
            if (asset) {
                // We have the asset!  Get the data and send it along.
                ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
                NSString* MIMEType = (__bridge_transfer NSString*)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)[assetRepresentation UTI], kUTTagClassMIMEType);
                Byte* buffer = (Byte*)malloc((unsigned long)[assetRepresentation size]);
                NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:(NSUInteger)[assetRepresentation size] error:nil];
                NSData* data = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
                [self sendResponseWithResponseCode:200 data:data mimeType:MIMEType];
            } else {
                // Retrieving the asset failed for some reason.  Send an error.
                [self sendResponseWithResponseCode:404 data:nil mimeType:nil];
            }
        };
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError* error) {
            // Retrieving the asset failed for some reason.  Send an error.
            [self sendResponseWithResponseCode:401 data:nil mimeType:nil];
        };
        
        ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary assetForURL:url resultBlock:resultBlock failureBlock:failureBlock];
        return;
    }else if ([[url absoluteString] hasPrefix:kCDVRemoteJavascriptHader]){
        //如果是约定好的开头
        //获取本地文件www文件路径
        NSString *docPath = [[NSBundle mainBundle]pathForResource:@"www" ofType:nil];
        docPath =  [docPath stringByAppendingString:@"/"];
        //将约定好的开头路径替换成本地的文件路径开头
        NSString *filePath = [[url absoluteString]stringByReplacingOccurrencesOfString:kCDVRemoteJavascriptHader withString:docPath];
        //将本地文件转换成Data数据类型
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        //将本地数据返回出去，并标志http请求成功状态码200.告诉客户端请求成功。该文件结构类型属于javascript
        [self sendResponseWithResponseCode:200 data:data mimeType:@"application/javascript"];
    }
    //  access not allowed to url ： @   access
    NSString* body = [NSString stringWithFormat:@"Access not allowed to URL: %@", url];
    [self sendResponseWithResponseCode:401 data:[body dataUsingEncoding:NSASCIIStringEncoding] mimeType:nil];
}

- (void)stopLoading
{
    // do any cleanup here
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest*)requestA toRequest:(NSURLRequest*)requestB
{
    return NO;
}

- (void)sendResponseWithResponseCode:(NSInteger)statusCode data:(NSData*)data mimeType:(NSString*)mimeType
{
    if (mimeType == nil) {
        mimeType = @"text/plain";
    }
    NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:[[self request] URL] statusCode:statusCode HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type" : mimeType}];
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    if (data != nil) {
        [[self client] URLProtocol:self didLoadData:data];
    }
    [[self client] URLProtocolDidFinishLoading:self];
}

@end
