/**
 * @description Trigger Handler Class for Triggers.
*/
public virtual class WOD_TriggerHandler {
    
    public static Boolean allTriggersDisabled = false;
    
    // static map of handlername, times run() was invoked
    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;
    
    // the current context of the trigger, overridable in tests
    @TestVisible
    private TriggerContext context;
    
    // the current context of the trigger, overridable in tests
    @TestVisible
    private Boolean isTriggerExecuting;
    
    // static initialization
    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
    }
    
    // constructor
    public WOD_TriggerHandler() {
        this.setTriggerContext();
    }
    
    /**
	 * @description main method that will be called during execution
	 * @return void
	*/
    public void run() {
        
        if(!validateRun()) return;
        if(!allTriggersDisabled ){
            addToLoopCount();
            
            // dispatch to the correct handler method
            if(this.context == TriggerContext.BEFORE_INSERT) {
                this.beforeInsert();
            } else if(this.context == TriggerContext.BEFORE_UPDATE) {
                this.beforeUpdate();
            } else if(this.context == TriggerContext.BEFORE_DELETE) {
                this.beforeDelete();
            } else if(this.context == TriggerContext.AFTER_INSERT) {
                this.afterInsert();
            } else if(this.context == TriggerContext.AFTER_UPDATE) {
                this.afterUpdate();
            } else if(this.context == TriggerContext.AFTER_DELETE) {
                this.afterDelete();
            } else if(this.context == TriggerContext.AFTER_UNDELETE) {
                this.afterUndelete();
            }
        }
        
    }
    
    /**
	 * @description method to set the Maximum number of times the handler is invoked
	 * @param max Maximum loop count
	 * @return void
	*/
    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();
        if(!WOD_TriggerHandler.loopCountMap.containsKey(handlerName)) {
            WOD_TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
        } else {
            WOD_TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        }
    }
    
    /**
	 * @description method to set the clear the loop count
	 * @return void
	*/
    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }
    

    /**
	 * @description bypass Handlers for a transactions
	 * @param handlerName Trigger handler name
	 * @return void
	*/
    public static void bypass(String handlerName) {
        WOD_TriggerHandler.bypassedHandlers.add(handlerName);
    }

    /**
	 * @description clear the bypass of a specific handler
	 * @param handlerName Trigger handler name
	 * @return  void
	*/
    public static void clearBypass(String handlerName) {
        WOD_TriggerHandler.bypassedHandlers.remove(handlerName);
    }

    /**
	 * @description method to check if the handler is bypassed
	 * @param handlerName Trigger handler name
	 * @return flag for handler is bypassed or not
	*/
    public static Boolean isBypassed(String handlerName) {
        return WOD_TriggerHandler.bypassedHandlers.contains(handlerName);
    }
    /**
	 * @description clear the bypass of all handlers
	 * @return void
	*/
    public static void clearAllBypasses() {
        WOD_TriggerHandler.bypassedHandlers.clear();
    }
    
    /**
	 * @description private instancemethods set Trigger context
	 * @return void
	*/
    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    /**
	 * @description private instancemethods set Trigger context
	 * @param ctx Trigger context
     * @param testMode Mode
	 * @return void
	*/
    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {
        if(!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        } else {
            this.isTriggerExecuting = true;
        }
        
        if((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
           (ctx != null && ctx == 'before insert')) {
               this.context = TriggerContext.BEFORE_INSERT;
           } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
                     (ctx != null && ctx == 'before update')){
                         this.context = TriggerContext.BEFORE_UPDATE;
                     } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
                               (ctx != null && ctx == 'before delete')) {
                                   this.context = TriggerContext.BEFORE_DELETE;
                               } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
                                         (ctx != null && ctx == 'after insert')) {
                                             this.context = TriggerContext.AFTER_INSERT;
                                         } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
                                                   (ctx != null && ctx == 'after update')) {
                                                       this.context = TriggerContext.AFTER_UPDATE;
                                                   } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
                                                             (ctx != null && ctx == 'after delete')) {
                                                                 this.context = TriggerContext.AFTER_DELETE;
                                                             } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
                                                                       (ctx != null && ctx == 'after undelete')) {
                                                                           this.context = TriggerContext.AFTER_UNDELETE;
                                                                       }
    }
    /**
	 * @description private instancemethods add to Loop Count
	 * @return void
	*/
    @TestVisible
    private void addToLoopCount() {
        String handlerName = getHandlerName();
        if(WOD_TriggerHandler.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = WOD_TriggerHandler.loopCountMap.get(handlerName).increment();
            if(exceeded) {
                Integer max = WOD_TriggerHandler.loopCountMap.get(handlerName).max;
                throw new WOD_TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }

    /**
	 * @description private instancemethods make sure this trigger should continue to run
	 * @return flaf
	*/
    @TestVisible
    private Boolean validateRun() {
        if(!this.isTriggerExecuting || this.context == null) {
            throw new WOD_TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        if(WOD_TriggerHandler.bypassedHandlers.contains(getHandlerName())) {
            return false;
        }
        return true;
    }
    /**
	 * @description private instancemethods get the name of handler
	 * @return Return Handler name
	*/
    @TestVisible
    private String getHandlerName() {
        return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    }
    
    /**
	 * @description context-specific methods for override
	*/
    @TestVisible
    protected virtual void beforeInsert(){}
    /**
	 * @description context-specific methods for override
	*/
    @TestVisible
    protected virtual void beforeUpdate(){}
    /**
	 * @description context-specific methods for override
	*/
    @TestVisible
    protected virtual void beforeDelete(){}
    /**
	 * @description context-specific methods for override
	*/
    @TestVisible
    protected virtual void afterInsert(){}
    /**
	 * @description context-specific methods for override
	*/
    @TestVisible
    protected virtual void afterUpdate(){}
    /**
	 * @description context-specific methods for override
	*/
    @TestVisible
    protected virtual void afterDelete(){}
    /**
	 * @description context-specific methods for override
	*/
    @TestVisible
    protected virtual void afterUndelete(){}
    
    /**
	 * @description inner class for managing the loop count per handler
	*/
    @TestVisible
    private class LoopCount {
        private Integer max;
        private Integer count;
        /**
         * @description constructor
        */
        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }
        /**
         * @description constructor
        */
        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }
        /**
         * @description to increase counter values
         * @return flag
        */
        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }
        /**
         * @description to check max limit
         * @return flag
        */
        public Boolean exceeded() {
            if(this.max < 0) return false;
            if(this.count > this.max) {
                return true;
            }
            return false;
        }
        /**
         * @description to get Max value
         * @return Integer value
        */
        public Integer getMax() {
            return this.max;
        }
        /**
         * @description to get Count value
         * @return Integer value
        */
        public Integer getCount() {
            return this.count;
        }
        /**
         * @description to set Maximum value
         * @param max Integer value
         * @return void
        */
        public void setMax(Integer max) {
            this.max = max;
        }
    }
    
    /**
     * @description possible trigger contexts
     */
    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
            AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
            AFTER_UNDELETE
            }
    
    /**
     * @description exception class
     */
    public class WOD_TriggerHandlerException extends Exception {}
    
}