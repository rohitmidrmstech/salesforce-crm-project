/**********************************************************************
Name:  WOD_TestDataFactory
===============================================================
Purpose: Test data set up class                                                                                                               
===============================================================
===============================================================
History                                                            
-------                                                            
  AUTHOR            DATE            DETAIL                        
  Pintoo Jadaun     14/04/2021      INITIAL DEVELOPMENT            
***********************************************************************/
@isTest
public class WOD_TestDataFactory {
    
    public static WOD_2__Claim__c CreateClaim(String recTypeDevName,String claimType,String accId,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Claim__c' limit 1].Id;
        WOD_2__Claim__c claim = new WOD_2__Claim__c(First_Name__c='Test',Last_Name__c='Claim',Address_1__c='Okaya 1',Address_2__c='Okaya 2',City__c='Noida',
                                                  Country__c='United States',Custom_State__c='UP',Phone__c='9999999999',Zip_Code_Postal_Code__c='201308',Invoice_Number__c='INV_001',
                                                  WOD_2__Date_of_Failure__c=system.today(),Defect_Details__c='N/A',material_quantity__c=100,WOD_2__Claim_Type__c=claimType,
                                                  customer__c =accId,Business_Units__c= bu,recordTypeId =recTypeId );
        return claim;
    }
    
    public static Account createAccount(string accountName, string accountCategory, string accountType){
        Account acc = new Account();
        acc.name = accountName;
        acc.WOD_2__Warranty_Account_Type__c = accountType;
         acc.Property_Account_External_Id__c= accountName;
        return acc;
    }
    
    public static Contact createContact(string firstName, string lastName, id accountId, boolean isPrimary){
        contact con = new contact();
        con.firstName = firstName;
        con.lastName = lastName;
        con.accountId = accountId;
        return con;
    }
    public static WOD_2__Warranty_Product__c createWarrantyProduct(string productName, string productCode, boolean isActive, string trackType, string productType, string ItemType, string uom){
        WOD_2__Warranty_Product__c product = new WOD_2__Warranty_Product__c();
        
        product.WOD_2__Product_Name__c = productName;
        product.WOD_2__Track_Type__c = trackType;
        product.WOD_2__Type__c = productType;
        product.WOD_2__Item_Type__c = ItemType;
        product.WOD_2__Units_of_Measure__c = uom;
        product.Name = productCode;
        return product;
    }
    public static WOD_2__Warranty_Code__c createWarrantyCode(String wCodeName,Id wpID){
        WOD_2__Warranty_Code__c warrantyCode = new WOD_2__Warranty_Code__c();
        warrantyCode.Name = wCodeName;
        warrantyCode.Warranty_Product__c = wpID;
        warrantyCode.WOD_2__Standard_Labor_Hour__c =10;
        return warrantyCode;      
    }
    public static WOD_2__WOD__c createWODCustomSetting_ForEnableWarrantyRuleCriteriaTrigger(){
        return new WOD_2__WOD__c(name='Enable WarrantyRuleCriteriaTrigger',WOD_2__isTriggered__c = true);
    }
    public static WOD_ZipFile__c createZipFile(String bu,String name){
        WOD_ZipFile__c zipFIle = new WOD_ZipFile__c();
        zipFIle.Name = name;
        zipFIle.Business_Unit__c = bu;
        zipFIle.Status__c = true;
        return zipFIle;      
    }
    public static WOD_2__Business_Category_Configuration__c createBusinessCategoryConfig(String buName){
        WOD_2__Business_Category_Configuration__c bcc = new WOD_2__Business_Category_Configuration__c();
        bcc.Name= buName;
        return bcc;
    }
    public static WOD_2__Warranty_Registration__c createWarrantyRegistration(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
    public static WOD_2__Warranty_Registration__c createWarrantyRegistrationsolar(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,Division__c='Solar',WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
    public static WOD_2__Warranty_Registration__c createWarrantyRegistrationroofing(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,Division__c='Residential',WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
    public static WOD_2__Warranty_Registration__c createWarrantyRegistrationsiding(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,Division__c='SPG Stone',WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
     public static WOD_2__Warranty_Registration__c createWarrantyRegistrationsiding1(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,Division__c='SPG Hardboard Siding',WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
    public static WOD_2__Warranty_Registration__c createWarrantyRegistrationsiding2(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,Division__c='SPG Millwork',WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
    public static WOD_2__Warranty_Registration__c createWarrantyRegistrationsiding3(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,Division__c='SPG Fence',WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
    public static WOD_2__Warranty_Registration__c createWarrantyRegistrationsiding4(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,Division__c='SPG Railing',WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
    public static WOD_2__Warranty_Registration__c createWarrantyRegistrationsiding5(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,Division__c='SPG Deck',WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
    
    public static WOD_2__Warranty_Registration__c createWarrantyRegistrationCBI(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_2__Warranty_Registration__c' limit 1].Id;
        //Id buId = [select Id from RecordType where DeveloperName =:bu and SobjectType = 'WOD_2__Business_Category_Configuration__c' limit 1].Id;
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(RecordTypeId =recTypeId,Name='WR',Last_Name__c='Registration',Address_1__c='Okaya 1',
        Address_2__c='Okaya 2',City__c='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',Email__c='aa@mail.com',Phone__c='9999999999',
         Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c =true,Property_Type__c='Residential',Building_Type__c='Other',Organisation_BL__c='Tavant',
        First_Name_BL__c='WR',Last_Name_BL__c='Registration',Address_1_BL__c='Okaya 1',Address_2_BL__c ='Okaya 2',City_BL__c ='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c ='United States',Is_New_Construction__c = true,Install_Date__c=System.Today(),Product_Group__c='Solar',Product_Detail__c='details',Quantity__c=1,Unit_of_Measure__c='LB',
        installation_Location__c='Other',Installation_Location_other__c='other',Business_Units__c =bu,Division__c='Commercial',WOD_2__Registration_Date__c =System.Today(),WOD_2__Registration_Type__c='Residential');         
        return wr;      
    }
    public static WOD_Warranty_Transfer__c createWarrantyTransfer(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_Warranty_Transfer__c' limit 1].Id;
        WOD_Warranty_Transfer__c wt = new WOD_Warranty_Transfer__c(RecordTypeId =recTypeId,First_Name__c='Wt',Last_Name__c ='Transfer',
        Address_1__c='Okaya 1',Address_2__c ='Okaya 2',City__c ='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',     Email__c='a@mail.com',Phone__c='9999999999',Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c = true,
        Property_Type__c ='Residential',Building_Type__c ='Other',Organisation_BL__c='Tavant',First_Name_BL__c='Wt',Last_Name_BL__c='Transfer',
        Address_1_BL__c='Okaya 1',Address_2_BL__c='Okaya 2',City_BL__c='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c='United States',Is_New_Construction__c = true,Install_Date__c =System.Today(),Transfered_Date__c = System.Today(),Product_Group__c='Solar',
        Product_Detail__c='details',Quantity__c =1,Unit_of_Measure__c='LB',installation_Location__c ='Other',Installation_Location_other__c='Other',Business_Units__c =bu);
        return wt;
    }
    public static WOD_Warranty_Transfer__c createWarrantyTransfersolar(String recTypeDevName,String bu){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_Warranty_Transfer__c' limit 1].Id;
        WOD_Warranty_Transfer__c wt = new WOD_Warranty_Transfer__c(RecordTypeId =recTypeId,First_Name__c='Wt',Last_Name__c ='Transfer',
        Address_1__c='Okaya 1',Address_2__c ='Okaya 2',City__c ='Noida',State__c='Florida (FL)',Postal_Code__c='201308',Country__c='United States',     Email__c='a@mail.com',Phone__c='9999999999',Organisation__c='Tavant',Is_New_Construction_Mailing_Address__c = true,
        Property_Type__c ='Residential',Building_Type__c ='Other',Organisation_BL__c='Tavant',First_Name_BL__c='Wt',Last_Name_BL__c='Transfer',
        Address_1_BL__c='Okaya 1',Address_2_BL__c='Okaya 2',City_BL__c='Noida',State_BL__c='Florida (FL)',Postal_Code_BL__c='201308',
        Country_BL__c='United States',Is_New_Construction__c = true,Install_Date__c =System.Today(),Transfered_Date__c = System.Today(),Product_Group__c='Solar',
        Product_Detail__c='details',Quantity__c =1,Division__c='Solar',Unit_of_Measure__c='LB',installation_Location__c ='Other',Installation_Location_other__c='Other',Business_Units__c =bu);
        return wt;
    }
    public static WOD_Payment__c createPayment(String recTypeDevName,String saleOrg,String claimId,String settlemtType,String remitTo){
        Id recTypeId = [select Id from RecordType where DeveloperName =:recTypeDevName and SobjectType = 'WOD_Payment__c' limit 1].Id;
        WOD_Payment__c payment = new WOD_Payment__c(RecordTypeId =recTypeId,Sales_Org__c=saleOrg,Claim__c=claimId,Settlement_Type__c=settlemtType,Remit_To__c=remitTo);
        return payment;
    } 
    public static WOD_Payment_Line__c createPaymentLine(String paymentId){
        WOD_Payment_Line__c pl = new WOD_Payment_Line__c(Payment__c = paymentId,Quantity__c =1);
        return pl;
    }
    public static WOD_Manufacturing_Plant__c createManufacturingPlant(string settlementType,String plantcode,String companyCode){
        WOD_Manufacturing_Plant__c plant = new WOD_Manufacturing_Plant__c(Warranty_Settelemt_Type__c =settlementType,Plant_Code__c=plantcode,Company_Code__c=companyCode);
        return plant;
    }
    public static Plants__c createPlant(string pName,String planCode){
        Plants__c p =new Plants__c(Name =pName,SAP_Plant__c=planCode);
        return p;        
    }
    public static Pitch_Cost__c createPitchCost(){
        Pitch_Cost__c pc = new Pitch_Cost__c(Pitch_of_Roof__c=1,Cost_per_Square__c=10);
        return pc;
    }
    public static WOD_2__Policy_Definition__c createPolicyDefination(){
        WOD_2__Policy_Definition__c plcyDef =new WOD_2__Policy_Definition__c(Name = 'testplDf1',WOD_2__Active_From__c = System.today().addDays(-30),
        WOD_2__Active_Until__c = System.today().addDays(40),WOD_2__Priority__c = 1,WOD_2__Months_Covered__c = 15,WOD_2__Type__c = 'Standard',WOD_2__Status__c = 'Active');       
        return plcyDef;
    }
    public static WOD_RSMeans__c createRSMeans(){
        WOD_RSMeans__c rs = new WOD_RSMeans__c(State__c ='Florida (FL)',Zip__c='201',Location_Factor__c=1.1);
        return rs;
    }
    public static Product_Type__c createProductType(){
        Product_Type__c prod = new Product_Type__c(Name='Warranty',Warranty_Labor_Cost__c=10,Warranty_Material_Cost__c=10,Steep_Pitch__c=10,Demolish_Tearoff__c=10,Additional_Story__c=10);
        return prod;
    }
    public static WOD_Claim_Interested_Parties__c createInterestedParty(String claimId,String type){
        WOD_Claim_Interested_Parties__c intParty = new WOD_Claim_Interested_Parties__c(Country__c ='United States',Zip_Code__c ='12345',Name='Test',Claim__c =claimId,Type__c = type);
        return intParty;
    }
    public static Territory__c createTerritory(){
        Territory__c t = new Territory__c(Sales_Org__c='1501',Territory_Code__c='aaa',Sales_Rep__c= UserInfo.getUserId());
        return t;
    }
}