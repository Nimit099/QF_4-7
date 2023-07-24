import {
    LightningElement,
    track,
    api
} from 'lwc';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import {
    NavigationMixin
} from "lightning/navigation";

import formdetails from '@salesforce/apex/previewFormcmp.formdetails';
import formfielddetails from '@salesforce/apex/previewFormcmp.formfielddetails';
import formpagedetails from '@salesforce/apex/previewFormcmp.formpagedetails';
import processDecryption from '@salesforce/apex/EncryptDecryptController.processDecryption';
import bgimages from '@salesforce/apex/previewFormcmp.bgimages';
import getthankyoupage from '@salesforce/apex/previewFormcmp.getthankyoupage';
import sendemailaftersubmission from '@salesforce/apex/previewFormcmp.sendemailaftersubmission';
import BackButton from '@salesforce/resourceUrl/BackButton';
import getFieldsRecords_page from '@salesforce/apex/FormBuilderController.getFieldsRecords_page';
import createrecord from '@salesforce/apex/FormBuilderController.createrecord';
import createrecord_for_secod_object from '@salesforce/apex/FormBuilderController.createrecord_for_secod_object';
import createrecord_for_third_object from '@salesforce/apex/FormBuilderController.createrecord_for_third_object';
import GetFormValidation from '@salesforce/apex/FormBuilderController.GetFormValidation';
import findlookupfildes from '@salesforce/apex/FormBuilderController.findlookupfildes';

import {
    loadStyle
} from 'lightning/platformResourceLoader';
import prevpreviewcss from '@salesforce/resourceUrl/prevpreviewcss';

export default class PreviewFormCmp extends NavigationMixin(LightningElement) {

    BackButton = BackButton;
    @api formid;
    @track getFieldCSS;
    @track page = [];
    @track PageList = [];
    @track Mainlist = [];
    @track pageindex = 1;
    @track spinnerDataTable = false;
    @track isIndexZero = true;
    @track isIndexLast = false;
    @track isPageNotFoud = false;
    @track isPreviewForm = true;
    @track Progressbarvalue;
    @track captchavalue;
    @track verify;
    @track buttonscss;
    @track PageCSS;
    @api activepreviews = false;
    @track hovercss;
    @track focuscss;
    @track fcss;
    @track pagecss;
    @track formcss;
    @track btncss;
    @track lcss;
    @track isPreviewView;
    @track filesignread;
    @track PageFieldList = [];
    @track PageFieldListName = [];
    fieldvalues = [];
    @track listofkey = [];
    @track listofvalue = [];
    @track first_object;
    @track second_object;
    @track third_object;
    @track ext_object;
    @track first_object_4_pdf = {};
    @track second_object_4_pdf = {};
    @track third_object_4_pdf = {};
    @track ext_object_4_pdf = {};
    @track form_object = [];
    @track form_mapped_Objects = [];
    @track obj;
    @track s_ob;
    @track list_first_obj = {
        'sobjectType': 'filde_vlue'
    };
    @track list_second_obj = {
        'sobjectType': 'filde_vlue'
    };
    @track list_third_obj = {
        'sobjectType': 'filde_vlue'
    };
    @track list_ext_obj = {
        'sobjectType': 'Extra'
    };
    @track all_filde_value = {
        'sobjectType': 'filde_vlue'
    };
    @track all_filde_value_second = {
        'sobjectType': 'filde_vlue'
    };
    @track all_filde_value_third = {
        'sobjectType': 'filde_vlue'
    };
    @track all_filde_value_ext = {
        'sobjectType': 'Extra'
    };
    @track list_validetion = {};
    @track checkbool = true;
    @track current_bt;
    @track datawithleabel;
    @track form_validation;
    @track custom_validation;
    @track error_validation_json = {};
    @track first_list = [];
    @track second_list = [];
    @track third_list = [];
    @track ex_list = [];
    @track sin_data_id;
    @track sig_con_id;
    @track sig_filde_id;
    @track sub_id;
    formname = '';
    @api nosubmission = false;
    @track add_input_val;
    @track show_captchavalue = true;
    @track file_upload = {};
    @track file_upload_fildeid = [];
    @track file_upload_id;
    @track file_upload_url;
    @track file_u_map = {};
    @track sig_u_map = {};
    @track sig_upload = {};
    @track sig_fildeid = [];
    @track lookup_2obj = [];
    @track lookup_3obj = [];
    @track lookup_filde_json = {};
    @track create_chi = true;
    @track create_chi_2 = true;
    @track error_josn_key_list = [];
    @api error_popup = false;
    @track error_popup1 = false;
    @track message;
    @api pageURL;
    @track formIdNew;
    @track base64Att;
    @track fileSize = 0;
    @track disableSaveButton = false;
    @track submit = true;

    connectedCallback() {
        this.submit = true;
        this.spinnerDataTable = true;
        this.formIdNew = this.formid;
        loadStyle(this, prevpreviewcss);
        let page;
        let accessKey = '';
        if (this.pageURL == null || this.pageURL == undefined) {
            page = window.location.href;
        }
        if (page != undefined && page != null && page.includes("?access_key=")) {
            this.accessKey = page.split("?access_key=")[1];
            this.processDecryptionmethod(this.accessKey, page);
        } else if (this.pageURL != undefined && this.pageURL != null && this.pageURL.includes("?access_key=")) {
            this.accessKey = this.pageURL.split("?access_key=")[1];
            this.processDecryptionmethod(this.accessKey, this.pageURL);
        }
        else {
            this.FormData('');
        }

        this.GetFormValidationmethod(this.formIdNew);
        this.spinnerDataTable = false;
    }

    processDecryptionmethod(accessKey, page) {
        processDecryption({
            encryptedData: accessKey
        })
            .then(result => {
                this.formIdNew = result;
                this.FormData(page);
                this.spinnerDataTable = false;
            }).catch(() => {
                this.message = 'Something Went Wrong In preview Page';
                this.showerror();
                this.spinnerDataTable = false;
            });
    }

    GetFormValidationmethod(formidval) {
        GetFormValidation({
            form_id: formidval
        })
            .then(result => {
                this.form_validation = result;
            })
            .catch(() => {
                this.message = 'Something Went Wrong In preview Page';
                this.showerror();
                this.spinnerDataTable = false;
            });
    }

    renderedCallback() {

        if (this.Mainlist.length > 0) {
            let value;
            let arr = this.template.querySelectorAll('.btn1');
            for (let i = 0; i < arr.length; i++) {
                const element = arr[i];
                element.style = this.buttonscss;
            }
            let buttoncss = this.buttonscss.split(';');
            for (let i = 0; i < buttoncss.length; i++) {
                buttoncss[i] = buttoncss[i].split(':');
                let label = buttoncss[i][0];

                if (label == 'justify-content') {
                    value = 'justify-content:' + buttoncss[i][1];
                }
            }
            let Arr = this.template.querySelectorAll(".footer");
            for (let i = 0; i < Arr.length; i++) {
                const element = Arr[i];
                element.style = value;
            }
        }
    }

    FormData(pageURL) {
        try {
            formdetails({
                id: this.formIdNew,
                webUrl: pageURL
            })
                .then(result => {
                    if (result.Status__c == true) {
                        this.isPreviewForm = true;
                        this.isPreviewView = true;
                        this.filesignread = false;
                        this.Progressbarvalue = result.Progress_Indicator__c;
                        this.captchavalue = result.Captcha_Type__c;
                        this.getFieldCSS = result.Form_Styling__c;
                        this.buttonscss = result.Button_CSS__c;
                        this.buttonscss = this.buttonscss.concat(result.Button_Position__c);
                        this.PageCSS = result.Page_CSS__c;
                        this.hovercss = result.All_Field_Hover__c;
                        this.focuscss = result.All_Field_Focus__c
                        this.fcss = result.All_Field_Styling__c;
                        this.lcss = result.Label_CSS__c;
                        let array;
                        let value;
                        let pagebg = result.PageBgID__c;
                        let formbg = result.FormBgID__c;
                        this.formname = result.Name;
                        this.form_object = result.Mapped_Objects__c;
                        console.log(JSON.stringify(this.form_object));
                        this.testtocall();

                        if (this.captchavalue == 'None' || this.captchavalue == '--None--' || this.captchavalue == undefined) {
                            this.show_captchavalue = false;

                        } else {
                            this.show_captchavalue = true;
                        }
                        //  close add by yash
                        if (formbg != null && formbg != undefined) {
                            bgimages({
                                id: formbg,
                                data: this.getFieldCSS
                            })
                                .then(result => {
                                    if (result != undefined && result != null) {
                                        array = this.template.querySelector('.myform');
                                        array.style = result;
                                        this.getFieldCSS = result;
                                    }
                                }).catch(() => {
                                    this.message = 'Something Went Wrong In preview Page';
                                    this.showerror();
                                    this.spinnerDataTable = false;
                                })
                        }

                        if (pagebg != null && pagebg != undefined) {
                            bgimages({
                                id: pagebg,
                                data: this.PageCSS
                            })
                                .then(result => {
                                    if (result != undefined && result != null) {
                                        array = this.template.querySelectorAll('.page');
                                        for (let i = 0; i < array.length; i++) {
                                            const element = array[i];
                                            element.style = result;
                                        }
                                        this.PageCSS = result;
                                    }
                                }).catch(() => {
                                    this.spinnerDataTable = false;
                                    this.message = 'Something Went Wrong In Preview Form Page';
                                    this.showerror(this.message);
                                })
                        }

                        // FormCss
                        if (this.getFieldCSS != undefined) {
                            array = this.template.querySelector('.myform');
                            array.style = this.getFieldCSS;
                        }

                        // PageCss
                        if (this.PageCSS != undefined) {
                            array = this.template.querySelectorAll('.page');
                            for (let i = 0; i < array.length; i++) {
                                const element = array[i];
                                element.style = this.PageCSS;
                            }
                        }

                        //ButtonCss
                        if (this.buttonscss != undefined) {
                            array = this.template.querySelectorAll('.btn1');
                            for (let i = 0; i < array.length; i++) {
                                const element = array[i];
                                element.style = this.buttonscss;
                            }
                            let buttoncss = this.buttonscss.split(';');
                            for (let i = 0; i < buttoncss.length; i++) {
                                buttoncss[i] = buttoncss[i].split(':');
                                let label = buttoncss[i][0];

                                if (label == 'justify-content') {
                                    value = 'justify-content:' + buttoncss[i][1];
                                }
                            }

                            //ButtonPosition
                            array = this.template.querySelectorAll(".footer");
                            for (let i = 0; i < array.length; i++) {
                                const element = array[i];
                                element.style = value;
                            }
                        }
                        if (this.nosubmission == false) {
                            var element = this.template.querySelector('.mainbody');
                            element.style = 'height: 97vh;';

                            element = this.template.querySelector('.fieldDiv1');

                        }

                        if (this.activepreviews == true) {
                            var element1 = this.template.querySelector('.myform');
                            element1.style = this.getFieldCSS
                        }
                        this.PageData();
                    } else {
                        this.isPreviewView = false;
                        this.isPageNotFoud = true;
                        this.spinnerDataTable = false;
                    }
                }).catch(() => {
                    this.spinnerDataTable = false;
                    this.message = 'Something Went Wrong In preview Page';
                    this.showerror();
                });
        } catch (error) {
            this.spinnerDataTable = false;
            this.message = 'Something Went Wrong In preview Page';
            this.showerror();
        }

    }

    PageData() {
        try {
            formpagedetails({
                id: this.formIdNew
            })
                .then(result => {
                    //PageData
                    this.PageList = result;
                    this.FieldsData();
                }).catch(() => {
                    this.message = 'Something Went Wrong In preview Page';
                    this.showerror();
                    this.spinnerDataTable = false;
                });
        } catch (error) {
            this.spinnerDataTable = false;
            this.message = 'Something Went Wrong In preview Page';
            this.showerror();
        }
    }

    FieldsData() {
        try {
            formfielddetails({
                id: this.formIdNew
            })
                .then(result => {
                    // FieldsData
                    this.setPageField(result);
                }).catch(() => {
                    this.spinnerDataTable = false;
                    this.message = 'Something Went Wrong In preview Page';
                    this.showerror();
                });
        } catch (error) {
            this.spinnerDataTable = false;
            this.message = 'Something Went Wrong In preview Page';
            this.showerror();
        }
    }


    setPageField(fieldList) {
        try {
            let outerlist = [];
            let innerlist = [];
            let fieldtype;

            for (let i = 0; i < this.PageList.length; i++) {
                innerlist = [];
                for (let j = 0; j < fieldList.length; j++) {
                    if (this.PageList[i].Id == fieldList[j].Form_Page__c) {
                        if (fieldList[j].Name.split(',')[1] == 'Extra') {
                            fieldtype = false;
                        } else {
                            fieldtype = true;
                        }

                        let isdisabledcheck;
                        let isRequiredcheck;
                        let labelcheck;
                        let helptextcheck;
                        let placeholdercheck;
                        let prefixcheck;
                        let prefixvalue;
                        let labelvalue;
                        let helptext;
                        let placeholdervalue;
                        let salutationvalue = [];
                        let Richtext;

                        // add by yash
                        let minimum;
                        let maximum;
                        let minimumtime;
                        let maximumtime;
                        let minimumdatetime;
                        let maximumdatetime;
                        let minimumdate;
                        let maximumdate;


                        fieldList[j].Field_Validations__c = fieldList[j].Field_Validations__c.split('?$`~');
                        for (let i = 0; i < fieldList[j].Field_Validations__c.length; i++) {
                            fieldList[j].Field_Validations__c[i] = fieldList[j].Field_Validations__c[i].split('<!@!>');
                            let labels = fieldList[j].Field_Validations__c[i][0];
                            let value = fieldList[j].Field_Validations__c[i][1];

                            if (labels == 'isRequired') {
                                isRequiredcheck = JSON.parse(value);
                            } else if (labels == 'isDisabled') {
                                isdisabledcheck = JSON.parse(value);
                            } else if (labels == 'isLabel') {
                                labelcheck = JSON.parse(value);
                            } else if (labels == 'isHelpText') {
                                helptextcheck = JSON.parse(value);
                            } else if (labels == 'isPlaceholder') {
                                placeholdercheck = JSON.parse(value);
                            } else if (labels == 'isPrefix') {
                                prefixcheck = JSON.parse(value);
                            } else if (labels == 'Prefix') {
                                prefixvalue = value;
                            } else if (labels == 'Label') {
                                labelvalue = value;
                            } else if (labels == 'HelpText') {
                                helptext = value;
                            } else if (labels == 'Placeholder') {
                                placeholdervalue = value;
                            } else if (labels == 'Salutation') {
                                salutationvalue.push(value);
                            } else if (labels == 'Richtext') {
                                Richtext = value;
                            } else if (labels == 'Minimum') {
                                minimum = value;
                            } else if (labels == 'Maximum') {
                                maximum = value;
                            } else if (labels == 'MinimumTime') {
                                minimumtime = value;
                            } else if (labels == 'MaximumTime') {
                                maximumtime = value;
                            } else if (labels == 'MinimumDateTime') {
                                minimumdatetime = value;
                            } else if (labels == 'MaximumDateTime') {
                                maximumdatetime = value;
                            } else if (labels == 'MinimumDate') {
                                minimumdate = value;
                            } else if (labels == 'MaximumDate') {
                                maximumdate = value;
                            }

                        }
                        fieldList[j].Field_Validations__c = ({
                            isRequired: isRequiredcheck,
                            isDisabled: isdisabledcheck,
                            isLabel: labelcheck,
                            isHelptext: helptextcheck,
                            isPlaceholder: placeholdercheck,
                            isPrefix: prefixcheck,
                            Prefix: prefixvalue,
                            Label: labelvalue,
                            HelpText: helptext,
                            Placeholder: placeholdervalue,
                            Salutation: salutationvalue,
                            fieldtype: fieldtype,
                            Richtext: Richtext,
                            Minimum: minimum,
                            Maximum: maximum,
                            MinimumTime: minimumtime,
                            MaximumTime: maximumtime,
                            MinimumDateTime: minimumdatetime,
                            MaximumDateTime: maximumdatetime,
                            MinimumDate: minimumdate,
                            MaximumDate: maximumdate
                        });

                        innerlist.push(fieldList[j]);
                    }
                }
                let temp = {
                    pageName: this.PageList[i].Name,
                    pageId: this.PageList[i].Id,
                    FieldData: innerlist
                };
                outerlist.push(temp);
            }
            this.Mainlist = outerlist;
            this.page = outerlist[0];

            if (this.pageindex == this.PageList.length) {
                this.isIndexZero = true;
                this.isIndexLast = true;
            }
            this.spinnerDataTable = false;
            this.template.querySelector('c-progress-indicator').calculation(this.Progressbarvalue, this.pageindex, this.PageList.length);
        } catch (error) {
            this.spinnerDataTable = false;
            this.message = 'Something Went Wrong In preview Page';
            this.showerror();
        }
    }

    backhome() {
        let cmpDef = {
            componentDef: "c:qf_home"
        };
        let encodedDef = btoa(JSON.stringify(cmpDef));
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: "/one/one.app#" + encodedDef
            }
        });
    }

    handlepagination(event) {
        this.current_bt = event.currentTarget.dataset.name;

        if (event.currentTarget.dataset.name == 'previous') {
            this.checkbool = true;
            this.spinnerDataTable = true;
            if (this.error_josn_key_list.length == 0) {
                if (this.pageindex == 1) {
                    this.isIndexZero = true;
                } else if (this.PageList.length > this.pageindex) {
                    this.pageindex--;
                    if (this.pageindex == 1) {
                        this.isIndexLast = false;
                        this.isIndexZero = true;
                    }
                } else if (this.PageList.length == this.pageindex) {
                    this.pageindex--;
                    this.isIndexLast = false;
                    if (this.pageindex == 1) {
                        this.isIndexLast = false;
                        this.isIndexZero = true;
                    }
                }
                this.page = this.Mainlist[this.pageindex - 1];
                this.spinnerDataTable = false;
                this.template.querySelector('c-progress-indicator').calculation(this.Progressbarvalue, this.pageindex, this.PageList.length);

            }
        } else if (event.currentTarget.dataset.name == 'next') {
            if (this.error_josn_key_list.length == 0) {
                this.spinnerDataTable = true;
                getFieldsRecords_page({
                    id: this.PageList[this.pageindex - 1].Id
                })
                    .then(result => {
                        this.PageFieldList = result;
                        this.check_validation();
                        this.spinnerDataTable = false;
                    })
                    .catch(() => {
                        this.spinnerDataTable = false;
                        this.message = 'Something Went Wrong In preview Page';
                        this.showerror();
                    });


            }

        } else if (event.currentTarget.dataset.name == 'submit') {
            if (this.error_josn_key_list.length == 0) {
                this.spinnerDataTable = true;

                getFieldsRecords_page({
                    id: this.PageList[this.pageindex - 1].Id
                })
                    .then(result => {
                        this.PageFieldList = result;
                        this.check_validation();
                        this.spinnerDataTable = false;
                    })
                    .catch(() => {
                        this.spinnerDataTable = false;
                        this.message = 'Something Went Wrong In preview Page';
                        this.showerror();
                    });
            }
        }
    }

    verifycaptcha(event) {
        this.verify = event.detail;
    }

    // add by yash
    testtocall() {
        try {
            
            console.log('Test to call');
            console.log(JSON.stringify(this.form_object));
            this.obj = this.form_object;
            console.log(JSON.stringify(this.obj));
            this.form_mapped_Objects = this.obj.split(',');
            console.log(JSON.stringify(this.form_mapped_Objects));
            this.first_object = this.form_mapped_Objects[0];
            console.log(JSON.stringify(this.first_object));
            this.list_first_obj.sobjectType = this.form_mapped_Objects[0];
            console.log(JSON.stringify(this.list_first_obj.sobjectType));
            this.all_filde_value.sobjectType = this.form_mapped_Objects[0];
            this.second_object = this.form_mapped_Objects[1];
            console.log(JSON.stringify(this.second_object));
            this.list_second_obj.sobjectType = this.form_mapped_Objects[1];
            this.all_filde_value_second.sobjectType = this.form_mapped_Objects[1];
            this.third_object = this.form_mapped_Objects[2];
            console.log(JSON.stringify(this.third_object));
            this.list_third_obj.sobjectType = this.form_mapped_Objects[2];
            this.all_filde_value_third.sobjectType = this.form_mapped_Objects[2];
            console.log('testtocall');
            if (this.form_mapped_Objects.length == 2) {
                console.log('Nimit 2');
                console.log(JSON.stringify(this.form_mapped_Objects[0]));
                console.log(this.form_mapped_Objects[1]);
                console.log('Nimit 2 ends');
                findlookupfildes({
                    minobj: this.form_mapped_Objects[0],
                    fsubobj: this.form_mapped_Objects[1]
                })
                    .then(result => {
                        this.lookup_2obj = result;
                    })
                    .catch(e => {
                        this.message = e.message;
                    });
    
            } else if (this.form_mapped_Objects.length == 3) {
    
                
                for (let k = 1; k < this.form_mapped_Objects.length; k++) {
                    console.log('Nimit Start 123');
                    console.log(JSON.stringify(this.form_mapped_Objects[0]));
                    console.log(JSON.stringify(this.form_mapped_Objects[k]));
                    console.log('Nimit End123');
                    findlookupfildes({
                        minobj: this.form_mapped_Objects[0],
                        fsubobj: this.form_mapped_Objects[k]
                    })
                        .then(result => {
                            this.lookup_filde_json[k] = result;
                            console.log(JSON.stringify(this.lookup_filde_json));   
    
                        })
                        .catch(e => {
                            this.message = e.message;
                        });
                }
                 
            }
        } catch (error) {
            console.log(error.message);
        }
    }
    show_required_fields_error() {
        this.checkbool = false;
        let error_msg = 'Please fill out all required fields.';
        this.template.querySelector('c-toast-component').showToast('error', error_msg, 3000);
    }
    check_validation() {

        for (let i = 0; i < this.PageFieldList.length; i++) {
            let test2 = this.PageFieldList[i].Field_Mapping__c;
            var add_name = test2.split('Address');
            let test3 = this.PageFieldList[i].Field_Validations__c;
            var fild_validetionArr = test3.split('?$`~');
            let is_req = fild_validetionArr[0];
            var requiredArr = is_req.split('<!@!>');
            let req_value = requiredArr[1];
            var nameArr = test2.split('<!@!>');
            const fildAPI = nameArr[0];
            this.list_validetion[test2] = req_value;
            this.s_ob = nameArr[0];
            const objectAPI = nameArr[1];

            if (this.first_object == objectAPI) {

                let fil_val = this.all_filde_value[fildAPI];

                if (req_value == 'true') {

                    if (fil_val != '' && fil_val != null && fil_val != ' ' && fil_val != undefined && fil_val != 'null') {

                        fil_val = fil_val.trim();
                        if (fil_val != '' && fil_val != null && fil_val != ' ' && fil_val != undefined && fil_val != 'null') {
                            this.checkbool = true;
                        } else {
                            this.show_required_fields_error();
                            break;
                        }

                    } else if (add_name[1] != undefined) {
                        let a_street = this.all_filde_value[add_name[0] + 'Street'];
                        if (a_street != '' && a_street != null && a_street != ' ' && a_street != undefined) {
                            this.checkbool = true;
                        } else {

                            this.show_required_fields_error();
                            break;
                        }

                    } else {

                        this.show_required_fields_error();
                        break;
                    }
                }
            } else if (this.second_object == objectAPI) {

                let fil_val = this.all_filde_value_second[fildAPI];

                if (req_value == 'true') {
                    if (fil_val != '' && fil_val != null && fil_val != ' ' && fil_val != undefined && fil_val != 'null') {
                        fil_val = fil_val.trim();
                        if (fil_val != '' && fil_val != null && fil_val != ' ' && fil_val != undefined && fil_val != 'null') {
                            this.checkbool = true;
                        } else {

                            this.show_required_fields_error();
                            break;
                        }

                    } else if (add_name[1] != undefined) {
                        let a_street = this.all_filde_value_second[add_name[0] + 'Street'];

                        if (a_street != '' && a_street != null && a_street != ' ' && a_street != undefined) {
                            this.checkbool = true;
                        } else {
                            this.show_required_fields_error();
                            break;
                        }

                    } else {

                        this.show_required_fields_error();
                        break;
                    }
                }

            } else if (this.third_object == objectAPI) {

                let fil_val = this.all_filde_value_third[fildAPI];

                if (req_value == 'true') {
                    if (fil_val != '' && fil_val != null && fil_val != ' ' && fil_val != undefined && fil_val != 'null') {
                        fil_val = fil_val.trim();
                        if (fil_val != '' && fil_val != null && fil_val != ' ' && fil_val != undefined && fil_val != 'null') {
                            this.checkbool = true;
                        } else {

                            this.show_required_fields_error();
                            break;
                        }

                    } else if (add_name[1] != undefined) {
                        let a_street = this.all_filde_value_third[add_name[0] + 'Street'];
                        if (a_street != '' && a_street != null && a_street != ' ' && a_street != undefined) {
                            this.checkbool = true;
                        } else {

                            this.show_required_fields_error();
                            break;
                        }

                    } else {

                        this.show_required_fields_error();
                        break;
                    }
                }

            } else {

                let fil_val = this.all_filde_value_ext[fildAPI];

                if (req_value == 'true') {

                    if (fil_val != '' && fil_val != null && fil_val != ' ' && fil_val != undefined && fil_val != 'null') {
                        fil_val = fil_val.trim();
                        if (fil_val != '' && fil_val != null && fil_val != ' ' && fil_val != undefined && fil_val != 'null') {
                            this.checkbool = true;
                        } else {

                            this.show_required_fields_error();
                            break;
                        }

                    } else {

                        this.show_required_fields_error();
                        break;
                    }
                }

            }
        }

        if (this.checkbool == true) {

            if (this.current_bt == 'next') {
                if (this.pageindex == 1) {

                    if (this.pageindex == this.PageList.length) {
                        this.isIndexZero = false;
                        this.isIndexLast = true;
                    } else {
                        this.pageindex++;
                        this.isIndexZero = false;
                        this.isIndexLast = false;
                        if (this.pageindex == this.PageList.length) {
                            this.isIndexLast = true;
                        }
                    }
                } else if (this.PageList.length > this.pageindex) {
                    this.pageindex++;
                    if (this.pageindex == this.PageList.length) {
                        this.isIndexLast = true;
                    } else {
                        this.isIndexLast = false;
                    }
                }
                this.page = this.Mainlist[this.pageindex - 1];
                this.template.querySelector('c-progress-indicator').calculation(this.Progressbarvalue, this.pageindex, this.PageList.length);
            } else if (this.current_bt == 'submit') {
                if (this.captchavalue == 'None' || this.captchavalue == '--None--' || this.captchavalue == undefined) {
                    this.remove_separator();

                } else {
                    if (this.verify == true) {
                        this.remove_separator();
                    } else {
                        let toast_error_msg = 'Invalid Captcha';
                        this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
                    }

                }

            }
        }
    } catch() {
        this.message = 'Something Went Wrong In Preview Form Page';
        this.showerror(this.message);
    }
    remove_separator() {

        for (let j = 0; j < this.first_list.length; j++) {

            var test_f_val = this.list_first_obj[this.first_list[j]];
            var f_valArr = test_f_val.split('<QF>');
            var first_val = f_valArr[0];

            if (first_val == 'select-one') {
                this.list_first_obj[this.first_list[j]] = f_valArr[1];

            } else if (first_val == 'textarea') {
                this.list_first_obj[this.first_list[j]] = f_valArr[1];

            } else if (first_val == 'fullname') {
                var f_name = f_valArr[1] + f_valArr[2] + f_valArr[3];
                this.list_first_obj[this.first_list[j]] = f_name;

            } else if (first_val == 'add') {
                var addres = f_valArr[1] + f_valArr[2] + f_valArr[3] + f_valArr[4] + f_valArr[5];
                this.list_first_obj[this.first_list[j]] = addres;

            } else if (first_val == 'm_pick') {

                let full_m_val = '';
                for (let k = 1; k < f_valArr.length; k++) {
                    if (f_valArr[k] != '' || f_valArr[k] != undefined) {
                        var m_pic_labele = f_valArr[k].split('<?QF>');

                        if (m_pic_labele[0] != undefined) {
                            full_m_val = full_m_val + m_pic_labele[0];

                            if (k < f_valArr.length - 2) {
                                full_m_val = full_m_val + ';';

                            }
                        }
                    }

                }
                this.list_first_obj[this.first_list[j]] = full_m_val;

            } else if (first_val == 'chk_box') {
                this.list_first_obj[this.first_list[j]] = f_valArr[1];
            } else if (first_val == 'refernce') {
                this.list_first_obj[this.first_list[j]] = f_valArr[2];

            } else if (first_val == 'datetime') {

                const date = new Date(f_valArr[1]); // assuming the input datetime is in UTC format
                const offset = new Date().getTimezoneOffset(); // get the local time zone offset in minutes
                const offsetHours = Math.abs(Math.floor(offset / 60)).toString().padStart(2, '0'); // convert offset to hours and pad with leading zeros if necessary
                const offsetMinutes = Math.abs(offset % 60).toString().padStart(2, '0'); // get the remaining minutes of the offset and pad with leading zeros if necessary
                const offsetSign = offset >= 0 ? '-' : '+'; // determine the sign of the offset
                const isoString = date.toISOString().replace('Z', `${offsetSign}${offsetHours}:${offsetMinutes}`);
                this.list_first_obj[this.first_list[j]] = isoString;

            } else if (first_val == 'time') {
                this.list_first_obj[this.first_list[j]] = f_valArr[1] + ':00.000Z';

            } else {
                this.list_first_obj[this.first_list[j]] = f_valArr[0];
            }


        }

        for (let j = 0; j < this.second_list.length; j++) {

            let test_f_val = this.list_second_obj[this.second_list[j]];
            let f_valArr = test_f_val.split('<QF>');
            let first_val = f_valArr[0];
            if (first_val == 'select-one') {
                this.list_second_obj[this.second_list[j]] = f_valArr[1];

            } else if (first_val == 'textarea') {
                this.list_second_obj[this.second_list[j]] = f_valArr[1];

            } else if (first_val == 'fullname') {
                let f_name = f_valArr[1] + f_valArr[2] + f_valArr[3];
                this.list_second_obj[this.second_list[j]] = f_name;

            } else if (first_val == 'add') {
                let addres = f_valArr[1] + f_valArr[2] + f_valArr[3] + f_valArr[4] + f_valArr[5];
                this.list_second_obj[this.second_list[j]] = addres;

            } else if (first_val == 'm_pick') {
                let full_m_val = '';
                for (let k = 1; k < f_valArr.length; k++) {
                    if (f_valArr[k] != '' || f_valArr[k] != undefined) {
                        let m_pic_labels = f_valArr[k].split('<?QF>');

                        if (m_pic_labels[0] != undefined) {
                            full_m_val = full_m_val + m_pic_labels[0];

                            if (k < f_valArr.length - 2) {
                                full_m_val = full_m_val + ';';

                            }
                        }
                    }

                }

                this.list_second_obj[this.second_list[j]] = full_m_val;

            } else if (first_val == 'chk_box') {

                this.list_second_obj[this.second_list[j]] = f_valArr[1];
            } else if (first_val == 'refernce') {
                this.list_second_obj[this.second_list[j]] = f_valArr[2];

            } else if (first_val == 'datetime') {
                const date = new Date(f_valArr[1]); // assuming the input datetime is in UTC format
                const offset = new Date().getTimezoneOffset(); // get the local time zone offset in minutes
                const offsetHours = Math.abs(Math.floor(offset / 60)).toString().padStart(2, '0'); // convert offset to hours and pad with leading zeros if necessary
                const offsetMinutes = Math.abs(offset % 60).toString().padStart(2, '0'); // get the remaining minutes of the offset and pad with leading zeros if necessary
                const offsetSign = offset >= 0 ? '-' : '+'; // determine the sign of the offset
                const isoString = date.toISOString().replace('Z', `${offsetSign}${offsetHours}:${offsetMinutes}`);
                this.list_second_obj[this.second_list[j]] = isoString;

            } else if (first_val == 'time') {
                this.list_second_obj[this.second_list[j]] = f_valArr[1] + ':00.000Z';
            } else if (first_val == 'attbase64') {
                this.list_second_obj[this.second_list[j]] = f_valArr[1];
            } else {
                this.list_second_obj[this.second_list[j]] = f_valArr[0];
            }
        }

        for (let j = 0; j < this.third_list.length; j++) {

            let test_f_val = this.list_third_obj[this.third_list[j]];
            let f_valArr = test_f_val.split('<QF>');
            let first_val = f_valArr[0];
            if (first_val == 'select-one') {
                this.list_third_obj[this.third_list[j]] = f_valArr[1];

            } else if (first_val == 'textarea') {
                this.list_third_obj[this.third_list[j]] = f_valArr[1];

            } else if (first_val == 'fullname') {
                let f_name = f_valArr[1] + f_valArr[2] + f_valArr[3];
                this.list_third_obj[this.third_list[j]] = f_name;

            } else if (first_val == 'add') {
                let addres = f_valArr[1] + f_valArr[2] + f_valArr[3] + f_valArr[4] + f_valArr[5];
                this.list_third_obj[this.third_list[j]] = addres;

            } else if (first_val == 'm_pick') {
                let full_m_val = '';
                for (let k = 1; k < f_valArr.length; k++) {
                    if (f_valArr[k] != '' || f_valArr[k] != undefined) {
                        let m_pic_labelss = f_valArr[k].split('<?QF>');

                        if (m_pic_labelss[0] != undefined) {
                            full_m_val = full_m_val + m_pic_labelss[0];
                            if (k < f_valArr.length - 2) {
                                full_m_val = full_m_val + ';';

                            }
                        }
                    }

                }
                this.list_first_obj[this.third_list[j]] = full_m_val;

            } else if (first_val == 'chk_box') {
                this.list_third_obj[this.third_list[j]] = f_valArr[1];
            } else if (first_val == 'refernce') {
                this.list_third_obj[this.third_list[j]] = f_valArr[2];

            } else if (first_val == 'datetime') {
                const date = new Date(f_valArr[1]); // assuming the input datetime is in UTC format
                const offset = new Date().getTimezoneOffset(); // get the local time zone offset in minutes
                const offsetHours = Math.abs(Math.floor(offset / 60)).toString().padStart(2, '0'); // convert offset to hours and pad with leading zeros if necessary
                const offsetMinutes = Math.abs(offset % 60).toString().padStart(2, '0'); // get the remaining minutes of the offset and pad with leading zeros if necessary
                const offsetSign = offset >= 0 ? '-' : '+'; // determine the sign of the offset
                const isoString = date.toISOString().replace('Z', `${offsetSign}${offsetHours}:${offsetMinutes}`);
                this.list_third_obj[this.third_list[j]] = isoString;

            } else if (first_val == 'time') {
                this.list_third_obj[this.third_list[j]] = f_valArr[1] + ':00.000Z';

            } else if (first_val == 'attbase64') {
                this.list_third_obj[this.third_list[j]] = f_valArr[1];

            } else {
                this.list_third_obj[this.third_list[j]] = f_valArr[0];
            }


        }

        if (this.ex_list.length == 0) {
            this.list_ext_obj = {};
        }
        for (let j = 0; j < this.ex_list.length; j++) {
            let test_f_val = this.list_ext_obj[this.ex_list[j]];
            let f_valArr = test_f_val.split('<QF>');
            let first_val = f_valArr[0];
            if (first_val == 'select-one') {
                this.list_ext_obj[this.ex_list[j]] = f_valArr[1];

            } else if (first_val == 'textarea') {
                this.list_ext_obj[this.ex_list[j]] = f_valArr[1];

            } else if (first_val == 'fullname') {
                let f_name = f_valArr[1] + ' ' + f_valArr[2] + ' ' + f_valArr[3];
                this.list_ext_obj[this.ex_list[j]] = f_name;

            } else if (first_val == 'add') {
                let addres = f_valArr[1] + f_valArr[2] + f_valArr[3] + f_valArr[4] + f_valArr[5];
                this.list_ext_obj[this.ex_list[j]] = addres;

            } else if (first_val == 'm_pick') {
                let full_m_val = '';
                for (let k = 1; k < f_valArr.length; k++) {
                    if (f_valArr[k] != '' || f_valArr[k] != undefined) {
                        let m_pics_labels = f_valArr[k].split('<?QF>');
                        if (m_pics_labels[0] != undefined) {
                            full_m_val = full_m_val + m_pics_labels[0];
                            if (k < f_valArr.length - 2) {
                                full_m_val = full_m_val + ';';
                            }
                        }
                    }

                }
                this.list_first_obj[this.ex_list[j]] = full_m_val;

            } else if (first_val == 'chk_box') {
                this.list_ext_obj[this.ex_list[j]] = f_valArr[1];
            } else if (first_val == 'chkbox') {
                var chk_list = '';
                for (let k = 2; k < f_valArr.length; k++) {

                    if (f_valArr.length - 1 > k) {

                        chk_list = chk_list + f_valArr[k] + ',';
                    } else {
                        chk_list = chk_list + f_valArr[k];
                    }

                }
                this.list_ext_obj[this.ex_list[j]] = chk_list;
            } else if (first_val == 'refernce') {
                this.list_ext_obj[this.ex_list[j]] = f_valArr[2];

            } else if (first_val == 'redio') {
                this.list_ext_obj[this.ex_list[j]] = f_valArr[1];

            } else if (first_val == 'time') {
                this.list_ext_obj[this.ex_list[j]] = f_valArr[1] + ':00.000Z';

            } else if (first_val == 'star') {
                this.list_ext_obj[this.ex_list[j]] = f_valArr[1];

            } else if (first_val == 'emoji') {
                this.list_ext_obj[this.ex_list[j]] = f_valArr[1];

            } else if (first_val == 'datetime') {
                const date = new Date(f_valArr[1]); // assuming the input datetime is in UTC format
                const offset = new Date().getTimezoneOffset(); // get the local time zone offset in minutes
                const offsetHours = Math.abs(Math.floor(offset / 60)).toString().padStart(2, '0'); // convert offset to hours and pad with leading zeros if necessary
                const offsetMinutes = Math.abs(offset % 60).toString().padStart(2, '0'); // get the remaining minutes of the offset and pad with leading zeros if necessary
                const offsetSign = offset >= 0 ? '-' : '+'; // determine the sign of the offset
                const isoString = date.toISOString().replace('Z', `${offsetSign}${offsetHours}:${offsetMinutes}`);
                this.list_ext_obj[this.ex_list[j]] = isoString;

            } else {
                this.list_ext_obj[this.ex_list[j]] = f_valArr[0];
            }


        }

        this.onsubmit();
    }

    onsubmit() {
        if (this.nosubmission == false) {
            this.disableSaveButton = true;
            if (Object.keys(this.list_ext_obj).length == 1) {
                this.list_ext_obj == {};
            }
            let list_submission_obj = {
                'sobjectType': 'Form_Submission__c'
            };
            list_submission_obj['Form__c'] = this.formIdNew;
            list_submission_obj['First_object_data__c'] = JSON.stringify(this.list_first_obj);
            list_submission_obj['Second_object_data__c'] = JSON.stringify(this.list_second_obj);
            list_submission_obj['Third_object_data__c'] = JSON.stringify(this.list_third_obj);
            list_submission_obj['Other_fields_data__c'] = JSON.stringify(this.list_ext_obj);
            if (this.form_mapped_Objects.length == 1) {

                createrecord({
                    acc: list_submission_obj,
                    first_obj_list: this.list_first_obj,
                    sig_upload_jsone: JSON.stringify(this.sig_upload),
                    sig_upload_fid_list: this.sig_fildeid,
                    file_upload_jsone: JSON.stringify(this.file_upload),
                    file_upload_fid_list: this.file_upload_fildeid,
                    
                })
                    .then(data => {
                        console.log(JSON.stringify(data));
                        this.sub_id = data.SubmissionId;
                        this.file_u_map = data.File_upload_map;
                        this.sig_u_map = data.Sig_upload_map;
                        let toast_error_msg = 'Your form is submitted successfully.';
                        this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);
                        console.log('email1');
                        console.log('sub_id : ', this.sub_id);
                        this.sendnotification(this.sub_id);
                        console.log('email2');
                        // this.add_sig();
                    })
                    .catch((error) => {
                        console.log(error.message);
                        this.spinnerDataTable = false;
                        let toast_error_msg = 'Your Form Submission was unsuccessful. Please try again';
                        this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);

                    })
            } else if (this.form_mapped_Objects.length == 2) {

                this.add_lookyp_fildes();
                createrecord_for_secod_object({
                    acc: list_submission_obj,
                    first_obj_list: this.list_first_obj,
                    list_second_obj: this.list_second_obj,
                    sig_upload_jsone: JSON.stringify(this.sig_upload),
                    sig_upload_fid_list: this.sig_fildeid,
                    file_upload_jsone: JSON.stringify(this.file_upload),
                    file_upload_fid_list: this.file_upload_fildeid,
                    create_chi: this.create_chi,
                    lookup_list: this.lookup_2obj,
                    base64att: this.base64Att,
                })
                    .then(data => {
                        this.sub_id = data.SubmissionId;
                        this.file_u_map = data.File_upload_map;
                        this.sig_u_map = data.Sig_upload_map;
                        let toast_error_msg = 'Your form is submitted successfully.';
                        this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);
                        this.sendnotification(this.sub_id);
                        // this.add_sig();
                    })
                    .catch(() => {
                        this.spinnerDataTable = false;
                        let toast_error_msg = 'Your form submission was unsuccessful. Please try again.';
                        this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
                    })

            } else if (this.form_mapped_Objects.length == 3) {
                console.log('Nimit Start');
                console.log(this.lookup_filde_json);
                console.log(this.lookup_filde_json['1']);
                this.lookup_2obj = this.lookup_filde_json['1'];
                console.log(this.lookup_2obj);
                console.log(JSON.stringify(this.lookup_filde_json));
                console.log(JSON.stringify(this.lookup_filde_json['1']));
               
                this.lookup_3obj = this.lookup_filde_json['2'];
                console.log(this.lookup_filde_json['2']);
                console.log(JSON.stringify(this.lookup_filde_json['2']));
                console.log('Nimit End');
                this.add_lookyp_fildes();
                this.add_lookyp_fildes_2();
                createrecord_for_third_object({
                    acc: list_submission_obj,
                    first_obj_list: this.list_first_obj,
                    list_second_obj: this.list_second_obj,
                    list_third_obj: this.list_third_obj,
                    sig_upload_jsone: JSON.stringify(this.sig_upload),
                    sig_upload_fid_list: this.sig_fildeid,
                    file_upload_jsone: JSON.stringify(this.file_upload),
                    file_upload_fid_list: this.file_upload_fildeid,
                    create_chi: this.create_chi,
                    lookup_list: this.lookup_2obj,
                    create_chi_2: this.create_chi_2,
                    lookup_list2: this.lookup_3obj,
                    base64att: this.base64Att,
                    
                })
                    .then(data => {
                        this.sub_id = data.SubmissionId;
                        this.file_u_map = data.File_upload_map;
                        this.sig_u_map = data.Sig_upload_map;
                        let toast_error_msg = 'Your form is submitted successfully.';
                        this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);
                        this.sendnotification(this.sub_id);
                        // this.add_sig();
                    })
                    .catch(() => {
                        this.spinnerDataTable = false;
                        let toast_error_msg = 'Your form submission was unsuccessful. Please try again';
                        this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
                    })
            }
        }
        this.redirecttothankyou();
        this.regeneratecaptcha();
    }

    errorpopupcall() {
        location.reload();
    }
    next_val_by(event) {
        let key = event.detail;
        let push_val = 'yes';
        for (let i = 0; i < this.error_josn_key_list.length; i++) {

            if (this.error_josn_key_list[i] == key) {
                push_val = 'no'
                break;
            }
        }
        if (push_val == 'yes') {
            this.error_josn_key_list.push(key);
        }

    }
    next_val_true(event) {
        let key = event.detail;
        for (let i = 0; i < this.error_josn_key_list.length; i++) {
            if (this.error_josn_key_list[i] == key) {
                this.error_josn_key_list.splice(i, 1);
            }
        }

    }
    add_input_val_josn(event) {
        let newval = event.detail;
        var newvalArr = newval.split('<!@!>');
        this.add_input_val = newvalArr[2];

    }

    storefielddata(event) {
        this.datawithleabel = event.detail;
        var nameArr = this.datawithleabel.split('<!@!>');
        let testt = 'no';
        let ind;

        if (this.first_object == nameArr[1]) {
            for (let i = 0; i < this.list_first_obj.length; i++) {
                if (this.list_first_obj[i] == nameArr[0]) {

                    testt = 'yes'
                    ind = i;
                }
            }
            if (testt == 'yes') {

                this.list_first_obj[ind].filde_vlue = nameArr[2];
                this.all_filde_value[ind].filde_vlue = this.add_input_val;

            } else {
                this.list_first_obj[nameArr[0]] = nameArr[2];
                this.all_filde_value[nameArr[0]] = this.add_input_val;

                let pass_key = 'no';
                for (let i = 0; i < this.first_list.length; i++) {
                    if (nameArr[0] == this.first_list[i]) {
                        pass_key = 'yes';
                    }
                }
                if (pass_key == 'no') {
                    this.first_list.push(nameArr[0]);
                }

            }
        } else if (this.second_object == nameArr[1]) {
            for (let i = 0; i < this.list_second_obj.length; i++) {
                if (this.list_second_obj[i] == nameArr[0]) {

                    testt = 'yes'
                    ind = i;
                }
            }
            if (testt == 'yes') {

                this.list_second_obj[ind].filde_vlue = nameArr[2];
                this.all_filde_value_second[ind].filde_vlue = this.add_input_val;

            } else {

                this.list_second_obj[nameArr[0]] = nameArr[2];
                this.all_filde_value_second[nameArr[0]] = this.add_input_val;

                this.second_list.push(nameArr[0]);
                let pass_key = 'no';
                for (let i = 0; i < this.second_list.length; i++) {
                    if (nameArr[0] == this.second_list[i]) {
                        pass_key = 'yes';
                    }
                }
                if (pass_key == 'no') {
                    this.second_list.push(nameArr[0]);
                }

            }
        } else if (this.third_object == nameArr[1]) {
            for (let i = 0; i < this.list_third_obj.length; i++) {
                if (this.list_third_obj[i] == nameArr[0]) {

                    testt = 'yes'
                    ind = i;
                }
            }
            if (testt == 'yes') {

                this.list_third_obj[ind].filde_vlue = nameArr[2];
                this.all_filde_value_third[ind].filde_vlue = this.add_input_val;


            } else {

                this.list_third_obj[nameArr[0]] = nameArr[2];
                this.all_filde_value_third[nameArr[0]] = this.add_input_val;
                this.third_list.push(nameArr[0]);
                let pass_key = 'no';
                for (let i = 0; i < this.third_list.length; i++) {
                    if (nameArr[0] == this.third_list[i]) {
                        pass_key = 'yes';
                    }
                }
                if (pass_key == 'no') {
                    this.third_list.push(nameArr[0]);
                }

            }
        } else {
            for (let i = 0; i < this.list_ext_obj.length; i++) {
                if (this.list_ext_obj[i] == nameArr[0]) {

                    testt = 'yes'
                    ind = i;
                }
            }
            if (testt == 'yes') {

                this.list_ext_obj[ind].filde_vlue = nameArr[2];
                this.all_filde_value_ext[ind].filde_vlue = this.add_input_val;

            } else {

                this.list_ext_obj[nameArr[0]] = nameArr[2];
                this.all_filde_value_ext[nameArr[0]] = this.add_input_val;
                this.ex_list.push(nameArr[0]);
                let pass_key = 'no';
                for (let i = 0; i < this.ex_list.length; i++) {
                    if (nameArr[0] == this.ex_list[i]) {
                        pass_key = 'yes';
                    }
                }
                if (pass_key == 'no') {
                    this.ex_list.push(nameArr[0]);
                }

            }

        }
    }

    thankyou = false;
    thankyoutype;
    label;
    changelabel;
    text;
    richtext;
    url;

    redirecttothankyou() {
        // TO REDIRECT TO THANK YOU PAGE
        getthankyoupage({
            currentformid: this.formIdNew
        })
            .then(result => {
                this.thankyoutype = result.Thankyou_Page_Type__c;
                this.label = result.ThankYou_Label__c;
                this.changelabel = result.ThankYou_Label__c;
                this.text = result.Thankyou_Text__c;
                this.richtext = result.Thankyou_Text__c;
                this.url = result.Thank_you_URL__c;

                if (result.Thankyou_Page_Type__c == 'Show Text') {
                    this.thankyou = true;
                    this.isPreviewForm = false;
                } else if (result.Thankyou_Page_Type__c == 'Show HTML block') {
                    this.thankyou = true;
                    this.isPreviewForm = false;
                } else if (result.Thankyou_Page_Type__c == 'Redirect to a webpage') {
                    window.open(result.Thank_you_URL__c);
                } else if (result.Thankyou_Page_Type__c == 'Show text, then redirect to web page') {
                    this.thankyou = true;
                    this.isPreviewForm = false;
                }
            })

            .catch(() => {
                this.spinnerDataTable = false;
                this.message = 'Something Went Wrong In preview Page';
                this.showerror();
                this.spinnerDataTable = false;
            });
        // TO REDIRECT TO THANK YOU PAGE
    }
    sendnotification(submissionids) {
        console.log('formIdNew : ', this.formIdNew);
        console.log('submissionids : ', submissionids);
        sendemailaftersubmission({
            formid: this.formIdNew,
            submissionid: submissionids
        })
            .then((result) => {
                console.log(JSON.stringify(result));
            }).catch(e => {
                console.log('error send notification : ', e.message);
                this.message = 'Something Went Wrong In preview Page' + e.message;
                this.showerror();
                this.spinnerDataTable = false;
            })
    }
    convertedDataURIsin(event) {
        this.sin_data_id = event.detail.con_id;
        this.sig_filde_id = event.detail.filde_id;

        this.sig_upload[this.sig_filde_id] = this.sin_data_id;
        let add_id = 'yes';
        if (this.sig_fildeid.length == 0) {
            this.sig_fildeid.push(this.sig_filde_id);
        }
        for (let i = 0; i < this.sig_fildeid.length; i++) {

            if (this.sig_fildeid[i] == this.sig_filde_id) {

                add_id = 'no';
            }
        }
        if (add_id == 'yes') {

            this.sig_fildeid.push(this.sig_filde_id);

        }

    }
    add_file_upload_josn(event) {

        this.file_upload_id = event.detail.filde_id;
        this.file_upload_url = event.detail.con_id;
        let file_name = event.detail.fileName;
        let file_titel = event.detail.contentType;
        let add_id = 'yes';
        let full_id = this.file_upload_id + '<!QF!>' + file_name + '<!QF!>' + file_titel;

        this.file_upload[full_id] = this.file_upload_url;

        if (this.file_upload_fildeid.length == 0) {

            this.file_upload_fildeid.push(full_id);
        }
        for (let i = 0; i < this.file_upload_fildeid.length; i++) {

            if (this.file_upload_fildeid[i] == full_id) {

                add_id = 'no';
            }
        }
        if (add_id == 'yes') {

            this.file_upload_fildeid.push(full_id);

        }

    }

    @api showerror() {
        this.error_popup1 = true;
        let errordata = {
            header_type: 'Preview page',
            Message: this.message
        };
        const showpopup = new CustomEvent('showerrorpopup', {
            detail: errordata
        });
        this.dispatchEvent(showpopup);
    }

    regeneratecaptcha() {
        if (this.captchavalue == 'Normal_Captcha') {
            this.template.querySelector('c-captcha-type').generate_new_normal_captcha();
        } else if (this.captchavalue == 'Maths_Captcha') {
            this.template.querySelector('c-captcha-type').generate_new_math_captcha();
        } else if (this.captchavalue == 'Slider_Captcha') {
            this.template.querySelector('c-captcha-type').generate_new_slider_captcha();
        } else if (this.captchavalue == 'Image_Captcha') {
            this.template.querySelector('c-captcha-type').getrendomcolore();
        }
    }

    add_lookyp_fildes() {
        var apis_of_2obj = Object.keys(this.list_second_obj);
        for (let i = 0; i < apis_of_2obj.length; i++) {

            for (let j = 0; j < this.lookup_2obj.length; j++) {
                if (apis_of_2obj[i] == this.lookup_2obj[j]) {
                    let filde_api = apis_of_2obj[i];
                    if (this.list_second_obj[filde_api] != null && this.list_second_obj[filde_api] != undefined && this.list_second_obj[filde_api] != '') {
                        this.create_chi = false;
                    }
                }
            }
        }
    }
    add_lookyp_fildes_2() {
        var apis_of_3obj = Object.keys(this.list_third_obj);
        for (let i = 0; i < apis_of_3obj.length; i++) {

            for (let j = 0; j < this.lookup_3obj.length; j++) {
                if (apis_of_3obj[i] == this.lookup_3obj[j]) {
                    let filde_api = apis_of_3obj[i];
                    if (this.list_third_obj[filde_api] != null && this.list_third_obj[filde_api] != undefined && this.list_third_obj[filde_api] != '') {
                        this.create_chi_2 = false;

                    }
                }
            }
        }
    }
    @api show_msg_pop(event) {
        var error_msg = event.detail.toast_error_msg;
        var type_pop = event.detail.msg_type;
        this.template.querySelector('c-toast-component').showToast(type_pop, error_msg, 3000);
    }

    showToast(title, variant) {
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    startspinner() {
        this.spinnerDataTable = true;
    }

    stopspinner() {
        this.spinnerDataTable = false;
    }

    @api base64attpreview(event) {
        this.base64Att = event.detail.base64;
        this.fileSize = this.fileSize + event.detail.fSize;

    }


    file_remove(event) {

        let file_id = event.detail;
        var nameArr = file_id.split('<!@!>');
        this.add_input_val = null;
        this.ex_list = this.ex_list.filter(item => item !== nameArr[0]);
        if (nameArr[0] in this.list_ext_obj) {
            delete this.list_ext_obj[nameArr[0]];
            delete this.all_filde_value_ext[nameArr[0]];
            for (let i = 0; i < this.file_upload_fildeid.length; i++) {
                let test_key = this.file_upload_fildeid[i];
                var new_test = test_key.split('<!QF!>');
                if (new_test[0] == nameArr[0]) {
                    if (test_key in this.file_upload) {
                        delete this.file_upload[test_key];
                        this.file_upload_fildeid.splice(i, 1);
                    }
                }
            }

        }

    }
    file_remove_att() {
        this.base64Att = null;
        if ('Body' in this.list_second_obj) {
            delete this.list_second_obj['Body'];
            delete this.all_filde_value_second['Body'];

        }
        else if ('Body' in this.list_third_obj) {
            delete this.list_third_obj['Body'];
            delete this.all_filde_value_third['Body'];

        }

    }
    @api
    getrequestforcloserefencefield(){
        try {
            console.log('getrequestforcloserefencefield');
            var quickfields = this.template.querySelectorAll('c-quickformfieldcomponent');
            for (let index = 0; index < quickfields.length; index++) {
                const element = quickfields[index];
                console.log('getrequestforcloserefencefield');
                element.changeMessage('true');
                
            }
        } catch (error) {
            console.error(error.message);
        }
        
    }
}