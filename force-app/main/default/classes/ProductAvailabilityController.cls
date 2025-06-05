public class ProductAvailabilityController {
    
    
    public List<ProductAvailabilityResponse> lstProductAvailabilityResponse {get;set;}
    public static WS.StockAvailabiltyResponse stockAvailResponse {get;set;}
    public List<WS.StockAvailSuccess> getLstSuccesses(){
        List<WS.StockAvailSuccess> lstReturn = null;
        if(stockAvailResponse != null && stockAvailResponse.lstSuccesses != null){
            lstReturn = new List<WS.StockAvailSuccess>();
            Integer intNonNullItems = 0;
            for(WS.StockAvailSuccess sas : stockAvailResponse.lstSuccesses){
                if(sas.strMaterial != null){
                    intNonNullItems++;
                    lstReturn.add(sas);
                } else if(intNonNullItems <= 1){
                    lstReturn.add(sas);
                }
            }
        }
        return lstReturn;
    }
    private ProductAvailabilityRequest productAvailabilityRequest {get;set;}
    public Boolean isSearchResultView {get;set;}
    public transient String displayMsg {get;set;}
    
    public static String territoryId {get;set;}
    public static String territoryType {get;set;}
    //public static String Sales_Org {get;set;}
    public static String plantId {get;set;}
    public static String marketClassId {get;set;}
    public static String productTypeId {get;set;}
    public static String itemDescriptionId {get;set;}
    public string userId {get;set;}
    
    
    public static List<SelectOption> territoryTypeOption {get;set;}
    public static List<SelectOption> territoriesOption {get;set;}
    public static List<SelectOption> plantesOption {get;set;}
    public static List<SelectOption> marketClassesOption {get;set;}
    public static List<SelectOption> productTypesOption {get;set;}
    public static List<SelectOption> itemDescriptionOption {get;set;}
    public static List<string> territories  {get;set;}
    public static List<string> plants {get;set;}
    
    public static List<string> markets {get;set;}
    public static List<string> productTypes {get;set;}
    public static List<string> items {get;set;}
    public static User userInfo {get; set;}
    public static Map<string,string> mapPlant {get; set;}
    
    public ProductAvailabilityController(){
        try{
            
            territoryId = null;
            plantId = null;
            marketClassId = null;
            productTypeId = null;
            itemDescriptionId = null;
            territoryType = null;
            
        }
        catch(Exception ex){
            System.debug('Exception:::' + ex.getMessage());
        }
    }
    
    //called below method on page load
    public  Pagereference onPageLoad(){
        if(ApexPages.currentPage().getParameters().containsKey('territoryType')){
            territoryType = ApexPages.currentPage().getParameters().get('territoryType');
            isSearchResultView = true;
        }else if(territoriesOption != null && territoriesOption.size() == 2 && (ApexPages.currentPage().getParameters().get('territoryId') == '' || ApexPages.currentPage().getParameters().get('territoryId') == null)){
            territoryId = territoriesOption[1].getValue();
            territoryType = [Select Type__c from Territory__c where id =: territoryId].Type__c;
            isSearchResultView = true;
            Pagereference pr = new Pagereference('/apex/ProductAvailability?territoryId=' + territoryId);
            pr.setRedirect(true);
            return pr;
        }else if(ApexPages.currentPage().getParameters().get('territoryId') != '' && ApexPages.currentPage().getParameters().get('territoryId') != null){
            territoryId = ApexPages.currentPage().getParameters().get('territoryId');
            territoryType = [Select Type__c from Territory__c where id =: territoryId].Type__c;
            isSearchResultView = true;
        }
        
        return null;
    }
    
    //Get Territories Option List which are permitted to current Logged in User
    public static Map<String, List<Territory__c>> territoryTypeMap {get; set;}
    @AuraEnabled
    public static List<String> getTerritories(){
        try{
            userInfo = new User();
            userInfo = UtilityClass_PA.userDetail;
            
            territoryTypeMap = new Map<String, List<Territory__c>>();
            territoryTypeOption = new List<SelectOption>();
            territories =new List<String>();
            //territories.add('--Select--');
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--Select--'));
            system.debug('userInfo.Role__c'+userInfo);
            if(userInfo.Role__c != null){
                String userID = userInfo.Id;
                String sapTMNumber = userInfo.SAP_TM_Number__c;
                system.debug('sapTMNumber @@@'+sapTMNumber );
                system.debug('userID +++'+userID );
                
                List<Territory__c> territoryList  = [select id,name,Type__c,Sales_Org__c,Region__c,SAP_TM_number__c,SAP_TM_number2__c,SAP_TM_number3__c,SAP_TM_number4__c,SAP_TM_number5__c 
                                                     From Territory__c where (SAP_TM_number__c !='' or SAP_TM_number2__c !='' or SAP_TM_number3__c !='' or SAP_TM_number4__c !='' or SAP_TM_number5__c !='') and 
                                                     (SAP_TM_number__c =:sapTMNumber OR SAP_TM_number2__c =:sapTMNumber OR SAP_TM_number3__c =:sapTMNumber OR
                                                      SAP_TM_number4__c =:sapTMNumber OR SAP_TM_number5__c =:sapTMNumber) and Sales_Org__c in ('1501','1102','1021','1111') ORDER BY Type__c DESC ];
                
                system.debug('territoryList +++'+ territoryList.size()+territoryList );
                /*for(Territory__c hMatrix : territoryList ){
system.debug('hMatrix@@@'+hMatrix );
system.debug('hMatrix.Type__c@@@'+hMatrix.Type__c);
if(!territoryTypeMap.containsKey(hMatrix.Type__c)){
territoryTypeMap.put(hMatrix.Type__c, new List<Territory__c>());
system.debug('territoryTypeMap@@@'+territoryTypeMap);
territoryTypeOption.add(new SelectOption(hMatrix.Type__c, hMatrix.Type__c));
system.debug('territoryTypeOption@@@'+territoryTypeOption);
}
territoryTypeMap.get(hMatrix.Type__c).add(hMatrix );
system.debug('territoryTypeMap@@@'+territoryTypeMap);

territories.add(hMatrix.Name);
system.debug('territories@@@'+territories);
}*/
                for(Territory__c hMatrix : territoryList ){
                    //system.debug('hMatrix@@@'+hMatrix );
                    system.debug('hMatrix.Sales_Org__c@@@'+hMatrix.Sales_Org__c);
                    if(!territoryTypeMap.containsKey(hMatrix.Sales_Org__c)){
                        territoryTypeMap.put(hMatrix.Sales_Org__c, new List<Territory__c>());
                        system.debug('territoryTypeMap@@@'+territoryTypeMap);
                        territoryTypeOption.add(new SelectOption(hMatrix.Sales_Org__c, hMatrix.Sales_Org__c));
                        system.debug('territoryTypeOption@@@'+territoryTypeOption);
                    }
                    territoryTypeMap.get(hMatrix.Sales_Org__c).add(hMatrix );
                    system.debug('territoryTypeMap@@@'+territoryTypeMap);
                    
                    territories.add(hMatrix.Name);
                    system.debug('territories@@@'+territories);
                }
            }
            territories.sort();
            return territories;
        }catch(AuraHandledException ex){
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage())); 
            system.debug('Exception :'+ex.getStackTraceString());
            System.debug('============================= ERROR '+ex.getMessage());
            System.debug('============================= Full Stack Track '+ex.getStackTraceString());
            system.debug('Cause:'+ex.getCause());
            system.debug('getTypeName:'+ex.getTypeName());
            // system.debug('setMessage:'+ex.setMessage());
            if(ex.getMessage() =='Script-thrown exception')
            {
                ex.setMessage('Please check territory') ; 
            }
            throw new AuraHandledException('Exception in Fetching territory'+ex.getMessage()); 
            //return null;
        }
    }
    
    //Get Plant Option List
    @AuraEnabled
    public static List<string> getPlantes(String tid , String userId){
        try{
            if(tid == null || tid == ''){
                
                throw new AuraHandledException('territory is empty'+tid);
            }
            system.debug('tid=====>'+tid);
            system.debug('userId=====>'+userId);
            List<Territory__c> territoryList = new List<Territory__c>();
            plants = new List<String>();
            
            system.debug('sorted order'+plants);
            system.debug('tid'+tid);
            if(tid != null && tid != ''){
                User userInfo = [select firstname,Role__c from user where id=:userId];
                system.debug('userInfo====>'+userInfo);
                system.debug('userInfo.Role__c====>'+userInfo.Role__c);
                if(userInfo.Role__c != null && userInfo.Role__c  != '' && userInfo.Role__c == Constants_PA.ROLE_TM){
                    territoryList = [Select Id, Name, Type__c,Sales_Org__c From Territory__c WHERE Name = :tid and Sales_Org__c in ('1501','1102','1021','1111')];
                    system.debug('territoryList if ++++'+territoryList );
                }else{
                    //territoryList = [Select Id, Name, Type__c From Territory__c WHERE Name = :tid];
                    territoryList =[Select Id, Name, Type__c,Sales_Org__c From Territory__c WHERE Name = :tid and Sales_Org__c in ('1501','1102','1021','1111')];
                }
            }else if(territoryType != null && territoryType != '' && territoryTypeMap.containsKey(territoryType)){
                territoryList = territoryTypeMap.get(territoryType);
            }
            system.debug('territoryList'+territoryList);
            //Sales_Org =territoryList[0].Sales_Org__c ;
            // system.debug('Sales_Org from Territory'+Sales_Org );
            if(territoryList.size() > 0 ||Test.isRunningTest()){
                Set<String> warehouseIds = new Set<String>();
                
                if(tid != null && tid != ''){
                    // for(Territory_Warehouse__c tw : [Select t.Warehouse__c, t.Territory__c, t.Name From Territory_Warehouse__c t where t.Territory__c IN :territoryList]){
                    for(Territory_Warehouse__c tw : [Select Plant__c,Territory__c,Name From Territory_Warehouse__c  where Territory__c IN :territoryList]){
                        warehouseIds.add(tw.Plant__c);
                        system.debug('warehouseIds+++++'+warehouseIds);
                    }
                    //for(Warehouse__c w : [Select w.Warehouse_Description__c, w.Id From Warehouse__c w where w.Id in: warehouseIds order By Name Limit 1000]){
                    // options.add(new SelectOption(w.Id, w.Warehouse_Description__c));
                    for(Plants__c w: [Select name,Warehouse_Description__c,SAP_Plant__c,Id From Plants__c  where id in: warehouseIds order By Name Limit 1000]){
                        plants.add(w.name);
                        
                        //mapPlant.put(w.name,w.SAP_Plant__c);
                        system.debug('plants+++++'+plants);
                    }
                }
                else{
                    // for(Warehouse__c w : [Select w.Warehouse_Description__c, w.Id From Warehouse__c w Where Warehouse_Status__c = 'Active' order By Name Limit 1000]){
                    //  options.add(new SelectOption(w.Id, w.Warehouse_Description__c));
                    for(Plants__c w : [Select w.Warehouse_Description__c,w.SAP_Plant__c, w.Id From Plants__c w Where Warehouse_Status__c = 'Active' order By Name Limit 1000]){
                        //options.add(new SelectOption(w.Id, w.Warehouse_Description__c));
                        plants.add(w.Warehouse_Description__c);
                        // mapPlant.put(w.name,w.SAP_Plant__c);
                        
                    }
                }
            }
            plants.sort();
            return plants;
        }catch(Exception ex){ 
            system.debug('Exception plants:'+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
            throw new AuraHandledException('Exception getIn Plants');
        }
    }
    
    @AuraEnabled
    public static List<String> getMarkets(string pname,String userId){
        try{
            system.debug('pname====>'+pname);
            
            List<string> strPlants  = new List<string>();
            markets = new List<String>();
            
            User userInfo = [select firstname,Role__c from user where id=:userId];
            system.debug('userId====>'+userId);
            
            List<Plants__c> sapPlantList =[Select name,SAP_Plant__c,Id From Plants__c where name =:pname limit 50];
            system.debug('sapPlantList@@@'+sapPlantList);
            system.debug('strPlants in get Markets'+strPlants);
            String sapPlant ='%' + sapPlantList[0].SAP_Plant__c+ '%';
            //Plants__c =:sapPlantList[0].SAP_Plant__c 
            List<Product2> queryList =[Select Id,Name,Plants__c,Plant_Names__c,MKT_CLASS__c  From Product2 where IsActive = true and Plants__c LIKE :sapPlant and MKT_CLASS__c!='' order By Name];
            system.debug('queryList in market@@'+queryList);
            system.debug('queryList in market@@ Size'+queryList.size());
            Set<Product2> marketSet = new Set<Product2>();
            marketSet.addAll(queryList);
            system.debug('marketSet.size()'+marketSet.size());//15
            system.debug('marketSet+++'+marketSet);
            Set<string> marketNames = new set<string>();
            for(Product2 products : marketSet)
            {
                marketNames.add(products.MKT_CLASS__c);
                
            }
            markets.addall(marketNames);
            markets.sort();
            return markets;
            
        }
        catch(Exception ex){ 
            system.debug('Exception Markets:'+ex.getStackTraceString());
            throw new AuraHandledException('Exception getIn markets');
        }
    }
    
    //Once Market Class is selected, it should filter the products and then show the Product Type dropdown based on PROD_TYPE__c field on Product2 object. 
    //Get ProductType  Option List
    @AuraEnabled
    public static List<String> getProductTypes(string pname,string mname,String userId){
        try{
            productTypes = new List<String>();
            //productTypes.add('--Select product Type--');
            User userInfo = [select firstname,Role__c from user where id=:userId];
            system.debug('mname====>'+mname);
            system.debug('pname====>'+pname);
            
            if(mname != null && mname != '' && pname != null && pname != '')
                //plant and Market should not be null and empty
            {
                List<Plants__c> sapPlantList =[Select name,SAP_Plant__c,Id From Plants__c where name =:pname limit 50];
                system.debug('sapPlantList@@@'+sapPlantList);
                system.debug('sapPlantList.size()'+sapPlantList.size());
                String sapPlant ='%' + sapPlantList[0].SAP_Plant__c+ '%';
                //Plants__c =:sapPlantList[0].SAP_Plant__c 
                List<Product2>productProdList =[Select  Id,name,MKT_CLASS__c,Plants__c,Plant_Names__c,Item_Sub_Family__c,PROD_TYPE__c from Product2 
                                                where MKT_CLASS__c =:mname and  Plants__c LIKE :sapPlant and  IsActive = true and MKT_CLASS__c !='' and PROD_TYPE__c !=''
                                                and Item_Sub_Family__c NOT IN ('RDW','RAV','RH2','RH3','RH4','RH5','RHD') order By Name];
                
                system.debug('productProdList@@@'+productProdList);
                system.debug('productProdList.size()'+productProdList.size());
                Set<string> productsTypeSet = new Set<string>();
                
                for(Product2 products : productProdList)
                {
                    productsTypeSet.add(products.PROD_TYPE__c);
                }
                productTypes.addAll(productsTypeSet);
                system.debug('productTypes.size()'+productTypes.size());
            }
            productTypes.sort();
            return productTypes;
            
        }
        catch(Exception ex){ 
            system.debug('Exception productTypes:'+ex.getStackTraceString());
            throw new AuraHandledException('Exception getIn productTypes');
        }
    }
    //Once Product Type is selected it should show all products by Name field on Product2 object in the Item dropdown. 
    //Get items Option List
    @AuraEnabled
    public static List<String> getItems(string pname,string mname,String ptname,String userId,String tName){
        try{
            items = new List<String>();
            // items.add('--Select items--');
            system.debug('mname====>'+mname);
            system.debug('pname====>'+pname);
            system.debug('ptname====>'+ptname);
            system.debug('tname===>'+tName);
            User userInfo = [select firstname,Role__c,Sales_Org__c  from user where id=:userId];
         
            if(mname != null && mname != '' && pname != null && pname != '' && ptname != null && ptname !='' && tName !=null && tName!='')
            {
                // all there should not be null or empty
                List<Plants__c> sapPlantList =[Select name,SAP_Plant__c,Id From Plants__c where name =:pname limit 50];
                List<Territory__c> territoryList =[select id,name,Sales_Org__c from Territory__c where name= :tname and  Sales_Org__c in ('1501','1102','1021','1111') ];
                system.debug('territoryList.size()'+territoryList.size()+territoryList[0].Sales_Org__c);    
                system.debug('sapPlantList.size()'+sapPlantList.size());
                system.debug('sapPlantList@@@'+sapPlantList);
                String sapPlant ='%' + sapPlantList[0].SAP_Plant__c+ '%';
                List<String> sOrgLst = new List<String>();
                //string sorg = territoryList.Sales_Org__c;
                for(Territory__c tc :territoryList){
                    sOrgLst.add(tc.Sales_Org__c);
                }
                //string sorg =userInfo.Sales_Org__c;
                //List<String> sOrgLst = userInfo.Sales_Org__c.split(';');
                List<Product2>queryList =[Select  Id,name,MKT_CLASS__c,Plant_Names__c,Item_Sub_Family__c,PROD_TYPE__c,Sales_Org__c  from Product2 
                                          where MKT_CLASS__c =:mname and PROD_TYPE__c =:ptname and IsActive = true and Plants__c LIKE :sapPlant and MKT_CLASS__c !='' and PROD_TYPE__c !='' 
                                          and Sales_Org__c in:sOrgLst];
                system.debug('queryList in Get Iems@@'+queryList); 
                system.debug('queryList.size() in Get Iems@@'+queryList.size()); 
                
                Set<string> itemSet = new Set<string>();
                
                for(Product2 products : queryList)
                {
                    //itemSet.add(products.Name);
                    items.add(products.Name);
                }
                // items.addAll(itemSet) ;
                
            }
            items.sort();
            return items;
            
        }
        catch(Exception ex){ 
            system.debug('Exception items:'+ex.getStackTraceString());
            throw new AuraHandledException('Exception getIn items');
        }
    }
    //Set Search Result Panel
    // public void showSearchResultView(){
    //   isSearchResultView = true;
    // }
    
    //Search Callout on the basis of selected attributes
    @AuraEnabled
    public static ws.StockAvailabiltyResponse searchProducts(string pname, String iname,String userId){
        //public static void searchProducts(string pname, String iname,String userId){
        try{
            
            system.debug('inside searchProducts===.');
            //1-30-2017 Dru: Updated to use WS class for callout
            system.debug('pname====>'+pname);
            system.debug('Iname====>'+iname);
            if(pname == null || pname == ''){
                
                throw new AuraHandledException('plant name is empty'+pname);
                
                
            }
            if(iname == null || iname == ''){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select Item'));
                //return  WS.StockAvailabiltyResponse;
                throw new AuraHandledException('Item name is empty'+iname);
            }
            if(pname != null && pname != '' && iname != null && iname != '')
            {
                WS.StockAvailRequest request = new WS.StockAvailRequest();
                for(Plants__c w: [Select Id,SAP_Plant__c From Plants__c Where name = : pname  ] ){
                    request.strPlant =  w.SAP_Plant__c;
                    system.debug('request.strPlant====>'+request.strPlant);
                }
                
                for(Product2 p: [Select Id,ProductCode From Product2 Where name = : iname and IsActive = true ] ){
                    if(request.lstMaterials == null) request.lstMaterials = new List<String>();
                    request.lstMaterials.add(p.ProductCode);
                    system.debug('p.Family====>'+p.ProductCode);
                    
                }
                stockAvailResponse = WS.stockAvailabilityCall(request);
                String strErrors = '';
                
                for(integer i = 0; i < stockAvailResponse.lstErrors.size(); i++){
                    if(i != 0) strErrors += '/n';
                    WS.StockAvailabilityError e = stockAvailResponse.lstErrors.get(i);
                    strErrors += e.strMessage;
                }
                if(!String.isEmpty(strErrors)) throw new WS.WSException(strErrors);
                
            }
            
        }
        /*catch(Exception ex){ 
System.debug('============================= ERROR '+ex.getMessage());
System.debug('============================= Full Stack Track '+ex.getStackTraceString());
system.debug('Exception searchProducts:'+ex.getStackTraceString());
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage())); 
//throw new AuraHandledException('Exception searchProducts'+ex.getMessage()); 
}*/
        catch(AuraHandledException ex){ 
            System.debug('============================= ERROR '+ex.getMessage());
            System.debug('============================= Full Stack Track '+ex.getStackTraceString());
            system.debug('Cause:'+ex.getCause());
            system.debug('getTypeName:'+ex.getTypeName());
            // system.debug('setMessage:'+ex.setMessage());
            if(ex.getTypeName() =='System.AuraHandledException' && ex.getMessage() =='Script-thrown exception')
            {
                ex.setMessage('Please validate Plantname and ProductName') ; 
            }
            if(ex.getTypeName() =='System.CalloutException' && ex.getMessage() =='Read timed out')
            {
                ex.setMessage('Read Time Out, Please Relaod Page') ; 
            }
            
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage())); 
            throw new AuraHandledException('Error While Fetching Search Results :  '+ex.getMessage()); 
        }
        system.debug('stockAvailResponse=====>'+stockAvailResponse);
        
        return stockAvailResponse;
    }
}