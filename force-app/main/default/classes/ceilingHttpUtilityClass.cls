/****************************************************************************************
    * @Author       Gopi Ravoori
    * @Date         May 18, 2017
    * @Description  Has inner classes for request, response, and the callout method to get data from SAPweb service
    *****************************************************************************************/
    
    public class ceilingHttpUtilityClass {
       public class ceilingHttpUtilityClassException extends Exception {}
        /****************************************************************************************
         * @Author       Gopi Ravoori
         * @Date        May 18, 2017
         * @Description  Inner class that holds fields for the Request
         *****************************************************************************************/
        public ceilingHttpUtilityClass(){}
       
        public class Request {
                public Request(){}
                public String soldTo;//Sold to Account
                public String shipTo;//Ship to Account
                public String productCode;//Product code
                public  Date  pricingDate;//pricingDate
                public String priceType;//Price List 
                public String salesOrg;//Sales Org 1003 or 1101
                public String salesDistrict;//Price Zone 
                public String division;//Optional 01
                public String disChannel;//Optional 02
                public String quantity;
                public String plantno;
                }
        
        /****************************************************************************************
         * @Author       Gopi Ravoori
         * @Date         May 18, 2017
         * @Description  Inner class that holds fields for the Response
         *****************************************************************************************/
        public class Response {
            public Decimal price;//CondValue
            public String  cost;
            public String priceType;
            public String error;//Message
            public String product;//Matnr
            public String uom; //Seling Uom
            
          public Response(){}
            public Response(String c, Decimal p, String pT, String e,String prod,String u){
                this.cost = c;
                this.price = p;
                this.priceType = pT;
                this.error = e;
                this.product= prod;
                this.uom=u;
           
        }
        }
        
        /**
        * @description class for wrapping the material data that comes back from the Api.
        */
        public class materialObject
        {
            public string matnr {get;set;} //Material Number
            public string kschl {get;set;} //“Price Type”.  ZP00=list, ZP01=Discounted Price, ZIDC=Discounted Percentage
            public decimal condValue {get;set;} //Price
            public string currencyCode {get;set;} //Currency of price (Should always be USD).
            public string condUnit {get;set;} //this is the Unit of Measure  of the pricing.
            public string accessSeq {get;set;} // This is the Access Level of the price request
            public string datbi {get;set;} //expiration date of the price exception.
            public string dDtext {get;set;} //The Label that is associated with the AccessSeq.
            public string message {get;set;}
        }
        
           
      
    
        
            public static String generatePriceRequestSOAPXml(Request request)            
            {    
                
              Date myDate = Date.today();
                
               request.pricingDate = myDate;
               //request.priceType='CAA';
                if(request.soldTo==null)
                {
                    request.soldTo =request.shipTo;
                }
                
                if(request.shipTo==null)
                {
                    request.shipTo=request.soldTo;
                }
                
                
                
             System.debug('Request'+request); 
        /*        string materialIdString = '';  
            for(string materialId : request.materialIds)
            {
                materialIdString += '<item><Matnr>'+materialId+'</Matnr></item>';
            }  */
                
            String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:soap:functions:mc-style">' +
            '<soapenv:Header/>'+
                '<soapenv:Body>'+
                    ' <urn:Zsdi9002OutWsdlPricing>'+
                            '<GtInputMatnr>'+
                              '<item>'+
                                '<Matnr>'+
                            request.productCode+
                                '</Matnr>'+
                            '</item>'+
                            '</GtInputMatnr>'+
                            '<IvBzirk>'+
                             +            
                            '</IvBzirk>'+
                            '<IvDate>'+
                             
                DateTime.newInstance(request.pricingDate.year(),request.pricingDate.month(),request.pricingDate.day()).format('YYYY-MM-dd')+
                            '</IvDate>'+
                            '<IvPltyp>'+
                            +
                            '</IvPltyp>'+
                            '<IvShipto>'+
                            request.shipTo+
                            '</IvShipto>'+
                            '<IvSoldto>'+
                            request.soldTo+
                            '</IvSoldto>'+
                            '<IvSorg>'+
                            request.salesOrg+
                             '</IvSorg>'+
                            '<IvSpart>'+
                                '01'+
                            '</IvSpart>'+
                           '<IvVtweg>'+
                                '01'+
                            '</IvVtweg>' +
                            '<IvWerks>'+
                              request.plantno+
                            '</IvWerks>'+
                           '</urn:Zsdi9002OutWsdlPricing>' +
                           '</soapenv:Body>' +
            '</soapenv:Envelope>'; 
               /* String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:soap:functions:mc-style">'+
       '<soapenv:Header/>'+
       '<soapenv:Body>'+
          '<urn:Zsdi9002OutWsdlPricing>'+
             '<GtInputMatnr>'+
                   '<item>'+
                   '<Matnr>601182</Matnr>'+
                '</item>'+
             '</GtInputMatnr>'+
             '<IvBzirk></IvBzirk>'+
             '<IvDate>'+DateTime.newInstance(request.pricingDate.year(),request.pricingDate.month(),request.pricingDate.day()).format('YYYY-MM-dd')+'</IvDate>'+
             '<IvPltyp></IvPltyp>'+
             '<IvShipto>1011080</IvShipto>'+
             '<IvSoldto>1011080</IvSoldto>'+
             '<IvSorg>1003</IvSorg>'+
             '<IvSpart>01</IvSpart>'+
             '<IvVtweg>01</IvVtweg>'+
          '</urn:Zsdi9002OutWsdlPricing>'+
       '</soapenv:Body>'+
    '</soapenv:Envelope>';*/
                return body;
                
            }
         public static string stripLeadingZeros(string value)
        {
            return value.replaceFirst( '^0+', '');
        }
        public  static Response sendRequest(Request request) {                 
            //Querying SAP credentials from custom metadata type 
            SAP_Credentials__mdt[] sapCredentials = [SELECT MasterLabel, QualifiedApiName, User_Name__c 
                                                     ,Password__c,Endpoint_Url__c 
                                                     FROM SAP_Credentials__mdt];
            
            String username;// commeted to get values dynamically
            String password;//  commeted to get values dynamically
            String url;
         
            if(sapCredentials.size()>0){
                username = sapCredentials[0].User_Name__c;
                password = sapCredentials[0].Password__c;
                url = sapCredentials[0].Endpoint_Url__c;
            }
            if(Test.isRunningTest()){
                username = 'Test';
                password = 'Test';
                url = 'http://sap-wddev.certainteed.com';
            }
            
            map<string,map<string,materialObject>> materialMap = new map<string,map<string,materialObject>>();
            string requestBody = generatePriceRequestSOAPXml(request);
            System.debug('This is a request'+requestBody);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(60000);
            req.setEndpoint(url);
            req.setMethod('POST'); //Use POST as we are headed towards SOAP calls which is a standard that is based on POST
            //Add the headers to follow the SOAP standard
            req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            req.setHeader('SOAPAction','urn:sap-com:document:sap:soap:functions:mc-style:ZSDI_9002_OUT_WSDL_PRICING_WS:Zsdi9002OutWsdlPricingRequest');
            //if a username and password are specified, set the authorization header.            
                   
                Blob headerValue = Blob.valueOf(username + ':' + password);
                String authorizationHeader = 'BASIC '+EncodingUtil.base64Encode(headerValue);
                string a;
                req.setHeader('Authorization', authorizationHeader);
             
            req.setBody(requestBody);
            // Send the request, and return a response
            HttpResponse res = h.send(req);
            String strResponse = res.getBody();
            System.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'+request);
            System.debug('---------------------------------------------------------------'+strResponse);
              Response resZp01= null;
            Response resZp00 = null;
            Response resZAdd = null;
            Response resVPRS =null;
            Response errorCode = null;
            if(strResponse == '' || strResponse == null){
                errorCode = new Response();
               errorCode.error = 'No pricing data passed.';
              return errorCode;
            }
            else if(!strResponse.contains('<soap')){
                errorCode = new Response();
               errorCode.error = 'No pricing data passed.';
                return errorCode;
          }
            //Parse the reponse into a response object
            Dom.Document doc = new Dom.Document();        
            doc.load(strResponse.unescapeXml().normalizeSpace().replaceAll('> <','><'));
            Dom.XMLNode rootNode = doc.getRootElement();
            Dom.XmlNode bodyElement = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
            Dom.XmlNode responseElement = bodyElement.getChildElements()[0];
            Dom.XmlNode returnElement = responseElement.getChildElements()[0];
            //read the GtOut element from the response element (contains all the items)
            Dom.XmlNode gtOuptut = responseElement.getChildElement('GtOutput',null);
            
             //read the Messages element from the response element (contains error message)
            Dom.XmlNode messages = responseElement.getChildElement('Messages',null);
            Decimal costValue1;
            
            for(Dom.XmlNode item: gtOuptut.getChildElements())
            {
                if(item.getChildElement('Kschl',null).getText()=='VPRS')
                   costValue1= Decimal.valueOf(item.getChildElement('CondValue',null).getText());
                   System.debug('===================================================costValue'+costValue1);
    
            }
            
          for(Dom.XmlNode item: gtOuptut.getChildElements())
            {
              //  materialObject thisMaterial = new materialObject();
                //thisMaterial.matnr = item.getChildElement('Matnr',null).getText();
                Decimal costValue;
                
                if(item.getChildElement('Kschl',null).getText()=='VPRS')
                   costValue= Decimal.valueOf(item.getChildElement('CondValue',null).getText());
                   System.debug('===================================================costValue'+costValue);
                         //Assigning  Cost if ZP00,ZADD,ZP01 is null 1/9/2018 by Gopi Ravoori        
                		resVPRS = new Response();
                        resVPRS.product=item.getChildElement('Matnr',null).getText();                    
                        resVPRS.priceType = item.getChildElement('Kschl',null).getText();
                        //resVPRS.price = decimal.valueOf(item.getChildElement('CondValue',null).getText());
						resVPRS.price = 0;
						resVPRS.cost = item.getChildElement('CondValue',null).getText();
                        resVPRS.uom = item.getChildElement('CondUnit',null).getText();                                                                    
                   		System.debug('=======================================================costValueVPRS'+resVPRS.cost);
                        resVPRS.error = item.getChildElement('Message',null).getText();
                            
                
                if( item.getChildElement('Kschl',null).getText()=='ZP01')
                {	
                        resZp01 = new Response();
                        resZp01.product=item.getChildElement('Matnr',null).getText();
                    
                        resZp01.priceType=item.getChildElement('Kschl',null).getText();
                        //res1.kschl = item.getChildElement('Kschl',null).getText();
                         resZp01.price= decimal.valueOf(item.getChildElement('CondValue',null).getText());
                        //res1.currencyCode = item.getChildElement('Currency',null).getText();
                        resZp01.uom = item.getChildElement('CondUnit',null).getText();
                        //res1.priceType = item.getChildElement('AccessSeq',null).getText();
                        //res1.datbi = item.getChildElement('Datbi',null).getText();
                        //res1.dDtext = item.getChildElement('Ddtext',null).getText();
                       // if(item.getChildElement('Kschl',null).getText()=='VPRS')
                        //{
                        //resZp01.cost= item.getChildElement('CondValue',null).getText();
                        //}
                        resZp01.cost=String.valueOf(costValue1);
                    System.debug('======================================================='+resZp01.cost);
                        resZp01.error = item.getChildElement('Message',null).getText();
                        //materialData.add(thisMaterial); 
                  }
                    else if( item.getChildElement('Kschl',null).getText()=='ZP00')
                {
                        resZp00 = new Response();
                        resZp00.product=item.getChildElement('Matnr',null).getText();
                    
                        resZp00.priceType=item.getChildElement('Kschl',null).getText();
                         resZp00.price= decimal.valueOf(item.getChildElement('CondValue',null).getText());
                        resZp00.uom = item.getChildElement('CondUnit',null).getText();
                    //if(item.getChildElement('Kschl',null).getText()=='VPRS')
                      //  {
                       // resZp00.cost= item.getChildElement('CondValue',null).getText();
                        //}
                        resZp00.cost=String.valueOf(costValue1);
                        
                        
                    System.debug('=======================================================costValue12'+resZp00.cost);
                        resZp00.error = item.getChildElement('Message',null).getText();
                    
                }
                
                    else if( item.getChildElement('Kschl',null).getText()=='ZADD' )
                {
                        resZAdd = new Response();
                        resZAdd.product=item.getChildElement('Matnr',null).getText();
                    
                        resZAdd.priceType=item.getChildElement('Kschl',null).getText();
                         resZAdd.price= decimal.valueOf(item.getChildElement('CondValue',null).getText());
                        resZAdd.uom = item.getChildElement('CondUnit',null).getText();
                      //if(item.getChildElement('Kschl',null).getText()=='VPRS')
                       // {
                        //resZAdd.cost= item.getChildElement('CondValue',null).getText();
                       // }
                       resZAdd.cost=String.valueOf(costValue1);
                                        
                    System.debug('8888888888888888888888888888888'+resZAdd.cost);
                    resZAdd.error =item.getChildElement('Message',null).getText();
                    
                }
                else if( item.getChildElement('Kschl',null).getText()== null || item.getChildElement('Kschl',null).getText()=='')
                {
                    errorCode = new Response();
                    
                    errorCode.error = item.getChildElement('Message',null).getText();
                }
            
    
            } 
                  
    
            if( resZp01 != null)
            {
                System.debug('======================================================='+resZp01);
                
            
                return resZp01;
            }
            if( resZp00 != null)
            {
                if( resZAdd != null)
                {
                    resZp00.price = resZp00.price+resZAdd.price;
                   // resZp00.cost =   resZp00.cost+resZAdd.cost;
                    
                     //resZp00.cost =   resZp00.cost+resZAdd.cost;
                  }
                System.debug('In loop======================================================='+resZp00);
    
                return resZp00;
            }
            
             if(resZp00 == null &&  resZp01 == null && resZAdd ==null){
                 
             return resVPRS;
                
            }
            
                /*try
                {
            if(errorCode!=null);
                }  
            catch(Exception ex)
                {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, errorCode);
                } */
            return errorCode;
            }
        }