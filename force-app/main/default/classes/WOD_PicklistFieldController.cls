/**
 * @description This class returns Controllling and Dependent Picklist map
*/
public class WOD_PicklistFieldController {
    /**
	 * @description returns controlling field and dependent picklists values in map format 
	 * @param objName Object Api Name
     * @param contfieldName Controlling field API Name
     * @param depfieldName Dependent field API Name
     * @param addUSCanadafilter Canada Filter condition
	 * @return Map of picklist values
    */
     @AuraEnabled
    public static Map<String,List<String>> getDependentOptions(String objName, String contfieldName, String depfieldName, Boolean addUSCanadafilter) {

        Map<String,List<String>> objResults = new Map<String,List<String>>();
        String objectName = objName.toLowerCase();
        String controllingField = contfieldName.toLowerCase();
        String dependentField = depfieldName.toLowerCase();
       
        
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!Schema.getGlobalDescribe().containsKey(objectName)) {
            System.debug('---Object Name does not exist--- ' + objectName);
            return null;
        }
        Schema.SObjectType objType = objGlobalMap.get(objectName);
        
        //Schema.SObjectType objType = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
        if (objType == null) {
            System.debug('---SObjectType is null---');
            return null;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        if (!objFieldMap.containsKey(controllingField)) {
            System.debug('---Field Not found--- ' + controllingField);
            return null;
        }
        if (!objFieldMap.containsKey(dependentField)) {
            System.debug('---Field Not found--- ' + dependentField);
            return null;
        }

        //WOD_BitSet bitSetObj = new WOD_BitSet();

        List<Schema.PicklistEntry> contEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
        List<Integer> controllingIndexes = new List<Integer>();
        Schema.PicklistEntry ctrlentry;
        String label;
        /*
        for(Integer contIndex=0; contIndex<contEntries.size(); contIndex++) {
            ctrlentry = contEntries[contIndex];
            label = ctrlentry.getLabel();
            objResults.put(label,new List<String>());
            controllingIndexes.add(contIndex);
        }
        */
        List<WOD_PicklistEntryWrapper> objJsonEntries = new List<WOD_PicklistEntryWrapper>();
        objJsonEntries = (List<WOD_PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(depEntries), List<WOD_PicklistEntryWrapper>.class);
        List<Integer> indexes;
        for (WOD_PicklistEntryWrapper objJson : objJsonEntries){
            /*
            if(objJson.label == 'Alberta (AB)'){
            System.debug(objJson.label + '<>'+ objJson.validFor);
            if (objJson.validFor==null || objJson.validFor==''){
                continue;
            }
            indexes = bitSetObj.testBits(objJson.validFor,controllingIndexes);
            break;
            for (Integer idx : indexes){
                String contrLabel = contEntries[idx].getLabel();
                objResults.get(contrLabel).add(objJson.label);
            }
            }
            */
            if(true){
            for(Integer contIndex=0; contIndex<contEntries.size(); contIndex++) {
                String contrLabel = contEntries[contIndex].getLabel();
                if(!objResults.containskey(contrLabel)){
                    objResults.put(contrLabel, new List<String>());
                }
                if((addUSCanadafilter && (contrLabel  == 'United States' || contrLabel  == 'Canada')) || !addUSCanadafilter ){
                    WOD_PicklistFieldController pickCtrl = new WOD_PicklistFieldController();
                    pickCtrl.BitsetChecker(objJson.validFor);
                    if(pickCtrl.testBit(contIndex)){
                        objResults.get(contrLabel).add(objJson.label);
                       
                    }
                }    
            }
            }
        }
        return objResults;
    }
    
    ///////////////////////////////////////////////////////
    public String validFor {get;private set;}
    public String vfDecoded {get;private set;}
    public String[] hexBytes {get;private set;}
    public Integer[] bytes {get;private set;}

    /**
	 * @description BitsetChecker
	 * @param validFor to encode
	 * @return void
	*/
    public void BitsetChecker(String validFor) {
        this.validFor = validFor;
        this.vfDecoded = null;
        hexBytes = new String[] {};
        bytes = new Integer[] {};
        if (String.isNotBlank(validFor)) {
            this.vfDecoded = String.isNotBlank(validFor) ?
                EncodingUtil.convertToHex(EncodingUtil.base64Decode(validFor)).toLowerCase() : '';
            if (String.isNotBlank(vfDecoded) && Math.mod(vfDecoded.length(), 2) == 0) {
                for (Integer i = 0; i < vfDecoded.length(); i += 2) {
                    String hexByte = vfDecoded.substring(i, i + 2);
                    hexBytes.add(hexByte);
                    bytes.add(hexToDecimal(hexByte).intValue());
                }
            }
        }
    }
    /**
	 * @description testBit
	 * @param n to validator param
	 * @return flag
	*/
    public Boolean testBit(Integer n) {
        Boolean result = false;
        if (n != null && n < size() && hexBytes != null) {
            Integer bytesPos = n >> 3;
            Integer targetByte = bytesPos < bytes.size() ? bytes[bytesPos] : null;
            if (targetByte != null) {
                Integer mask = 128 >> Math.mod(n, 8);
                Integer maskedByte = targetByte & mask;
                result = maskedByte != 0;
            }
        }
        return result;
    }
    /**
	 * @description to get byte size
	 * @return size of the byte
	*/
    public Integer size() {
        return bytes.size() * 8;
    }
    /**
	 * @description hexa To Decimal conversion
     * @param sourceHex hexa number
	 * @return result in decimal
	*/
    public static Decimal hexToDecimal(String sourceHex) {
        String hex = '0123456789abcdef';
        String[] hexValue = sourceHex.split('');
        Decimal result = 0;
        for(Integer index = 0; index < hexValue.size(); index++) {
            result = (result * 16) + hex.indexOf(hexValue[index]);
        }
        return result;
    }
}



/**************************************************************************************************
Apex Class Name  : BitSet
Version          : 1.0
Created Date     : 1/Jan/2021
Function         : Getting and Comparing BitSet Values mainly for Dependent Picklists
Modification Log :
------------------------------------------------------------------------------------

***************************************************************************************************
public class WOD_BitSet {
    public Map<String, Integer> alphaNumCharCodes { get; set; }
    public Map<String, Integer> base64CharCodes { get; set; }

    public WOD_BitSet() {
        loadCharCodes();
    }

    //Method loads the character codes for all letters
    private void loadCharCodes() {
        // All Upper Cases
        alphaNumCharCodes = new Map<String, Integer> {
            'A'=>65, 'B'=>66, 'C'=>67, 'D'=>68, 'E'=>69, 'F'=>70, 'G'=>71, 'H'=>72, 'I'=>73, 'J'=>74,
            'K'=>75, 'L'=>76, 'M'=>77, 'N'=>78, 'O'=>79, 'P'=>80, 'Q'=>81, 'R'=>82, 'S'=>83, 'T'=>84,
            'U'=>85, 'V'=>86, 'W'=>87, 'X'=>88, 'Y'=>89, 'Z'=>90
        };
        base64CharCodes = new Map<String, Integer>();

        // All lower cases
        Set<String> pUpperCase = alphaNumCharCodes.keySet();
        for(String pKey : pUpperCase) {
            // Difference between upper case and lower case is 32
            alphaNumCharCodes.put(pKey.toLowerCase(), alphaNumCharCodes.get(pKey) + 32);
            // Base 64 alpha starts from 0 (The ascii charcodes started from 65)
            base64CharCodes.put(pKey, alphaNumCharCodes.get(pKey) - 65);
            base64CharCodes.put(pKey.toLowerCase(), alphaNumCharCodes.get(pKey)-(65)+26);
        }

        // Numerics
        for(Integer i=0; i<=9; i++) {
            alphaNumCharCodes.put(String.valueOf(i), i+48);
            // Base 64 numeric starts from 52
            base64CharCodes.put(String.valueOf(i), i+52);
        }
        base64CharCodes.put('+', 62);
        base64CharCodes.put('/', 63);
    }
    

    public List<Integer> testBits(String pValidFor, List<Integer> nList) {
        
        List<Integer> results = new List<Integer>();
        List<Integer> pBytes = new List<Integer>();
        Integer bytesBeingUsed = (pValidFor.length() * 6) / 8;
        Integer pFullValue = 0;
        if(bytesBeingUsed <= 1)
            return results;
        for(Integer i=0; i<pValidFor.length(); i++) {
            pBytes.Add(base64CharCodes.get((pValidFor.Substring(i, i+1))));
            
        }
        System.debug(pBytes);
        System.debug(pBytes.size());
        for(Integer i=0; i<pBytes.size(); i++) {
            Integer pShiftAmount = (pBytes.size() - (i+1)) * 6; // Used to shift by a factor 6 bits to get the value
            pFullValue = pFullValue + (pBytes[i] << (pShiftAmount));
        }

        Integer bit;
        Integer targetOctet;
        Integer shiftBits;
        Integer tBitVal;
        Integer n;
        Integer nListSize = nList.size();

        for(Integer i=0; i<nListSize; i++) {
            n = nList[i];
            bit = 7 - (Math.mod(n,8));
            targetOctet = (bytesBeingUsed - 1) - (n >> bytesBeingUsed);
            shiftBits = (targetOctet * 8) + bit;
            tBitVal = ((Integer)(2 << (shiftBits-1)) & pFullValue) >> shiftBits;
            if (tBitVal==1)
                results.add(n);
            
        }
        System.debug(results);
        return results;
    }
}
*/