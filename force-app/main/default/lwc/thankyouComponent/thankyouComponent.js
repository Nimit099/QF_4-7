import { LightningElement, track, api } from 'lwc';
import thankyoulogo from '@salesforce/resourceUrl/Thankyoulogo';
import whitepen from '@salesforce/resourceUrl/whitepen';
import records from '@salesforce/apex/qfthankyou.insertrecord';
import getrecords from '@salesforce/apex/qfthankyou.getthankyoupage';
import changelabel from '@salesforce/apex/qfthankyou.changelabel';

import { NavigationMixin } from "lightning/navigation";
export default class ThankyouComponent extends NavigationMixin(LightningElement) {
    thankyoulogo = thankyoulogo;
    whitepen = whitepen;
    formats = ['font', 'size', 'bold', 'italic', 'underline', 'strike', 'list', 'indent', 'align', 'link', 'clean', 'table',
        'header', 'color', 'background'
    ];
    @api text;
    @track textNewValue;
    @api url;
    @track urlNewValue;
    @api richtext;
    @track richtextNewValue;
    @api label;
    @track labelNewValue;
    @api changelabel;
    @track changelabelNewValue;
    textcheck = false;
    richtextcheck = false;
    editlabelcheck = false;
    picklist;
    @api currentformid;
    @api currentthankyouid;
    @track currentthankyouidNewValue;
    @api formname = '';
    None = true;
    @track ThankYou_Text;
    @track ThankYou_URL;
    @track Redirect_Text_And_URL;
    @track ThankYou_Report;
    @track ThankYou_RichText;
    classtext;
    spinner;
    @api editing = false;
    @api thankyoutype;
    @track thankyoutypeNewValue;
    @api submissionId;
    @api report = false;
    @track reportdata = [];
    @track thankyoulabel = true;
    classurl;
    @api error_popup = false;
    @track error_popupNewValue;
    @track message;

    connectedCallback() {
        try {
            this.thankyoutypeNewValue = this.thankyoutype;
            this.labelNewValue = this.label;
            this.changelabelNewValue = this.changelabel;
            this.currentthankyouidNewValue = this.currentthankyouid;
            this.textNewValue = this.text;
            this.urlNewValue = this.url;
            this.richtextNewValue = this.richtext;
            this.error_popupNewValue = this.error_popup;
            this.spinner = true;
            if (this.editing == true) {
                getrecords({
                    currentformid: this.currentformid
                }).then(result => {
                    this.thankyoutypeNewValue = result.MVQF__Thankyou_Page_Type__c;
                    this.labelNewValue = result.MVQF__ThankYou_Label__c;
                    this.changelabelNewValue = result.MVQF__ThankYou_Label__c;
                    this.currentthankyouidNewValue = result.Id;
                    if (result.MVQF__Thankyou_Page_Type__c == 'Show Text') {
                        this.classtext = result.MVQF__Thankyou_Text__c;
                        this.textNewValue = result.MVQF__Thankyou_Text__c;
                        this.textfunc();
                        this.template.querySelector(".text").style = "display:block";

                    } else if (result.MVQF__Thankyou_Page_Type__c == 'Redirect to a webpage') {
                        this.urlNewValue = result.MVQF__Thank_you_URL__c;
                        this.classurl = this.urlNewValue;
                        this.urlfunc();
                        this.template.querySelector(".url").style = "display:block";

                    } else if (result.MVQF__Thankyou_Page_Type__c == 'Show text, then redirect to web page') {
                        this.urlNewValue = result.MVQF__Thank_you_URL__c;
                        this.classurl = this.urlNewValue;
                        this.classtext = result.MVQF__Thankyou_Text__c;
                        this.textNewValue = result.MVQF__Thankyou_Text__c;
                        this.text_urlfunc();
                        this.template.querySelector(".text_url").style = "display:block";

                    } else if (result.MVQF__Thankyou_Page_Type__c == 'Show HTML block') {
                        this.classtext = result.MVQF__Thankyou_Text__c;
                        this.richtextNewValue = result.MVQF__Thankyou_Text__c;
                        this.richtextfun();
                        this.template.querySelector(".richtext").style = "display:block";

                    } else if (result.MVQF__Thankyou_Page_Type__c == 'None') {
                        this.nonefunc();
                    }
                    this.template.querySelector('.thanksPreviewDiv').style.background = '#E5E5E5';
                    this.template.querySelector('.thanksMainDiv').style = 'justify-content= none';
                    this.spinner = false;
                }).catch(() => {
                    this.spinner = false;
                    this.message = 'Something Went Wrong In Thank You Page';
                    this.showerror();
                })
            } else {
                if (this.thankyoutypeNewValue == 'Show Text') {
                    this.textfunc();
                } else if (this.thankyoutypeNewValue == 'Redirect to a webpage') {
                    this.urlfunc();
                } else if (this.thankyoutypeNewValue == 'Show text, then redirect to web page') {
                    this.text_urlfunc();
                    setTimeout(() => {
                        window.open(this.urlNewValue,"_self");
                    }, 3000);
                } else if (this.thankyoutypeNewValue == 'Show HTML block') {
                    this.richtextfun();
                } else if (this.thankyoutypeNewValue == 'None') {
                    this.nonefunc();
                } else if (this.thankyoutypeNewValue == 'Show report of User data') {
                    this.reportfunc();
                }
            }
        } catch (e) {
            this.message = 'Something Went Wrong In Thank You Page ' + e.message;
        }
    }

    toggleFields(event) {
        try {
            this.textcheck = false;
            this.richtextcheck = false;
            this.urlNewValue = '';
            this.textNewValue = '';
            this.richtextNewValue = '';
            const a = this.template.querySelectorAll(".form-control");            
            for (let i = 0; i < a.length; i++) {
                a[i].style.display = "none";
            }
            this.picklist = event.target.value;
            if (event.target.value == 'text') {
                if (this.thankyoutypeNewValue == 'Show Text') {
                    this.textNewValue = this.classtext;
                }
                this.textfunc();
            } else if (event.target.value == 'text_url') {
                if (this.thankyoutypeNewValue == 'Show text, then redirect to web page') {
                    this.textNewValue = this.classtext;
                    this.urlNewValue = this.classurl;
                }
                this.text_urlfunc();
            } else if (event.target.value == 'url') {
                if (this.thankyoutypeNewValue == 'Redirect to a webpage') {
                    this.urlNewValue = this.classurl;
                }
                this.urlfunc();
            } else if (event.target.value == 'richtext') {
                if (this.thankyoutypeNewValue == 'Show HTML block') {
                    this.richtextNewValue = this.classtext;
                }
                this.richtextfun();
            } else if (event.target.value == 'none') {
                this.nonefunc();
            }            
            let setStyle = this.template.querySelector("." + event.target.value);  
            if(setStyle != null && setStyle != undefined){
                setStyle.style = "display:block";
            }                      
        } catch (error) {
            console.log('QF INFO:- ToggleFields ThankyouCmp');
        }
    }

    input(event) {
        if (event.target.name == 'url') {
            this.urlNewValue = event.target.value;
        } else if (event.target.name == 'text') {
            this.textNewValue = event.target.value;
        } else if (event.target.name == 'richtext') {
            this.richtextNewValue = event.target.value;
        }
    }

    saveThanksData() {
        try {
            this.spinner = true;
            if (this.ThankYou_URL == true || this.Redirect_Text_And_URL == true) {
                if (this.Redirect_Text_And_URL == true) {
                    this.classtext = this.textNewValue;
                }
                this.classurl = this.urlNewValue;
                var regexp = new RegExp('^(?!mailto:)(?:(?:http|https|ftp)://)(?:\\S+(?::\\S*)?@)?(?:(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[0-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,})))|localhost)(?::\\d{2,5})?(?:(/|\\?|#)[^\\s]*)?$');
                if (regexp.test(this.urlNewValue)) {
                    records({
                        name: this.formname,
                        picklist: this.picklist,
                        label: this.labelNewValue,
                        classtext: this.classtext,
                        formId: this.currentformid,
                        url: this.urlNewValue,
                        currentthankyouid: this.currentthankyouidNewValue
                    }).then(result => {
                        this.template.querySelector('c-toast-component').showToast('success', 'Successlly Changed', 3000);
                        this.thankyoutypeNewValue = result.MVQF__Thankyou_Page_Type__c;
                        this.labelNewValue = result.MVQF__ThankYou_Label__c;
                        this.changelabelNewValue = result.MVQF__ThankYou_Label__c;
                        this.currentthankyouidNewValue = result.Id;
                        if (result.MVQF__Thankyou_Page_Type__c == 'Show Text') {
                            this.classtext = result.MVQF__Thankyou_Text__c;
                            this.textNewValue = result.MVQF__Thankyou_Text__c;
                            this.textfunc();
                            this.template.querySelector(".text").style = "display:block";

                        } else if (result.MVQF__Thankyou_Page_Type__c == 'Redirect to a webpage') {
                            this.urlNewValue = result.MVQF__Thank_you_URL__c;
                            this.classurl = this.urlNewValue;
                            this.urlfunc();
                            this.template.querySelector(".url").style = "display:block";

                        } else if (result.MVQF__Thankyou_Page_Type__c == 'Show text, then redirect to web page') {
                            this.urlNewValue = result.MVQF__Thank_you_URL__c;
                            this.classtext = result.MVQF__Thankyou_Text__c;
                            this.textNewValue = result.MVQF__Thankyou_Text__c;
                            this.classurl = this.urlNewValue;
                            this.text_urlfunc();
                            this.template.querySelector(".text_url").style = "display:block";

                        } else if (result.MVQF__Thankyou_Page_Type__c == 'Show HTML block') {
                            this.classtext = result.MVQF__Thankyou_Text__c;
                            this.richtextNewValue = result.MVQF__Thankyou_Text__c;
                            this.richtextfun();
                            this.template.querySelector(".richtext").style = "display:block";

                        } else if (result.MVQF__Thankyou_Page_Type__c == 'None') {
                            this.nonefunc();
                        }
                        this.template.querySelector('.thanksPreviewDiv').style.background = '#E5E5E5';
                        this.template.querySelector('.thanksMainDiv').style = 'justify-content= none';
                        this.spinner = false;
                    }).catch(() => {
                        this.message = 'Something Went Wrong In Thank You Page';
                        this.showerror();
                    })
                    return true;
                } else {
                    this.spinner = false;
                    this.template.querySelector('c-toast-component').showToast('error', 'Enter Correct URL', 3000);
                }
            } else {
                if (this.ThankYou_RichText == true) {
                    this.classtext = this.richtextNewValue;
                } else {
                    this.classtext = this.textNewValue;
                }
                records({
                    name: this.formname,
                    picklist: this.picklist,
                    label: this.labelNewValue,
                    classtext: this.classtext,
                    formId: this.currentformid,
                    url: this.urlNewValue,
                    currentthankyouid: this.currentthankyouidNewValue
                }).then(result => {
                    this.template.querySelector('c-toast-component').showToast('success', 'Changes are updated Successfully', 3000);
                    this.thankyoutypeNewValue = result.MVQF__Thankyou_Page_Type__c;
                    this.labelNewValue = result.MVQF__ThankYou_Label__c;
                    this.changelabelNewValue = result.MVQF__ThankYou_Label__c;
                    this.currentthankyouidNewValue = result.Id;
                    if (result.MVQF__Thankyou_Page_Type__c == 'Show Text') {
                        this.classtext = result.MVQF__Thankyou_Text__c;
                        this.textNewValue = result.MVQF__Thankyou_Text__c;
                        this.textfunc();
                        this.template.querySelector(".text").style = "display:block";

                    } else if (result.MVQF__Thankyou_Page_Type__c == 'Redirect to a webpage') {
                        this.urlNewValue = result.MVQF__Thank_you_URL__c;
                        this.urlfunc();
                        this.template.querySelector(".url").style = "display:block"

                    } else if (result.MVQF__Thankyou_Page_Type__c == 'Show text, then redirect to web page') {
                        this.urlNewValue = result.MVQF__Thank_you_URL__c;
                        this.classtext = result.MVQF__Thankyou_Text__c;
                        this.textNewValue = result.MVQF__Thankyou_Text__c;
                        this.text_urlfunc();
                        this.template.querySelector(".text_url").style = "display:block";

                    } else if (result.MVQF__Thankyou_Page_Type__c == 'Show HTML block') {
                        this.classtext = result.MVQF__Thankyou_Text__c;
                        this.richtextNewValue = result.MVQF__Thankyou_Text__c;
                        this.richtextfun();
                        this.template.querySelector(".richtext").style = "display:block";

                    } else if (result.MVQF__Thankyou_Page_Type__c == 'None') {
                        this.nonefunc();
                    } else if (result.MVQF__Thankyou_Page_Type__c == 'Show report of User data') {
                        this.reportfunc();
                        this.template.querySelector(".report").style = "display:block";
                    }
                    this.template.querySelector('.thanksPreviewDiv').style.background = '#E5E5E5';
                    this.template.querySelector('.thanksMainDiv').style = 'justify-content= none';
                    this.spinner = false;
                }).catch(() => {
                    this.message = 'Something went wrong in Records(A) in thankyou Component';
                    this.showerror();
                })
                this.spinner = false;
            }
        } catch (error) {
            console.log('QF INFO:- SaveThanksData ThankyouCmp');
        }
    }

    cancelThanksData() {
        try {
            const a = this.template.querySelectorAll(".form-control");
            for (let i = 0; i < a.length; i++) {
                a[i].style.display = "none";
            }
            if (this.thankyoutypeNewValue == 'Show Text') {
                this.textNewValue = this.classtext;
                this.textfunc();
                this.template.querySelector(".text").style = "display:block";
            } else if (this.thankyoutypeNewValue == 'Redirect to a webpage') {
                this.urlNewValue = this.classurl;
                this.urlfunc();
                this.template.querySelector(".url").style = "display:block"
            } else if (this.thankyoutypeNewValue == 'Show text, then redirect to web page') {
                this.textNewValue = this.classtext;
                this.urlNewValue = this.classurl;
                this.text_urlfunc();
                this.template.querySelector(".text_url").style = "display:block";
            } else if (this.thankyoutypeNewValue == 'Show HTML block') {
                this.richtextNewValue = this.classtext;
                this.richtextfun();
                this.template.querySelector(".richtext").style = "display:block";
            } else if (this.thankyoutypeNewValue == 'None') {
                this.classtext = '';
                this.urlNewValue = '';
                this.textNewValue = '';
                this.richtextNewValue = '';
                this.nonefunc();
            }
        } catch (error) {
            console.log('QF INFO:- CancelThanksData ThankyouCmp');
        }
    }

    nonefunc() {
        this.thankyoulabel = false;
        this.picklist = 'None';
        this.None = true;
        this.ThankYou_Text = false;
        this.ThankYou_URL = false;
        this.Redirect_Text_And_URL = false;
        this.ThankYou_Report = false;
        this.ThankYou_RichText = false;
        this.textcheck = false;
        this.richtextcheck = false;
        this.spinner = false;
    }

    textfunc() {
        this.thankyoulabel = true;
        this.picklist = 'Show Text';
        this.None = false;
        this.ThankYou_Text = true;
        this.ThankYou_URL = false;
        this.Redirect_Text_And_URL = false;
        this.ThankYou_Report = false;
        this.ThankYou_RichText = false;
        this.textcheck = true;
        this.richtextcheck = false;
        this.spinner = false;
    }

    text_urlfunc() {
        this.thankyoulabel = true;
        this.picklist = 'Show text, then redirect to web page';
        this.None = false;
        this.ThankYou_Text = false;
        this.ThankYou_URL = false;
        this.Redirect_Text_And_URL = true;
        this.ThankYou_Report = false;
        this.ThankYou_RichText = false;
        this.textcheck = true;
        this.richtextcheck = false;
        this.spinner = false;
    }

    richtextfun() {
        this.thankyoulabel = true;
        this.picklist = 'Show HTML block';
        this.None = false;
        this.ThankYou_Text = false;
        this.ThankYou_URL = false;
        this.Redirect_Text_And_URL = false;
        this.ThankYou_Report = false;
        this.ThankYou_RichText = true;
        this.textcheck = false;
        this.richtextcheck = true;
        this.spinner = false;
    }

    reportfunc() {
        this.thankyoulabel = true;
        this.picklist = 'Show report of User data';
        this.None = false;
        this.ThankYou_Text = false;
        this.ThankYou_URL = false;
        this.Redirect_Text_And_URL = false;
        this.ThankYou_Report = true;
        this.ThankYou_RichText = false;
        this.textcheck = false;
        this.richtextcheck = false;
        this.spinner = false;
    }

    urlfunc() {
        this.thankyoulabel = false;
        this.picklist = 'Redirect to a webpage';
        this.None = false;
        this.ThankYou_Text = false;
        this.ThankYou_URL = true;
        this.Redirect_Text_And_URL = false;
        this.ThankYou_Report = false;
        this.ThankYou_RichText = false;
        this.textcheck = false;
        this.richtextcheck = false;
        this.template.querySelector(".url").style = "display:block";
        this.spinner = false;
    }

    editlabel() {
        this.editlabelcheck = true;
    }

    labelinput(event) {
        this.changelabelNewValue = event.target.value;
    }

    closeLabel() {
        this.editlabelcheck = false;
    }

    saveLabel() {
        try {
            this.labelNewValue = this.changelabelNewValue;
            this.editlabelcheck = false;

            changelabel({
                label: this.labelNewValue,
                currentthankyouid: this.currentthankyouidNewValue
            }).then(() => { }).catch(() => {

            });

        } catch (e) {
            this.message = 'Something Went Wrong In Thank You Page ';
        }
    }

    @api showerror() {
        try {
            this.error_popupNewValue = true;
            let errordata = {
                header_type: 'Thank You page',
                Message: this.message
            };
            if (typeof window !== 'undefined') {
                const showpopup = new CustomEvent('showerrorpopup', {
                    detail: errordata
                });
                this.dispatchEvent(showpopup);
            }

        } catch (error) {
            console.log('QF INFO:- Showerror ThankyouCmp');

        }
    }

    showerrorpopup(event) {
        try {
            this.template.querySelector('c-errorpopup').errormessagee(event.detail.header_type, event.detail.Message);
        } catch (error) {
            console.log('QF INFO:- Showerrorpopup ThankyouCmp');
        }
    }
}