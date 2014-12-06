//
//  Agent+Model.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 5/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Agent+Model.h"

NSString *const agentEntityName = @"Agent";
NSString *const agentPropertyAppraisal = @"appraisal";
NSString *const agentPropertyDestructionPower = @"destructionPower";
NSString *const agentPropertyMotivation = @"motivation";

@implementation Agent (Model)

#pragma mark - Convenience constructor

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc {
    Agent *agent = [NSEntityDescription insertNewObjectForEntityForName:agentEntityName
                                                 inManagedObjectContext:moc];
    return agent;
}


#pragma mark - Dependencies

+ (NSSet *) keyPathsForValuesAffectingAppraisal {
    return [NSSet setWithArray:@[agentPropertyDestructionPower, agentPropertyMotivation]];
}


#pragma mark - Custom getters & setters

- (NSNumber *) appraisal {
    [self willAccessValueForKey:agentPropertyAppraisal];
//    NSUInteger destrPowerValue = [self.destructionPower unsignedIntegerValue];
    NSUInteger destrPowerValue = [[self valueForKey:agentPropertyDestructionPower] unsignedIntegerValue];
//    NSUInteger motivationValue = [self.motivation unsignedIntegerValue];
    NSUInteger motivationValue = [[self valueForKey:agentPropertyMotivation] unsignedIntegerValue];
    NSUInteger appraisalValue = (destrPowerValue + motivationValue) / 2;
    [self didAccessValueForKey:agentPropertyAppraisal];

    return @(appraisalValue);
}


#pragma mark - Picture logic

- (NSString *) generatePictureUUID {
    return @"";
}

@end
