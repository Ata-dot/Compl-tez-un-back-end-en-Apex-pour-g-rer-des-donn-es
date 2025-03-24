/**
 * @description       : Service pour la gestion des commandes.
 * @author            : TonNom/TonEmail
 * @group             : NomDuGroupe (si applicable)
 * @last modified on  : 03-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderService {

    /**
     * Valide une commande en fonction du type de client (Particulier ou Professionnel).
     * @param orderToValidate La commande à valider.
     * @throws AuraHandledException Si la commande ne respecte pas les critères de validation.
     */
    public static void validateOrder(Order orderToValidate) {
        System.debug('Validation de la commande : ' + orderToValidate.Id);

        if (orderToValidate.AccountId == null) {
            throw new AuraHandledException('La commande doit être associée à un compte.');
        }

        // Définir le nombre minimum de produits requis en fonction du type de client
        String accountType = [SELECT CustomerType__c FROM Account WHERE Id = :orderToValidate.AccountId LIMIT 1].CustomerType__c;
        Integer minProductsRequired = (accountType == 'Particulier') ? 3 : 5;
        Integer totalProducts = 0;

        // Calculer la quantité totale de produits dans la commande
        for (OrderItem item : [
            SELECT Quantity FROM OrderItem WHERE OrderId = :orderToValidate.Id
        ]) {
            totalProducts += item.Quantity.intValue(); // Convertir la quantité en Integer
        }

        // Vérifier si la quantité de produits est suffisante
        if (totalProducts < minProductsRequired) {
            throw new AuraHandledException('La commande doit contenir au moins ' + minProductsRequired + ' produits.');
        }

        System.debug('Commande validée avec succès.');
    }

    /**
     * Met à jour le statut d'une commande.
     * @param orderId L'ID de la commande à mettre à jour.
     * @param newStatus Le nouveau statut de la commande.
     */
    public static void updateOrderStatus(Id orderId, String newStatus) {
        System.debug('Mise à jour du statut de la commande : ' + orderId);

        try {
            Order orderToUpdate = [SELECT Id, Status FROM Order WHERE Id = :orderId LIMIT 1];
            orderToUpdate.Status = newStatus;
            update orderToUpdate;

            System.debug('Statut mis à jour en : ' + newStatus);
        } catch (Exception e) {
            System.debug('Erreur lors de la mise à jour du statut : ' + e.getMessage());
            throw new AuraHandledException('Impossible de mettre à jour la commande.');
        }
    }

    /**
     * Assigne le transporteur le plus performant à une commande en fonction du pays de livraison.
     * @param orderToProcess La commande à traiter.
     */
    public static void assignBestTransporter(Order orderToProcess) {
        System.debug('Assignation du transporteur pour la commande : ' + orderToProcess.Id);

        if (orderToProcess.ShippingCountry == null) {
            System.debug('Pays de livraison non renseigné.');
            return;
        }

        // Récupérer le meilleur transporteur pour le pays de livraison
        List<Delivery__c> deliveries = [
            SELECT Id, Price__c, Transporter__c, DeliveryTime__c, Status__c
            FROM Delivery__c
            WHERE Country__c = :orderToProcess.ShippingCountry
            ORDER BY DeliveryTime__c ASC, Price__c ASC
            LIMIT 1
        ];

        if (!deliveries.isEmpty()) {
            Delivery__c newDelivery = new Delivery__c(
                Order__c = orderToProcess.Id,
                Country__c = orderToProcess.ShippingCountry,
                Price__c = deliveries[0].Price__c,
                DeliveryTime__c = deliveries[0].DeliveryTime__c,
                Transporter__c = orderToProcess.Transporteur__c,
                ShippedDate__c = Date.today(),
                DeliveryDate__c = Date.today().addDays(deliveries[0].DeliveryTime__c.intValue()),
                Status__c = 'Livraisons en cours'

                
            );

            insert newDelivery; // Correction : il faut insérer une nouvelle livraison

            System.debug('Transporteur assigné avec succès : ' + deliveries[0].Transporter__c);
        } else {
            System.debug('Aucun transporteur trouvé pour le pays de livraison.');
        }
    }
}
