/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TestDataFactory2 {

    public static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.CustomerType__c = 'Particulier';
        insert acc;
        return acc;
    }

    public static Product2 createProduct(){
        Product2 prod = new Product2();
        prod.Name = 'Product Test';
        prod.Family = 'None';
        prod.IsActive = true;
        prod.ProductCode = 'Test01';
        insert prod;
        return prod;
    }

    public static PricebookEntry createPricebookEntry(Product2 prod){
        PricebookEntry pbe = new PricebookEntry();
        pbe.UseStandardPrice = false;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 100; 
        pbe.IsActive = true;
        insert pbe;
        return pbe;
    }

    public static Order createOrder(Account acc ){
        Order ord = new Order();
        ord.AccountId = acc.Id;
        ord.ShippingCountry = 'France';
        ord.EffectiveDate = Date.today().addDays(-5);
        ord.Status = 'Draft';
        ord.Pricebook2Id = Test.getStandardPricebookId();        
        insert ord;
        return ord;
    }

    public static OrderItem createOrderItem(Order ord, Product2 prod, PricebookEntry pbe){
        OrderItem item = new OrderItem();
        item.OrderId = ord.Id;
        item.Quantity = 5;
        item.Product2Id = prod.Id;
        item.PricebookEntryId = pbe.Id;
        item.UnitPrice = pbe.UnitPrice;
        insert item;
        return item;
    }

    public static Transporter__c createTransporter(){
        Transporter__c  transporter = new Transporter__c();
        transporter.Name = 'Transporteur Test';
        transporter.CustomerType__c = 'Particulier';
        transporter.External_Id__c = 'TR' + String.valueOf(Crypto.getRandomInteger()).substring(0, 6);
        transporter.DeliveryTime__c = 2;
        insert transporter;
        return transporter;
    }

    public static Delivery__C createDelivery(Order ord, Transporter__c transporter){
        Delivery__c delivery = new Delivery__c();
        delivery.Order__c = ord.Id;
        delivery.Country__c = 'France';
        delivery.Price__c = 100;
        delivery.DeliveryTime__c = 3;
        delivery.Transporter__c = transporter.Id;
        delivery.Status__c = 'Livraisons en cours';
        insert delivery;
        return delivery;
    }

}