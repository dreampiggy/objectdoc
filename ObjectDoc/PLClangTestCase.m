#import "PLClangTestCase.h"

#define STRINGIFY(x) STRINGIFY_(x)
#define STRINGIFY_(x) @#x

@implementation PLClangTestCase

- (void) setUp {
    [super setUp];
    _index = [[PLClangSourceIndex alloc] init];
}

/**
 * Convenience method to create a translation unit from the given source with options
 * suitable for typical unit testing.
 */
- (PLClangTranslationUnit *) translationUnitWithSource: (NSString *) source {
    return [self translationUnitWithSource: source path: @"test.m"];
}

/**
 * Convenience method to create a translation unit from the given source and path with
 * options suitable for typical unit testing.
 */
- (PLClangTranslationUnit *) translationUnitWithSource: (NSString *) source path: (NSString *) path {
    return [self translationUnitWithSource: source path: path options: PLClangTranslationUnitCreationIncludeAttributedTypes];
}

/**
 * Convenience method to create a translation unit from the given source and path and options
 */
- (PLClangTranslationUnit *) translationUnitWithSource: (NSString *) source path: (NSString *) path options: (PLClangTranslationUnitCreationOptions) options {
    NSError *error = nil;
    NSData *data = [source dataUsingEncoding: NSUTF8StringEncoding];
    PLClangUnsavedFile *file = [PLClangUnsavedFile unsavedFileWithPath: path data: data];
    PLClangTranslationUnit *tu = [_index addTranslationUnitWithSourcePath: path
                                                             unsavedFiles: @[file]
                                                        compilerArguments: @[@"-isysroot", STRINGIFY(SDKROOT), @"-I", @"/usr/local/opt/llvm/lib/clang/9.0.0/include/"]
                                                                  options: options
                                                                    error: &error];
    XCTAssertNotNil(tu, @"Failed to parse", nil);
    XCTAssertNil(error, @"Received error for successful parse");
    XCTAssertFalse(tu.didFail, @"Should be marked as non-failed: %@", tu.diagnostics);

    return tu;
}

@end

@implementation PLClangTranslationUnit (TestingAdditions)

/**
 * Returns the first cursor in the translation unit with the specified spelling
 */
- (PLClangCursor *) cursorWithSpelling: (NSString *) spelling {
    __block PLClangCursor *cursor = nil;
    [self.cursor visitChildrenUsingBlock: ^PLClangCursorVisitResult(PLClangCursor *child) {
        if ([child.spelling isEqualToString: spelling]) {
            cursor = child;
            return PLClangCursorVisitBreak;
        }
        return PLClangCursorVisitRecurse;
    }];

    return cursor;
}

@end
