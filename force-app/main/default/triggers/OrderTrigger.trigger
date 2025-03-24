/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-22-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OrderTrigger on Order (before insert, before update) {
    try {
        OrderTriggerHandler.handleOrders(Trigger.new);
    } catch (Exception e) {
        System.debug('Erreur dans OrderTrigger : ' + e.getMessage());
    }
}