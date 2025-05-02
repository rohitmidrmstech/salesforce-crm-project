public class beforeInsertRiskScapeData {
     public static void beforeInsert(List<RiskScapeIds__c> records) {
        for (RiskScapeIds__c record : records) {
            String idToValidate = record.Name;
            Boolean isId = idToValidate instanceof Id;
            if(isId){
                record.isValidId__c= true;
            } else {
                 record.isValidId__c= false;
            }
             System.debug(idToValidate+ '  ' + isId);
        }
            // Perform the validation
           /* if (isValidId(idToValidate)) {
                record.isValidId__c = true;
            } else {
                record.isValidId__c = false;
            }*/
      
    }

    Public static Boolean isValidId(String id) {
        // Check if the ID is either 15 or 18 characters long and contains at least one digit and one letter
    Pattern pattern = Pattern.compile('^(?=.*[0-9])(?=.*[a-zA-Z])[a-zA-Z0-9]{15}$|^(?=.*[0-9])(?=.*[a-zA-Z])[a-zA-Z0-9]{18}$');
              //  Pattern pattern = Pattern.compile('^[a-zA-Z0-9]{15}$|^[a-zA-Z0-9]{18}$');

        Matcher matcher = pattern.matcher(id);
        
        return matcher.matches();
    }

}