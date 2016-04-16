//
//  ProfileHelper.m
//
//  Created by DesenGuo on 2016-01-14.
//

#import <Foundation/Foundation.h>
#import "ProfileHelper.h"

NSString * TAG=@"ProfileHelper";
int retryno;
@implementation ProfileHelper
{
}

- (NSURL*) getDocumentsDirectoryURL {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDirectory = [paths objectAtIndex:0];
    
    NSURL *baseURL = [NSURL fileURLWithPath:docsDirectory isDirectory:YES];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[baseURL path]];
    
    if (!exists) {
        NSError *error;
        exists = [[NSFileManager defaultManager] createDirectoryAtURL:baseURL withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (exists)
        return baseURL;
    
    return nil;
}
- (BOOL)saveProfileImageAsTempFile:(NSData *)pngImageData
{
    NSURL *docsDirURL = [self getDocumentsDirectoryURL];
    if (!docsDirURL) {
        NSLog(@"%@ Failed to locate Dive Buddle: %@", TAG, [docsDirURL path]);
        return false;
    }
    
    // retrieve the temporary picked image file
    NSURL *tmpFileURL = [NSURL URLWithString:@"profile.png" relativeToURL:docsDirURL];
    if (![pngImageData writeToURL:tmpFileURL atomically:YES]) {
        NSLog(@"%@ Failed to write selected profile image to path: %@", TAG, [tmpFileURL path]);
        return false;
    }
    return true;
}

- (NSURL*)getProfileImageURL
{
    NSURL *docsDirURL = [self getDocumentsDirectoryURL];
    if (!docsDirURL) {
        NSLog(@"%@ Failed to locate Dive Buddle: %@", TAG, [docsDirURL path]);
        return nil;
    }
    
    // retrieve the temporary picked image file
    return [NSURL URLWithString:@"profile.png" relativeToURL:docsDirURL];
}

- (UIImage*)getSavedProfileImage
{
    NSURL *docsDirURL = [self getDocumentsDirectoryURL];
    if (!docsDirURL) {
        NSLog(@"%@ Failed to locate Dive Buddle: %@", TAG, [docsDirURL path]);
        return false;
    }
    
    // retrieve the temporary picked image file
    NSURL *tmpFileURL = [NSURL URLWithString:@"profile.png" relativeToURL:docsDirURL];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[tmpFileURL path]];
    
    // rename the file and place it into the users directory
    if (!exists) {
        NSLog(@"%@ Failed to locate image picked by user at path: %@", [[self class] description], [tmpFileURL path]);
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:[tmpFileURL path]];
}

- (BOOL)saveTempProfileImage:(NSString*)userid
{
    NSURL *docsDirURL = [self getDocumentsDirectoryURL];
    if (!docsDirURL) {
        NSLog(@"%@ Failed to locate Dive Buddle: %@", TAG, [docsDirURL path]);
        return false;
    }
    
    // retrieve the temporary picked image file
    NSURL *tmpFileURL = [NSURL URLWithString:@"profile.png" relativeToURL:docsDirURL];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[tmpFileURL path]];
    
    // rename the file and place it into the users directory
    if (!exists) {
        NSLog(@"%@ Failed to locate image picked by user at path: %@", [[self class] description], [tmpFileURL path]);
        return false;
    }
    
    NSString *userDirectoryName = [NSString stringWithFormat:@"%@/%@",[docsDirURL path], userid];
    NSURL *userDirectoryURL = [NSURL fileURLWithPath:userDirectoryName isDirectory:YES];
    exists = [[NSFileManager defaultManager] fileExistsAtPath:[userDirectoryURL path]];
    
    if (!exists) {
        NSError *error;
        exists = [[NSFileManager defaultManager] createDirectoryAtURL:userDirectoryURL withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!exists) {
        NSLog(@"%@ Failed to createDirectoryAtURL: %@", TAG, [userDirectoryURL path]);
        return false;
    }
    
    NSString *imagFilePath = [NSString stringWithFormat:@"%@/%@.png", [userDirectoryURL path], userid];
    NSURL *imgFileURL = [NSURL fileURLWithPath:imagFilePath];
    
    // retrieve the data and write it to the new file
    NSData *imageData = [NSData dataWithContentsOfURL:tmpFileURL];
    BOOL dataWasWritten = [imageData writeToURL:imgFileURL atomically:YES];
    
    if (!dataWasWritten) {
        NSLog(@"%@ Failed to write image data to file path: %@", TAG, [imgFileURL path]);
        return false;
    }
    return true;
}

@end