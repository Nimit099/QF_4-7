import { LightningElement, track, api } from 'lwc';
import copyIcon from '@salesforce/resourceUrl/CopyUrlIcon';
import htmlIcon from '@salesforce/resourceUrl/html';
import jsIcon from '@salesforce/resourceUrl/js';
import cssIcon from '@salesforce/resourceUrl/css';
import siteUrl from "@salesforce/apex/QuickFormHome.siteUrl";
import qrcode from './qrcode.js';

export default class Qf_publish extends LightningElement {
    copy_Icon = copyIcon;
    html_Icon = htmlIcon;
    css_Icon = cssIcon;
    js_Icon = jsIcon;
    @track spinner = false;
    readonly = true;
    lightBoxOpt;
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
    @track publishment_value = 'aura';
    @track text_b_color = "background-color: #b2CCE5;";
    @track img_b_color = "background-color: #ffffff;";
    @track auto_b_color = "background-color: #ffffff;";
    @track floating_b_color = "background-color: #ffffff;";
    aura = false;
    lwc = false;
    iframe = false;
    QRCode = false;
    lightBox = false;
    @api error_popup;
    @track error_popup1;
    @track message;

    connectedCallback() {
        try {
            this.spinner = true;
            this.error_popup1 = this.error_popup;

            siteUrl({
                formid: this.currentformid
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
            this.aura = true;
        } catch (error) {
            console.log(error);
        }
    }

    copyTextFieldHelper() {
        try {
            this.copyToClipboard('.inputBox', '.urlCopied');
        } catch (error) {
            console.log(error);
        }
    }

    copyDivToClipboard_1() {
        try {
            this.copyToClipboard(".copyCodeSection_12", ".copiedtext1");
        } catch (error) {
            console.log(error);
        }
    }
    copyDivToClipboard_2() {
        try {
            this.copyToClipboard(".copyCodeSection_22", ".copiedtext2");
        } catch (error) {
            console.log(error);
        }
    }
    copyDivToClipboard_3() {
        try {
            this.copyToClipboard(".copyCodeSection_32", ".copiedtext3");
        } catch (error) {
            console.log(error);
        }
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
            if (copiedTextSelector === '.urlCopied') {
                let error_msg = 'Something went wrong' + e.message;
                this.template.querySelector('c-toast-component').showToast('error', error_msg, 3000);
            } else {
                let error_msg = 'Something went wrong' + e.message;
                this.template.querySelector('c-toast-component').showToast('error', error_msg, 3000);
            }
        }
    }

    copy_code_fir_lwc() {
        try {
            this.copyToClipboard('.codestyle', null);
        } catch (error) {
            console.log(error);
        }
    }

    handleRadioChange(event) {
        try {
            const selectedOption = event.target.value;

            if (selectedOption == 'aura') {
                this.usingAura = true;
                this.aura = true;
                this.lwc = false;
                this.iframe = false;
                this.QRCode = false;
                this.lightBox = false;
            } else {
                this.usingAura = false;
            }


            if (selectedOption == 'lwc') {
                this.usingLWC = true;
                this.aura = false;
                this.lwc = true;
                this.iframe = false;
                this.QRCode = false;
                this.lightBox = false;
            } else {
                this.usingLWC = false;
            }


            if (selectedOption == 'iframe') {
                this.formIFrame = true;
                this.aura = false;
                this.lwc = false;
                this.iframe = true;
                this.PageUrl = '{pageURL : \'' + this.srcurl + '\'},';
                this.QRCode = false;
                this.lightBox = false;
            } else {
                this.formIFrame = false;
            }


            if (selectedOption == 'QRCode') {
                this.formQRCode = true;
                this.aura = false;
                this.lwc = false;
                this.iframe = false;
                this.QRCode = true;
                this.lightBox = false;
            } else {
                this.formQRCode = false;
            }

            if (selectedOption == 'lightBox') {
                this.formLightBox = true;
                this.lightBoxOpt = true;
                this.aura = false;
                this.lwc = false;
                this.iframe = false;
                this.QRCode = false;
                this.lightBox = true;
            } else {
                this.formLightBox = false;
                this.lightBoxOpt = false;
            }
        } catch (e) {
            this.message = 'Something went wrong in Selection Of Component' + e.message;
            this.showerrorpopup();
        }
    }

    handleLightBoxChange(event) {
        try {
            var getDiv = event.target.dataset.id;
            if (getDiv == 'textLink') {
                this.formTextLink = true;
                this.formImageLink = false;
                this.formAutoPopup = false;
                this.floatingButton = false;

                this.text_b_color = "background-color: #b2CCE5;";
                this.img_b_color = "background-color: #ffffff;";
                this.auto_b_color = "background-color: #ffffff;";
                this.floating_b_color = "background-color: #ffffff;";
            }
            if (getDiv == 'imageLink') {
                this.formTextLink = false;
                this.formImageLink = true;
                this.formAutoPopup = false;
                this.floatingButton = false;
                this.text_b_color = "background-color: #ffffff;";
                this.img_b_color = "background-color: #b2CCE5;";
                this.auto_b_color = "background-color: #ffffff;";
                this.floating_b_color = "background-color: #ffffff;";
            }
            if (getDiv == 'autoPopup') {
                this.formTextLink = false;
                this.formImageLink = false;
                this.formAutoPopup = true;
                this.floatingButton = false;
                this.text_b_color = "background-color: #ffffff;";
                this.img_b_color = "background-color: #ffffff;";
                this.auto_b_color = "background-color: #b2CCE5;";
                this.floating_b_color = "background-color: #ffffff;";
            }
            if (getDiv == 'floatingBtn') {
                this.formTextLink = false;
                this.formImageLink = false;
                this.formAutoPopup = false;
                this.floatingButton = true;
                this.text_b_color = "background-color: #ffffff;";
                this.img_b_color = "background-color: #ffffff;";
                this.auto_b_color = "background-color: #ffffff;";
                this.floating_b_color = "background-color: #b2CCE5;";
            }
        } catch (error) {
            console.log(error);
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
            this.message = 'Something went wrong in QR Code Generation' + e.message;
            this.showerrorpopup();
        }
    }

    showerrorpopup() {
        try {
            this.template.querySelector('c-errorpopup').errormessagee('Publish Component Error', this.message);
        } catch (error) {
            console.log(error);
        }
    }
}