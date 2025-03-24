/**
 * @description       : Handler pour gérer les événements du trigger Order.
 * @author            : TonNom/TonEmail
 * @group             : NomDuGroupe (si applicable)
 * @last modified on  : 03-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderTriggerHandler {
    public static void handleOrders(List<Order> orders) {
        for (Order ord : orders) {
            OrderService.validateOrder(ord);
                OrderService.assignBestTransporter(ord);
            // try {
                
            // } catch (Exception e) {
            //     ord.addError('Erreur lors du traitement de la commande : ' + e.getMessage());
            // }
        }
    }
}
 


