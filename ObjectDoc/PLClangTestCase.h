#import <XCTest/XCTest.h>
#import "PLClang.h"

@interface PLClangTestCase : XCTestCase {
    PLClangSourceIndex *_index;
}

- (PLClangTranslationUnit *) translationUnitWithSource: (NSString *) source;

- (PLClangTranslationUnit *) translationUnitWithSource: (NSString *) source
                                                  path: (NSString *) path;

- (PLClangTranslationUnit *) translationUnitWithSource: (NSString *) source
                                                  path: (NSString *) path
                                               options: (PLClangTranslationUnitCreationOptions) options;

@end

@interface PLClangTranslationUnit (TestingAdditions)

- (PLClangCursor *) cursorWithSpelling: (NSString *) spelling;

@end
