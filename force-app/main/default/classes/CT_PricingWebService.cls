/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Pricing Web Service Class
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Gautam Kumar (gkumar@liquidhub.com)
* @verstion       1.0
* @created        2017-05-22
*/
public class CT_PricingWebService
{
   private CT_Common_Settings__c settings = CT_Common_Settings__c.getInstance();
   public static final Integer TIMEOUT_MILLISECONDS = 30000;
    
    /**
    * @description sample method for making a call to get some material data to ensure connectivity and test the parser etc
    * @return a mapping of material id to a map of kschl codes for that material. 
    */
    public map<string,map<string,materialObject>> requestMaterialPrice()
    {
        list<string> mats = new list<string>();
        mats.add('638445');
        
        return getMaterialPrice(Datetime.now().addDays(1).format('yyyy-MM-dd'),mats,'1011308','2017076','1100');  
    }
    
	public map<string,priceInfoContainer> requestPriceInfo()
    {
        Set<String> mats = new Set<String>();
        mats.add('638652');
        mats.add('638445');
       // return getPriceInfo(mats, '1002220', '2018281', Date.today());
        return getPriceInfo(mats, '1011308', '2017076', Date.today());
    }

    /** 
    * @description gets list prices and current prices for given products from remote SAP system.
    * @return map of id to priceInfoContainer object which has listPrice and currentPrice information
    */
    public map<string,priceInfoContainer> getPriceInfo (set<string> materialIds, String soldTo, String shipTo, Date startDate){
        return getPriceInfo (materialIds, soldTo, shipTo, startDate, '1100');
    }
    public map<string,priceInfoContainer> getPriceInfo (set<string> materialIds, String soldTo, String shipTo, Date startDate, String salesOrg)
    {
        system.debug('\n\n\n\n------------------------- Getting Price Info from Remote API For Materials:');
        system.debug(materialIds);
        
        map<string,priceInfoContainer> priceInfos = new map<string,priceInfoContainer>();
        
        //we have to send material information requests in batches of 10. so break the list into batches
        integer totalCounter = 0;
        list<string> thisBatchOfMaterialIds = new list<string>();
        map<string,map<string,CT_PricingWebService.materialObject>> materialDataMap =
            new map<string,map<string,CT_PricingWebService.materialObject>>(); 
        Integer BatchSize = 10;
        if(Test.isRunningTest())BatchSize =1;
                                 
            
        
        
        for(string thisMaterialId : materialIds)
        {
            totalCounter++;
            
            if(thisMaterialId == null) continue;

            priceInfoContainer thisContainer = new priceInfoContainer();
            priceInfos.put(thisMaterialId, thisContainer);
            
            boolean invalidProductCode = thisMaterialId.length() != 6 ? true : false;
            if(invalidProductCode)
            {
                thisContainer.invalidProductCode = true;
                system.debug('\n\n\n\n------------------------- Invalid Material Code Detected!! : ' + thisMaterialId);
                continue;
            }
            
            //add this material to the batch of ids to send to the API now that we know it shouldn't cause an error
            thisBatchOfMaterialIds.add(thisMaterialId);   
            system.debug('\n\n\n\n------------------------- Adding Material Id to list: ' + thisMaterialId);
            

            //if we have hit the limit of the number of materials we can send per request, or all the requested materials 
           
            if(thisBatchOfMaterialIds.size()  >= BatchSize || totalCounter == materialIds.size())
            {
                system.debug('\n\n\n\n------------------------- Sending batch of Ids');

               String startDateString = Datetime.now().addDays(1).format('yyyy-MM-dd');
                map<string,map<string,CT_PricingWebService.materialObject>> tempMaterialDataMap =
                    getMaterialPrice( startDateString,thisBatchOfMaterialIds, shipTo, soldTo, salesOrg);
                system.debug('\n\n\n\n ------------------------ Got back material price data');
                system.debug(tempMaterialDataMap);
                
                for (String currKey : tempMaterialDataMap.keySet()){
                    materialDataMap.put(currKey, tempMaterialDataMap.get(currKey));
                }
                thisBatchOfMaterialIds.clear();
            }
        }
        

        for(string thisMaterialId : materialIds)
        {                     
            if(thisMaterialId == null) continue;

            priceInfoContainer thisContainer = priceInfos.get(thisMaterialId);
            if(thisContainer.invalidProductCode) continue;

            if(materialDataMap.containsKey(thisMaterialId))
            {
                system.debug('\n\n\n\n ------------------------ Matching material from API found!');
                
                thisContainer.listPriceObject = materialDataMap.get(thisMaterialId).containsKey('ZP00') ? materialDataMap.get(thisMaterialId).get('ZP00') : new CT_PricingWebService.materialObject(); //the zp00 key is for list price.
                thisContainer.discountedPriceObject  = materialDataMap.get(thisMaterialId).containsKey('ZP01') ? materialDataMap.get(thisMaterialId).get('ZP01') : new CT_PricingWebService.materialObject(); //the zp01 key is for current price.
                thisContainer.discountedPercentObject  = materialDataMap.get(thisMaterialId).containsKey('ZIDC') ? materialDataMap.get(thisMaterialId).get('ZIDC') : new CT_PricingWebService.materialObject(); //the zidc key is for current price. 
            }
            else
            {
                system.debug('\n\n\n\n ------------------------ Unable to locate matching material for code');
            }
        }

        system.debug('\n\n\n\n -------------------- all price info batches found ');
        system.debug(priceInfos);
        
        return priceInfos;
    }
        
    /**
    * @description gets data for requested materials from remote SAP API. Takes up to 10 materials at a time. 
    * @param ivDate the date to get material data for. yyyy-MM-dd
    * @param materialIds a list of strings that are material Ids. These are likely 6 digit codes.
    * @param shipTo a 7 digit string that is the id of the customer to ship to in SAP
    * @param soldTo a 7 digit string that is the id of the customer that a material was sold to in SAP
    * @return Returns a map of map of materials. The first key is the material ID with leading zeros removed. The second
    * key is the kschl code which I beleive to be the indicator for the list vs current price. ZP00 being current price and ZP01 being list price (maybe?)
    */
    public map<string,map<string,materialObject>> getMaterialPrice(String convertedDate, list<string> materialIds, string shipTo, string soldTo, String salesOrg)
    {    
        map<string,map<string,materialObject>> materialMap = new map<string,map<string,materialObject>>();
        
        //create the XML request data with the passed in information   
        string requestBody = generateMaterialRequestXML(convertedDate, materialIds, shipTo, soldTo, salesOrg);
        
        system.debug('reqBOdy'+requestBody);
        
        HTTPResponse response = sendRequest(requestBody,'POST');
        system.debug('tryResponse'+response.getBody());
        //parse the raw http response into a list of materialObject objects
        list<materialObject> materials = parseResponse(response);
        
        //iterate over the materials and organize them by their material id, then by their kschl code to produce a map within a map.
        for(materialObject thisMat : materials)
        {
            string cleanedMaterialId = stripLeadingZeros(thisMat.Matnr);
             
            map<string,materialObject> thisMaterialMap = materialMap.containsKey(cleanedMaterialId) ? materialMap.get(cleanedMaterialId) : new map<string,materialObject>();
            thisMaterialMap.put(thisMat.kschl,thisMat);
            materialMap.put(cleanedMaterialId,thisMaterialMap);
        }
        
        //return the generated map
        return materialMap;
    }
    
    /**
    * @description simple utility method for removing leading zeros from a string. The SAP API returns material ids with a large number of leading zeroes that salesforce may not have. Therefor it may be
    * useful to remove them for mapping API data to SF data.
    * @param value to remove leading zeroes from
    * @return string with leading zeros removed
    */
    public string stripLeadingZeros(string value)
    {
        return value.replaceFirst( '^0+', '');
    }
    
    /**
    * @description parses an httpResponse object provided by the SAP API into a list of materialObject objects which can be interacted with within apex.
    * @param res an httpResponse object from SAP that should contain XML data to parse
    * @return a list of materialObject objects which contain the data from the API in an object with properties (see materialObject nested class below)
    */
    public list<materialObject> parseResponse(httpResponse res)
    {
        list<materialObject> materialData = new list<materialObject>();
        
        //parse http response body (XML string) into XML object 
        Dom.Document doc = res.getBodyDocument();
        system.debug('G*G response frm sap'+doc);
        //Retrieve the root element for this document.
        Dom.XMLNode rootNode = doc.getRootElement();

        //Read the body element
        Dom.XmlNode bodyElement = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
        
        //read the first element in the body (it has an odd name which I was unsure it would always be the same so I figured accessing it by position was safer than by name)
        Dom.XmlNode responseElement = bodyElement.getChildElements()[0];

        //read the GtOut element from the response element (contains all the items)
        Dom.XmlNode gtOuptut = responseElement.getChildElement('GtOutput',null);
        
        //iterate over each item and create a materialObject from it by reading it's values (maybe worth making a constructor instead of setting properties individually?)
        for(Dom.XMLNode item: gtOuptut.getChildElements()) 
        {            
            materialObject thisMaterial = new materialObject();
            
            thisMaterial.matnr = item.getChildElement('Matnr',null).getText();
            thisMaterial.kschl = item.getChildElement('Kschl',null).getText();
            thisMaterial.condValue = decimal.valueOf(item.getChildElement('CondValue',null).getText());
            thisMaterial.currencyCode = item.getChildElement('Currency',null).getText();
            thisMaterial.condUnit = item.getChildElement('CondUnit',null).getText();
            thisMaterial.accessSeq = item.getChildElement('AccessSeq',null).getText();
            thisMaterial.datbi = item.getChildElement('Datbi',null).getText();
            thisMaterial.dDtext = item.getChildElement('Ddtext',null).getText();
            thisMaterial.message = item.getChildElement('Message',null).getText();
           
            materialData.add(thisMaterial);
        }
                        
        return materialData;
    }
    
    /**
    * @description creates a sample httpResponse for testing the parser and for use in test classes
    * @return httpResponse object with body set to sample XML data for parsing
    */
    public HTTPResponse getSampleResponse()
    {
        HTTPResponse thisResponse = new HTTPResponse();
        // thisResponse.setBody(TestDataFactory.PRICINGSERVICE_RESPONSE);
         thisResponse.setBody('<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/"><soap-env:Header/><soap-env:Body><n0:Zsdi9002OutWsdlPricingResponse xmlns:n0="urn:sap-com:document:sap:soap:functions:mc-style"><GtOutput><item><Matnr>000000000000638445</Matnr><Kschl>VPRS</Kschl><CondValue>466.51</CondValue><Currency>CAD</Currency><CondUnit>PC</CondUnit><AccessSeq>00</AccessSeq><Datbi>0000-00-00</Datbi><Ddtext/><Message/></item><item><Matnr>000000000000638445</Matnr><Kschl>ZP00</Kschl><CondValue>912.0</CondValue><Currency>CAD</Currency><CondUnit>MSF</CondUnit><AccessSeq>17</AccessSeq><Datbi>2099-12-01</Datbi><Ddtext>Sales org./Division/District/Price list/IDC</Ddtext><Message/></item><item><Matnr>000000000000638652</Matnr><Kschl>VPRS</Kschl><CondValue>190.15</CondValue><Currency>CAD</Currency><CondUnit>PC</CondUnit><AccessSeq>00</AccessSeq><Datbi>0000-00-00</Datbi><Ddtext/><Message/></item><item><Matnr>000000000000638652</Matnr><Kschl>ZP00</Kschl><CondValue>711.0</CondValue><Currency>CAD</Currency><CondUnit>MSF</CondUnit><AccessSeq>17</AccessSeq><Datbi>2099-12-01</Datbi><Ddtext>Sales org./Division/District/Price list/IDC</Ddtext><Message/></item></GtOutput><Messages/></n0:Zsdi9002OutWsdlPricingResponse></soap-env:Body></soap-env:Envelope>');
        return thisResponse;
    }
    
    /**
    * @description sends http request to the endpoint specified in the VSDApiSettings custom setting object
    * @param requestBody string of content to include in the http request body
    * @param httpVerb http very used to send the request (get, post, patch, etc)
    * @return httpResponse object from the remote source. 
    */
    public HTTPResponse sendRequest(string requestbody, string httpVerb)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(settings.Pricing_Endpoint__c);
        req.setMethod(httpVerb);
        req.setTimeout(TIMEOUT_MILLISECONDS);

        HTTPResponse res;
        
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction','urn:sap-com:document:sap:soap:functions:mc-style:ZSDI_9002_OUT_WSDL_PRICING_WS:Zsdi9002OutWsdlPricingRequest');
        
        //if a username and password are specified, set the authorization header.
        if(settings.Pricing_Username__c != null && settings.Pricing_Password__c != null)
        {
            Blob headerValue = Blob.valueOf(settings.Pricing_Username__c + ':' + settings.Pricing_Password__c);
            String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
        }  
         req.setBody(requestBody);
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
        
        system.debug('\n\n\n\n------------------- Sending Request');
        system.debug('request xml'+req);
        System.Debug(req.getBody());
        
        Http http = new Http();
        if(!Test.isRunningTest())
        {
            res = http.send(req);
        }
        else
        {
            res = getSampleResponse();
        }
        
        system.debug('\n\n\n\n--------------------- RAW RESPONSE BODY');
        system.debug('response xml'+res.getBody());
        return res;   
    }
    
    /**
    * @description creates the required XML body to send to the remote SAP service for getting information about materials.
    * @param ivDate the date to get material data for. Should be today or in the future
    * @param materialIds a list of strings that are material Ids. These are likely 7 digit codes.
    * @param shipTo a 6 digit string that is the id of the customer to ship to in SAP
    * @param soldTo a 6 digit string that is the id of the customer that a material was sold to in SAP
    * @return xml string that can be used as the request body of an http request to get information about materials from SAP.
    */
    public string generateMaterialRequestXML(string ivDate, list<string> materialIds, string shipTo, string soldTo, String salesOrg)
    {       
        string materialIdString = '';  
        for(string materialId : materialIds)
        {
            materialIdString += '<item><Matnr>'+materialId+'</Matnr></item>';
        }   
        
        string returnString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:soap:functions:mc-style"> '+
           '<soapenv:Header></soapenv:Header>'+
           '<soapenv:Body>'+
              '<urn:Zsdi9002OutWsdlPricing>'+
                 '<GtInputMatnr>'+
                       materialIdString +
                 '</GtInputMatnr>'+
                 '<IvDate>'+(ivDate !=null ? ivDate : '') +'</IvDate>'+
                 '<IvShipto>'+(shipTo  !=null ? shipTo : '' )+'</IvShipto>'+
                 '<IvSoldto>'+(soldTo !=null ? soldTo : '') +'</IvSoldto>'+
                 '<IvSorg>'+(salesOrg !=null ? salesOrg : '') +'</IvSorg>'+
                 '<IvSpart>01</IvSpart>'+
                 '<IvVtweg>01</IvVtweg>'+
                 '<IvBzirk></IvBzirk>'+
                 '<IvPltyp></IvPltyp>'+
              '</urn:Zsdi9002OutWsdlPricing>'+
           '</soapenv:Body>'+
        '</soapenv:Envelope>';
        
        system.debug('G*G returnString'+returnString);
        return returnString;  
    }

    /**
    * @description class for holding price information fetched from remote SAP webservice
    */
    public class priceInfoContainer
    {
        public boolean invalidProductCode ;
        public CT_PricingWebService.materialObject discountedPercentObject ; // ZIDC
        public CT_PricingWebService.materialObject discountedPriceObject ; // ZP01
        public CT_PricingWebService.materialObject listPriceObject ; // ZP00
                
        public priceInfoContainer()
        {
            this.invalidProductCode = false;
            this.discountedPercentObject = new CT_PricingWebService.materialObject();
            this.discountedPriceObject = new CT_PricingWebService.materialObject();
            this.listPriceObject = new CT_PricingWebService.materialObject();
        }
        
    }
        
    /**
    * @description class for wrapping the material data that comes back from the Api.
    */
    public class materialObject
    {
        public string matnr ; //Material Number
        public string kschl ; //Price Type.  ZP00=list, ZP01=Discounted Price, ZIDC=Discounted Percentage
        public decimal condValue ; //Price
        public string currencyCode; // Currency of price 
        public string condUnit ; //this is the Unit of Measure the of the pricing.
        public string accessSeq ; // This is the Access Level of the price request
        public string datbi ; //expiration date of the price exception.
        public string dDtext ; //The Label that is associated with the AccessSeq.
        public string message ;
    }
 /* @@ code merge from outmerg sandbox*/
  public map<string,priceInfoContainer> getPriceInfo (Set<String> materialIds, String soldTo, String shipTo, Date startDate, String salesOrg,string salesDistrict, string PriseListType)
    {
        return null;
    }

}

//Test