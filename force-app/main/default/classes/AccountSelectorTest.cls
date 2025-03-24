/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-18-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class AccountSelectorTest {

    // Méthode de configuration pour créer des données de test
    @TestSetup
    static void setupTestData() {
        // Créer un compte pour les tests
        Account testAccount = new Account(
            Name = 'Test Account',
            Type = 'Customer',
            Industry = 'Technology',
            BillingCity = 'Paris',
            BillingCountry = 'France',
            Phone = '0123456789',
            CustomerType__c = 'Professionnel'
        );
        insert testAccount;
    }

    // Test pour la méthode getAccountById
    @isTest
    static void testGetAccountById() {
        // Récupérer le compte créé dans la méthode de configuration
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        // Appeler la méthode à tester
        Test.startTest();
        Account result = AccountSelector.getAccountById(testAccount.Id);
        Test.stopTest();

        // Vérifier que le compte retourné correspond à celui créé
        System.assertNotEquals(null, result, 'Le compte ne devrait pas être null');
        System.assertEquals(testAccount.Id, result.Id, 'L\'ID du compte ne correspond pas');
        System.assertEquals('Test Account', result.Name, 'Le nom du compte ne correspond pas');
        System.assertEquals('Customer', result.Type, 'Le type du compte ne correspond pas');
        System.assertEquals('Technology', result.Industry, 'L\'industrie du compte ne correspond pas');
    }
}