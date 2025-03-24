/**
 * @description       : Test unitaire pour le contrôleur LaunchDeliveryController
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class LaunchDeliveryControllerTest {

    @isTest
    public static void testGetOrderDetails() {
        // Création d'un compte et d'une commande via la factory
        Account testAccount = TestDataFactory2.createAccount();
        Order testOrder = TestDataFactory2.createOrder(testAccount);

        // Création d'un produit et d'une entrée de prix
        Product2 testProduct = TestDataFactory2.createProduct();
        PricebookEntry testPbe = TestDataFactory2.createPricebookEntry(testProduct);
        OrderItem testOrderItem = TestDataFactory2.createOrderItem(testOrder, testProduct, testPbe);

        // Appel de la méthode pour récupérer les détails de la commande
        Test.startTest();
        Order retrievedOrder = LaunchDeliveryController.getOrderDetails(testOrder.Id);
        Test.stopTest();

        System.assertNotEquals(null, retrievedOrder, 'La commande récupérée ne doit pas être nulle');
        System.assertEquals(testOrder.Id, retrievedOrder.Id, 'L\'ID de la commande récupérée doit correspondre');
    }

    @isTest
    public static void testGetAvailableTransporters() {
        // Création d'un transporteur de test
        Transporter__c transporter = new Transporter__c(Name = 'DHL', CustomerType__c = 'Particulier', External_Id__c = 'DHL-123');
        insert transporter;

        // Appel de la méthode pour récupérer les transporteurs disponibles
        Test.startTest();
        List<Transporter__c> transporters = LaunchDeliveryController.getAvailableTransporters('France');
        Test.stopTest();

        System.assertNotEquals(0, transporters.size(), 'Il doit y avoir au moins un transporteur disponible');
    }

    
        @isTest
        public static void testLaunchDelivery() {
            // Création des données de test
            Account acc = TestDataFactory2.createAccount();
            Transporter__c transporter = TestDataFactory2.createTransporter();
            Order ord = TestDataFactory2.createOrder(acc);
            
            // Création de trois produits
            Product2 prod1 = TestDataFactory2.createProduct();
            Product2 prod2 = TestDataFactory2.createProduct();
            Product2 prod3 = TestDataFactory2.createProduct();
            
            // Création d'un PricebookEntry pour chaque produit
            PricebookEntry pbe1 = TestDataFactory2.createPricebookEntry(prod1);
            PricebookEntry pbe2 = TestDataFactory2.createPricebookEntry(prod2);
            PricebookEntry pbe3 = TestDataFactory2.createPricebookEntry(prod3);
            
            // Ajout des items à la commande
            TestDataFactory2.createOrderItem(ord, prod1, pbe1);
            TestDataFactory2.createOrderItem(ord, prod2, pbe2);
            TestDataFactory2.createOrderItem(ord, prod3, pbe3);
    
            // Activation de la commande
            ord.Status = 'Activated';
            update ord;
    
            // Appel de la méthode avec des données valides
            Test.startTest();
            try {
                LaunchDeliveryController.launchDelivery(ord.Id, transporter.Id); 
                System.assert(true, 'Livraison lancée avec succès');
            } catch (Exception e) {
                System.assert(false, 'Erreur lors du lancement de la livraison: ' + e.getMessage());
            }
            Test.stopTest();
        }
    }
    

    
    
        