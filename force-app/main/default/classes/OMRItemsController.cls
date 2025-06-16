/**
    Name        : OMRItemsController
    Date        : 21 January 2020
    Author      :
    Description : This is Child Controller.
**/
public class OMRItemsController{
    public List<Product2> productList{get;set;}
    public String productName{get;set;}
    public String productNumber{get;set;}
    public String desciption{get;set;}
    public OMRItemsController(){
        productList = new List<Product2>();
        productName = productNumber = desciption = '';
    }
    
    public void search(){
        productList = new List<Product2>();
        if(String.isNotBlank(productName) || String.isNotBlank(productNumber) || String.isNotBlank(desciption)){
            String qry = 'SELECT Id, Name, ProductCode, Description, Item_Class__c, Item_Class_Description__c FROM Product2 WHERE ';
            if(String.isNotBlank(productName)){
                qry += 'Name LIKE \'%' + String.escapeSingleQuotes(productName.trim()) +'%\' AND ';
            }
            if(String.isNotBlank(productNumber)){
                qry += 'ProductCode LIKE \'%' + String.escapeSingleQuotes(productNumber.trim()) +'%\' AND ';
            }
            if(String.isNotBlank(desciption)){
                qry += 'Description LIKE \'%' + String.escapeSingleQuotes(desciption.trim()) +'%\' ';
            }
            qry = qry.removeEnd('AND ');
            qry += ' LIMIT 500';
            productList = Database.query(qry);
        }
    }
}