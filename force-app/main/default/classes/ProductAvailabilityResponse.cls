public with sharing class ProductAvailabilityResponse {
 
    public String Plant{get;set;}
    public String Description{get;set;}
    public String Material{get;set;}
    public String UOM{get;set;}
    public String Date_x{get;set;}
    public Decimal AvailQty{get;set;}
    
    public ProductAvailabilityResponse() {
        this.Plant = null;
        this.Description = null;
        this.Material = null;
        this.UOM = null;
        this.Date_x = null;
        this.AvailQty = null;
    }
    
}