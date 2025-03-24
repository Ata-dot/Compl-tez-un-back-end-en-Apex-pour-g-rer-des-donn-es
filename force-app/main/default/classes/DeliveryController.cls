/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class DeliveryController {

    /**
     * Récupère les livraisons d'une commande donnée.
     * @param orderId L'ID de la commande.
     * @return List<Delivery__c> La liste des livraisons associées.
     */
    @AuraEnabled(cacheable=true)
    public static List<Delivery__c> getDeliveriesByOrder(Id orderId) {
        try {
            System.debug('Récupération des livraisons pour la commande: ' + orderId);
            List<Delivery__c> deliveries = [
                SELECT Id, Status__c, ShippedDate__c, Transporter__c, DeliveryTracking__c, Transporter__r.Name, 
                Order__c, Order__r.OrderNumber, Order__r.ShippingCountry
                FROM Delivery__c
                WHERE Order__c = :orderId
                ORDER BY ShippedDate__c DESC
            ];
            System.debug('Livraisons récupérées: ' + deliveries.size());
            System.debug('Livraisons: ' + JSON.serialize(deliveries));
            return deliveries;
        } catch (Exception e) {
            System.debug('Erreur lors de la récupération des livraisons pour la commande ' + orderId + ': ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de la récupération des livraisons.');
        }
    }

    /**
     * Met à jour le statut d'une livraison.
     * @param deliveryId L'ID de la livraison à mettre à jour.
     * @param newStatus Le nouveau statut de la livraison.
     */
    @AuraEnabled
    public static void updateDeliveryStatus(Id deliveryId, String newStatus) {
        try {
            System.debug('Mise à jour du statut de la livraison ID: ' + deliveryId + ' vers ' + newStatus);
            Delivery__c deliveryToUpdate = [
                SELECT Id, Status__c, Order__c, Transporter__c FROM Delivery__c WHERE Id = :deliveryId LIMIT 1
            ];

            if (deliveryToUpdate != null) {
                deliveryToUpdate.Status__c = newStatus;
                update deliveryToUpdate;
                System.debug('Statut de la livraison mis à jour avec succès: ' + newStatus);
            } else {
                System.debug('Livraison introuvable pour l\'ID: ' + deliveryId);
                throw new AuraHandledException('Livraison introuvable.');
            }
        } catch (Exception e) {
            System.debug('Erreur lors de la mise à jour du statut de la livraison ID ' + deliveryId + ': ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de la mise à jour du statut de la livraison.');
        }
    }

    /**
     * Récupère les détails d'une livraison spécifique.
     * @param deliveryId L'ID de la livraison à récupérer.
     * @return Delivery__c Les détails de la livraison.
     */
    @AuraEnabled(cacheable=true)
    public static Delivery__c getDeliveryDetails(Id deliveryId) {
        try {
            System.debug('Récupération des détails de la livraison ID: ' + deliveryId);
            Delivery__c delivery = [
                SELECT Id, Status__c, ShippedDate__c, Transporter__c, DeliveryTracking__c, Order__c, Transporter__r.Name
                FROM Delivery__c
                WHERE Id = :deliveryId
                LIMIT 1
            ];
            System.debug('Détails de la livraison récupérés: ' + delivery);
            return delivery;
        } catch (Exception e) {
            System.debug('Erreur lors de la récupération des détails de la livraison ID ' + deliveryId + ': ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de la récupération des détails de la livraison.');
        }
    }
}