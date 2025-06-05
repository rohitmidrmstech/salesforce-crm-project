// ==================================================================================
//   Object: WTUNote
//  Company: Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Wrapper Class
// ==================================================================================
//  Changes: 2013-11-19 Initial version.
// ==================================================================================

public class WTUNote {
    public WTU_Note__c wNote {get;set;}
    public List<VOCLine> productLineList {get;set;}
    public List<VOCLine> salesLineList {get;set;}
    public List<VOCLine> serviceLineList {get;set;}
    public List<VOCLine> otherLineList {get;set;}
    public Boolean addProduct {get;set;}
    public Boolean addSales {get;set;}
    public Boolean addService {get;set;}
    public Boolean addOther {get;set;}
    public Integer wIndex {get;set;}
    
    public WTUNote() {
        productLineList = new List<VOCLine>();
        salesLineList = new List<VOCLine>();
        serviceLineList = new List<VOCLine>();
        otherLineList = new List<VOCLine>();
        addProduct = false;
        addSales = false;
        addService = false;
        addOther = false;
    }
}