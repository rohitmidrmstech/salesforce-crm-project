/****************************************************************************************
* @Name         Test Factory
* @Author       Huron Consulting Group
* @Date         March 1, 2016
* @Description  Class generates Test data and can be called from Test Classes
* @revision(s)  
****************************************************************************************/
@isTest
public class SKELETONTestFactory {
    //Class variables
    public static String testFactoryName = 'SKELETONTestFactory';
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  getDefaultClassName method - returns the default class name for the sobject
    * @params       SObject <object to get default class name of>
    * @return       String <default class name>
    * @revision(s)  
    * **************************************************************************************/
    public static String getDefaultClassName(SObject sObj){
        return String.valueOf(sObj.getSObjectType()).replace('__c', '') + 'Defaults';
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createObject method - adds default fields and field map to object
    * @params       SObject <object to add fields to>, String <object default method name>, Map<String,Object> <fieldname,value>
    * @return       SObject <passed in object with default fields and field map added>
    * @revision(s)  
    * **************************************************************************************/
    public static SObject createSObject(SObject sObj, String defaultClassName, Map<String,Object> dynamicValueMap) {
        if(defaultClassName == null) defaultClassName = getDefaultClassName(sObj);
        FieldDefaults defaults = getFieldDefaults(defaultClassName,dynamicValueMap);
        sObj = addFieldDefaults(sObj.clone(false, true), defaults.getFieldDefaults());
        return sObj;
    } 
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createObject method - passes on to main createSObject
    * @params       SObject <object to add fields to>
    * @return       SObject <passed in object with default fields and field map added>
    * @revision(s)  
    * **************************************************************************************/
    public static SObject createSObject(SObject sObj) {
        sObj = createSObject(sObj, null, null);
        return sObj;
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createObject method - passes on to main createSObject
    * @params       SObject <object to add fields to>, String <object default method name>
    * @return       SObject <passed in object with default fields and field map added>
    * @revision(s)  
    * **************************************************************************************/
    public static SObject createSObject(SObject sObj, String defaultClassName) {
        sObj = createSObject(sObj, defaultClassName, null);
        return sObj;
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createObject method - passes on to main createSObject
    * @params       SObject <object to add fields to>, Map<String,Object> <fieldname,value>
    * @return       SObject <passed in object with default fields and field map added>
    * @revision(s)  
    * **************************************************************************************/
    public static SObject createSObject(SObject sObj,Map<String,Object> dynamicValueMap) {
        sObj = createSObject(sObj, null, dynamicValueMap);
        return sObj;
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createObjectList method - adds default fields and field map and returns a specificed number of test objects
    * @params       SObject <object to add fields to>, Integer <number of objects to create>, String <object default method name>, Map<String,Object> <fieldname,value>
    * @return       SObject[] <array of passed in object type with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName, Map<String,Object> dynamicValueMap) {
        if(defaultClassName == null) defaultClassName = getDefaultClassName(sObj);
        SObject[] sObjs = new SObject[] {};
        SObject newObj;
        FieldDefaults defaults = getFieldDefaults(defaultClassName,dynamicValueMap);
        for (Integer i = 0; i < numberOfObjects; i++) {
            newObj = addFieldDefaults(sObj.clone(false, true), defaults.getFieldDefaultsMultipleRecords(i));
            sObjs.add(newObj);
        }
        return sObjs;
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createObjectList method - passes on to object default createObjectsList
    * @params       SObject <object to add fields to>, Integer <number of objects to create>, String <object default method name>
    * @return       SObject[] <array of passed in object type with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName) {
        return createSObjectList(sObj, numberOfObjects, defaultClassName, null);
    }

    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createObjectList method - passes on to object default createObjectsList
    * @params       SObject <object to add fields to>, Integer <number of objects to create>, Map<String,Object> <fieldname,value>
    * @return       SObject[] <array of passed in object type with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, Map<String,Object> dynamicValueMap) {
        return createSObjectList(sObj, numberOfObjects, null, dynamicValueMap);
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createFromStaticResource method - creates objects from static resource file and adds default fields. May overwrite fields from file if they are default fields or dynamic value fields
    * @params       SObject <used for object type>, String <static resource name>, Map<String,Object> <fieldname,value>, String <default class name>
    * @return       List<SObject> <list of objects from file with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static List<SObject> createFromStaticResource(SObject sObj, String srName, Map<String,Object> dynamicValueMap, String defaultClassName) {
        if(defaultClassName == null) defaultClassName = getDefaultClassName(sObj);
        if(srName == null) srName = defaultClassName;
        FieldDefaults defaults = getFieldDefaults(defaultClassName,dynamicValueMap);
        List<SObject> lstSO = Test.loadData(sObj.getSObjectType(), srName);
        for(SObject so : lstSO){
            addFieldDefaults(so, defaults.getFieldDefaults());
        }
        return lstSO;
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createFromStaticResource method - passes to main createFromStaticResource method
    * @params       SObject <used for object type>
    * @return       List<SObject> <list of objects from file with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static List<SObject> createFromStaticResource(SObject sObj) {
        return createFromStaticResource(sObj,null,null,null);
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createFromStaticResource method - passes to main createFromStaticResource method
    * @params       SObject <used for object type>, String <static resource name>
    * @return       List<SObject> <list of objects from file with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static List<SObject> createFromStaticResource(SObject sObj, String srName) {
        return createFromStaticResource(sObj,srName,null,null);
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createFromStaticResource method - passes to main createFromStaticResource method
    * @params       SObject <used for object type>, Map<String,Object> <fieldname,value>
    * @return       List<SObject> <list of objects from file with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static List<SObject> createFromStaticResource(SObject sObj, Map<String,Object> dynamicValueMap) {
        return createFromStaticResource(sObj,null,dynamicValueMap,null);
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createFromStaticResource method - passes to main createFromStaticResource method
    * @params       String <default class name>, SObject <used for object type>
    * @return       List<SObject> <list of objects from file with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static List<SObject> createFromStaticResource(String defaultClassName, SObject sObj) {
        return createFromStaticResource(sObj,null,null,defaultClassName);
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createFromStaticResource method - passes to main createFromStaticResource method
    * @params       SObject <used for object type>, String <static resource name>, Map<String,Object> <fieldname,value>
    * @return       List<SObject> <list of objects from file with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static List<SObject> createFromStaticResource(SObject sObj, String srName, Map<String,Object> dynamicValueMap) {
        return createFromStaticResource(sObj,srName,dynamicValueMap,null);
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createFromStaticResource method - passes to main createFromStaticResource method
    * @params       SObject <used for object type>, String <static resource name>, String <default class name>
    * @return       List<SObject> <list of objects from file with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static List<SObject> createFromStaticResource(SObject sObj, String srName, String defaultClassName) {
        return createFromStaticResource(sObj,srName,null,defaultClassName);
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  createFromStaticResource method - passes to main createFromStaticResource method
    * @params       SObject <used for object type>,  Map<String,Object> <fieldname,value>, String <default class name>
    * @return       List<SObject> <list of objects from file with default fields and field map added to each object in array>
    * @revision(s)  
    * **************************************************************************************/
    public static List<SObject> createFromStaticResource(SObject sObj, Map<String,Object> dynamicValueMap, String defaultClassName) {
        return createFromStaticResource(sObj,null,dynamicValueMap,defaultClassName);
    }
    
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  getFieldDefaults method - returns the map of field defaults if it exists
    * @params       String <default class name>, Map<String,Object> <fieldname,value>
    * @return       FieldDefaults <interface that holds defaults for objects>
    * @revision(s)  
    * **************************************************************************************/
    private static FieldDefaults getFieldDefaults(String defaultClassName, Map<String,Object> dynamicValueMap) {
        if(!defaultClassName.startsWith(testFactoryName + '.')) defaultClassName = testFactoryName + '.' + defaultClassName;
        // Create an instance of the defaults class so we can get the Map of field defaults
        Type t = Type.forName(defaultClassName);
        if (t == null) {
            Throw new TestFactoryException('Invalid defaults class:' + defaultClassName);
        }
        FieldDefaults defaults = (FieldDefaults)t.newInstance();
        defaults.setDynamicValueMap(dynamicValueMap);
        return defaults;
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  addFieldDefaults method - returns the map of field defaults if it exists
    * @params       String <default class name>, Map<String,Object> <fieldname,value>
    * @return       FieldDefaults <interface that holds defaults for objects>
    * @revision(s)  
    * **************************************************************************************/
    private static SObject addFieldDefaults(SObject sObj, Map<String, Object> defaults) {
        // Loop through the map of fields and if they are null on the object, fill them.
        for (String field : defaults.keySet()) {
            if (sObj.get(field) == null) {
                sObj.put(field, defaults.get(field));
            }
        }
        return sObj;
    }
    
    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  Custom exception thrown by testfactory
    * @revision(s)  
    * **************************************************************************************/
    public class TestFactoryException extends Exception {}

    /****************************************************************************************
    * @Author       Huron Consulting Group
    * @Date         March 1, 2016
    * @Description  Use the FieldDefaults interface to set up values you want to default in for all objects
    * @params       String <default class name>, Map<String,Object> <fieldname,value>
    * @return       FieldDefaults <interface that holds defaults for objects>
    * @revision(s)  
    * **************************************************************************************/
    public interface FieldDefaults {
        Map<String,Object> getDynamicValueMap();
        void setDynamicValueMap(Map<String,Object> val);
        Map<String, Object> getFieldDefaults();
        Map<String, Object> getFieldDefaultsMultipleRecords(Integer val);
    }
    
    /****************************************************************************************
    * @Author       Huron Trianer
    * @Date         March 16, 2016
    * @Description  Contains default fields for Case
    * @revision(s)  
    * **************************************************************************************/
    public class CaseDefaults implements FieldDefaults {
        Map<String,Object> dynamicValueMap;
        
        public void setDynamicValueMap(Map<String,Object> val) {
            this.dynamicValueMap = val;
        }
        
        public Map<String,Object> getDynamicValueMap() {
            return this.dynamicValueMap;
        }
        
        public Map<String, Object> getFieldDefaults() {
            Map<String, Object>  m = new Map<String, Object> {
                'Subject' => 'Test Case'
            };
            if(dynamicValueMap!=null) m.putAll(dynamicValueMap);
            return m;
        }
        public Map<String, Object> getFieldDefaultsMultipleRecords(integer counter) {
            Map<String, Object>  m = new Map<String, Object> {
                'Subject' => 'Test Case' + counter
            };
            if(dynamicValueMap!=null) m.putAll(dynamicValueMap);
            return m;
        } 
    }
    
    /****************************************************************************************
    * @Author       Huron Trianer
    * @Date         March 16, 2016
    * @Description  Contains default fields for Case
    * @revision(s)  
    * **************************************************************************************/
    public class AdjustmentDefaults implements FieldDefaults {
        Map<String,Object> dynamicValueMap;
        
        public void setDynamicValueMap(Map<String,Object> val) {
            this.dynamicValueMap = val;
        }
        
        public Map<String,Object> getDynamicValueMap() {
            return this.dynamicValueMap;
        }
        
        public Map<String, Object> getFieldDefaults() {
            Map<String, Object>  m = new Map<String, Object> {
            };
            if(dynamicValueMap!=null) m.putAll(dynamicValueMap);
            return m;
        }
        public Map<String, Object> getFieldDefaultsMultipleRecords(integer counter) {
            Map<String, Object>  m = new Map<String, Object> {
            };
            if(dynamicValueMap!=null) m.putAll(dynamicValueMap);
            return m;
        } 
    }
    
    /****************************************************************************************
    * @Author       Huron Trianer
    * @Date         March 16, 2016
    * @Description  Contains default fields for Case
    * @revision(s)  
    * **************************************************************************************/
    public class JDE_OrderDefaults implements FieldDefaults {
        Map<String,Object> dynamicValueMap;
        
        public void setDynamicValueMap(Map<String,Object> val) {
            this.dynamicValueMap = val;
        }
        
        public Map<String,Object> getDynamicValueMap() {
            return this.dynamicValueMap;
        }
        
        public Map<String, Object> getFieldDefaults() {
            Map<String, Object>  m = new Map<String, Object> {
            };
            if(dynamicValueMap!=null) m.putAll(dynamicValueMap);
            return m;
        }
        public Map<String, Object> getFieldDefaultsMultipleRecords(integer counter) {
            Map<String, Object>  m = new Map<String, Object> {
            };
            if(dynamicValueMap!=null) m.putAll(dynamicValueMap);
            return m;
        } 
    }
    
    /****************************************************************************************
    * @Author       Huron Trianer
    * @Date         March 16, 2016
    * @Description  Contains default fields for Case
    * @revision(s)  
    * **************************************************************************************/
    public class JDE_Order_Line_ItemDefaults implements FieldDefaults {
        Map<String,Object> dynamicValueMap;
        
        public void setDynamicValueMap(Map<String,Object> val) {
            this.dynamicValueMap = val;
        }
        
        public Map<String,Object> getDynamicValueMap() {
            return this.dynamicValueMap;
        }
        
        public Map<String, Object> getFieldDefaults() {
            Map<String, Object>  m = new Map<String, Object> {
            };
            if(dynamicValueMap!=null) m.putAll(dynamicValueMap);
            return m;
        }
        public Map<String, Object> getFieldDefaultsMultipleRecords(integer counter) {
            Map<String, Object>  m = new Map<String, Object> {
            };
            if(dynamicValueMap!=null) m.putAll(dynamicValueMap);
            return m;
        } 
    }
}