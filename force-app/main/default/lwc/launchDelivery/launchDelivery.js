import { LightningElement, api, wire, track } from 'lwc';
import getOrderDetails from '@salesforce/apex/LaunchDeliveryController.getOrderDetails';
import getAvailableTransporters from '@salesforce/apex/TransporterSelector.getAvailableTransporters';
import launchDelivery from '@salesforce/apex/LaunchDeliveryController.launchDelivery';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class LaunchDelivery extends LightningElement {
    @api recordId; // ID de la commande Salesforce
    @track order; // Détails de la commande
    @track delivery; // Détails de la livraison
    selectedTransporter; // ID du transporteur sélectionné
    @track transporters = [
        // { label: 'Chronopost', value: 'Chronopost' },
        // { label: 'DHL Express', value: 'DHL Express' },
        // { label: 'LaPoste', value: 'LaPoste' },
        // { label: 'UPS', value: 'UPS' },
        // { label: 'FedEx', value: 'FedEx' },
        // { label: 'GLS', value: 'GLS' },
        // { label: 'Mondial Relay', value: 'Mondial Relay' },
        // { label: 'TNT', value: 'TNT' },
        // { label: 'Colis Privé', value: 'Colis Privé' },
        // { label: 'DB Schenker', value: 'DB Schenker' },
        // { label: 'Geodis', value: 'Geodis' },
        // { label: 'Amazon Logistics', value: 'Amazon Logistics' },
        // { label: 'DPD', value: 'DPD' },
        // { label: 'XPO Logistics', value: 'XPO Logistics' },
        // { label: 'Hermes', value: 'Hermes' }

    ]; // Liste des transporteurs disponibles

    // Récupération des détails de la commande
    @wire(getOrderDetails, { orderId: '$recordId' })
    wiredOrder({ data, error }) {
        if (data) {
            console.log('Détails de la commande récupérés :', data);
            this.order = data;
        } else if (error) {
            console.error('Erreur lors de la récupération de la commande :', error);
            this.showToast('Erreur', 'Impossible de récupérer la commande.', 'error');
        }
    }
    getdetailsoforder(){
        getOrderDetails ({orderId: this.recordId})
        .then(result => {
            this.order = result;
            console.log('Détails de la commande récupérés :', this.order);
            this.getAvailableTransporters();
        })
        .catch(error => {
            this.error = error;
        });
    }
    getAvailableTransporters(){
        getAvailableTransporters({ country: this.order.ShippingCountry, customerType: 'Particulier' })
        .then(result => {
            console.log('Transporteurs disponibles :', result);
            this.transporters = result.map(item => ({ label: " Price: "+ item.Price__c +"euro, "+"Delay: "+ item.DeliveryTime__c +"days, "+item.Transporter__r.Name, value: item.Transporter__c}));
        })
        .catch(error => {
            console.error('Erreur lors de la récupération des transporteurs :', error);
            this.showToast('Erreur', 'Impossible de récupérer les transporteurs.', 'error');
        });
    }
    
    connectedCallback () {
        this.getdetailsoforder();
    }

    
    // Mise à jour du transporteur sélectionné
    handleTransporterChange(event) {
        this.selectedTransporter = event.target.value;
        console.log('Transporteur sélectionné :', this.selectedTransporter);
    }

    // Lancement de la livraison
    handleLaunchDelivery() {
        if (!this.selectedTransporter) {
            this.showToast('Erreur', 'Veuillez sélectionner un transporteur.', 'error');
            return;
        }

        launchDelivery({ orderId: this.recordId, transporterId: this.selectedTransporter })
            .then(() => {
                this.showToast('Succès', 'La livraison a été lancée.', 'success');
                console.log('Livraison lancée avec succès.');
                return refreshApex(this.wiredDelivery); // Rafraîchir la livraison
            })
            .catch(error => {
                console.error('Erreur lors du lancement de la livraison :', error);
                this.showToast('Erreur', error.body.message, 'error');
            });
    }

    // Affichage des notifications
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    // Vérification si la livraison est en cours
    get isDeliveryInProgress() {
        return this.delivery?.Status__c === 'En cours';
    }
}