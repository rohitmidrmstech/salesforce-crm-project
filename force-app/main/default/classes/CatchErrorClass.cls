public class CatchErrorClass {
    public static DebugLog__c exceptionerror(exception cause, integer linenumber ,string message,string extype, string obj, string errortype){
        DebugLog__c debugobj = new DebugLog__c() ;
        debugobj.Cause__c= JSON.serialize(cause);
        debugobj.message__c = message;        
        debugobj.line_Number__c = string.valueof(linenumber);
        debugobj.exception_type__c = extype;
        debugobj.object__c = obj;
        debugobj.Error_type__c = errortype;
        return debugobj;
        
        
    }
}