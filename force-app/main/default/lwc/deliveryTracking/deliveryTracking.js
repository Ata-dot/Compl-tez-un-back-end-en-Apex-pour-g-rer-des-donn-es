import { api, LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex'; // Importer la méthode refreshApex
import getDeliveriesByOrder from '@salesforce/apex/DeliveryController.getDeliveriesByOrder';
import OrderNumber from '@salesforce/schema/Order.OrderNumber';

export default class DeliveryTracking extends LightningElement {
    @track livraisons = []; // Stocke les livraisons
    @track error; // Stocke les erreurs
    @api recordId; // ID de la commande, à définir d'une manière ou d'une autre
    @track isLoading = false; // Indique si les données sont en cours de chargement
    wiredResult; // Stocke la référence à la méthode wire

    columns = [
        { label: 'Shipping Country', fieldName: 'ShippingAddress' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Transporter', fieldName: 'TransporterName' }
    ];

    // Utilisez la méthode wire pour appeler l'Apex Controller
    @wire(getDeliveriesByOrder, { orderId: '$recordId' })
    wiredDeliveries(result) {
        this.wiredResult = result;
        const { error, data } = result; // stocke les données pour refreshApex
        if (data) {
            console.log('Livraisons récupérées :', result.data);

            // Mapper les données pour les afficher dans le tableau
            this.livraisons = data.map(delivery => ({
                ...delivery,
                ShippingAddress: delivery.Country__c ? delivery.Country__c : 'N/A', // Adresse de livraison
                TransporterName: delivery.Transporter__r ? delivery.Transporter__r.Name : 'N/A' // Nom du transporteur
            }));
            
            this.error = undefined;
        } else if (error) {
            console.error('Erreur lors de la récupération des livraisons', error);
            this.error = 'Erreur: ' + JSON.stringify(error); // Gérer l'erreur
            this.livraisons = []; // Réinitialiser les livraisons
        }
    }

    // Méthode pour rafraichir  les livraisons
    loadLivraisons() {
        console.log('Rafraichissement des livraisons...');
        this.isLoading = true;

        refreshApex(this.wiredResult) // Appel de la méthode refreshApex
        .finally(() => {
            this.isLoading = false; // Désactive le spinner
        });

        getDeliveriesByOrder ({orderId: this.recordId})
        .then((data) => {
            this.livraisons = data;
            this.error = undefined;
            console.log('Livraisons récupérées :', this.livraisons);
        })
        .catch((error) => {
            this.error = 'Erreur lors de la récupération des livraisons: ' + error.body.message;
            this.livraisons = [];
            console.error('Erreur lors de la récupération des livraisons :', error);
        })
        .finally(() => {
            this.isLoading = false; //desactive le spinner
        });
    }
}