import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from 'lightning/platformResourceLoader';
import signaturePadURL from '@salesforce/resourceUrl/signature_pad';

export default class Signature_Pad extends LightningElement {
    sigPadInitialized = false;
    canvasWidth = 400;
    canvasHeight = 200;

    connectedCallback() {
        if (this.sigPadInitialized) {
            return;
        }
        this.sigPadInitialized = true;

        Promise.all([
            loadScript(this, signaturePadURL)
        ])
            .then(() => {
                this.initialize();
            })
            .catch(error => {
                console.log(error);
            });
    }

    initialize() {
        try {
            const canvas = this.template.querySelector('canvas.signature-pad');
            console.log(canvas);
            this.signaturePad = new window.SignaturePad(canvas);
        } catch (error) {
            console.log(error.message);
        }
       
    }

    handleClick() {
        console.log(this.signaturePad.toDataURL("image/png"))
    }
}