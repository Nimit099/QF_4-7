import {
    LightningElement,
    api,
    track
} from 'lwc';
import getContactList from '@salesforce/apex/notificationInsertData.getContactList';
import create from '@salesforce/apex/notificationInsertData.create';
import updated from '@salesforce/apex/notificationInsertData.updated';
import status from '@salesforce/apex/notificationInsertData.getNotificationByStatus';
import {
    loadStyle
} from 'lightning/platformResourceLoader';
import notification_css from '@salesforce/resourceUrl/notification_css';
import pulsicon from '@salesforce/resourceUrl/Puls_icon';

export default class NotificationComponent extends LightningElement {
    formats = ['font', 'size', 'bold', 'italic', 'underline', 'strike', 'list', 'indent', 'align', 'link', 'clean', 'table',
        'header', 'color', 'background'
    ];
    pulsicon_img = pulsicon;
    @api myVal = "";
    @api errorMessage = "You haven't composed anything yet.";
    testval = false;
    @api validity = this.testval;
    @track validity2 = this.validity;

    @track Notification__c;
    @track Notification_list = [];
    @track error;
    @track spinnerDataTable = false;
    @track required_to = false;
    @track required_Subject = false;
    @track required_Message = false;
    @track toAddress = '';
    @track ccAddress = '';
    @track bccAddress = '';
    @track text2;
    @track text3;
    @track Subject = '';
    @track Message = '';
    @track Attachment = false;
    @track toast_error_msg;
    @api form_id;
    @track Notification_id;
    @track list_length = 0;
    @track to;
    @track cc;
    @track bcc;
    @track to_list = [];
    @track cc_list = [];
    @track bcc_list = [];
    @track test45;

    @track textto;
    @track textcc;
    @track textbcc;




    @api listto = [];
    @api pillid = 'cc';
    @track email_msg = false;
    @track items = [];
    @track getprogreshbar;
    @track isChecked = false;
    searchTerm = "";
    blurTimeout;
    notificationId;
    boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    _selectedValues = [];
    selectedValuesMap = new Map();





    @track email_msg_cc = false;
    @track get_all_cc_emailid;
    _selectedValues_2 = [];
    selectedValues_2Map = new Map();


    @track email_msg_bcc = false;
    @track get_all_bcc_emailid;
    _selectedValues_3 = [];
    selectedValues_3Map = new Map();

    @track open_addcc = false;
    @track open_addbcc = false;
    @track open_addcc_label = true;
    @track open_addbcc_label = true;
    @track open_addcc_and_addbcc = true;

    @track inputValue;
    @track inputValue1;
    @track inputValue2;

    //error_popup
    @api error_popup = false;
    @track error_message;


    connectedCallback() {
        try {
            Promise.all([
                loadStyle(this, notification_css)
            ]).then(() => { })
                .catch(() => {
                    this.message = 'Something went wrong while loading style';
                    this.showerrorpopup();
                });
            this.get_records();
        } catch (error) {
            console.log(error);
        }

    }

    get_records() {
        try {
            this.spinnerDataTable = true;
            getContactList({
                formid: this.form_id
            })
                .then(result => {
                    if ((result != null) && (result.length > 0) && (result != undefined)) {

                        this.isChecked = result[0].Status__c;

                        this.list_length = result.length;
                        this.to = result[0].To_Recipients__c;
                        this.to_email(this.to);

                        this.cc = result[0].CC_Recipients__c;
                        this.cc_email(this.cc);

                        this.bcc = result[0].BCC_Recipients__c;
                        this.bcc_email(this.bcc);

                        this.Subject = result[0].Subject__c;

                        this.Message = result[0].Email_Body__c;

                        this.Attachment = result[0].Attachment__c;


                        this.Notification_id = result[0].Id;

                        if (this.cc == '' || this.cc == null || this.bcc == '' || this.bcc == null) {
                            this.open_addcc_and_addbcc = true;
                        } else {
                            this.open_addcc_and_addbcc = false;
                        }

                        if (this.cc != '' && this.cc != null) {
                            this.open_addcc = true;
                            this.open_addcc_label = false;
                        } else {
                            this.open_addcc = false;
                            this.open_addcc_label = true;
                        }

                        if (this.bcc != '' && this.bcc != null) {
                            this.open_addbcc = true;
                            this.open_addbcc_label = false;
                        } else {
                            this.open_addbcc = false;
                            this.open_addbcc_label = true;
                        }
                    }
                    this.spinnerDataTable = false;
                })
                .catch(() => {
                    this.spinnerDataTable = false;
                    this.error_message = 'Something went wrong in Get Records(A)';
                    this.showerrorpopup();
                });
        } catch (error) {
            this.spinnerDataTable = false;
            this.error_message = 'Something went wrong in Get Records';
            this.showerrorpopup();
        }
    }



    get selectedValues() {
        return this._selectedValues;
    }
    set selectedValues(value) {
        try {
            this._selectedValues = value;
            this.handleToAddressChange({
                detail: {
                    selectedValues: this._selectedValues
                }
            })
        } catch (error) {
            console.log(error);
        }
    }


    get selectedValues_2() {
        return this._selectedValues_2;
    }
    set selectedValues_2(value) {
        try {
            this._selectedValues_2 = value;
            this.handleCcAddressChange({
                detail: {
                    selectedValues_2: this._selectedValues_2
                }
            })
        } catch (error) {
            console.log(error);
        }
    }


    get selectedValues_3() {
        return this._selectedValues_3;
    }
    set selectedValues_3(value) {
        try {
            this._selectedValues_3 = value;
            this.handleBccAddressChange({
                detail: {
                    selectedValues_3: this._selectedValues_3
                }
            })
        } catch (error) {
            console.log(error);
        }
    }

    handleToAddressChange(event) {
        try {
            this.required_to = false;
            this.toAddress = event.detail.selectedValues;
            this.getprogreshbar = +',' + this.toAddress;
        } catch (error) {
            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Notification Page';
            this.showerrorpopup();
        }
    }

    handleCcAddressChange(event) {
        this.required_to = false;
        this.ccAddress = event.detail.selectedValues_2;
        this.getprogreshbar = +',' + this.ccAddress;
    }

    handleBccAddressChange(event) {
        this.required_to = false;
        this.bccAddress = event.detail.selectedValues_3;
        this.getprogreshbar = +',' + this.bccAddress;
    }

    handleSubject(event) {
        this.Subject = event.target.value;
        this.required_Subject = false;
    }
    handlemessage(event) {
        this.required_Message = false;
        this.Message = event.target.value;
    }
    handleAttachment(event) {
        this.Attachment = event.target.checked;
    }

    handleValidation() {
        try {
            this.template.querySelector('c-email-input').handleValidationtest();
            let nameCmp = this.template.querySelector(".nameCls");

            if (!nameCmp.value) {
                nameCmp.setCustomValidity("Form Title is required");
            } else {
                nameCmp.setCustomValidity(""); // clear previous value

            }
        } catch (error) {
            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Notification Page';
            this.showerrorpopup();
        }
    }
    open_add_cc() {
        this.open_addcc = true;
        this.open_addcc_label = false;
        this.remove_cc_and_bcc();
    }
    open_add_bcc() {
        this.open_addbcc = true;
        this.open_addbcc_label = false;
        this.remove_cc_and_bcc();
    }

    remove_cc_and_bcc() {
        if (this.open_addbcc == true && this.open_addcc == true) {
            this.open_addcc_and_addbcc = false;
        }
    }

    // inputValue
    handlechange(event) {
        this.inputValue = event.target.value;
    }
    // inputValue1
    handlechange1(event) {
        this.inputValue1 = event.target.value;
    }
    // inputValue2
    handlechange2(event) {
        this.inputValue2 = event.target.value;
    }


    changestatus(event) {
        this.isChecked = event.target.checked;
        this.spinnerDataTable = true;
        try {
            if (this.Notification_id != null || this.Notification_id != '' || this.Notification_id != undefined) {
                status({
                    formid: this.form_id,
                    status: this.isChecked
                })
                    .then(result => {
                        this.spinnerDataTable = false;
                        if (result.length <= 0) {
                            this.enable_disable();
                        }
                    });
            } else {
                this.spinnerDataTable = false;
            }
        } catch (error) {
            this.spinnerDataTable = false;
            this.error_message = 'Something went wrong in Change Status';
            this.showerrorpopup();
        }
    }

    handleSave() {
        try {
            let toValue = this.inputValue;
            let ccValue = this.inputValue1;
            let bccValue = this.inputValue2;

            if ((toValue === '' || toValue === undefined) && (ccValue === '' || ccValue === undefined) && (bccValue === '' || bccValue === undefined)) {
                // All email fields are empty, proceed to save
                this.save();
                this.inputValue = '';
                this.inputValue1 = '';
                this.inputValue2 = '';
            } else {
                let isToValid = this.isEmailValid(toValue);
                let isCcValid = this.isEmailValid(ccValue);
                let isBccValid = this.isEmailValid(bccValue);

                if (isToValid || isCcValid || isBccValid) {
                    // All email fields are valid, proceed to save
                    this.save();
                    this.inputValue = '';
                    this.inputValue1 = '';
                    this.inputValue2 = '';
                } else {
                    this.inputValue = '';
                    this.inputValue1 = '';
                    this.inputValue2 = '';
                }
            }
        } catch (error) {
            console.log(error);
        }
    }



    isEmailValid(email) {
        try {
            // Regular expression to validate email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        } catch (error) {
            console.log(error);
        }
    }



    save() {
        try {
            this.textto = this.toAddress.toString();
            this.textcc = this.ccAddress.toString();
            this.textbcc = this.bccAddress.toString();

            this.Subject = this.Subject.trim();
            if (this.textto == '') {
                this.required_to = true;
                this.email_msg = false;
            }
            if (this.Subject == '') {
                this.required_Subject = true;
            }
            if (this.Message == '') {
                this.required_Message = true;

            }

            if (this.textto != '' && this.Subject != '' && this.Message != '') {
                this.inputValue = '';
                this.inputValue1 = '';
                this.inputValue2 = '';
                this.email_msg = false;
                this.email_msg_cc = false;
                this.email_msg_bcc = false;

                let listObj = {
                    'sobjectType': 'Notification__c'
                };
                listObj.To_Recipients__c = this.textto;
                listObj.CC_Recipients__c = this.textcc;
                listObj.BCC_Recipients__c = this.textbcc;
                listObj.Subject__c = this.Subject;
                listObj.Email_Body__c = this.Message;
                listObj.Form__c = this.form_id;
                listObj.Attachment__c = this.Attachment;
                listObj.Id = this.Notification_id;
                listObj.Status__c = this.isChecked;
                if (this.Notification_id == null) {
                    try {
                        this.spinnerDataTable = true;
                        create({
                            acc: listObj
                        })
                            .then(data => {
                                this.toast_error_msg = 'The Notification data has been Saved successfully';
                                this.template.querySelector('c-toast-component').showToast('success', this.toast_error_msg, 3000);
                                this.Cancel();
                                this.spinnerDataTable = false;
                                getContactList({
                                    formid: this.form_id
                                });
                            })
                            .catch(error => {
                                this.spinnerDataTable = false;
                                this.error_message = 'Something Went Wrong In Notification Page' + error.message;
                                this.showerrorpopup();
                            })

                    } catch (error) {
                        this.spinnerDataTable = false;
                        this.error_message = 'Something Went Wrong In Notification Page';
                        this.showerrorpopup();
                    }
                } else {
                    try {
                        this.spinnerDataTable = true;
                        updated({
                            updatelist: listObj
                        })
                            .then(data => {
                                this.toast_error_msg = 'he notification data has been Updated successfully';
                                this.template.querySelector('c-toast-component').showToast('success', this.toast_error_msg, 3000);
                                this.spinnerDataTable = false;
                                this.get_records();
                                this.Subject = data.Subject__c;

                            })
                            .catch(error => {
                                this.spinnerDataTable = false;
                                console.error({
                                    error
                                });
                                this.error_message = 'Something Went Wrong In Notification Page';
                                this.showerrorpopup();
                            })

                    } catch (error) {
                        this.spinnerDataTable = false;
                        this.error_message = 'Something Went Wrong In Notification Page';
                        this.showerrorpopup();
                    }

                }
            }
        } catch (error) {
            console.log(error);
        }

    }
    Cancel() {
        try {
            this.spinnerDataTable = true;
            getContactList({
                formid: this.form_id
            })
                .then(result => {
                    console.log(result);
                    console.log(JSON.stringify(result));
                    this.selectedValuesMap.clear();
                    this.selectedValues_2Map.clear();
                    this.selectedValues_3Map.clear();
                    this.selectedValues = '';
                    this.selectedValues_2 = '';
                    this.selectedValues_3 = '';
                    this.list_length = result.length;
                    console.log(JSON.stringify(this.list_length));
                    this.to = result[0].To_Recipients__c;
                    this.to_email(this.to);
                    this.cc = result[0].CC_Recipients__c;
                    this.cc_email(this.cc);
                    this.bcc = result[0].BCC_Recipients__c;
                    this.bcc_email(this.bcc);
                    this.Subject = result[0].Subject__c;
                    this.Message = result[0].Email_Body__c;
                    this.Attachment = result[0].Attachment__c;
                    this.Notification_id = result[0].Id;
                })
                .catch(error => {
                    this.spinnerDataTable = false;
                    this.error = error;
                    this.error_message = 'Something Went Wrong In Notification';
                    this.showerrorpopup();
                });
            if (this.list_length < 1) {
                console.log('oy');
                this.toAddress = '';
                this.ccAddress = '';
                this.Subject = '';
                this.Message = '';
                this.Attachment = false;
                this.inputValue = '';
                this.inputValue1 = '';
                this.inputValue2 = '';
                this.email_msg = false;
                this.email_msg_cc = false;
                this.email_msg_bcc = false;
                this.required_to = false;
                this.required_Subject = false;
                this.required_Message = false;
                this.selectedValuesMap.clear();
                this.selectedValues_2Map.clear();
                this.selectedValues_3Map.clear();
                this.selectedValues = '';
                this.selectedValues_2 = '';
                this.selectedValues_3 = '';
                this.spinnerDataTable = false;
            }
            else {
                this.email_msg = false;
                this.email_msg_cc = false;
                this.email_msg_bcc = false;
                this.inputValue = '';
                this.inputValue1 = '';
                this.inputValue2 = '';
                this.spinnerDataTable = false;
            }
        } catch (error) {
            console.log(error);
        }

    }
    remove_error_msg() {
        this.required_to = false;
    }




    create_pill_to() {
        try {
            const value = this.template.querySelector('lightning-input.input2').value;
            var pattern = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            if (value == null || value == '') {
                this.email_msg = false;
            } else {
                var validation = pattern.test(value);
                if (validation == false) {
                    this.email_msg = true;
                    this.template.querySelector('lightning-input.input2').value = value;
                    this.remove_error_msg();
                } else {
                    this.email_msg = false;
                    this.selectedValuesMap.set(value, value);
                    this.selectedValues = [...this.selectedValuesMap.keys()];
                    this.template.querySelector('lightning-input.input2').value = '';
                }
            }

        } catch (error) {
            this.error_message = 'Something Went Wrong In Notification Page';
            this.showerrorpopup();
            this.spinnerDataTable = false;
        }
    }


    handleKeyPress(event) {
        if (event.keyCode === 13 || event.keyCode === 9 || event.keyCode === 32 || event.keyCode === 44) {
            this.create_pill_to(event);
        }
    }

    handleRemove(event) {
        try {
            const item = event.target.label;
            this.selectedValuesMap.delete(item);
            this.selectedValues = [...this.selectedValuesMap.keys()];
        } catch (error) {
            this.error_message = 'Something Went Wrong In Notification Page';
            this.showerrorpopup();
            this.spinnerDataTable = false;
        }
    }


    @api reset() {
        this.selectedValuesMap = new Map();
        this.selectedValues = [];
    }

    @api validate() {
        try {
            this.template.querySelector('input').reportValidity();
            const isValid = this.template.querySelector('input').checkValidity();
            return isValid;
        } catch (error) {
            console.log(error);
        }
    }
    to_email(strString) {
        try {
            this.getprogreshbar = strString;
            this.to_list = this.getprogreshbar.split(',');
            for (var i = 0; i < this.to_list.length; i++) {
                const value = this.to_list[i];
                this.selectedValuesMap.set(value, value);
                this.selectedValues = [...this.selectedValuesMap.keys()];
            }
        } catch (error) {
            this.error_message = 'Something Went Wrong In Notification Page';
            this.showerrorpopup();
            this.spinnerDataTable = false;
        }
    }
    @api email_erroe_msg() {
        this.email_msg = false;
    }


    create_pill_cc(event) {
        try {
            event.preventDefault(); // Ensure it is only this code that runs
            const value = this.template.querySelector('lightning-input.input3').value;
            var pattern = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            var validation = pattern.test(value);
            if (value == null || value == '') {
                this.email_msg_cc = false;
            } else if (validation == false) {
                this.template.querySelector('lightning-input.input3').value = value;
                this.email_msg_cc = true;
            } else {
                this.email_msg_cc = false;
                this.selectedValues_2Map.set(value, value);
                this.selectedValues_2 = [...this.selectedValues_2Map.keys()];
                this.template.querySelector('lightning-input.input3').value = '';
            }

        } catch (error) {
            this.error_message = 'Something Went Wrong In Notification Page';
            this.showerrorpopup();
            this.spinnerDataTable = false;
        }
    }


    handleKeyPress_2(event) {
        if (event.keyCode === 13 || event.keyCode === 9 || event.keyCode === 32 || event.keyCode === 44) {
            this.create_pill_cc(event);
        }
    }

    handleRemove_2(event) {
        const item = event.target.label;
        this.selectedValues_2Map.delete(item);
        this.selectedValues_2 = [...this.selectedValues_2Map.keys()];
    }
    @api reset_2() {
        this.selectedValues_2Map = new Map();
        this.selectedValues_2 = [];
    }

    @api validate_2() {
        try {
            this.template.querySelector('input').reportValidity();
            const isValid = this.template.querySelector('input').checkValidity();
            return isValid;
        } catch (error) {
            console.log(error);
        }
    }
    @api cc_email(strString) {
        try {
            this.get_all_cc_emailid = strString;
            if (this.get_all_cc_emailid != null && this.get_all_cc_emailid != '') {
                this.cc_list = this.get_all_cc_emailid.split(',');
                for (var i = 0; i < this.cc_list.length; i++) {
                    const value = this.cc_list[i];
                    this.selectedValues_2Map.set(value, value);
                    this.selectedValues_2 = [...this.selectedValues_2Map.keys()];
                }
            }

        } catch (error) {
            this.error_message = 'Something Went Wrong In Notification Page';
            this.showerrorpopup();
        }

    }





    create_pill_bcc(event) {
        try {
            event.preventDefault(); // Ensure it is only this code that runs
            const value = this.template.querySelector('lightning-input.input4').value;
            var pattern = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            if (value == null || value == '') {
                this.email_msg_bcc = false;
            } else {
                var validation = pattern.test(value);

                if (validation == false) {
                    this.email_msg_bcc = true;
                    this.template.querySelector('lightning-input.input4').value = value;
                } else {
                    this.email_msg_bcc = false;
                    this.selectedValues_3Map.set(value, value);
                    this.selectedValues_3 = [...this.selectedValues_3Map.keys()];
                    this.template.querySelector('lightning-input.input4').value = '';
                }
            }

        } catch (error) {
            this.error_message = 'Something Went Wrong In Notification Page';
            this.showerrorpopup();
            this.spinnerDataTable = false;
        }
    }

    handleKeyPress_3(event) {
        if (event.keyCode === 13 || event.keyCode === 9 || event.keyCode === 32 || event.keyCode === 44) {
            this.create_pill_bcc(event);
        }
    }

    handleRemove_3(event) {
        const item = event.target.label;
        this.selectedValues_3Map.delete(item);
        this.selectedValues_3 = [...this.selectedValues_3Map.keys()];
    }
    @api reset_3() {
        this.selectedValues_3Map = new Map();
        this.selectedValues_3 = [];
    }

    @api validate_3() {
        this.template.querySelector('input').reportValidity();
        const isValid = this.template.querySelector('input').checkValidity();
        return isValid;
    }
    @api bcc_email(strString) {
        try {
            this.get_all_bcc_emailid = strString;
            if (this.get_all_bcc_emailid != null && this.get_all_bcc_emailid != '') {
                this.bcc_list = this.get_all_bcc_emailid.split(',');
                for (var i = 0; i < this.bcc_list.length; i++) {
                    const value = this.bcc_list[i];
                    this.selectedValues_3Map.set(value, value);
                    this.selectedValues_3 = [...this.selectedValues_3Map.keys()];
                }
            }
        } catch (error) {
            this.error_message = 'Something Went Wrong In Notification Page';
            this.showerrorpopup();
            this.spinnerDataTable = false;
        }


    }

    showerrorpopup() {
        try {
            this.template.querySelector('c-errorpopup').errormessagee('Notification Component Error', this.error_message);
            
        } catch (error) {
            console.log(error);
        }
    }
    errorpopupcall() {
        location.reload();
    }

    enable_disable() {
        this.isChecked = false;
        this.toast_error_msg = 'Fill out the fields and click Save to Enable Notification';
        this.template.querySelector('c-toast-component').showToast('error', this.toast_error_msg, 3000);

    }

}