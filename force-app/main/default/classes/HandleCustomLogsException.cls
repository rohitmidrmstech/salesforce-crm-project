/* **********************************************************************************************************************************
* Class Name   : HandleCustomLogsException
* Description  : Class to handle Exceptions
* Author       : Dipen
* Created On   : Dec 30,2023
* Test Class   : HandleCustomExceptionLogsTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Dipen			         30-12-20223           1000              Initial Development
**************************************************************************************************************************************/

public class HandleCustomLogsException extends Exception {
  public static void LogException(Exception e)
    {
        LogExceptionMethod(e);
    }
    
    // Log Exception in CustomException object. 
    public static void LogExceptionMethod(Exception e)
    {
        try
        {
		String stackTrace = e.getStackTraceString().substringBefore('\n');
		String className = stackTrace.substringAfter('.').substringBefore('.');	
            	String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
             
            	//Log information in object
                CustomLogsException__c exc = new CustomLogsException__c();         
                exc.ExceptionMessage__c = e.getMessage();
                exc.Exception_Type__c = e.getTypeName();
                exc.Line_Number__c = e.getLineNumber();
                exc.Stack_Trace__c = e.getStackTraceString();
                exc.Method_Name__c=methodName;
                exc.ClassName__c=className;
                database.insert(exc);            
        } 
        finally{
        }            
    }
}