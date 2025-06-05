/**
 * @description To Handle Inventory Transfer
*/
public without sharing class wod_CTInventoryTransferController {
    
    public sobject warrantyRegistration { get; set; }
    public WOD_Warranty_Transfer__c wtt { get; set; }
    public WOD_2__Warranty_Registration__c wrt { get; set; }
    public boolean exceptionCheck { get; set; }
    public string trackingNumber { get; set; }
    
    public List<Attachment> newAttachments {get; set;}
    public List<Attachment> newAttachmentsCopied {get; set;}
    public Account acc { get; set; }
    //public static twod_CTUtil.validateBuildingLocationAddress valAddress{get;set;}
    public String propertyType {get; set;}
    public String Organization {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String address1 {get; set;}
    public String address2 {get; set;}
    public String email {get; set;}
    public String phone {get; set;}
    public String city {get; set;}
    public String state {get; set;}
    public String country {get; set;}
    public String postalcode {get; set;}
    //Transfer
    public String BL_firstName {get; set;}
    public String BL_lastName {get; set;}
    public String BL_address1 {get; set;}
    public String BL_address2 {get; set;}
    public String BL_email {get; set;}
    public String BL_phone {get; set;}
    public String BL_city {get; set;}
    public String BL_state {get; set;}
    public String BL_country {get; set;}
    public String BL_postalcode {get; set;}
    public String BuildingType {get; set;}
    public String ProductName {get; set;}
    public String ProductGroup {get; set;}
    public String UnitsOfMeasure {get; set;}
    public Date installedDate{get;set;}
    public Date TransferedDate{get;set;}
    public integer Quantity {get; set;}
    public String ProductDetail {get; set;}
    public String InstallationLocation {get; set;}
    public String InstallationLocationOther {get; set;}
    public String errorMessage {get; set;}
    public String errorMessage1 {get; set;}
    public String recordType {get; set;}
    public String url {get; set;}
    public Boolean render {get; set;}
    public Boolean attachmentRender {get ;  set ; }
    public boolean isSiding{get; set;}
    public boolean isRoofing{get; set;}  
    public boolean print;
    /**
     * @description Constructor
    */
    public wod_CTInventoryTransferController() {
        render = false;
        exceptionCheck = true;
        try{
            String name = ApexPages.currentPage().getParameters().get('trackingNumber');
            print = boolean.valueOf(ApexPages.currentPage().getParameters().get('printPdf'));
            String recId = ApexPages.currentPage().getParameters().get('id');
            system.debug('==========='+print);
            system.debug('==========='+recId);
            //recordType = ApexPages.currentPage().getParameters().get('type');
            if(name.contains('WT')){
                recordType = 'transfer';
            }
            system.debug('recordType::::'+recordType);
            render=false;
            if(recordType=='transfer')
            {
                render=true;
                system.debug('render::::'+render);
                warrantyRegistration = [SELECT First_Name_BL__c,Last_Name_BL__c,Address_1_BL__c,Address_2_BL__c,City_BL__c,Country_BL__c,State_BL__c,Postal_Code_BL__c,First_Name__c,Phone__c,
                                        Name,Last_Name__c,Quantity__c,Transfered_Date__c,Address_1__c,Address_2__c,Building_Type__c,Business_Units__c,City__c,Country__c,Install_Date__c,
                                        Email__c,Unit_of_Measure__c,Organisation__c,Organisation_BL__c,
                                        Installation_Location__c,Property_Type__c,Postal_Code__c,Product_Detail__c,Product_Group__c,State__c FROM WOD_Warranty_Transfer__c where Name =:name and Id =:recId LIMIT 1];
                wtt = (WOD_Warranty_Transfer__c)warrantyRegistration;
                address2 = wtt.Address_2__c;
                BL_address2 = wtt.Address_2_BL__c;
                propertyType=wtt.Property_Type__c;
                if(wtt.Business_Units__c == 'Siding'){
                    isSiding =true;
                }else{
                    isRoofing = true;
                }
                
            }
            else
            {
                system.debug('inside if');
                
                warrantyRegistration = [SELECT WR_Tracking_Number__c,Quantity__c,First_Name_BL__c,Last_Name_BL__c,Address_1_BL__c,Address_2_BL__c,City_BL__c,Country_BL__c,State_BL__c,Postal_Code_BL__c,
                                        Name,Last_Name__c,Email__c,Property_Type__c,Transfered_Date__c,Address_1__c,Address_2__c,Building_Type__c,Business_Units__c,Phone__c,City__c,Country__c,Install_Date__c,
                                        Installation_Location__c,Postal_Code__c,Organisation__c,Product_Detail__c,Product_Group__c,State__c ,
                                        WOD_2__Registration_Date__c,Unit_of_Measure__c,Organisation_BL__c
                                        FROM WOD_2__Warranty_Registration__c where WR_Tracking_Number__c = :name  and Id =:recId LIMIT 1];
                
                wrt = (WOD_2__Warranty_Registration__c)warrantyRegistration;
                trackingNumber = wrt.WR_Tracking_Number__c;
                address2 = wrt.Address_2__c;
                BL_address2 = wrt.Address_2_BL__c;
                propertyType=wrt.Property_Type__c;
                if(wrt.Business_Units__c == 'Siding'){
                    isSiding =true;
                }else{
                    isRoofing = true;
                }
            }
            url=ApexPages.currentPage().getUrl();
            system.debug('url-->' + url);
            
        }catch(Exception e){
            exceptionCheck = false;
            if(e.getMessage().equals('List has no rows for assignment to SObject')){
                ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.Error, 'Error while fetching details, Please contact Admin. ' + 'No Record Found with details mentioned' ));
                return;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.Error, 'Error while fetching details, Please contact Admin. ' + e.getMessage() ));
                return;
            }
        }
        saveToPdf();
        render = render;
    }
    /**
	 * @description to download Inventory Transfer
	 * @return PageReference
	*/
    public PageReference download()
    {
        PageReference pg1 =new PageReference('/apex/CTDownload');
        return pg1;    
    }
    /**
	 * @description Determines what kind of rendering to use for the page request
	*/
    public String renderingService { get; private set; }
    /**
	 * @description Allow the page to set the PDF file name
	*/
    public String renderedFileName { 
        get; 
        set { renderedFileName = this.sanitizeFileName(value); }
    }
    /**
	 * @description Rendered content MIME type, used to affect HTTP response
	*/
    public String renderedContentType {
        get {
            String renderedContentType = 'text/html'; // the default
            
            if( ! this.renderingAsHtml() ) {
                // Provides a MIME type for a PDF document 
                renderedContentType = 'application/pdf';
                
                // Add a file name for the PDF file
                if( this.renderedFileName != null) {
                    // This is supposed to set the file name, but it doesn't work
                    renderedContentType += '#' + this.renderedFileName;
                    
                    // This is a work-around to set the file name
                    ApexPages.currentPage().getHeaders().put(
                        'content-disposition', 'attachment; filename=' + 
                        this.renderedFileName);
                }
            }
            
            return renderedContentType;
        }
    }
    
    /**
	 * @description Are we rendering to HTML or PDF?
	*/
    public Boolean renderingAsHtml() {
        return ( (renderingService == null) || 
                ( ! renderingService.startsWith('PDF')) );
    }
    /**
	 * @description Action method to save (or "print") to PDF
	*/
    public PageReference saveToPdf() {
        renderingService = 'PDF';
        if(!print){
            if(render)
            {
                renderedFileName='WarrantyTransfer-'+ wtt.Name +'.pdf'; 
            }
            else
            {
                renderedFileName='WarrantyRegistration-'+ wrt.WR_Tracking_Number__c+'.pdf';   
            }
            String s=this.renderedContentType;
        }
        
        return null;
    }
    
    /**
	 * @description Private helper -- basic, conservative santization
     * @param unsafeName input file name
     * @return resultant file name
	*/
    public String sanitizeFileName(String unsafeName) {
        String allowedCharacters = '0-9a-zA-Z-_.';
        String sanitizedName = 
            unsafeName.replaceAll('[^' + allowedCharacters + ']', '');
        // You might also want to check filename length, 
        // that the filename ends in '.pdf', etc.
        return(sanitizedName);
    }
    
    
    
}