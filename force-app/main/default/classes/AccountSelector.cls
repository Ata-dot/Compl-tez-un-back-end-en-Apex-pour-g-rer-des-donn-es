/**
 * @description       : Classe utilitaire permettant la récupération des comptes dans Salesforce.
 *                      Fournit diverses méthodes pour récupérer les comptes par ID, nom, pays, ainsi que ceux liés aux commandes et transporteurs.
 * @author            : TonNom
 * @group             : Gestion des Comptes
 * @last modified on  : 03-18-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class AccountSelector {

    /**
     * @description  Récupère un compte par son ID.
     * @param        accountId L'ID du compte à récupérer.
     * @return       Account Le compte correspondant ou null si non trouvé.
     */
    public static Account getAccountById(Id accountId) {
        Account account = null;
        try {
            System.debug(' Recherche du compte avec l\'ID : ' + accountId);
            account = [
                SELECT Id, Name, Type, Industry, BillingCity, BillingCountry, Phone, Website, CustomerType__c
                FROM Account
                WHERE Id = :accountId
                LIMIT 1
            ];
        
         
        } catch (Exception e) {
            System.debug(' Erreur lors de la récupération du compte : ' + e.getMessage());
            
        }
        return account;
    }
}