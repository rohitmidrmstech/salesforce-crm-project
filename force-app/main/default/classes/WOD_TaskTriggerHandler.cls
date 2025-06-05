/**
 * @description Trigger Handler Class for Task.
*/
public class WOD_TaskTriggerHandler extends WOD_TriggerHandler{
    Map<Id, Task> oldTaskMap;
    Map<Id, Task> newTaskMap;
    List<Task> newTaskList;
    /*
        Constructor
    */
    public WOD_TaskTriggerHandler (){
        oldTaskMap = (Map<Id, Task>)Trigger.oldMap;
        newTaskMap = (Map<Id, Task>)Trigger.newMap;
        newTaskList= ( List<Task>)Trigger.new;
    }
    /**
     * @description To performe action before Insert operation on Task
    */
    public override void beforeInsert(){
        onBeforeInsert(newTaskList);
    }    
    /**
     * @description To performe action after Insert operation on Task
    */
   // public override void afterInsert(){}
    /**
     * @description To performe action before update operation on Task
    */
   // public override void beforeUpdate(){}
    /**
     * @description To performe action after update operation on Task
    */
  //  public override void afterUpdate(){}
    
    /**
     * @description To performe action on Task before insert
     * @param newTaskList List of Task
     * @return void
    */
    public static void onBeforeInsert(List<Task> newTaskList){
        
        Schema.DescribeSObjectResult insp = Schema.getGlobalDescribe().get('WOD_Inspection__c').getDescribe();
        String inspPrefix = insp.getKeyPrefix();
        Map<String, Schema.RecordTypeInfo> recTypeMap = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName();
        ID roofingRectypeID =recTypeMap.get('General Task').getRecordTypeId();
        ID sidingRecTypeId = recTypeMap.get('Siding Task').getRecordTypeId();
        Set<Id> inspIds = new Set<Id>();
        //Schema.DescribeSObjectResult inspPrefix = getDescribe('WOD_Inspection__c');
        for(Task currTask : newTaskList){
            if (currTask.WhatId!=null &&  inspPrefix.equals(((String)currTask.WhatId).left(3))){
                inspIds.add(currTask.WhatId);
            }
        }
        if(inspIds <> null && inspIds.size()> 0){
            
            Map<Id, WOD_Inspection__c > inspRecMap =new Map<Id, WOD_Inspection__c>([SELECT Id, name, Claim__c, Claim__r.Business_units__c, Registration__c, Registration__r.Business_units__c from WOD_Inspection__c WHERE ID IN : inspIds]);
            for(Task currTask : newTaskList){
                if (currTask.WhatId!=null &&  inspPrefix.equals(((String)currTask.WhatId).left(3)) && inspRecMap.containskey(currTask.WhatId)){
                    WOD_Inspection__c ins = inspRecMap.get(currTask.WhatId);
                    String bu ='';
                    if(ins.Claim__c!= null){
                        bu = ins.Claim__r.Business_units__c;
                    }
                    else if(ins.Registration__c!= null){
                        bu= ins.Registration__r.Business_units__c;
                    }
                    if(!String.isBLank(bu) && bu.equalsIgnoreCase('Siding')){//CER-211
                        currTask.recordtypeId = sidingRecTypeId;
                    }
                    else{
                        currTask.recordtypeId = roofingRectypeID;
                    }
                }
            }
            
        }
    }
    
}