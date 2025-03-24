/**
 * @description       : Classe pour gérer la sélection des transporteurs.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-18-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TransporterSelector {

    /**
     * Récupère les transporteurs disponibles triés par coût (ascendant) et délai (ascendant).
     * @return List<Delivery__c> La liste des transporteurs disponibles.
     */
    @AuraEnabled(cacheable=true)
    public static List<Delivery__c> getAvailableTransporters(String country, String customerType) {
        System.debug('Récupération des transporteurs disponibles.');
        System.debug('Pays : ' + country);
        System.debug('Type de client : ' + customerType);

        try {
            return [
                SELECT Id, DeliveryTime__c, Price__c, Transporter__c, Transporter__r.Name, Transporter__r.CustomerType__c
                FROM Delivery__c
                WHERE Country__c = :country AND Transporter__r.CustomerType__c = :customerType
                ORDER BY Price__c ASC, DeliveryTime__c ASC
            ];
        } catch (Exception e) {
            // Capture et log l'erreur générique
            System.debug('Erreur lors de la récupération des transporteurs : ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de la récupération des transporteurs.');
        }
    }
}