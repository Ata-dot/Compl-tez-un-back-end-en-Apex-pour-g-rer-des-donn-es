/**
 * @description       : Contrôleur pour gérer le lancement et le suivi des livraisons.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class LaunchDeliveryController {
    
    /**{}
     * Récupère les détails d'une commande spécifique.
     * @param orderId L'ID de la commande à récupérer.
     * @return Order La commande avec ses détails.
     */
    @AuraEnabled(cacheable=true)
    public static Order getOrderDetails(Id orderId) {
        System.debug('Récupération des détails de la commande avec ID: ' + orderId);
        
        try {
            Order order = [
                SELECT Id, OrderNumber, Status, Account.CustomerType__c, Transporteur__c, ShippingCountry,
                       (SELECT Id, Product2.Name, Quantity FROM OrderItems)
                FROM Order
                WHERE Id = :orderId
                LIMIT 1
            ];
            return order;
        } catch (Exception e) {
            System.debug('Erreur lors de la récupération des détails de la commande: ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de la récupération des détails de la commande.');
        }
    }

    /**
     * Récupère la liste des transporteurs disponibles pour un pays donné.
     * @param country Pays de destination.
     * @return List<Transporter__c> Liste des transporteurs filtrés et triés.
     */
    @AuraEnabled(cacheable=true)
    public static List<Transporter__c> getAvailableTransporters(String country) {
        System.debug('Récupération des transporteurs pour le pays: ' + country);

        try {
            return [
                SELECT Id, Name, External_ID__c, DeliveryTime__c, CustomerType__c 
                FROM Transporter__c
                ORDER BY External_ID__c ASC, DeliveryTime__c ASC
            ];
        } catch (Exception e) {
            System.debug('Erreur lors de la récupération des transporteurs: ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de la récupération des transporteurs.');
        }
    }

    /**
     * Récupère les détails de la livraison associée à une commande.
     * @param orderId L'ID de la commande associée.
     * @return Delivery__c Les détails de la livraison.
     */
    @AuraEnabled(cacheable=true)
    public static Delivery__c getDeliveryDetails(Id orderId) {      
        System.debug('Récupération des détails de la livraison pour la commande ID: ' + orderId);
        
        try {
            return [
                SELECT Id, Status__c, ShippedDate__c
                FROM Delivery__c
                WHERE Order__c = :orderId
                LIMIT 1
            ];
        } catch (Exception e) {
            System.debug('Erreur lors de la récupération des détails de la livraison: ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de la récupération des détails de la livraison.');
        }
    }

    /**
     * Lance la livraison d'une commande avec le transporteur optimal.
     * @param orderId L'ID de la commande.
     * @param transporterId L'ID du transporteur sélectionné.
     */
    @AuraEnabled
    public static void launchDelivery(Id orderId, Id transporterId) {
        System.debug('Lancement de la livraison pour la commande: ' + orderId + ' avec le transporteur: ' + transporterId);

        try {
            Order order = [
                SELECT Id, Status, ShippingCountry
                FROM Order
                WHERE Id = :orderId
                LIMIT 1
            ];

            if (order == null) {
                System.debug('Commande non trouvée avec l\'ID: ' + orderId);
                throw new AuraHandledException('Commande non trouvée.');
            }

            if (order.Status == 'Draft') {
                System.debug('La commande n\'est pas activée, impossible de la livrer.');
                throw new AuraHandledException('La commande doit être activée avant d\'être expédiée.');
            }

            Transporter__c transporter = [
                SELECT Id, Name, DeliveryTime__c
                FROM Transporter__c
                WHERE Id = :transporterId
                LIMIT 1
            ];

            if (transporter == null) {
                System.debug('Transporteur non trouvé.');
                throw new AuraHandledException('Transporteur sélectionné introuvable.');
            }

            
            update new Order(Id=orderId, Transporteur__c=transporterId);

           
        } catch (Exception e) {
            System.debug('Erreur lors du lancement de la livraison: ' + e.getMessage());
            throw new AuraHandledException('Erreur lors du lancement de la livraison.');
        }           
    }
}