import { api, LightningElement, track } from 'lwc';
import close from '@salesforce/resourceUrl/popup_close';
import alert from '@salesforce/resourceUrl/popup_alert';

export default class Errorpopup extends LightningElement {
    alert_img = alert;
    close_img = close;
    @track header_type;
    @track error_messagee;
    show = false;

    @api errormessagee(header_type, error_messagee) {
        try {
            this.show = true;
            this.header_type = header_type;
            this.error_messagee = error_messagee;
        } catch (error) {
            console.log(error);
        }
    }

    hideError() {
        this.show = false;
    }

    reload() {
        try {
            const reload = new CustomEvent('errorpopup');
            this.dispatchEvent(reload);
            this.show = false;
        } catch (error) {
            console.log(error);
        }
    }
}