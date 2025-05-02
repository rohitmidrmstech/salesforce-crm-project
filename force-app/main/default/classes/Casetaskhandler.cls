public class Casetaskhandler {
    public static void CreateTaskRelatedOpportunity(String Subjects){
        List<Task> tasksToInsert = new List<Task>();
        System.debug('Subjects==' + Subjects);
        String subject = Subjects;
        Integer startIndex = subject.indexOf('#') + 1;
        String orderNumber = subject.substring(startIndex).trim();
        System.debug('orderNumber==' + orderNumber);        
        if (!String.isEmpty(orderNumber)) {
            List<Opportunity> relatedOpportunities = [SELECT Id FROM Opportunity WHERE OrderNumber__c = :orderNumber LIMIT 1];
            System.debug('relatedOpportunities==' + relatedOpportunities);
            if (!relatedOpportunities.isEmpty()) {
                Opportunity relatedOpportunity = relatedOpportunities[0];
                Task newTask = new Task(
                    Subject = 'Saffron Marigold - Order Delivered',
                    WhatId = relatedOpportunity.Id,
                    Description = 'Saffron Marigold - Order Delivered #' + orderNumber
                );
                tasksToInsert.add(newTask); 
                System.debug('BesoretasksToInsert==' + tasksToInsert);
            }
        }
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
        System.debug('AftertasksToInsert==' + tasksToInsert);        
    }
    public static void preventcaseCreation(List<Case> newcase){
        System.debug('newcase==' + newcase);
        
        for (Case newcs : newcase) {
            if (newcs.Origin == 'Email' && newcs.Subject.startsWith('Saffron Marigold - Order Delivered #')) {
                System.debug('newcs==' + newcs.Subject);
                newcs.addError('Case creation not allowed for this scenario.');
            }
        }
    }
}