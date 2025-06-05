/**
 * @description To Manage Payments related things
*/
public class WOD_PaymentManager {
    /**
     * @description Wrapper class
    */
    public class PriceWrapper{
        public decimal Price {get; private set;}
        public decimal OriginalPrice{get; private set;}
        public decimal LocationFactor {get; private set;}
        /**
         * @description Contructor
        */
        public PriceWrapper(decimal originalPrice, decimal locationFactor){
            this.Price= originalPrice * locationFactor;
            this.OriginalPrice =  originalPrice;
            this.LocationFactor = locationFactor;
        }
    }
    Decimal monthsCovered;
    /**
     * @description To get labor cost- Settlement types are RSL, STP,TOF,2ND Story
     * @param isRoofing Flag for Roofing BU
     * @param productId Warranty Product Id
     * @param state State 
     * @param zip Zip Code
     * @param city City
     * @param steepPitch Flag for Steep Pitch
     * @param addStory Flag for addStory
     * @param demolishTearOff Flag
     * @return Wrapper class
    */
    public static PriceWrapper GetLaborCost(boolean isRoofing, string productId, string state, string zip, string city, boolean steepPitch, boolean addStory, boolean demolishTearOff){
        decimal costPerSquare;
        decimal locationFactor = GetLocationFactor(state, zip, city);
        system.debug('Value of ProductID ' + productId);
        Map<string,string> warrantyProductMap = WOD_WarrantyProductWrapper.getProductDetails(productId, true);
        
        if(isRoofing){
            if(string.isEmpty(warrantyProductMap.get('LaborCost')))
                throw new WOD_IntegrationException('Labor cost not defined for the selected product');
            
            costPerSquare = decimal.valueOf(warrantyProductMap.get('LaborCost')) ;
            System.debug(steepPitch+'steepPitch'+warrantyProductMap.get('SteepPitch'));
            if(steepPitch && !string.isEmpty(warrantyProductMap.get('SteepPitch')))
                  costPerSquare = decimal.valueOf(warrantyProductMap.get('SteepPitch'));
            if(addStory && !string.isEmpty(warrantyProductMap.get('AdditionalStory')))
                costPerSquare = decimal.valueOf(warrantyProductMap.get('AdditionalStory'));
            if(demolishTearOff && !string.isEmpty(warrantyProductMap.get('DemolishTearOff')))
                costPerSquare = decimal.valueOf(warrantyProductMap.get('DemolishTearOff'));
        }else{
            warrantyProductMap = WOD_WarrantyProductWrapper.getProductDetails(productId, false);
                
            decimal reductionFactor;
            if(string.isEmpty(warrantyProductMap.get('ReductionFactor')))
                throw new WOD_IntegrationException('Reduction Factor not specified for the product');
            else
                reductionFactor = decimal.valueOf(warrantyProductMap.get('ReductionFactor'));
            decimal demolishReinstall;
            if(string.isEmpty(warrantyProductMap.get('DemolishReinstall'))){
                throw new WOD_IntegrationException('Demolish Reinstall not specified for the product');
            }
            else{
                demolishReinstall = decimal.valueOf(warrantyProductMap.get('DemolishReinstall'));
            }
            decimal cedarImpressionFactor=0;
            if(string.isNotEmpty(warrantyProductMap.get('CedarImpressionFactor')))
                cedarImpressionFactor = decimal.valueOf(warrantyProductMap.get('CedarImpressionFactor'));
            System.debug('locationFactor==>'+locationFactor +'reductionFactor==>'+reductionFactor+'demolishReinstall==>'+demolishReinstall+'cedarImpressionFactor==>'+cedarImpressionFactor);
            costPerSquare = (locationFactor - reductionFactor) * demolishReinstall;
            if(cedarImpressionFactor <> 0)
                costPerSquare = costPerSquare * cedarImpressionFactor;
                
            PriceWrapper wrapper = new PriceWrapper(costPerSquare, 1);
            return wrapper;
        }
        
        PriceWrapper wrapper = new PriceWrapper(costPerSquare, locationFactor);
        return wrapper;
    } 
    
    /**
     * @description To get the location factor from RSMeans object
     * @param state State
     * @param zip Zip Code
     * @param city City
     * @return Decimal value
    */
    private static decimal GetLocationFactor(string state, string zip, string city){
        System.debug(state+'======'+zip); 
        List<WOD_RSMeans__c> rs;          
        //ZIP will be empty for Canadian states.
        if(!string.isEmpty(zip)){
            string zipLike = zip.left(3);
            rs = [Select Location_Factor__c from WOD_RSMeans__c Where Zip__c=:zipLike];
        }else{
            rs = [Select Location_Factor__c from WOD_RSMeans__c Where State__c= :state ];
        }
                
        if(rs.size() == 0){
            throw new WOD_IntegrationException('Unable to Fetch Location factor for the given address');
        }
        system.debug('Location Factor' +  rs[0].Location_Factor__c);
        return rs[0].Location_Factor__c;
    }
    
    /**
     * @description To get material cost for Roofing from Product Structure.- Settlement - RSM
     * @param state State
     * @param zip Zip Code
     * @param city City
     * @param productId Warranty Product Id
     * @return Wrapper class
    */
    public static PriceWrapper GetMaterialCost(string state, string zip, string city, string productId){
        decimal locationFactor = GetLocationFactor(state, zip, city);
        Map<string,string> warrantyProductMap = WOD_WarrantyProductWrapper.getProductDetails(productId, true);
        if(warrantyProductMap.get('MaterialCost')!=null)
        return new PriceWrapper(decimal.valueOf(warrantyProductMap.get('MaterialCost')),  locationFactor);
        else return new PriceWrapper(0.0,  0.0);
    }
    
    /**
     * @description To get Settlement types- ALG,HAN,HAP
     * @param pitch pitch value
     * @return Decimal value
    */
    public static decimal GetPitchRoofCost(integer pitch){
        List<Pitch_Cost__c> pitchCost = [Select Cost_per_Square__c from Pitch_Cost__c Where Pitch_of_Roof__c =:pitch AND Settlement_Type__c != 'HAN' AND Settlement_Type__c != 'HAP'];
        
        if(pitchCost.size() == 0){
            return null;
        }
        return pitchCost[0].Cost_per_Square__c;
     }

     public static decimal GetPitchRoofCostwithSType(integer pitch, string stype){
        List<Pitch_Cost__c> pitchCost = [Select Cost_per_Square__c from Pitch_Cost__c Where Pitch_of_Roof__c =:pitch And Settlement_Type__c =:stype] ;
        
        if(pitchCost.size() == 0){
            return null;
        }
        return pitchCost[0].Cost_per_Square__c;
     }
     
     /*public static decimal GetProrateMaterialCost(string claimId){
        WOD_2__Claim__c claim = [Select Install_Date__c, CreatedDate, WOD_2__Applicable_Policy__r.Maxiumum_Liability__c, WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c from WOD_2__Claim__c Where id=:claimId];
        if(claim.WOD_2__Applicable_Policy__r == null){
            throw new WOD_IntegrationException('There is no applicable policy for the claim');
        }
        if(claim.WOD_2__Applicable_Policy__r.Maxiumum_Liability__c == null){
            throw new WOD_IntegrationException('Maximum Liability not defined for the Policy');
        }
        
        integer monthsUsed = claim.Install_Date__c.MonthsBetween(claim.CreatedDate.date());
        integer monthsRemaining = integer.valueof(calculateMonthsCovered(claim)) - monthsUsed;
        return (monthsRemaining/calculateMonthsCovered(claim))*claim.WOD_2__Applicable_Policy__r.Maxiumum_Liability__c;
     }
   
      public static decimal GetProrateMaterialLaborCost(string claimId){
        WOD_2__Claim__c claim = [Select WOD_2__warranty_product__c, State_BL__c, Country_BL__c, Postal_code_BL__c, City_BL__c, Install_Date__c, CreatedDate, WOD_2__Applicable_Policy__r.Maxiumum_Liability__c, WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c from WOD_2__Claim__c Where id=:claimId];
        decimal laborCost;
        decimal materialCost;
        if(claim.WOD_2__Applicable_Policy__r == null){
            throw new WOD_IntegrationException('There is no applicable policy for the claim');
        }
        if(claim.Country_BL__c == 'Canada'){
            laborCost = GetLaborCost(true, claim.WOD_2__warranty_product__c, claim.State_BL__c, '', claim.City_BL__c, false,false,false).Price;
            materialCost = GetMaterialCost(claim.State_BL__c, '', claim.City_BL__c, claim.WOD_2__warranty_product__c).Price;
            
        }else{
            laborCost = GetLaborCost(true, claim.WOD_2__warranty_product__c, claim.State_BL__c, claim.Postal_code_BL__c, claim.City_BL__c, false,false,false).Price;
            materialCost = GetMaterialCost(claim.State_BL__c, claim.Postal_code_BL__c, claim.City_BL__c, claim.WOD_2__warranty_product__c).Price;
        }
                
        decimal totalCost = laborCost+materialCost;
        integer monthsUsed = claim.Install_Date__c.MonthsBetween(claim.CreatedDate.date());
        integer monthsRemaining = integer.valueof(calculateMonthsCovered(claim)) - monthsUsed;
        return (monthsRemaining/calculateMonthsCovered(claim))*totalCost;
      }
    */
    /**
     * @description To Get Prorate Material Cost
     * @param claimId Claim Id
     * @return Payment Line Object Record
    */
    public static WOD_Payment_Line__c GetProrateMaterialCost(string claimId){
        decimal materialCost;
        WOD_2__Claim__c claim = [Select WOD_2__Warranty_Product__r.Product_Type__r.Warranty_Material_Cost__c,WOD_2__warranty_product__c, Install_Date__c, 
        State_BL__c, Country_BL__c, Postal_code_BL__c, City_BL__c,CreatedDate, WOD_2__Applicable_Policy__r.Maxiumum_Liability__c, WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c,
                                WOD_2__Applicable_Policy__r.SureStart_Period__c,OwnershipType__c from WOD_2__Claim__c Where id=:claimId];
                                /*,is_Before_SureStart__c, WOD_2__Applicable_Policy__r.After_SureShort_Warranty_Period__c*/
        WOD_Payment_Line__c payLine = new WOD_Payment_Line__c();
        if(claim.WOD_2__Applicable_Policy__r == null){
            throw new WOD_IntegrationException('There is no applicable policy for the claim');
        }
        if(claim.WOD_2__Applicable_Policy__r.Maxiumum_Liability__c == null){
           materialCost = claim.WOD_2__Warranty_Product__r.Product_Type__r.Warranty_Material_Cost__c;
        }
        //Added on June 1
        else{
            materialCost = claim.WOD_2__Applicable_Policy__r.Maxiumum_Liability__c;
        }
        Decimal monthsCovered= claim.WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c;
        integer monthsUsed = claim.Install_Date__c.MonthsBetween(claim.CreatedDate.date());
        payLine.Months_Used__c = monthsUsed;        
        payLine.Months_Covered__c = monthsCovered;        
        integer monthsRemaining = integer.valueof(monthsCovered) - monthsUsed;
        system.debug('monthsUsed is ---->' + monthsUsed);
        system.debug('monthsRemaining is ---->' + monthsRemaining);
        system.debug('monthsCovered is ---->' + monthsCovered);
        system.debug('materialCost is ---->' + materialCost); 
        if(null == materialCost){
            materialCost =0;    
        }
        //payLine.Amount__c =  (monthsRemaining/monthsCovered)*claim.WOD_2__Applicable_Policy__r.Maxiumum_Liability__c;
        payLine.Amount__c =  (monthsRemaining/monthsCovered)*materialCost;
        
        return payLine;
     }
    
    /**
     * @description To Get Prorate Material Labor Cost
     * @param claimId Claim Id
     * @return Payment Line Object Record
    */
    public static WOD_Payment_Line__c GetProrateMaterialLaborCost(string claimId){
        WOD_2__Claim__c claim = [Select WOD_2__warranty_product__c, State_BL__c, Country_BL__c, Postal_code_BL__c, City_BL__c, Install_Date__c, 
        CreatedDate, WOD_2__Applicable_Policy__r.SureStart_Period__c,OwnershipType__c,
        WOD_2__Applicable_Policy__r.Maxiumum_Liability__c, WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c from WOD_2__Claim__c Where id=:claimId];
        /* is_Before_SureStart__c, WOD_2__Applicable_Policy__r.After_SureShort_Warranty_Period__c ,*/
        decimal laborCost;
        decimal materialCost;
        Decimal monthsCovered= claim.WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c;
        WOD_Payment_Line__c payLine = new WOD_Payment_Line__c();
        if(claim.WOD_2__Applicable_Policy__r == null){
            throw new WOD_IntegrationException('There is no applicable policy for the claim');
        }
        if(claim.Country_BL__c == 'Canada'){
            laborCost = GetLaborCost(true, claim.WOD_2__warranty_product__c, claim.State_BL__c, '', claim.City_BL__c, false,false,false).Price;
            materialCost = GetMaterialCost(claim.State_BL__c, '', claim.City_BL__c, claim.WOD_2__warranty_product__c).Price;
            
        }else{
            laborCost = GetLaborCost(true, claim.WOD_2__warranty_product__c, claim.State_BL__c, claim.Postal_code_BL__c, claim.City_BL__c, false,false,false).Price;
            materialCost = GetMaterialCost(claim.State_BL__c, claim.Postal_code_BL__c, claim.City_BL__c, claim.WOD_2__warranty_product__c).Price;
        }
               
        decimal totalCost = laborCost+materialCost;
        integer monthsUsed = claim.Install_Date__c.MonthsBetween(claim.CreatedDate.date());
        integer monthsRemaining = integer.valueof(monthsCovered) - monthsUsed;
        payLine.Months_Used__c = monthsUsed;
        payLine.Months_Covered__c = monthsCovered;
        payLine.Amount__c = (monthsRemaining/monthsCovered)*totalCost;
         System.debug(laborCost+'laborCost==>materialCost'+materialCost+'monthsRemaining'+monthsRemaining+'monthsCovered'+monthsCovered);
        return payLine;
      }
    /**
     * @description To get Warranty Class Action Cost
     * @param claimId Claim Id
     * @return Payment Line Object Record
    */
      public static WOD_Payment_Line__c GetWarrantyClassActionCost(string claimId){
        WOD_2__Claim__c claim = [Select Install_Date__c, CreatedDate, WOD_2__Applicable_Policy__r.SureStart_Period__c,OwnershipType__c,
        WOD_2__Applicable_Policy__r.Maxiumum_Liability__c, WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c from WOD_2__Claim__c Where id=:claimId];
        /*is_Before_SureStart__c, WOD_2__Applicable_Policy__r.After_SureShort_Warranty_Period__c ,*/
        WOD_Payment_Line__c payLine = new WOD_Payment_Line__c();
        if(claim.WOD_2__Applicable_Policy__r == null){
            throw new WOD_IntegrationException('There is no applicable policy for the claim');
        }
          Decimal monthsCovered= claim.WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c;
        //ClassAction_Amount__c cs =  ClassAction_Amount__c.GetValues('Warranty');         --Divya
        integer monthsUsed = claim.Install_Date__c.MonthsBetween(claim.CreatedDate.date());
        payLine.Months_Used__c = monthsUsed;
        payLine.Months_Covered__c = monthsCovered;
          
        //system.debug('Amount:' + ((monthsCovered - decimal.valueOf(monthsUsed))/monthsCovered)* cs.Value__c);
        //payLine.Amount__c = ((monthsCovered - decimal.valueOf(monthsUsed))/monthsCovered)* cs.Value__c; -- Divya
        payLine.Amount__c = ((monthsCovered - decimal.valueOf(monthsUsed))/monthsCovered)* 1;
        System.debug(monthsUsed+'monthsCovered'+monthsCovered);
        return payLine;
      }
    /**
     * @description To get Releasor Class Action Cost
     * @param claimId Claim Id
     * @return Payment Line Object Record
    */
      public static WOD_Payment_Line__c GetReleasorClassActionCost(string claimId){
        WOD_Payment_Line__c payLine = GetWarrantyClassActionCost(claimId);
        decimal totalCost = payLine.Amount__c;
         decimal previousCost = 0.0;
        WOD_2__claim__c claim = [Select Customer__c from WOD_2__claim__c where Id=:claimId];
         AggregateResult[] result = [Select sum(Total_Amount__C) from WOD_Payment__C where Claim__r.Customer__c =: claim.Customer__c  and Settlement_Type__c ='RCR - Cls Action Releasor' and Claim__r.Id <> : claimId];
       
        if(result[0].get('expr0') != null)
        {previousCost = (decimal)result[0].get('expr0');} 
             
        payLine.Previous_Recieved_Amount__c = previousCost;
        payLine.Amount__c = totalCost;
        return payLine;
      }
       /**
         * @description To get Transfer Class Action Cost
         * @param claimId Claim Id
         * @return Payment Line Object Record
       */
       public static WOD_Payment_Line__c GetTransferClassActionCost(string claimId){
        WOD_Payment_Line__c payLine = new WOD_Payment_Line__c();
        WOD_2__Claim__c claim = [Select Install_Date__c, CreatedDate, WOD_2__Applicable_Policy__r.SureStart_Period__c,OwnershipType__c,
        WOD_2__Applicable_Policy__r.Maxiumum_Liability__c, 
        WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c from WOD_2__Claim__c Where id=:claimId];
        /*is_Before_SureStart__c, WOD_2__Applicable_Policy__r.After_SureShort_Warranty_Period__c , */
        if(claim.WOD_2__Applicable_Policy__r == null){
            throw new WOD_IntegrationException('There is no applicable policy for the claim');
        }
        Decimal monthsCovered= claim.WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c;        
        integer monthsUsed = claim.Install_Date__c.MonthsBetween(claim.CreatedDate.date());
        decimal totalCost = 34*(1- (monthsUsed/monthsCovered));
        payLine.Months_Used__c = monthsUsed;
        payLine.Months_Covered__c = monthsCovered;
        payLine.Amount__c = totalCost; 
        return payLine;
      }
       
    /**
     * @description To get material price from SAP   
     * @param isRoofing Flag for Roofing BU
     * @param productId Warranty Product Id
     * @param plantCode Plant Code
     * @param shipTo Ship to account Id
     * @param soldTo Sold to account Id
     * @param paymentId Payment Id
     * @return Response Wrapper
    */
    public static WOD_WS.PricingSuccess GetMaterialPrice(boolean isRoofing, string productId, string plantCode, string shipTo, string soldTo,String paymentId){
        Map<string,string> warrantyProductMap = WOD_WarrantyProductWrapper.getProductDetails(productId, isRoofing);
        System.debug(warrantyProductMap);
        List<Account> shipToAcc = [Select SAP_ACCOUNT__c, Sales_District_lookup__c, Sales_District_lookup__r.Area_Price_Code__c, /* Price_Area__r.Name, */ LOB__c from Account where id=:shipTo];
        if(shipToAcc.size()==0){
            throw new WOD_IntegrationException('ShipTo account not specified');
        }
        if((null ==plantCode || '' ==plantCode) && isRoofing){
            throw new WOD_IntegrationException('Plant Code not specified on Claim.');    
        }
           
        List<Account> soldToAcc = [Select SAP_ACCOUNT__c, Sales_District_lookup__c, Sales_District_lookup__r.Area_Price_Code__c/* , Price_Area__r.Name  */ from Account where id=:soldTo];
        if(soldToAcc.size()==0){
            throw new WOD_IntegrationException('SoldTo account not specified');
        }
        System.debug(warrantyProductMap.get('ProductCode'));
        integer productCode = integer.valueOf(warrantyProductMap.get('ProductCode'));
                
        WOD_WS.PricingRequest request = new WOD_WS.PricingRequest();
        if(isRoofing){
            request.lstMaterials = new List<Integer>{productCode}; 
            request.strShipTo = shipToAcc[0].SAP_ACCOUNT__c;
            request.strSoldTo = soldToAcc[0].SAP_ACCOUNT__c;        
            //request.strDivision = warrantyProductMap.get('DivisonCode');
            request.strDivision = '01';
            request.strDistChannel = '01';
            request.strDistrict = shipToAcc[0].Sales_District_lookup__r.Area_Price_Code__c; //shipToAcc[0].Price_Area__r.Name;   -- Divya
            //request.strPlant = plantCode;
            request.strIdc = warrantyProductMap.get('IDC');
            //request.strSalesOrg = '1501';//IvSorg //ISorg 
            request.strSalesOrg = shipToAcc[0].LOB__c; //CT Multi currency changes   -Divya
            request.isRoofing = true;
         }
        else{            
            //request.lstMaterials = new List<Integer>{productCode,966};
            request.lstMaterials = new List<Integer>{productCode};
            request.strShipTo = shipToAcc[0].SAP_ACCOUNT__c;
            request.strSoldTo = soldToAcc[0].SAP_ACCOUNT__c;     
            request.strDivision = warrantyProductMap.get('DivisonCode');
            request.strDistChannel = '01';
            request.strSalesOrg =  shipToAcc[0].LOB__c; //'1502'; //IvSorg //ISorg
            request.isRoofing = false;
        }
        
        system.debug(request);        
        WOD_WS.PricingResponse r =WOD_WS.doPriceCall(request);
        System.debug(r);    
        // Add log
        WOD_SAP_Log__c log = new WOD_SAP_Log__c();
        log.Payment_Id__c = paymentId;
        log.Request__c = JSON.SerializePretty(request);
        log.Request_Date__c = dateTime.now();
        log.Response__c = JSON.SerializePretty(r);
        System.debug(r);    
        
        insert log;
        System.debug(r);    
        System.debug(productCode);
        if(r.mapSuccesses.containsKey(productCode)){
            WOD_WS.PricingSuccess ps = r.mapSuccesses.get(productCode);
            return ps;
        } else {
            for(Integer i = 0; i < r.lstErrors.size(); i++){
                WOD_WS.PricingError pe = r.lstErrors[i];
                if(i == 0){
                    throw new WOD_IntegrationException('Type:' + pe.strType + ' Message:' + pe.strMessage);
                }else if(i == 1){
                    throw new WOD_IntegrationException('Type:' + pe.strType + ' Message:' + pe.strMessage);
                }
            }
        }
        return null;
    }

    /**
     * @description To Send the free material order or credit debit order to SAP
     * @param paymentId Payment Id
     * @return SAP Log 
    */
    public static WOD_SAP_Log__c SendOrderToSAP(string paymentId){
        
        WOD_SAP_Log__c log;
        try{
            boolean isFreeMaterialOrder = false;
            String salesOrg;
            log = new WOD_SAP_Log__c();
            log.Payment_Id__c = paymentId;
            
            List<WOD_Payment_Line__c> paymentLines = [Select  Quantity__c,Amount__c,Amount_Converted__c,Material_Name__c, Material_Number__c, Total_Payment_Amount_Converted__c,
            toLabel(Material_Code__c)/*TECP-705 */, UOM__c, payment__r.Comments__c, payment__r.Order_Type__c, payment__r.Payment_Type__c, 
            payment__r.Order_Reason__c, payment__r.Shipping_Condition__c,  payment__r.Claim__r.Name, 
            payment__r.Claim__r.Territory_Manager__c, payment__r.Claim__r.Territory__r.Name, 
            payment__r.Claim__r.Owner.Name, payment__r.Ship_To__r.SAP_ACCOUNT__c ,Payment__r.Territory_Manager__c ,
            payment__r.Sold_To__r.SAP_ACCOUNT__c, payment__r.Product_Name__c, payment__r.Contact_Name__c,payment__r.Sales_Org__c, 
            payment__r.Contact_Phone__c, payment__r.Contact_Email__c, payment__r.Roofer_Name__c, payment__r.Roofer_Phone__c,payment__r.claim__r.ClaimType__c,
            payment__r.Ship_To__r.Territory__r.Name,payment__r.Sold_To__r.Territory__r.Name,payment__r.Ship_To__r.Territory__c,payment__r.Sold_To__r.Territory__c 
            From WOD_Payment_Line__c Where payment__r.Id=:paymentId];
            
            if(paymentLines.size() == 0)     {
                log.Error__c = 'Package does not have any payment lines';
                log.Has_Error__c = true;
                return log;
            }
            
            if(paymentLines.size() > 0 && String.IsNotBlank(paymentLines[0].payment__r.Sales_Org__c)){
                salesOrg = paymentLines[0].payment__r.Sales_Org__c;
            }
            
            if(paymentLines[0].payment__r.Payment_Type__c == 'Check' || paymentLines[0].payment__r.Payment_Type__c == 'Gelco'){
                log.Error__c = 'Only Credit/Debit and Material orders can be sent to SAP';
                log.Has_Error__c = true;
                return log;
            }       
            
            WOD_WS.OrderRequest request = new WOD_WS.OrderRequest();
             if(paymentLines[0].payment__r.Payment_Type__c == 'Free Material'){
                isFreeMaterialOrder = true;
                request.strType = 'ZFW';
            }else if(paymentLines[0].payment__r.Order_Type__c == 'Credit Memo'){
                request.strType = 'ZCR';
            }else{
                request.strType = 'ZDR';
            }
            request.strShipTo = paymentLines[0].payment__r.Ship_To__r.SAP_ACCOUNT__c; //KunnrSh
            request.strSoldTo = paymentLines[0].payment__r.Sold_To__r.SAP_ACCOUNT__c; //KunnrSp
            request.strOrdReason = paymentLines[0].payment__r.Order_Reason__c.Left(3); //Augru
            request.strPONumber = paymentLines[0].payment__r.Claim__r.Name; //Bstkd
            //request.strName = paymentLines[0].payment__r.Claim__r.Owner.Name; //Bname
            request.strName = UserInfo.getName(); //Bname
            if(paymentLines[0].payment__r.Payment_Type__c == 'Free Material'){
                request.strShipCondition = paymentLines[0].payment__r.Shipping_Condition__c.Left(2); //Vsbed
            }
            //request.strSalesOrg = '1501'; //Vkorg
            request.strSalesOrg = paymentLines[0].payment__r.Sales_Org__c; //CT Multi currency changes
            request.strDistChannel = '01'; //Vtweg
            request.strDivision = '01'; //Spart
            
            map<string,WOD_WS.OrderLine> tempLines = new map<string,WOD_WS.OrderLine>();
            request.lstOrdLines = new List<WOD_WS.OrderLine>();
            request.lstOrdNotes = new List<WOD_WS.OrderNote>();
            if(isFreeMaterialOrder){
                for(WOD_Payment_Line__c line : paymentLines){
                    WOD_WS.OrderLine oli = new WOD_WS.OrderLine();
                    oli.strMaterial = line.Material_Number__c; //Matnr
                    //oli.intQuantity = integer.valueOf(line.Quantity__c); //Kwmeng
                    oli.decQuantity = line.Quantity__c; //Kwmeng
                    //oli.decPrice = line.Amount__c; //Kbetr
                    oli.strUOM = line.UOM__c; //Vrkme
                    request.lstOrdLines.add(oli);
                }
            }else{
                
                for(WOD_Payment_Line__c line : paymentLines){
                    WOD_WS.OrderLine oli = tempLines.get(line.Material_Code__c);
                    if(oli == null){
                        oli = new WOD_WS.OrderLine();
                        oli.strMaterial = line.Material_Code__c; //Matnr
                        //oli.intQuantity = 1; //Kwmeng
                        oli.decQuantity = 1; //Kwmeng
                        If(String.IsNotBlank(salesOrg)){
                            if(salesOrg == '1502' || salesOrg == '1018' || salesOrg == '1019' || salesOrg == '1020'){ // CER-230
                                if(line.Amount__c != NULL && line.Quantity__c != NULL){
                                    oli.decPrice = (Math.abs(line.Amount__c) * line.Quantity__c).SetScale(2); //Kbetr
                                }
                            }
                            else{
                                if(line.Amount_Converted__c != NULL && line.Quantity__c != NULL){
                                    oli.decPrice = (Math.abs(line.Amount_Converted__c) * line.Quantity__c).SetScale(2); //Kbetr
                                }
                            }
                        }
                        
                        tempLines.put(line.Material_Code__c, oli);
                        request.lstOrdLines.add(oli);
                    }else{
                        If(String.IsNotBlank(salesOrg)){
                            if(salesOrg == '1502' || salesOrg == '1018' || salesOrg == '1019' || salesOrg == '1020'){ // CER-230
                                if(line.Amount__c != NULL && line.Quantity__c != NULL){
                                    oli.decPrice = (oli.decPrice + (Math.abs(line.Amount__c) * line.Quantity__c)).SetScale(2);
                                }
                            }
                            else{
                                if(line.Amount_Converted__c != NULL && line.Quantity__c != NULL){
                                    oli.decPrice = (oli.decPrice + (Math.abs(line.Amount_Converted__c) * line.Quantity__c)).SetScale(2);
                                }
                            }
                        }
                    }
                }
            }
                       
            AddNotes(request, paymentLines, isFreeMaterialOrder);
            
            log.Request__c = JSON.SerializePretty(request);
            log.Request_Date__c = dateTime.now();
            system.debug(request);
            WOD_WS.OrderResponse r = WOD_WS.doOrderCall(request);
            if(r.intOrderNumber != null){
                log.Response__c = string.valueOf(r.intOrderNumber);
           } else {
                for(WOD_WS.OrderError oe : r.lstErrors){
                    if(string.isEmpty(log.Error__c)){
                        log.Error__c = 'Type:' + oe.strType + ' Message:' + oe.strMessage;
                    }else{
                        log.Error__c = log.Error__c + '\n Type:' + oe.strType + ' Message:' + oe.strMessage;
                    }
                    log.Has_Error__c = true;
                }
            }
        }catch (WOD_WS.WSException e){
            log.Error__c = e.getMessage();
            log.Has_Error__c = true;
        }catch (exception ex){
            system.debug('@@ExceptionReleaseToSAP'+ex.getStackTraceString());
            log.Error__c = ex.getMessage()+':'+ex.getStackTraceString();
            log.Has_Error__c = true;
        }
        
        return log;
        
    }
    /**
     * @description To add notes
     * @param request Order Request
     * @param lines List of Payment Line records
     * @param isFreeMaterialOrder Falg for free material
    */
    private static void AddNotes(WOD_WS.OrderRequest request, List<WOD_Payment_Line__c> lines, boolean isFreeMaterialOrder){
        string stringId;
        boolean addNote =false;
        if(!isFreeMaterialOrder){
            stringId = 'Z006'; //TDID
        }else{
            stringId = 'Z013'; //TDID
        }
        
        WOD_WS.OrderNote oNote = new WOD_WS.OrderNote();
        oNote.strId = stringId;
        //added for CER-224 and queried fields in lines
        /*if(!isFreeMaterialOrder){
            oNote.strText = lines[0].payment__r.claim__r.Name + ', ' + 'TM ' +  lines[0].payment__r.Territory_Manager__c  + ', ' + lines[0].payment__r.Claim__r.Territory__r.Name;
        }
        else{
            oNote.strText = lines[0].payment__r.claim__r.Name + ', ' + 'TM ' + lines[0].payment__r.claim__r.Territory_Manager__c + ', ' + lines[0].payment__r.Claim__r.Territory__r.Name;
        }*/
        if(!isFreeMaterialOrder){
            if(lines[0].payment__r.Ship_To__r.Territory__r.Name!=null && lines[0].payment__r.Ship_To__r.Territory__r.Name!='' && lines[0].payment__r.Ship_To__r.Territory__c!=null){
                oNote.strText = lines[0].payment__r.claim__r.Name + ', ' + 'TM ' +  lines[0].payment__r.Territory_Manager__c  + ', ' + /*lines[0].payment__r.Claim__r.Territory__r.Name*/lines[0].payment__r.Ship_To__r.Territory__r.Name;
            }
            else{
                oNote.strText = lines[0].payment__r.claim__r.Name + ', ' + 'TM ' +  lines[0].payment__r.Territory_Manager__c  + ', ' + /*lines[0].payment__r.Claim__r.Territory__r.Name*/lines[0].payment__r.Sold_To__r.Territory__r.Name;
            }
            
        }
        else{
            if(lines[0].payment__r.Ship_To__r.Territory__r.Name!=null && lines[0].payment__r.Ship_To__r.Territory__r.Name!='' && lines[0].payment__r.Ship_To__r.Territory__c!=null){
                 oNote.strText = lines[0].payment__r.claim__r.Name + ', ' + 'TM ' + lines[0].payment__r.claim__r.Territory_Manager__c + ', ' + /*lines[0].payment__r.Claim__r.Territory__r.Name*/lines[0].payment__r.Ship_To__r.Territory__r.Name;
            }
            else{
                oNote.strText = lines[0].payment__r.claim__r.Name + ', ' + 'TM ' + lines[0].payment__r.claim__r.Territory_Manager__c + ', ' + /*lines[0].payment__r.Claim__r.Territory__r.Name*/lines[0].payment__r.Ship_To__r.Territory__r.Name;
            }
        }
        request.lstOrdNotes.add(oNote);
        
        if(!isFreeMaterialOrder){
            WOD_WS.OrderNote oNote3 = new WOD_WS.OrderNote();
            oNote3.strId = stringId;        
            oNote3.strText = 'To Settle Complaint# ' + lines[0].payment__r.claim__r.Name;
            request.lstOrdNotes.add(oNote3);
        }
        
        if(isFreeMaterialOrder){
            WOD_WS.OrderNote oNote2 = new WOD_WS.OrderNote();
            oNote2.strText = 'Distributor Contact ';
            oNote2.strId = stringId;
            if(!string.isEmpty(lines[0].payment__r.Contact_Name__c)){
                addNote =true;            
                oNote2.strText = 'Distributor Contact ' + lines[0].payment__r.Contact_Name__c; 
            }
            if(!string.isEmpty(lines[0].payment__r.Contact_Phone__c) ){
                addNote =true;
                oNote2.strText += ', ' + lines[0].payment__r.Contact_Phone__c;
            }
            if(!string.isEmpty(lines[0].payment__r.Contact_Email__c)){
                addNote =true;
                oNote2.strText += ', ' + lines[0].payment__r.Contact_Email__c;
            }
            if(addNote)
                request.lstOrdNotes.add(oNote2);
        }   
        //Added for JIRA CERUAT-715
        if(lines[0].payment__r.claim__r.ClaimType__c == 'Short Term'){
             oNote = new WOD_WS.OrderNote();
            oNote.strId = stringId; //TDID
            if(isFreeMaterialOrder){
                oNote.strText =  'Short Term';
            }
            request.lstOrdNotes.add(oNote);
        }
        
        for(WOD_Payment_Line__c line: lines ){
            oNote = new WOD_WS.OrderNote();
            oNote.strId = stringId; //TDID
            if(isFreeMaterialOrder){
                oNote.strText =  'Material Name ' + line.Material_Name__c + ', ' + 'Quantity ' +  line.Quantity__c + ', ' + 'UOM ' + line.UOM__c; //TDLINE
            }
            else{
                oNote.strText =  'Material Name ' + line.Material_Name__c + ', ' + 'Quantity ' +  line.Quantity__c + ', ' + 'UOM ' + line.UOM__c + ', ' + line.Total_Payment_Amount_Converted__c; //TDLINE
            }
            request.lstOrdNotes.add(oNote);
        }
        
        WOD_2__Claim__c claim = [Select First_Name__C, Last_Name__c, Address_1__c, City__c, State__c From WOD_2__Claim__c where Id =: lines[0].payment__r.claim__r.Id];
        oNote = new WOD_WS.OrderNote();
        oNote.strId = stringId; //TDID
        oNote.strText = 'Building Owner ' + claim.First_Name__C + ', ' +  claim.Last_Name__c + ', '  + claim.Address_1__c + ', ' + claim.City__c + ', ' + claim.State__c ;
        request.lstOrdNotes.Add(oNote);
        
        if(isFreeMaterialOrder){
            oNote = new WOD_WS.OrderNote();
            oNote.strId = 'Z008'; //TDID
            oNote.strText = 'Building Owner ' + claim.Last_Name__C + ', ' +  claim.First_Name__c + ', '  + claim.Address_1__c + ', ' + claim.City__c + ', ' + claim.State__c ;
            request.lstOrdNotes.Add(oNote);
            
            //Roofer Information
            addNote = false;
            oNote = new WOD_WS.OrderNote();
            oNote.strId = 'Z008'; //TDID
            if(!string.isEmpty(lines[0].payment__r.Roofer_Name__c)){
                addNote = true;   
                oNote.strText = 'Roofer Name ' + lines[0].payment__r.Roofer_Name__c; 
            }
            
            if(!string.isEmpty(lines[0].payment__r.Roofer_Phone__c)){
                addNote = true;
                oNote.strText += ', ' +  'Roofer Phone ' + lines[0].payment__r.Roofer_Phone__c;
            }
            if(addnote)
                request.lstOrdNotes.Add(oNote);
        }
        AddComments(lines[0].payment__r.Comments__c, request, isFreeMaterialOrder);
        
        
        List<WOD_Claim_Interested_Parties__c> claimParties =[Select Name, Address_1__c, City__c, State__c, Type__c, Phone__c from WOD_Claim_Interested_Parties__c where Claim__c =:lines[0].payment__r.claim__r.Id and Type__c in ('Contractor', 'Lumberyard')];
        for(WOD_Claim_Interested_Parties__c party: claimParties){
            oNote = new WOD_WS.OrderNote();
            oNote.strId = stringId; //TDID
            if(party.Type__c == 'Lumberyard'){
            oNote.strText = party.Type__c + ' ' + party.Name + ', ' + party.Address_1__c + ', ' + party.City__c + ', ' + party.State__c + ', ' + party.Phone__c;
            }
            else{
            oNote.strText = party.Type__c + ' ' + party.Name + ', ' + party.Address_1__c + ', ' + party.City__c + ', ' + party.State__c;
            }
            request.lstOrdNotes.add(oNote);
        }
            
         //Adding disclaimer in the end applicable only for creditdebit
         if(!isFreeMaterialOrder){
             AddDisclaimer(request,'Z006');
         }
        
    }
    /**
     * @description To Add Disclaimer
     * @param request request
     * @param stringId Note Id
    */
    private static void AddDisclaimer(WOD_WS.OrderRequest request, string stringId){
        WOD_WS.OrderNote oNote1 = new WOD_WS.OrderNote();
        WOD_WS.OrderNote oNote2 = new WOD_WS.OrderNote();
        WOD_WS.OrderNote oNote3 = new WOD_WS.OrderNote();
        WOD_WS.OrderNote oNote4 = new WOD_WS.OrderNote();
        WOD_WS.OrderNote oNote5 = new WOD_WS.OrderNote();
        //WS.OrderNote oNote6 = new WS.OrderNote();
        oNote1.strId = oNote2.strId = oNote3.strId = oNote4.strId = oNote5.strId = stringId;
        string strText1 = 'If the above DB/CR is being issued due to an applied product complaint, the recipient of such DB/CR agrees that it will be ';
        string strText2 = 'applied only toward satisfaction of the claim that arose from the use of a CertainTeed product on the above-described ';
        string strText3 = 'premises, and such DB/CR will not be applied toward, or used to satisfy, any other claim or account. The recipient also agrees ';
        string strText4 = 'that CertainTeed shall have no further liability or responsibility with regard to this claim should the recipient ';
        string strText5 = 'fail to perform as described above';
        //string strText6 = strText1 + strText2 + strText3 + strText4 +  strText5;
        oNote1.strText  = strText1;
        oNote2.strText  = strText2;
        oNote3.strText  = strText3;
        oNote4.strText  = strText4;
        oNote5.strText  = strText5;
        //oNote6.strText  = strText6;
        
        //TDID
        //request.lstOrdNotes.add(oNote6);
        request.lstOrdNotes.add(oNote1);        
        request.lstOrdNotes.add(oNote2);        
        request.lstOrdNotes.add(oNote3);        
        request.lstOrdNotes.add(oNote4);        
        request.lstOrdNotes.add(oNote5);
    }
    
   /* public static Decimal calculateMonthsCovered(WOD_2__claim__c claim){
        Decimal months=claim.WOD_2__Applicable_Policy__r.WOD_2__Months_Covered__c;        
        if(claim.OwnershipType__c=='Second' && claim.is_Before_SureStart__c=='N'){           
            months=claim.WOD_2__Applicable_Policy__r.After_SureShort_Warranty_Period__c;        
        }
        return months;
    }
    */

    /**
     * @description To add comments
     * @param comments comment
     * @param request request
     * @param isFreeMaterialOrder flag for filter
    */
    private static void AddComments(string comments, WOD_WS.OrderRequest request, boolean isFreeMaterialOrder){
        if(string.isEmpty(comments)){
            return;
        }
        integer startIndex = 0;
        integer endIndex = 0;
        integer strLength = comments.length();
        WOD_WS.OrderNote oNote1;
        string strID;
        if(isFreeMaterialOrder)
            strID = 'Z013';
        else
            strID = 'Z006';
        if(strLength >= 132){
            while(strLength >= 132){
                endIndex = endIndex +132;
                oNote1 = new WOD_WS.OrderNote();
                oNote1.strId = strID; //TDID
                oNote1.strText = comments.substring(startIndex,endIndex);
                request.lstOrdNotes.add(oNote1);
                startIndex = startIndex +132;
                strLength = strLength -132;
            }
        }
        oNote1 = new WOD_WS.OrderNote();
        oNote1.strId = strID; //TDID
        oNote1.strText = comments.substring(startIndex);
        request.lstOrdNotes.add(oNote1);
    }
}