/** 
 * TaskTriggerHandler
 * @Author LiquidHub / Vincent Ip <vip@liquidhub.com>
 * @Date 03/31/2016
 * @Description used to update and maintain trigger events.
 */
public class TaskTriggerHandler {

    public void onBeforeUpdate( List<Task> newList, Map<Id, Task> oldMap)
    {
        impactAnalysisGetRmEmail(newList,oldMap);
    }

    //
    // Approval Flow - Impact anaysis -> Get RM email
    //  will perform 1 query to get all the related Pricing requests
    //
    @testVisible
    private void impactAnalysisGetRmEmail(List<Task> newList, Map<Id, Task> oldMap )
    {
        /*Schema.DescribeSObjectResult priReqDesc = getDescribe('Pricing_Request__c');

        Set<Id> priReqIdSet = new Set<Id>();
        List<Task> workingList = new List<Task>();
        for (Task currTask : newList)
        {
            if (currTask.WhatId!=null && String.isEmpty(currTask.Manager_Email__c) && 
                priReqDesc.getKeyPrefix().equals(((String)currTask.WhatId).left(3)))
            {
                workingList.add(currTask);
                priReqIdSet.add(currTask.WhatId);
            }
        }

        if (priReqIdSet.size()>0){
            Map<Id, Pricing_Request__c> priReqMap = 
                new Map<Id, Pricing_Request__c>([ select Id, RM_Approver__c, RM_Approver__r.email 
                    from Pricing_Request__c
                    where id in :priReqIdSet]);

            for(Task currTask : workingList)
            {
                Pricing_Request__c currPriReq = priReqMap.get(currTask.WhatId);
                currTask.Manager_Email__c = currPriReq.RM_Approver__r.Email;
            }
        }*/
    }


    //
    // Utility methods ------------------------------------------------
    // Move to Utility common if there are enough of these
    //
    @testVisible
    private Schema.DescribeSObjectResult getDescribe(String objectName)
    {
        Schema.DescribeSObjectResult[] descResultList = Schema.describeSObjects( new String[]{ objectName } );
        if (descResultList.size()>0) return descResultList[0];
        return null;
    }
}