For KissXML：
1、引用库：libxml2.dylib
2、添加头文件索引：/usr/include/libxml2
3、OTHER_LDFLAGS添加：-force_load $(BUILT_PRODUCTS_DIR)/libFCTools.a

////////////////////////////////////////////////////////////////////////
KissXML解析XML:

-(void)parseXML:(NSData *)data
{
    //文档开始（KissXML和GDataXML一样也是基于DOM的解析方式）
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    
    //利用XPath来定位节点（XPath是XML语言中的定位语法，类似于数据库中的SQL功能）
    NSArray *users = [xmlDoc nodesForXPath:@"//cd" error:nil];
    for (DDXMLElement *user in users)
    {
        NSString *userId = [[user attributeForName:@"country"] stringValue];
        NSLog(@"cd country:%@",userId);
        
        DDXMLElement *nameEle = [user elementForName:@"title"];
        if (nameEle)
        {
            NSLog(@"cd title:%@",[nameEle stringValue]);
        }
        
        DDXMLElement *ageEle = [user elementForName:@"artist"];
        if (ageEle)
        {
            NSLog(@"cd artist:%@",[ageEle stringValue]);
        }
    }
}

////////////////////////////////////////////////////////////////////////
KissXML封装XML:

    NSString *newXML = nil;
    
    DDXMLElement *rootElement = [DDXMLElement elementWithName:@"root"];
    DDXMLElement *firstElemnt = [DDXMLElement elementWithName:@"first" stringValue:@"firstValue"];
    [firstElemnt addAttributeWithName:@"attribute" stringValue:@"attributeValue"];
    [rootElement addChild:firstElemnt];
    
    newXML = [rootElement XMLString];
    
    NSLog(@"newXML:%@", newXML);