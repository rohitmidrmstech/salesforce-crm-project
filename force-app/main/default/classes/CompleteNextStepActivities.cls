public without sharing class  CompleteNextStepActivities {

    @invocablemethod
    public static void updateExistingActivtyRecords(List<ID> recordIDs){
        System.debug('--updateExistingActivtyRecords--recordIDs--'+recordIDs);
        if(recordIDs != null){
            List<Task> activityUpdateList = new List<task>();
            for(task act : [Select id from task where Subject Like 'Next Step%' and whatid in :recordIDs and status in ('Open', 'In Progress') ]){
                act.status = 'Completed';
                activityUpdateList.add(act);
            }
            update activityUpdateList;
        }
    }
}