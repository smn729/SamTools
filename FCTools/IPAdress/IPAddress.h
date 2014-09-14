//
//  IPAddress.h
//  FCTools
//
//  Created by Sam on 14-9-7.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#ifndef FCTools_IPAddress_h
#define FCTools_IPAddress_h

#define MAXADDRS	32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

// Function prototypes

void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();

#endif
