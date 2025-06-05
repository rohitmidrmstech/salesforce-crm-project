global class DeleteCaseScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        DeleteCase bs = new DeleteCase();
        Database.executeBatch(bs);
    }
    
}