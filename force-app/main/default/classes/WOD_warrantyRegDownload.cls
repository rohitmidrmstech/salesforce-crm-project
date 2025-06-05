public without sharing class  WOD_warrantyRegDownload {
    public static String renderingService { get; set; }
    // Allow the page to set the PDF file name
    public static String renderedFileName { 
        get; 
        set { renderedFileName = sanitizeFileName(value); }
    }
    @TestVisible
        // Rendered content MIME type, used to affect HTTP response
    public static  String renderedContentType {
        get {
            String renderedContentType = 'text/html'; // the default
            
            //if( ! this.renderingAsHtml() ) {
                // Provides a MIME type for a PDF document 
                renderedContentType = 'application/pdf';
                
                // Add a file name for the PDF file
                if( renderedFileName != null) {
                    // This is supposed to set the file name, but it doesn't work
                    renderedContentType += '#' + renderedFileName;
                    
                    // This is a work-around to set the file name
                    ApexPages.currentPage().getHeaders().put(
                        'content-disposition', 'attachment; filename=' + 
                        renderedFileName);
                }
           // }
            
            return renderedContentType;
        }
    }
    @AuraEnabled
    public static void saveToPdf(String warrantyRegistrationNum) {
        system.debug('warrantyRegistrationNum'+warrantyRegistrationNum);
      /*  system.debug('=========>getsaveToPdf'); 
        renderingService = 'PDF';
        
        /*if(render)
        {
           renderedFileName='WarrantyTransfer-'+ wtt.Name +'.pdf'; 
        }
        else
        {*/
        //  renderedFileName='WarrantyRegistration-'+'.pdf';   
        //}
        //String s=renderedContentType;
        //return null;  
    }
    
    public static String sanitizeFileName(String unsafeName) {
        String allowedCharacters = '0-9a-zA-Z-_.';
        String sanitizedName = 
            unsafeName.replaceAll('[^' + allowedCharacters + ']', '');
        // You might also want to check filename length, 
        // that the filename ends in '.pdf', etc.
        return(sanitizedName);
    }
    @AuraEnabled
    public static wrapper getEntireData(String warrantyRegistrationNum) {
        system.debug('==========='+warrantyRegistrationNum);
         wrapper w = new wrapper();
        if(warrantyRegistrationNum != null && warrantyRegistrationNum != ''){
            if(warrantyRegistrationNum.contains('WR')){
                WOD_2__Warranty_Registration__c  wrData = [SELECT WR_Tracking_Number__c,Quantity__c,First_Name_BL__c,Last_Name_BL__c,Address_1_BL__c,
                                                    Address_2_BL__c,City_BL__c,Country_BL__c,State_BL__c,Postal_Code_BL__c,
                                                           Name,Last_Name__c,Transfered_Date__c,Address_1__c,Address_2__c,Building_Type__c,Business_Units__c,
                                                           City__c,Country__c,Install_Date__c,Installation_Location__c,Postal_Code__c,Product_Detail__c,Product_Group__c,State__c 
                                                           FROM WOD_2__Warranty_Registration__c where WR_Tracking_Number__c =:warrantyRegistrationNum LIMIT 1];
               
                w.aw.firstName = wrData.Name;
                w.aw.lastName = wrData.Last_Name__c;
                w.aw.address1 = wrData.Address_1__c;
                w.aw.address2 = wrData.Address_2__c;
                w.aw.cityName = wrData.City__c;
                w.aw.state = wrData.State__c;
                w.aw.postalCode = wrData.Postal_Code__c;     
                w.aw.country = wrData.Country__c;
                w.bw.firstName = wrData.First_Name_BL__c;
                w.bw.lastName = wrData.Last_Name_BL__c;
                w.bw.address1 = wrData.Address_1_BL__c;
                w.bw.address2 = wrData.Address_2_BL__c;
                w.bw.cityName = wrData.City_BL__c;
                w.bw.state = wrData.State_BL__c;
                w.bw.postalCode = wrData.Postal_Code_BL__c;     
                w.bw.country = wrData.Country_BL__c;
                w.selectedInstallDate = wrData.Install_Date__c;
                w.selectedTransferDate = wrData.Transfered_Date__c;
                w.selectedProductGroup = wrData.Product_Group__c;
                w.quantity = string.valueof(wrData.Quantity__c);
                w.productDetailVal = wrData.Product_Detail__c;
                w.showWRThankYouText = true;
               if(wrData.Business_Units__c == 'Siding'){
                    w.showWRThankYouHeaderTextSliding = true;
                }else{
                    w.showWTThankYouHeaderTextRoofing = true;
                }
            }else{
                WOD_Warranty_Transfer__c  wrData = [SELECT First_Name_BL__c,Last_Name_BL__c,Address_1_BL__c,Address_2_BL__c,City_BL__c,Country_BL__c,State_BL__c,Postal_Code_BL__c,
                                                           Name,Last_Name__c,Quantity__c,Transfered_Date__c,Address_1__c,Address_2__c,Building_Type__c,Business_Units__c,City__c,Country__c,Install_Date__c,
                                                           Installation_Location__c,Postal_Code__c,Product_Detail__c,Product_Group__c,State__c FROM WOD_Warranty_Transfer__c where Name =:warrantyRegistrationNum LIMIT 1];
                w.aw.firstName = wrData.Name;
                w.aw.lastName = wrData.Last_Name__c;
                w.aw.address1 = wrData.Address_1__c;
                w.aw.address2 = wrData.Address_2__c;
                w.aw.cityName = wrData.City__c;
                w.aw.state = wrData.State__c;
                w.aw.postalCode = wrData.Postal_Code__c;     
                w.aw.country = wrData.Country__c;
                w.bw.firstName = wrData.First_Name_BL__c;
                w.bw.lastName = wrData.Last_Name_BL__c;
                w.bw.address1 = wrData.Address_1_BL__c;
                w.bw.address2 = wrData.Address_2_BL__c;
                w.bw.cityName = wrData.City_BL__c;
                w.bw.state = wrData.State_BL__c;
                w.bw.postalCode = wrData.Postal_Code_BL__c;     
                w.bw.country = wrData.Country_BL__c;
                w.selectedInstallDate = wrData.Install_Date__c;
                w.selectedTransferDate = wrData.Transfered_Date__c;
                w.selectedProductGroup = wrData.Product_Group__c;
                w.quantity = string.valueof(wrData.Quantity__c);
                w.productDetailVal = wrData.Product_Detail__c;
                w.showWTThankYouText = true;
                if(wrData.Business_Units__c == 'Siding'){
                    w.showWRThankYouHeaderTextSliding = true;
                }else{
                    w.showWTThankYouHeaderTextRoofing = true;
                }
                
            }
        }
       return w;
    }
    public class addressWarapper{
        @AuraEnabled
        public String firstName;
        @AuraEnabled
        public string lastName;
        @AuraEnabled
        public string address1;
        @AuraEnabled
        public String address2;
        @AuraEnabled
        public string cityName;
        @AuraEnabled
        public string state;
        @AuraEnabled
        public String postalCode;
        @AuraEnabled
        public string country;
        
    }
    public class buildingAddressWarapper{
        @AuraEnabled
        public String firstName;
        @AuraEnabled
        public string lastName;
        @AuraEnabled
        public string address1;
        @AuraEnabled
        public String address2;
        @AuraEnabled
        public string cityName;
        @AuraEnabled
        public string state;
        @AuraEnabled
        public String postalCode;
        @AuraEnabled
        public string country;
        
    }
    public class wrapper{
        @AuraEnabled
        public buildingAddressWarapper bw;
        @AuraEnabled
        public addressWarapper aw;
        @AuraEnabled
        public date selectedInstallDate;
        @AuraEnabled
        public date selectedTransferDate;
        @AuraEnabled
        public string selectedProductGroup;
        @AuraEnabled
        public string quantity;
        @AuraEnabled
        public string productDetailVal;
        @AuraEnabled
        public boolean showWTThankYouHeaderTextRoofing = false;
        @AuraEnabled
        public boolean showWRThankYouHeaderTextSliding = false;
        @AuraEnabled
        public boolean showWRThankYouText = false;
        @AuraEnabled
        public boolean showWTThankYouText = false;
        wrapper(){
            bw = new buildingAddressWarapper();
            aw = new addressWarapper();
            
        }
    }

}