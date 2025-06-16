/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Apex class to check recursive triggers.  
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Gautam Kumar (gkumar@liquidhub.com)
* @version        1.0
* @created        2017-07-07
*/
public class CT_RecursiveTriggerCheck {
    
    @TestVisible private static boolean run = true;
    
    /*@return - Boolean indicating whether the trigger has fired before or not. 
     * @description - Function used to check if the trigger has been fired before or not. 
     */
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }
        else    return run;
        
    }
    
}