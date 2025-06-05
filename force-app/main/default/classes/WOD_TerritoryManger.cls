/**
 * @description This class is used for assign appropriate Territory Manager
*/
public class WOD_TerritoryManger {

    public String setTerritoryType(String salesOrg, String division){
        string ret = 'AND Territory__r.Territory_Code__c LIKE {0}% ';
        String returnType='';
        if(salesOrg=='1021' || salesorg=='1111'){
            if(division.equalsIgnoreCase('CBI Deneef')   ){
                returnType=String.format(ret, new List<String>{'TDN'});
                
            }
            if(division.equalsIgnoreCase('SBM Fireproofing')){
                returnType=String.format(ret, new List<String>{'TFP'});
            }
            if(division.equalsIgnoreCase('SBM Infrastructure')){
                returnType=String.format(ret, new List<String>{'TBD'});
            }
            
            
        }
        else if (salesOrg=='1501' || salesorg=='1102'){
            if(division.equalsIgnoreCase('Commercial')   ){
                returnType=String.format(ret, new List<String>{'TC'});

            }
            if(division.equalsIgnoreCase('Residential') || division.equalsIgnoreCase('Symphony')  || division.equalsIgnoreCase('Metal Roofing')){
                returnType=String.format(ret, new List<String>{'TR'});
                system.debug(returnType);
                returnType+= ' AND  (NOT Territory__r.Territory_Code__c LIKE \'TRS%\' ) ';
                system.debug(returnType);
            }
            if(division.equalsIgnoreCase('Solar')){
                returnType=String.format(ret, new List<String>{'TRS'});
            }
            if(division.equalsIgnoreCase('SBM Commercial WP')   ){
                returnType=String.format(ret, new List<String>{'TBE'});

            }
            if(division.equalsIgnoreCase('SBM Residential WP')){
                returnType=String.format(ret, new List<String>{'TGR'});
            }
            
        }
        returntype=returntype.replace('LIKE ', 'LIKE \'');
        returntype=returntype.replace('% ', '%\'');
        returntype=returntype.replace('\'\'', ' \'');
        system.debug(returntype);
        return returnType;

    }
    /**
     * @description to get Territory Manager
     * @param statecode State Code
     * @param search Search
     * @param propertyType Property Type of the Claim
     * @param countryName Country Name
     * @return list of Territory Manager Id and Name
    */
     public List<String> populateTM(String statecode,String search,String propertyType,String countryName, String city,String salesOrg, String division){
         String soql = '';
        //String TCode='';
        List<Territory__c> territoryList ;
        List<String> TCValues = new List<String>();
        
        
        try{
            String terrCondition = setTerritoryType(salesOrg, division);
            String terQuery = terrCondition;
            /*
            if (terrCondition!=null && terrCondition.contains('_')  ){
                if(terrCondition.split('_')[0] == 'type') {
                    terQuery+=' AND IGSBU__c= \'' + terrCondition.split('_')[1] + '\'';
                }
                else{
                    terQuery+=' AND Territory__r.Territory_Code__c LIKE \'' + terrCondition.split('_')[0] + '%\'';
                }

            }
            */
            if(countryName == 'Canada'){
                
                statecode = statecode.substringBefore('(');
                statecode = statecode.trim();
                //TCode = statecode;
                List<FIPS__c> fips = [select Id,Name,FIPS_Code__c from FIPS__c where State__c=:statecode limit 10000 ];
                //TCValues.add(fips[0].Teritory_Code__c);
                if(fips <> null && fips.size() > 0 ){
                    List<Id> fipsIds = new List<Id>();
                    for(FIPS__c  fip : fips){
                        fipsIds.add(fip.Id);
                    }
                    //soql = 'select Name, Territory__c, FIPS__c, Territory__r.Territory_SalesOrg__c, Territory__r.Sales_Rep__c, Territory__r.Sales_Rep__r.Name from Territory_Assignment__c';          
                    //soql +=' WHERE FIPS__c= \''+ fips[0].Id + '\' AND Territory__r.Territory_SalesOrg__c =\'' + fips[0].Teritory_Code__c + '\' LIMIT 50';

                    String taQuery='select Id,Name, Territory__c, FIPS__c, Territory__r.Territory_SalesOrg__c, Territory__r.Sales_Rep__c, Territory__r.Sales_Rep__r.Name from Territory_Assignment__c';
                    taQuery+=' WHERE FIPS__c IN : fipsIds AND Territory__r.Active__c = true AND ( Territory__r.Sales_Org__c = \''+ salesOrg + '\' ) ';
                    
                    taQuery+=terQuery;
                    taQuery+=' limit 10000';
                    System.debug(taQuery);
                    List<Territory_Assignment__c> terrLists = Database.query(taQuery);
                    for(Territory_Assignment__c tA : terrLists){
                        TCValues.add(tA.Territory__c);    
                    }
                }
                
                soql = 'select Id,Name,SAP_TM_Name__c,Territory_SalesOrg__c, Sales_Rep__c,Sales_Rep__r.Name,Sales_Rep2__c,Sales_Rep2__r.Name,Sales_Rep3__c,Sales_Rep3__r.Name,Sales_Rep4__c,Sales_Rep4__r.Name,Sales_Rep5__c,Sales_Rep5__r.Name  from Territory__c WHERE ID in : TCValues OR NAME =\'No Territory\'ORDER BY Territory_Code__c DESC NULLS LAST  LIMIT 50';          
                
                
            }else{      
                statecode = statecode.substringAfter('(');
                statecode = statecode.substringBefore(')');
                statecode = statecode.trim();
                //search = search.substringBefore('-');
                //search = '\'' + String.escapeSingleQuotes(search) + '%\'';
                System.debug('@statecode '+statecode);
                String citySearch = '%'+ city + '%';
                List<Zip_to_Fips__c> zipToFips=new  List<Zip_to_Fips__c>();
                zipToFips= [select Id,Name,State_Code__c, FIPS_Code__c, FIPS_Code_Name__c from Zip_to_Fips__c where State_Code__c =:statecode and City__c like :city /*TECP-731*/ limit 10000];
                if(zipToFips==null || zipToFips.size()==0){
                zipToFips= [select Id,Name,State_Code__c, FIPS_Code__c, FIPS_Code_Name__c from Zip_to_Fips__c where State_Code__c =:statecode and City__c like :citySearch /*TECP-731*/ limit 10000];
                }
                    //List<FIPS_Codes__c> fips = [select Teritory_Code__c from FIPS__c where State__c=:statecode AND ];
                List<Id> fipsIds = new List<Id>();
                for(Zip_to_Fips__c zipF : zipToFips){
                    fipsIds.add(zipF.FIPS_Code_Name__c );
                }
                String  taQuery = 'select Id,Name, Territory__c, FIPS__c, Territory__r.Territory_SalesOrg__c, Territory__r.Sales_Rep__c, Territory__r.Sales_Rep__r.Name from Territory_Assignment__c ';
                taQuery+='WHERE FIPS__c IN :fipsIds  AND Territory__r.Active__c = true AND ( Territory__r.Sales_Org__c  = \''+ salesOrg + '\' ) ';
                System.debug('@zipToFips '+zipToFips);
                taQuery+=terQuery;
                taQuery+='limit 10000';
                System.debug(taQuery);
                List<Territory_Assignment__c> terrLists = Database.query(taQuery);
                for(Territory_Assignment__c tA : terrLists){
                        TCValues.add(tA.Territory__c);    
                    }
                
                //soql = 'select Id,Name,Territory_SalesOrg__c, Territory__r.Sales_Rep__c,Territory__r.Sales_Rep__r.Name  from Territory__c WHERE ID in : TCValues OR NAME =\'No Territory\' LIMIT 50';  
                soql = 'select Id,Name,SAP_TM_Name__c,Territory_SalesOrg__c, Sales_Rep__c,Sales_Rep__r.Name,Sales_Rep2__c,Sales_Rep2__r.Name,Sales_Rep3__c,Sales_Rep3__r.Name,Sales_Rep4__c,Sales_Rep4__r.Name,Sales_Rep5__c,Sales_Rep5__r.Name,Type__c  from Territory__c WHERE ID in : TCValues OR NAME =\'No Territory\' ORDER BY Territory_Code__c DESC NULLS LAST  LIMIT 50';        
            } 
        }
        catch(Exception e)
        {
            System.debug(e);
            string soqlEx = 'select Id,Name,SAP_TM_Name__c,Territory_SalesOrg__c, Sales_Rep__c,Sales_Rep__r.Name,Sales_Rep2__c,Sales_Rep2__r.Name,Sales_Rep3__c,Sales_Rep3__r.Name,Sales_Rep4__c,Sales_Rep4__r.Name,Sales_Rep5__c,Sales_Rep5__r.Name,Type__c from Territory__c limit 0';
            territoryList= database.query(soqlEx);
        }
         
        System.debug('SOQL Val ********* ' + soql);
        try{
            territoryList= database.query(soql); 
        }
        catch(Exception e)
        {
           soql = 'select id, Name,Territory_SalesOrg__c, Sales_Rep__c,Sales_Rep__r.Name,Sales_Rep2__c,Sales_Rep2__r.Name,Sales_Rep3__c,Sales_Rep3__r.Name,Sales_Rep4__c,Sales_Rep4__r.Name,Sales_Rep5__c,Sales_Rep5__r.Name,Type__c from Territory__c';
            //if(searchString!='')
            //    soql = soql +  ' where name LIKE \'%' + searchString +'%\' OR Territory_SalesOrg__c LIKE \'%' + searchString +'%\'';
            soql = soql + ' limit 0';
            System.debug(e);
            territoryList =database.query(soql);
        }
        if(territoryList!= null && territoryList.size() > 0){
            List<String> ret = new List<String>();
            String TMName ='';
            Territory__c ter = territoryList[0];
            
            if(ter.Sales_Rep__c!= null){
                TMName+= ter.Sales_Rep__r.Name+',';
            }
            if(ter.Sales_Rep2__c!= null){
                TMName+= ter.Sales_Rep2__r.Name+ ',';
            }
            if(ter.Sales_Rep3__c!= null){
                TMName+= ter.Sales_Rep3__r.Name + ',';
            }
            if(ter.Sales_Rep4__c!= null){
                TMName+= ter.Sales_Rep4__r.Name + ',';
            }
            if(ter.Sales_Rep5__c!= null){
                TMName+= ter.Sales_Rep5__r.Name + ',';
            }
            ret.add(ter.Id);
            ret.add(TMName.removeEnd(','));
            return ret;
        }
        return null;                
       /*
        system.debug('Value of statecode ' + statecode);        
        system.debug('Value of zipcode ' + search);        
        system.debug('Value of Property Code ' + propertyType);        
        system.debug('Value of Country ' + countryName);  

        String BPCSvalue='';
        STring TCode='';
        string soql='';

        try{
            if(countryName == 'Canada'){
                statecode = statecode.substringBefore('(');
                statecode = statecode.trim();

                //TCode = statecode;

               // List<FIPS_Codes__c> fips = [select Commercial_Territory_SalesOrg__c,Residential_Territory_SalesOrg__c from FIPS_Codes__c where City__c =:statecode];
        List<FIPS_Codes__c> fips = [select Roofing_Id__c,Siding_Id__c from FIPS_Codes__c where State_Codes__c =:statecode];
                if(propertyType=='Residential'){
                   // TCode=fips[0].Residential_Territory_SalesOrg__c;
                }else if(propertyType=='Commercial'){
                   // TCode=fips[0].Commercial_Territory_SalesOrg__c;
                }

            soql = 'select id, Name from Territory__c ';  

            }else{      
                statecode = statecode.substringAfter('(');
                statecode = statecode.substringBefore(')');
                statecode = statecode.trim();
                search = search.substringBefore('-');       
                system.debug('search--'+search); 
                system.debug('statecode--'+statecode);

                List<WOD_County_Codes__c> countyCode = [select County_Code__c from WOD_County_Codes__c where Zip_code__c =:search and State__c =:statecode ];
                
                //List<FIPS_Codes__c> fips = [select Commercial_Territory_SalesOrg__c,Residential_Territory_SalesOrg__c from FIPS_Codes__c where County_Code__c =:countyCode[0].County_Code__c and State_Codes__c =:statecode];
                if(countyCode != null){
                    List<FIPS_Codes__c> fips = [select Roofing_Id__c,Siding_Id__c from FIPS_Codes__c where County_Code__c =:countyCode[0].County_Code__c and State_Codes__c =:statecode];
                    if(fips != null){
                        if(propertyType=='Residential'){
                            system.debug('fips-->'+fips);
                            // TCode=fips[0].Residential_Territory_SalesOrg__c;
                        }else if(propertyType=='Commercial'){
                            // TCode=fips[0].Commercial_Territory_SalesOrg__c;
                        }
                    }
                }
                soql = 'select id, Name from Territory__c';
            }
            if(TCode!='')
                soql = soql +  ' where Territory_SalesOrg__c LIKE \'%' + TCode +'%\'' ;          
            soql = soql + ' limit 10';
            System.debug(soql);
            return null;
        }
        catch(Exception e)
        {
            string soqlEx = 'select id, Name from Territory__c limit 0';
            return null;
        }
     */
     
     //return null;
        
        /*statecode = statecode.substringAfter('(');
        statecode = statecode.substringBefore(')');
        statecode = statecode.trim();
        List<County_Codes__c> countyCode = [select County_Code__c from County_Codes__c where Zip_code__c =:search and State__c =:statecode ];
        
        if(countyCode.size()>0){
            List<FIPS_Codes__c> fips = [select Commercial_Territory_SalesOrg__c,Residential_Territory_SalesOrg__c from FIPS_Codes__c where County_Code__c =:countyCode[0].County_Code__c and State_Codes__c =:statecode];
            if(propertyType=='Residential'){
                TCode=fips[0].Residential_Territory_SalesOrg__c;
            }else if(propertyType=='Commercial'){
                TCode=fips[0].Commercial_Territory_SalesOrg__c;
            }
        }
        
        String soql = 'select id, Name, (select TM__r.Name, name from Territory__c.Hierarchy_Matrix__r)  from Territory__c';
        
        if(TCode!='')
            soql = soql +  ' where Territory_SalesOrg__c LIKE \'%' + TCode +'%\'' ;
        
        if (countryName == 'Canada'){
            soql  =soql + 'and Type__c =:propertyType ';
        }
        
        //system.debug(soql); 

        try{
          //  system.debug('soql'+soql);
           // List<Territory__c> TerritoryList =database.query(soql);
            //system.debug('TerritoryList-->'+TerritoryList[0].Hierarchy_Matrix__r[0].TM__r.Name);
            String TMName='';
            for(Hierarchy_Matrix__c HC:TerritoryList[0].Hierarchy_Matrix__r){
                TMName=TMName+HC.TM__r.Name+',';                
            }          
            TMName=TMName.substring(0, TMName.length()-1);List<String> ret=new List<String>();ret.add(TerritoryList[0].Id);ret.add(TMName);return ret;
            
        } 
        
        catch(exception e){
            return null;
        } */
    }
    /**
     * @description to get Territory Manager for Siding BU
     * @param statecode State Code
     * @param search Search
     * @param countryName Country Name
     * @return list of Sobject
    */
    @AuraEnabled(cacheable=true)  
    public static List<sObject> populateTMSiding(String statecode,String search,String countryName, String city){
        String soql = '';
        //String TCode='';
        List<String> TCValues = new List<String>();
        try{
            if(countryName == 'Canada'){
                statecode = statecode.substringBefore('(');
                statecode = statecode.trim();
                //TCode = statecode;
                List<FIPS__c> fips = [select Id,Name,FIPS_Code__c from FIPS__c where State__c=:statecode limit 10000];
                //TCValues.add(fips[0].Teritory_Code__c);
                if(fips <> null && fips.size() > 0 && fips[0].FIPS_Code__c!= null){
                    //soql = 'select Name, Territory__c, FIPS__c, Territory__r.Territory_SalesOrg__c, Territory__r.Sales_Rep__c, Territory__r.Sales_Rep__r.Name from Territory_Assignment__c';          
                    //soql +=' WHERE FIPS__c= \''+ fips[0].Id + '\' AND Territory__r.Territory_SalesOrg__c =\'' + fips[0].Teritory_Code__c + '\' LIMIT 50';
                    List<Id> fipsIds = new List<Id>();
                    for(FIPS__c  fip : fips){
                        fipsIds.add(fip.Id);
                    }
                    for(Territory_Assignment__c tA : [select Id,Name, Territory__c, FIPS__c, Territory__r.Territory_SalesOrg__c, Territory__r.Sales_Rep__c, 
                    Territory__r.Sales_Rep__r.Name from Territory_Assignment__c WHERE FIPS__c IN : fipsIds AND Territory__r.Sales_Org__c IN ('1502' ,'1019', '1020' ) AND Territory__r.Active__c = true]){
                        TCValues.add(tA.Territory__c);    
                    }
                }
                
                soql = 'select Id,Name,Territory_SalesOrg__c, Sales_Rep__c,Sales_Rep__r.Name,Sales_Rep2__r.Name   from Territory__c WHERE ID in : TCValues OR NAME =\'No Territory\' LIMIT 50';          
            }else{      
                statecode = statecode.substringAfter('(');
                statecode = statecode.substringBefore(')');
                statecode = statecode.trim();
                //search = search.substringBefore('-');
                //search = '\'' + String.escapeSingleQuotes(search) + '%\'';
                String citySearch = '%'+ city + '%';
                System.debug('@statecode '+statecode);
                List<Zip_to_Fips__c > zipToFips= [select Id,Name,State_Code__c, FIPS_Code__c, FIPS_Code_Name__c from Zip_to_Fips__c where State_Code__c =:statecode and City__c like :citySearch /*TECP-731*/  limit 10000];
                //List<FIPS_Codes__c> fips = [select Teritory_Code__c from FIPS__c where State__c=:statecode AND ];
                System.debug('@zipToFips '+zipToFips);
                List<Id> fipsIds = new List<Id>();
                for(Zip_to_Fips__c zipF : zipToFips){
                    fipsIds.add(zipF.FIPS_Code_Name__c );
                }
                for(Territory_Assignment__c tA : [select Id,Name, Territory__c, FIPS__c, Territory__r.Territory_SalesOrg__c, Territory__r.Sales_Rep__c, 
                    Territory__r.Sales_Rep__r.Name from Territory_Assignment__c WHERE (FIPS__c IN  : fipsIds 
                    AND Territory__r.Sales_Org__c IN ('1502' ,'1019', '1020' ) AND Territory__r.Active__c = true  /*.Territory_SalesOrg__c like 'TS%' TECP-731*/) OR Territory__r.Name like '%No Territory%' ]){
                        TCValues.add(tA.Territory__c);    
                    }
                
                //soql = 'select Id,Name,Territory_SalesOrg__c, Territory__r.Sales_Rep__c,Territory__r.Sales_Rep__r.Name  from Territory__c WHERE ID in : TCValues OR NAME =\'No Territory\' LIMIT 50';  
                soql = 'select Id,Name,Territory_SalesOrg__c, Sales_Rep__c,Sales_Rep__r.Name,Sales_Rep2__r.Name   from Territory__c WHERE ID in : TCValues OR NAME =\'No Territory\' ORDER BY Territory_Code__c DESC NULLS LAST  LIMIT 50';     
            } 
        }
        catch(Exception e)
        {
            System.debug(e);
            string soqlEx = 'select Id,Name,Territory_SalesOrg__c from Territory__c limit 0';
            return database.query(soqlEx);
        }
         
        System.debug('SOQL Val ********* ' + soql);
        try{
            return database.query(soql); 
        }
        catch(Exception e)
        {
           soql = 'select id, Name from Territory__c';
            //if(searchString!='')
            //    soql = soql +  ' where name LIKE \'%' + searchString +'%\' OR Territory_SalesOrg__c LIKE \'%' + searchString +'%\'';
            soql = soql + ' limit 0';
            System.debug(e);
            return database.query(soql);
        }                
      
    }
    
    /*
    public static string returnTM(id TerritoryID){       
        return null;
    }
    */

    /**
     * @description to get Territory Name
     * @param territoryID Territory Id
     * @return Territory Name
    */
    @AuraEnabled(cacheable=true)
    public static string returnTM(String territoryID){   
        string territoryVal;
        Territory__c tmVal2=[select Territory_SalesOrg__c, Sales_Rep__r.Name,Sales_Rep2__r.Name from Territory__c where id=:territoryID];
        if(tmVal2.Territory_SalesOrg__c=='No Territory'){
            territoryVal='No TM Rep';
        }else{
            territoryVal = tmVal2.Sales_Rep__r.Name;
            if(tmVal2.Sales_Rep2__r.Name!=null){
             territoryVal=territoryVal+', '+tmVal2.Sales_Rep2__r.Name;   
            }
        }
        return territoryVal; 
    }

}