/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class OrderServiceTest {

    @isTest
    static void testValidateOrder() {
        // Création des données avec la DataFactory
        Account acc = TestDataFactory2.createAccount();
        Order ord = TestDataFactory2.createOrder(acc);
        Product2 prod = TestDataFactory2.createProduct();
        PricebookEntry pbe = TestDataFactory2.createPricebookEntry(prod);
        TestDataFactory2.createOrderItem(ord, prod, pbe); // Ajout d'un produit

        Test.startTest();
        try {
            OrderService.validateOrder(ord);
        } catch (Exception e) {
            System.assert(false, 'La validation ne devrait pas échouer.');
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateOrderStatus() {
        Account acc = TestDataFactory2.createAccount();
        Order order = TestDataFactory2.createOrder(acc);

        Test.startTest();
        OrderService.updateOrderStatus(order.Id, 'Draft');
        Test.stopTest();

        Order updatedOrder = [SELECT Status FROM Order WHERE Id = :order.Id];
        System.assertEquals('Draft', updatedOrder.Status);
    }

    @isTest
    static void testAssignBestTransporter() {
        Account acc = TestDataFactory2.createAccount();
        Order order = TestDataFactory2.createOrder(acc);
        Transporter__c transporter = TestDataFactory2.createTransporter();
        TestDataFactory2.createDelivery(order, transporter);

        //Assigner un transporteur à la commande
        order.Transporteur__c = transporter.Id;
        update order;

        // Créer une livraison pour la commande
        TestDataFactory2.createDelivery(order, transporter);

        Test.startTest();
        OrderService.assignBestTransporter(order);
        Test.stopTest();

        //Verifier que le transporteur a bien été assigné à la livraison
        Delivery__c assignedDelivery = [SELECT Order__c, Transporter__c FROM Delivery__c WHERE Order__c = :order.Id LIMIT 1];
        System.assertEquals(transporter.Id, assignedDelivery.Transporter__c);
    }
}
