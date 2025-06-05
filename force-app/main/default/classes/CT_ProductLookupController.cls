public class CT_ProductLookupController {
    
    @AuraEnabled 
    public static List<Product2> typeAhead(String searchString){
        List<Product2> productList = new List<Product2>();
        String query = 'select Id,Name,ProductCode from Product2 where name '+ ' like \''+searchString ;
        query+= '%\''+' LIMIT 10';
        productList = Database.query(query);
        return productList;
        
    }
    
    @AuraEnabled 
    public static Case fetchCase(String caseId){
        List<Case> caseList = new List<Case>();
        caseList =[select id,caseNumber,AccountId,Account.Name,Order__c,Order__r.OrderNumber, Sales_Org__c, Country__c,
                   Warehouse__c, Plants__c, Plants__r.Name, Manufacturing_Plant__c, Manufacturing_Plant__r.Name from Case where id=:caseId limit 1];
        return caseList.get(0);
    }
    
    @AuraEnabled
    public static String insertCaseItemRecord(Case_Order_Items__c caseItem, String productId){
        system.debug('G*G caseItem '+ caseItem);
        system.debug('G*G productId '+productId);
        String returnString = null;
        Case_Order_Items__c ci = new Case_Order_Items__c();
        ci.CR__c = caseItem.CR__c;
        ci.IS__c = caseItem.IS__c;
        ci.Order__c = caseItem.Order__c;
        ci.Case__c = caseItem.Case__c;
        ci.Line_Num__c = caseItem.Line_Num__c;
        ci.Ph_Lvl1__c = caseItem.Ph_Lvl1__c;
        ci.Ph_Lvl1_Desc__c = caseItem.Ph_Lvl1_Desc__c;
        ci.Ph_Lvl4__c = caseItem.Ph_Lvl4__c;
        ci.Ph_Lvl4_Desc__c = caseItem.Ph_Lvl4_Desc__c;
        ci.Ph_Lvl5__c = caseItem.Ph_Lvl5__c;
        ci.Ph_Lvl5_Desc__c = caseItem.Ph_Lvl5_Desc__c;
        ci.RB__c = caseItem.RB__c;
        ci.Req_deliv_date__c = caseItem.Req_deliv_date__c;
        ci.Planned_deliv_date__c = caseItem.planned_deliv_date__c;
        ci.Product__c = productId;
        ci.Total_Volume__c = caseItem.Total_Volume__c;
        insert ci;
        returnString = ci.Id;
        system.debug('G*G returnString '+returnString);
        return returnString;
    }
    
    @AuraEnabled
    public static Product2 getProductName(String productId){
        List<Product2> productList = new List<Product2>();
        String name = null;
        productList = [select Id,Name,ProductCode,PUR_UOM__c,SELL_UOM__c,Stocking_UOM__c,Square_Feet_UOM__c
                       from Product2 where id=: productId limit 1];
        return productList.get(0);
    }
    
    @AuraEnabled
    public static List<Product2> applyFilter(String resultString){
        List<filterWrapper> wrapperClassDeserialized;
        String tpId ;
        try{
            system.debug('resultString '+ resultString);
            if(!(String.isBlank(resultString) )){
                wrapperClassDeserialized = (List<filterWrapper>) JSON.deserialize(resultString, List<filterWrapper>.class); 
            }
            System.debug('--wrapperClassDeserialized--> '+wrapperClassDeserialized);
            String whereCondition = '';
            for(filterWrapper filter : wrapperClassDeserialized){
                if(String.isNotEmpty(filter.filterValue)){
                    if(filter.fieldType == 'Double' || filter.fieldType == 'Currency' || filter.fieldType == 'Integer' || filter.fieldType == 'Boolean'){
                        whereCondition += filter.fieldName+ '='+filter.filterValue+ ' AND ';
                    }
                    else if(filter.fieldType == 'multipicklist'){
                        whereCondition += filter.fieldName+ ' includes (\''+filter.filterValue+ '\') AND ';
                    }
                    else {
                        if(filter.operatorValue=='Equals')
                            whereCondition += filter.fieldName+ '=\''+filter.filterValue+'\' AND ';
                        else if(filter.operatorValue=='Ends With')
                            whereCondition += filter.fieldName+ ' like \'%'+filter.filterValue+'\' AND ';
                        else if(filter.operatorValue=='Starts With')
                            whereCondition += filter.fieldName+ ' like \''+filter.filterValue+'%\' AND ';
                        else if(filter.operatorValue=='Contains')
                            whereCondition += filter.fieldName+ ' like \'%'+filter.filterValue+'%\' AND ';
                    }
                }
            }
            whereCondition = whereCondition.removeEnd(' AND ');

            return fetchProductList(whereCondition);
        }catch(Exception e){
            System.debug('---Exception is --> '+e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Product2> fetchProductList(String whereCondition){
        List<Product2> productList = new List<Product2>();
        String query = 'SELECT Id, Name, ProductCode, Class__c, CORP_CLASS__c, '+
                       ' isActive, Plants__c, Plant_Names__c, Status_code__c, Description, ' +
                       ' PUR_UOM__c, SELL_UOM__c' +
                       ' FROM Product2 ';
        if(String.isNotBlank(whereCondition))
            query += ' where '+whereCondition;
        
        //query += ' LIMIT 10';
        system.debug('where query' + query);
        productList = Database.query(query);
        system.debug('productList'+ productList);
        return productList;
    }
    
    @AuraEnabled
    public static List<String> fetchOperators(){
        List<String> operatorsList = new List<String>();
        operatorsList.add('Equals');
        operatorsList.add('Contains');
        operatorsList.add('Starts With');
        operatorsList.add('Ends With');
        operatorsList.sort();
        return operatorsList;
    }
    
    @AuraEnabled 
    public static List<productWrapper> fetchProductWrapper(String caseId){
        List<productWrapper> resultWrapperList = new List<productWrapper>();

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objectSchema = schemaMap.get('Product2');
        Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();

        Map<String,String> fieldAndApiMap = new Map<String,String>();
        List<String> productFieldsList = new List<String>();
        List<fieldWrapper> fwList = new List<fieldWrapper>();
        List<operatorWrapper> owList = new List<operatorWrapper>();
        Set<String> productSearchFieldSet = new Set<String>();

        Case cs = new Case();
        
        cs = fetchCase(caseId);
        for(Product_Search_Fields__c psf: Product_Search_Fields__c.getAll().values()){
            productSearchFieldSet.add(psf.FieldApiName__c);
        }
        
              
        for (String fieldName: fieldMap.keySet()) 
        {  
            if(productSearchFieldSet.contains(fieldName)){
                fieldWrapper fw = new fieldWrapper();
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();

                fw.fieldLabel =  fieldDescribe.getLabel();
                fw.fieldType = String.ValueOf(fieldDescribe.getType());

                system.debug('fieldTYpes'+fw.fieldType);
                system.debug('fieldName'+fieldName);

                fw.fieldValue = fieldName;

                fw.multiSelectValues = null;
                if (fw.fieldType=='multipicklist'){
                    fw.multiSelectValues = new List<String>();
   
                    List<Schema.PicklistEntry> ple = fieldDescribe.getPicklistValues();
                    for( Schema.PicklistEntry currEntry : ple)
                    {
                        fw.multiSelectValues.add( currEntry.getValue() );
                    }       
                }
                fwList.add(fw);

                fieldAndApiMap.put(fieldName, String.ValueOf(fieldDescribe.getType()));
            }
        }
        
        for(String s: fetchOperators()){
            operatorWrapper ow = new operatorWrapper();
            ow.operator = s;
            owList.add(ow);
        }

        productWrapper pw = new productWrapper();
        pw.fieldWrapperList = fwList;
        pw.operatorWrapperList =owList;
        pw.fieldTypeMap = fieldAndApiMap;
        pw.cse = cs;
        resultWrapperList.add(pw);

        system.debug('resultWrapperList'+resultWrapperList);
        return resultWrapperList;
    }
    
    public class productWrapper{
        @AuraEnabled public List<fieldWrapper> fieldWrapperList;
        @AuraEnabled public List<operatorWrapper> operatorWrapperList;
        @AuraEnabled public Map<String,String> fieldTypeMap;
        @AuraEnabled public Case cse;
    }
    
    
    public class fieldWrapper{
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String fieldType;
        @AuraEnabled public String[] multiSelectValues; // this assumes that there is not translation for these picklists
    }
    
    public class operatorWrapper{
        @AuraEnabled public String operator;
    }
    
    public class filterWrapper{
        @AuraEnabled public String fieldName;
        @AuraEnabled public String filterValue;
        @AuraEnabled public String operatorValue;
        @AuraEnabled public String fieldType;
    }
    
    
}