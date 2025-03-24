/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-18-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TransporterSelectorTest {
    @isTest
    private static void testGetAvailableTransporters() {
        // Création d'un compte de test
        Account acc = new Account(Name = 'Test Account', CustomerType__c = 'Professionnel');
        insert acc;

        // Création de transporteurs pour différents pays et types de clients
        Transporter__c transporter1 = new Transporter__c(Name = 'Transporteur A', CustomerType__c = 'Professionnel', External_ID__c = 'T1');
        Transporter__c transporter2 = new Transporter__c(Name = 'Transporteur B', CustomerType__c = 'Professionnel', External_ID__c = 'T2');
        Transporter__c transporter3 = new Transporter__c(Name = 'Transporteur C', CustomerType__c = 'Particulier', External_ID__c = 'T3');
        insert new List<Transporter__c>{ transporter1, transporter2, transporter3 };

        // Création de livraisons associées aux transporteurs
        Delivery__c delivery1 = new Delivery__c(
            Country__c = 'France',
            Price__c = 50,
            DeliveryTime__c = 3,
            Transporter__c = transporter1.Id
        );
        Delivery__c delivery2 = new Delivery__c(
            Country__c = 'France',
            Price__c = 40,  // Moins cher que delivery1
            DeliveryTime__c = 2,  // Plus rapide que delivery1
            Transporter__c = transporter2.Id
        );
        Delivery__c delivery3 = new Delivery__c(
            Country__c = 'Belgique',  // Autre pays
            Price__c = 30,
            DeliveryTime__c = 1,
            Transporter__c = transporter3.Id
        );
        insert new List<Delivery__c>{ delivery1, delivery2, delivery3 };

        //  Exécution de la méthode à tester
        Test.startTest();
        List<Delivery__c> availableTransporters = TransporterSelector.getAvailableTransporters('France', 'Professionnel');
        Test.stopTest();

        //  Vérifications
        System.assertEquals(2, availableTransporters.size(), 'Deux transporteurs devraient être retournés pour la France et Professionnel.');
        System.assertEquals(delivery2.Id, availableTransporters[0].Id, 'Le transporteur avec le plus bas prix et délai le plus court doit être en premier.');
        System.assertEquals(delivery1.Id, availableTransporters[1].Id, 'Le second transporteur doit être celui avec le prix le plus élevé.');
        
        // 🚀 Test avec un pays sans transporteurs
        
        List<Delivery__c> noTransporters = TransporterSelector.getAvailableTransporters('Suisse', 'Professionnel');
      

        //  Vérification qu'aucun transporteur n'est retourné
        System.assertEquals(0, noTransporters.size(), 'Aucun transporteur ne doit être retourné pour un pays sans transporteurs.');
    }
}
