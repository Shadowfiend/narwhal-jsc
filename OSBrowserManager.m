/*********************************************************************************
 
 © Copyright 2010, Antonio Salazar Cardozo
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 *********************************************************************************/

//
//  OSBrowserManager.h
//

#import "OSBrowserManager.h"

@implementation OSBrowserManager

#pragma mark -
#pragma mark Initialization methods

- (id)initWithBrowsersObject:(WebScriptObject *)aWebScriptObjectArray
{
  if (self = [super init]) {
    browsers = aWebScriptObjectArray;
    webViewList = [[NSMutableArray alloc] init];
  }

  return self;
}

#pragma mark -
#pragma mark Script exposure method

+ (NSString *)webScriptNameForSelector:(SEL)aSelector
{
  if (aSelector == @selector(createBrowserNamed:)) {
    return @"createBrowserNamed";
  } else {
    return nil;
  }
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
  return aSelector != @selector(createBrowserNamed:);
}

#pragma mark -
#pragma mark WebView management

- (WebScriptObject *)createBrowserNamed:(NSString *)name
{
  IGIsolatedCookieWebView *browser = nil;
  @try {
    browser = [browsers valueForKey:name];
  } @catch (NSException *exception) {
    // We magically ignore this because we want to insert a value if the value doesn't exist.
  }

  NSUInteger length = [webViewList count];

  if (! browser) {
    browser = [[IGIsolatedCookieWebView alloc] init];

    [browsers setValue:browser forKey:name];
    [browsers setWebScriptValueAtIndex:length value:browser];
    [webViewList addObject:browser];
  }

  return browser;
}

@end

