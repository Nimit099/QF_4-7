import { api, LightningElement, track } from 'lwc';
import close from '@salesforce/resourceUrl/popup_close';
import alert from '@salesforce/resourceUrl/popup_alert';
import {
    NavigationMixin
  } from "lightning/navigation";

export default class Errorpopup extends NavigationMixin(LightningElement) {
    alert_img = alert;
    close_img = close;
    @track header_type;
    @track error_messagee;
    show = false;
    @track userConfig = false;

    @api errormessagee(header_type, error_messagee) {
        try {
            this.show = true;
            this.header_type = header_type;
            this.error_messagee = error_messagee;
        } catch (error) {
            console.log('QF INFO:- Errormessage EcCmp');
        }
    }

    @api userconfigenable(userCon) {
        try {
            this.show = true;
            this.userConfig = userCon;
        } catch(error) {
            console.log('QF INFO:- Userconfig EcCmp');
        }
    }

    hideError() {
        this.show = false;
    }

    reload() {
        try {            
            window.location.reload();
            this.show = false;
        } catch (error) {
            console.log('QF INFO:- Reload EcCmp');
        }
    }

    Redirect(){

        this[NavigationMixin.Navigate]({
            type: "standard__navItemPage",
            attributes: {
                apiName: 'MVQF__User_Configuration'
            }
        });
    }
}