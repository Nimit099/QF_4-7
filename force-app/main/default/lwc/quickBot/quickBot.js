import {
    api,
    track,
    LightningElement
} from 'lwc';
import {
    loadStyle
} from 'lightning/platformResourceLoader';
import QuickBotLogo from '@salesforce/resourceUrl/QuickBotLogo';
import QuickBotBody from '@salesforce/resourceUrl/QuickBotBody';
import QuickBot_Cross from '@salesforce/resourceUrl/QuickBot_Cross';
import QuickBotCSS from '@salesforce/resourceUrl/QuickBotCSS';
import quickbotheader from '@salesforce/label/c.QuickBot_Header';
import sendemail from '@salesforce/apex/QuickFormHome.sendemail';
export default class QuickBot extends LightningElement {
    Logo = QuickBotLogo;
    Body = QuickBotBody;
    Cross = QuickBot_Cross;
    @api recordId;
    @track spinnerdatatable = false;
    @track first_icon = false;
    @track wel_message = false;
    @track feedback_form = false;
    @track showquickbot = false;
    @track showComponent = true;
    @track filename;
    @track filedata;
    @track filesData = [];
    @track FName = [];
    @track FBase64 = [];
    @track error_toast = true;
    @track totalsize = parseInt(0);


    quickbotname;
    quickbotemail;
    quickbotcc;
    quickbotmessage;
    quickbotsubject;
    emailsend;
    fileSize;
    fileData1 = {};
    quickbotfiles = [];
    email_msg = true;
    cc_msg = true;
    name_msg = true;
    subject_msg = true;
    Message_msg = true;
    acceptedFormats = ['.jpg', '.jpeg', '.pdf', '.png'];
    fileDataMap = new Map();


    header = quickbotheader;
    get bgimg() {
        return `background-image:url(${QuickBotBody});background-repeat: no-repeat; background-size: cover;`;
    }

    connectedCallback() {
        try {
            if (typeof window !== 'undefined') {
                this.first_icon = true;
                this.wel_message = false;

                window.setTimeout(() => {
                    this.wel_message = true;
                    this.spinnerdatatable = false;
                    this.first_icon = true;
                }, 4000);
                this.feedback_form = false;
                window.setTimeout(() => {
                    this.feedback_form = true;
                }, 5500);
                this.spinnerdatatable = true;

            }
        } catch (error) {
            console.log('error');
        }

    }

    renderedCallback() {
        try {
            Promise.all([
                loadStyle(this, QuickBotCSS)
            ]).then(() => { })
                .catch(() => {
                    this.message = 'Something Went Wrong In QuickBot Page';
                    this.showerror();
                });
        } catch (error) {
            console.log('error');
        }
    }

    Quickbot_name(event) {
        this.quickbotname = event.target.value;
        this.name_msg = true;
    }
    Quickbot_email(event) {
        this.quickbotemail = event.target.value;
        this.email_msg = true;
    }
    Quickbot_cc(event) {
        this.quickbotcc = event.target.value;
        this.cc_msg = true;
    }
    Quickbot_message(event) {
        this.quickbotmessage = event.target.value;
        this.Message_msg = true;

    }
    Quickbot_subject(event) {
        this.quickbotsubject = event.target.value;
        this.subject_msg = true;

    }

    handleUploadFinished(event) {
        try {
            if (event.target.files.length > 0) {
                for (let i = 0; i < event.target.files.length; i++) {
                    var filesize = event.target.files[i].size;
                    this.totalsize += parseInt(event.target.files[i].size);
                    if (this.totalsize > 3000000) {
                        this.totalsize = this.totalsize - filesize;
                        let toast_error_msg = 'Image was not uploaded, Total file size exceeded the Limit.';
                        this.error_toast = true;
                        this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
                    }
                    else {
                        let file = event.target.files[i];
                        let reader = new FileReader();
                        reader.onload = () => {
                            var base64 = reader.result.split(',')[1];
                            this.filename = file.name;
                            this.filedata = base64;
                            this.filesData.push({
                                'fileName': file.name,
                                'filedata': base64
                            });
                            this.FName.push(file.name);
                            this.FBase64.push(base64);
                        };
                        reader.readAsDataURL(file);
                    }
                }
            }
        } catch (error) {
            console.log('error');
        }
    }

    removeReceiptImage(event) {
        try {
            var index = event.currentTarget.dataset.id;

            var binaryString = atob(this.FBase64[index]);
            var byteArray = Uint8Array.from(binaryString, c => c.charCodeAt(0));
            var sizeInBytes = byteArray.length;

            binaryString = parseInt(0);
            byteArray = parseInt(0);
            this.totalsize = parseInt(this.totalsize) - parseInt(sizeInBytes);
            this.filesData.splice(index, 1);
            this.FBase64.splice(index, 1);
            this.FName.splice(index, 1);
        } catch (error) {
            console.log('error');
        }
    }

    quickbot_Submit() {
        try {
            var pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            var validation1 = pattern.test(this.quickbotemail);
            var validation2 = true;
            this.quickbotname = this.quickbotname.trim();
            this.quickbotsubject = this.quickbotsubject.trim();
            this.quickbotmessage = this.quickbotmessage.trim();
            if ((this.quickbotname == undefined) || (this.quickbotname == '')) {
                this.name_msg = false;
            } else if (validation1 == false) {
                this.email_msg = false;
            } else if ((validation2 == false)) {
                this.cc_msg = false;
            } else if (this.quickbotsubject == undefined || (this.quickbotsubject == '')) {
                this.subject_msg = false;
            } else if (this.quickbotmessage == undefined || (this.quickbotmessage == '')) {
                this.Message_msg = false;
            } else {
                this.email_msg = true;
                sendemail({
                    name: this.quickbotname,
                    email: this.quickbotemail,
                    subject: this.quickbotsubject,
                    body: this.quickbotmessage,
                    fname: this.FName,
                    fbase64: this.FBase64,
                })
                    .then(result => {
                        if (result == 'success') {
                            this.emailsend = true;
                            this.dispatchEvent(new CustomEvent('botclose', {
                                detail: this.emailsend
                            }));
                            this.dispatchEvent(new CustomEvent('success'));
                        } else {
                            this.error_toast = true;
                            let toast_error_msg = 'Email was not sent, Something went wrong.';
                            this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
                        }
                    }).catch(() => { });
                const value = false;
                const valueChangeEvent = new CustomEvent("valuechange", {
                    detail: {
                        value
                    }
                });
                this.dispatchEvent(valueChangeEvent);
            }
        } catch (error) {
            console.log('error');
        }

    }

    quickboe_close() {
        try {
            this.showComponent = !this.showComponent;
            const value = false;
            const valueChangeEvent = new CustomEvent("valuechange", {
                detail: {
                    value
                }
            });
            this.dispatchEvent(valueChangeEvent);
        } catch (error) {
            console.log('error');
        }

    }

    errorpopupcall() {
        location.reload();
    }

    @api showerror() {
        try {
            this.error_popup = true;
            let errordata = {
                header_type: 'Fiedback Form error',
                Message: this.message
            };
            const showpopup = new CustomEvent('showerrorpopup', {
                detail: errordata
            });
            this.dispatchEvent(showpopup);
        } catch (error) {
            console.log('error');
        }
    }

    showerrorpopup(message) {
        try {

            this.template.querySelector('c-errorpopup').errormessagee(message, message);
        } catch (error) {
            console.log('error');
        }
    }

}