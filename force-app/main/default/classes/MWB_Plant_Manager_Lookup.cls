public class MWB_Plant_Manager_Lookup {
    //@InvocableMethod
    public static void getPlantManager(List<Case> lstCases)
    {
        map<string,id> plantMap = new map<string,id>();
        
        List<Case> updateCase = new List<Case>();
        List<case> UpdatePlanner = new List <case>();
        List<Case> result= new List<case>();
        set<Case> caseSet = new Set<case>();
        
       List<Case> caselist  = [SELECT Id,RecordTypeId, RecordType.Name, Status,Country__c,Plant_Quality_Manager_Id__c, Plant_Manager_Id__c,Issue_Problem__c,Planner__c,
                               Plant_Manager__c,Plants__r.Name,Plants__r.Plant_Manager__c,Warehouse__c,Comments_Planning__c ,OwnerId
                               FROM Case where RecordType.Name ='Service Case' and Country__c ='Canada' and Issue_Problem__c ='Service Charter Product Failure'
                              and Issue_Category__c = 'Service Incomplete' and Warehouse__c !='' and id IN :lstCases];
                             // WHERE  id IN :lstCases];
        //Issue_Problem__c =='Service Charter Product Failure';Issue_Category__c == 'Service Incomplete'
        System.debug('caseListMWB====>'+caselist);
          System.debug('caseListMWB Size====>'+caselist.size());
        
        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        for(Plants__c plant :[select id,Name,Plant_Manager__c,Plant_Manager__r.Id,Warehouse_Manager__c,Warehouse_Manager__r.Id,Country__c from Plants__c where Country__c='canada' and Plant_Manager__c!='' ] )
       
        {
         //plantMap.put(plant.name,plant.Plant_Manager__r.Id);   
       plantMap.put(plant.name,plant.Warehouse_Manager__r.Id);   
        }
       // system.debug('plantList' + plantList);
         System.debug('2.Number of Queries used in this apex code so far: ' + Limits.getQueries());
     for(case cases : caselist)
     {
         system.debug('cases.Plant_Manager__c'+cases.Plant_Manager__c);
         system.debug('cases.Warehouse__c'+cases.Warehouse__c);
         if (String.isBlank(cases.Plant_Manager__c)  && String.isNotEmpty(cases.Warehouse__c) && plantMap.containsKey(cases.Warehouse__c) && cases.RecordTypeId ==System.Label.Service_Case_Record_Id  ) {
            cases.Plant_Manager__c =plantMap.get(cases.Warehouse__c);
            updateCase.add(cases);
            
         }
         system.debug('cases.Comments_Planning__c====>'+cases.Planner__c );
         system.debug('cases.Planner__c ====>'+cases.Planner__c );
          system.debug('cases.OwnerId====>'+cases.OwnerId);
       
         if( cases.Comments_Planning__c == NULL || cases.Comments_Planning__c =='' )
         {
          system.debug('inside if cases.OwnerId====>'+cases.OwnerId);
             if(string.valueOf(cases.OwnerId).startsWith('005')) 
             {
              system.debug('inside if if cases.OwnerId====>'+cases.OwnerId);
             cases.Planner__c =cases.OwnerId;
             UpdatePlanner.add(cases);
             }
        }
         
          
     system.debug('cases.Plant_Manager__c '+cases.Plant_Manager__c ) ; 
     }
          caseSet.addAll(updateCase);
         caseSet.addAll(UpdatePlanner);  
         system.debug('updateCase===>'+updateCase);
         system.debug('UpdatePlanner===>'+UpdatePlanner);
         if(caseSet.size() > 0)
         {
         result.addAll(caseSet);
         
         }
     update result;
        
    system.debug('result===>'+result);
    
        
   }
  
   

}