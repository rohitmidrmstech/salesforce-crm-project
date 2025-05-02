public class ExceptionClass {
    public static void insertrecord(){
        try{  
            Account a1 = new Account() ;
            a1.name ='rohit';
            insert a1;
            system.debug('print is ===>>.' + a1);
        } catch(dmlexception ex){
            DebugLog__c debugobj  = CatchErrorClass.exceptionerror(ex.getLineNumber(),ex.getMessage(),ex.getTypeName(),'Account','dmlexception ');
            insert debugobj;
            system.debug('dml exception is >..' +  ex.getMessage() + ex.getLineNumber());
            
        }
        catch (nullpointerexception ex){
            DebugLog__c debugobj  = CatchErrorClass.exceptionerror(ex.getLineNumber(),ex.getMessage(),ex.getTypeName(),'Account','nullpointerexception');
            insert debugobj;
            
            system.debug('null exception is >..'  + ex.getMessage() + ex.getLineNumber());
        }
        catch(Exception ex){
            DebugLog__c debugobj  = CatchErrorClass.exceptionerror(ex.getLineNumber(),ex.getMessage(),ex.getTypeName(),'Account-','Exception');
            insert debugobj;
            
            system.debug( 'thse exception are ' + ex.getLineNumber()+ ' ' + ex.getMessage()+' ' + ex.getTypeName()); 
        }
        
    }  
}