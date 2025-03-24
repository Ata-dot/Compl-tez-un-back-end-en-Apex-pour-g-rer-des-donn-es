/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest

public with sharing class OrderTriggerTest {
    
    @IsTest

    public static void OrderUpdate(){
        Account acc = TestDataFactory2.createAccount();
        Product2  prod = TestDataFactory2.createProduct();
        PricebookEntry pbe = TestDataFactory2.createPricebookEntry(prod);
        Order ord = TestDataFactory2.createOrder(acc);
        OrderItem item = TestDataFactory2.createOrderItem(ord, prod, pbe);

        System.assertEquals('Draft', ord.Status);
    }


}