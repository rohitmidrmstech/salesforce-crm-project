public with sharing class ExceptionHandlingHandler {
    
    public static String handleException(integer lineNumber , String className) {
        
        try{
            System.debug('Exception occurred at line: ' + lineNumber + ' in class: ' + className);
            
            // Query to fetch the error description from Data_dictionary__c
            List<Data_dictionary__c> errorDetails = [
                SELECT Error_description__c,Dictionary__c,Line_number__c,IsActive__c,Dictionary__r.Name
                FROM Data_dictionary__c 
                WHERE Dictionary__r.Name = :className
                AND Line_number__c = :lineNumber
                AND IsActive__c = True
                LIMIT 1
            ];
            // If a matching error description is found
                Data_dictionary__c errorDetail = errorDetails[0];
                String errorMessageToDisplay = errorDetail.Error_description__c;
                return errorMessageToDisplay;
          
 
        } catch(Exception innerEx){
            // Handle any exception that might occur while fetching the error description
            System.debug('Failed to retrieve error description: ' + innerEx.getMessage());
            return 'An unexpected error occurred please contact system admin';
        }    
    }

}