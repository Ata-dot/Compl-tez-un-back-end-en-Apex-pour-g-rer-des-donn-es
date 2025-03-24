/**
 * @description Unit tests for DeliveryController using TestDataFactory2
 * @group Delivery
 */
@IsTest
private class DeliveryControllerTest {
    
    // Constants for delivery status values
    private static final String STATUS_EN_COURS = 'Livraisons en cours';
    private static final String STATUS_EFFECTUEES = 'Livraisons effectuées';
    private static final String STATUS_ECHOUEES = 'Livraisons échouées';
    
    @TestSetup
    static void setupTestData() {
        Account acc = TestDataFactory2.createAccount();
        Product2 prod = TestDataFactory2.createProduct();
        PricebookEntry pbe = TestDataFactory2.createPricebookEntry(prod);
        Order ord = TestDataFactory2.createOrder(acc);
        TestDataFactory2.createOrderItem(ord, prod, pbe);
        Transporter__c transporter = TestDataFactory2.createTransporter();
        TestDataFactory2.createDelivery(ord, transporter);
    }
    
    @IsTest
    static void testGetDeliveriesByOrder() {
        Order ord = [SELECT Id FROM Order LIMIT 1];
        
        Test.startTest();
        List<Delivery__c> deliveries = DeliveryController.getDeliveriesByOrder(ord.Id);
        Test.stopTest();
        
        System.assertNotEquals(0, deliveries.size(), 'Should have found deliveries');
        System.assertEquals(STATUS_EN_COURS, deliveries[0].Status__c, 'Default status should be "Livraisons en cours"');
    }
    
    @IsTest
    static void testUpdateDeliveryStatus() {
        Delivery__c delivery = [SELECT Id FROM Delivery__c LIMIT 1];
        
        Test.startTest();
        DeliveryController.updateDeliveryStatus(delivery.Id, STATUS_EFFECTUEES);
        Test.stopTest();
        
        Delivery__c updatedDelivery = [SELECT Status__c FROM Delivery__c WHERE Id = :delivery.Id];
        System.assertEquals(STATUS_EFFECTUEES, updatedDelivery.Status__c, 'Status should update to "Livraisons effectuées"');
    }
    
    @IsTest
    static void testUpdateToFailedStatus() {
        Delivery__c delivery = [SELECT Id FROM Delivery__c LIMIT 1];
        
        Test.startTest();
        DeliveryController.updateDeliveryStatus(delivery.Id, STATUS_ECHOUEES);
        Test.stopTest();
        
        Delivery__c updatedDelivery = [SELECT Status__c FROM Delivery__c WHERE Id = :delivery.Id];
        System.assertEquals(STATUS_ECHOUEES, updatedDelivery.Status__c, 'Status should update to "Livraisons échouées"');
    }
    
    @IsTest
    static void testInvalidStatusUpdate() {
        Delivery__c delivery = [SELECT Id FROM Delivery__c LIMIT 1];
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            DeliveryController.updateDeliveryStatus(delivery.Id, 'Invalid Status');
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assert(exceptionThrown, 'Should throw exception for invalid status');
    }
}