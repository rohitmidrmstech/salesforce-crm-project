// ==================================================================================
//   Object: VOCLine
//  Company: Navivo
//   Author: Mohan Kumar (Threshold)
// Comments: Wrapper Class
// ==================================================================================
//  Changes: 2013-11-14 Initial version.
// ==================================================================================

public class VOCLine {
  public VOC_Data_Entry__c vocEntry {get;set;}
  public Integer rIndex {get;set;}
  public List<Selectoption> pFamilyOptions {get;set;}
  public List<Selectoption> brandOptions {get;set;}
  public List<Selectoption> mFamilyOptions {get;set;}
  public List<Selectoption> mSegmentOptions {get;set;}
  public List<Selectoption> insightOptions {get;set;}
  public List<Selectoption> competitorTopic {get;set;}
  public List<Selectoption> brandvalues {get;set;}
  public List<Selectoption> topic {get;set;}
  public List<String> selectedcompetitors {get;set;}
  
  public VOCLine() {
    vocEntry = new VOC_Data_Entry__c();
    pFamilyOptions = new List<Selectoption>();
    pFamilyOptions.add(new Selectoption('', '--None--'));
    brandOptions = new List<Selectoption>();
    brandOptions.add(new Selectoption('', '--None--'));
    mFamilyOptions = new List<Selectoption>();
    mFamilyOptions.add(new Selectoption('', '--None--'));
    mSegmentOptions = new List<Selectoption>();
    mSegmentOptions.add(new Selectoption('', '--None--'));
    
    brandvalues = new List<Selectoption>();
    brandvalues.add(new Selectoption('', '--None--'));
    topic = new List<Selectoption>();
    topic.add(new SelectOption('Product', 'Products'));
    topic.add(new SelectOption('Marketing General', 'Marketing General'));
    topic.add(new SelectOption('Sales General', 'Sales General'));
    
    insightOptions = new List<Selectoption>();
    insightOptions.add(new Selectoption('', '--None--'));
    insightOptions.add(new Selectoption('Acoustics', 'Acoustics'));
    insightOptions.add(new Selectoption('Apps', 'Apps'));
    insightOptions.add(new Selectoption('Availability', 'Availability'));
    insightOptions.add(new Selectoption('Compliance and Regulation', 'Compliance and Regulation'));
    insightOptions.add(new Selectoption('Coverage', 'Coverage'));
    insightOptions.add(new Selectoption('Cross group opportunity', 'Cross group opportunity'));
    insightOptions.add(new Selectoption('Durability', 'Durability'));
    insightOptions.add(new Selectoption('Events', 'Events'));
    insightOptions.add(new Selectoption('Fire Rating', 'Fire Rating'));
    insightOptions.add(new Selectoption('IAQ', 'IAQ'));
    insightOptions.add(new Selectoption('Installation', 'Installation'));
    insightOptions.add(new Selectoption('Lead Time', 'Lead Time'));
    insightOptions.add(new Selectoption('Literature', 'Literature'));
    insightOptions.add(new Selectoption('Logistics', 'Logistics'));
    insightOptions.add(new Selectoption('Merchandising', 'Merchandising'));
    insightOptions.add(new Selectoption('Mold & Moisture', 'Mold & Moisture'));
    insightOptions.add(new Selectoption('New Product Idea', 'New Product Idea'));
    insightOptions.add(new Selectoption('Order Entry', 'Order Entry'));
    insightOptions.add(new Selectoption('Other', 'Other'));
    insightOptions.add(new Selectoption('Packaging', 'Packaging'));
    insightOptions.add(new Selectoption('POP', 'POP'));
    insightOptions.add(new Selectoption('Price', 'Price'));
    insightOptions.add(new Selectoption('Promotion', 'Promotion'));
    insightOptions.add(new Selectoption('Quality', 'Quality'));
    insightOptions.add(new Selectoption('Responsiveness', 'Responsiveness'));
    insightOptions.add(new Selectoption('Retail', 'Retail'));
    insightOptions.add(new Selectoption('Samples', 'Samples'));
    insightOptions.add(new Selectoption('Service', 'Service'));
    insightOptions.add(new Selectoption('Size', 'Size'));
    insightOptions.add(new Selectoption('Skills', 'Skills'));
    insightOptions.add(new Selectoption('Specification', 'Specification'));
    insightOptions.add(new Selectoption('Strategy', 'Strategy'));
    insightOptions.add(new Selectoption('Sustainability', 'Sustainability'));
    insightOptions.add(new Selectoption('Tools', 'Tools'));
    insightOptions.add(new Selectoption('Training', 'Training'));
    insightOptions.add(new Selectoption('Website', 'Website'));
    
    competitorTopic = new List<Selectoption>();
    competitorTopic.add(new SelectOption('', '--None--'));
    Schema.DescribeFieldResult fieldResult = VOC_Data_Entry__c.competitor_Topic__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for(Schema.PicklistEntry p : ple){
        competitorTopic.add(new SelectOption(p.getValue(), p.getValue()));
    }
  }
}