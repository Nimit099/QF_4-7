import { LightningElement, track, api } from 'lwc';
import copyIcon from '@salesforce/resourceUrl/CopyUrlIcon';
import getsiteUrl from "@salesforce/apex/QuickFormHome.getsiteUrl";
import qrcode from './qrcode.js';

export default class Qf_publish extends LightningElement {
    copy_Icon = copyIcon;
        @track spinner = false;
        formSiteURL = true;
    usingAura = true;
    usingLWC;
    formIFrame;
    formLightBox;
    formTextLink = true;
    formImageLink;
    formAutoPopup;
    floatingButton;
    formQRCode;
    @track formurl = '';
    @track srcurl;
    @track PageUrl;
    @api currentformid;
        aura = false;
    lwc = false;
    iframe = false;
    QRCode = false;
        @track message;

    connectedCallback() {
        this.spinner = true;
        this.aura = true;

       getsiteUrl({
            formId: this.currentformid
        })
            .then(data => {
                this.formurl = data;
                this.srcurl = data;
                if (this.formurl.includes("User Configuration tab")) {
                    this.srcurl = '';
                    this.template.querySelector('.inputBox').style.color = 'red';
                }
                this.spinner = false;
                this.error = undefined;
            })
            .catch(() => {
                this.message = 'Something went wrong in Site URL(A)';
                this.showerrorpopup();
                this.spinner = false;
            })
            }

    copyTextFieldHelper() {
        this.copyToClipboard('.inputBox', '.urlCopied');
    }

    copyDivToClipboard_1() {
        this.copyToClipboard(".copyCodeSection_12", ".copiedtext1");
    }
    copyDivToClipboard_2() {
        this.copyToClipboard(".copyCodeSection_22", ".copiedtext2");
    }
    copyDivToClipboard_3() {
        this.copyToClipboard(".copyCodeSection_32", ".copiedtext3");
    }

    copyToClipboard(elementSelector, copiedTextSelector) {
        try {
            const range = document.createRange();
            let parentDiv = null;
            let hiddenInput = null;

            if (elementSelector === '.codestyle') {
                parentDiv = event.currentTarget.parentNode.parentNode.querySelector('.codestyle');
                range.selectNode(parentDiv);
            } else if (elementSelector === '.inputBox') {
                hiddenInput = this.template.querySelector('.inputBox');
                range.selectNode(hiddenInput);
            } else {
                range.selectNode(this.template.querySelector(elementSelector));
            }

            window.getSelection().removeAllRanges();
            window.getSelection().addRange(range);
            document.execCommand("copy");

            const copied = this.template.querySelector(copiedTextSelector);
            copied.style.display = 'block';
            setTimeout(() => {
                copied.style.display = 'none';
                window.getSelection().removeAllRanges();
            }, 1500);
        } catch (e) {
            let error_msg = 'Something went wrong while coping' ;
                this.template.querySelector('c-toast-component').showToast('error', error_msg, 3000);
            }
        }
    
    copy_code_fir_lwc() {
        this.copyToClipboard('.codestyle', null);
    }

    handleRadioChange(event) {
        try {
            const selectedOption = event.target.value;
this.usingAura = false;
            this.aura = false;
            this.lwc = false;
            this.iframe = false;
            this.QRCode = false;
            this.usingLWC = false;
            this.formIFrame = false;
            this.formQRCode = false;

            if (selectedOption == 'aura') {
                this.usingAura = true;
                this.aura = true;
                } else if (selectedOption == 'lwc') {
                this.usingLWC = true;
                                this.lwc = true;
                } else if (selectedOption == 'iframe') {
                this.formIFrame = true;
                                this.iframe = true;
                this.PageUrl = '{pageURL : \'' + this.srcurl + '\'},';
                } else if (selectedOption == 'QRCode') {
                this.formQRCode = true;
                                this.QRCode = true;
                            }
        } catch (e) {
            this.message = 'Something went wrong in Selection Of Component' ;
            this.showerrorpopup();
        }
    }

    handleLightBoxChange(event) {
        var getDiv = event.target.dataset.id;
this.formTextLink = false;
        this.formImageLink = false;
        this.formAutoPopup = false;
        this.floatingButton = false;

        if (getDiv == 'textLink') {
            this.formTextLink = true;
                    }
        if (getDiv == 'imageLink') {
                        this.formImageLink = true;
                    }
        if (getDiv == 'autoPopup') {
                        this.formAutoPopup = true;
                    }
        if (getDiv == 'floatingBtn') {
                        this.floatingButton = true;
        }
    }

    qrGenerate() {
        try {
            const qrCodeGenerated = new qrcode(0, 'H');
            let strForGenearationOfQRCode = this.formurl;
            qrCodeGenerated.addData(strForGenearationOfQRCode);
            qrCodeGenerated.make();
            this.template.querySelector(".qrcode2").innerHTML = qrCodeGenerated.createSvgTag({});
        } catch (e) {
            this.message = 'Something went wrong in QR Code Generation' ;
            this.showerrorpopup();
        }
    }

    showerrorpopup() {
        this.template.querySelector('c-errorpopup').errormessagee('Publish Component Error', this.message);
    }
}