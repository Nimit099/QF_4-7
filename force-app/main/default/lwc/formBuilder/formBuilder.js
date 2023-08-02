import {
    LightningElement,
    track,
    wire,
    api
} from 'lwc';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import GetFormPage from '@salesforce/apex/FormBuilderController.GetFormPage';
import iconzip from '@salesforce/resourceUrl/NavigationBar'
import getFieldsRecords from '@salesforce/apex/FormBuilderController.getFieldsRecords';
import CreateFieldRecord from '@salesforce/apex/FormBuilderController.CreateFieldRecord';
import createPage from '@salesforce/apex/FormBuilderController.createPage';
import renameform from '@salesforce/apex/FormBuilderController.renameform';
import addPageBreak from '@salesforce/apex/FormBuilderController.addPageBreak';
import Add_icon from '@salesforce/resourceUrl/Add_icon';
import Edit_page_icon from '@salesforce/resourceUrl/Edit_page_icon';
import Edit_icon from '@salesforce/resourceUrl/Edit_icon';
import Delete_icon from '@salesforce/resourceUrl/Delete_icon';
import right from '@salesforce/resourceUrl/right';
import cross from '@salesforce/resourceUrl/cross';
import dropHere from '@salesforce/resourceUrl/dropHere'
import deletePage from '@salesforce/apex/FormBuilderController.deletePage';
import {
    NavigationMixin
} from "lightning/navigation";
import iconsZip from '@salesforce/resourceUrl/Iconfolder';
// edit form part imports 
import Objects_Type from "@salesforce/apex/QuickFormHome.f_Get_Types";
import getCaptchatype from '@salesforce/apex/QuickFormHome.getCaptchatype'; //import get getCaptchatype method from custom Metadata apex class
import Objects_Type_2 from "@salesforce/apex/QuickFormHome.Get_Captcha_Types";
import getProgressindicator from '@salesforce/apex/QuickFormHome.getProgressindicator'; //import get getProgressindicator method from custom Metadata apex class
import pageDetails from '@salesforce/apex/FormBuilderController.pageDetails';
import updatePage from '@salesforce/apex/FormBuilderController.updatePage';
import editFormSubmit from '@salesforce/apex/FormBuilderController.editFormSubmit';

// Importing Apec Metods
import reOrderField from '@salesforce/apex/FormBuilderController.reOrderField';
import date_timecss from '@salesforce/resourceUrl/date_timecss';

import formdetails from '@salesforce/apex/FormBuilderController.formdetails';
import {
    loadStyle,

} from 'lightning/platformResourceLoader';
import helptextcss from '@salesforce/resourceUrl/helptextcss'

export default class FormBuilder extends NavigationMixin(LightningElement) {


    @track spinnerDataTable = false;

    @api homeIcon = iconzip + '/home.png';
    fieldicon = iconzip + '/fields.png';
    designIcon = iconzip + '/designdesign.png';
    notificationicon = iconzip + '/notificationnotification.png';
    thankyouicon = iconzip + '/thankyou.png';
    previewIcon = iconzip + '/previewPreview.png';
    publishIcon = iconzip + '/Vectorpublishment.png';
    DeleteIcon = Delete_icon;

    editpageIcon = Edit_page_icon;
    addIcon = Add_icon;
    EditIcon = Edit_icon;
    cross = cross;
    right = right;
    outsideClick;
    dropHere = dropHere;
    @track newFormName = '';

    isModalOpen = false;
    isModalOpen1 = false;
    isModalOpen2 = false;
    spinnerTable = false;
    error_toast = true;

    @api ParentMessage = '';
    @api FormName = '';
    @track FormNamevalue = '';

    @track MainList = [];
    WieredResult;
    imageSpinner = false;
    pageImageSpinner = false;
    notShowField = true;
    showField = false;
    @track activeDropZone = true;
    @track FormId = this.ParentMessage;
    //dropzone variables
    count = 0;
    @track activeDesignsidebar = false;
    @track activesidebar = false;
    @track activeNotification = false;
    @track activethankyou = false;
    @track activepreview = false;
    @track activeqf_publish = false;
    @track PageList = [];
    @track FormTitle;
    @track FieldList = [];
    Id = this.ParentMessage; // Change When LMS Service Starts    
    EditButtonName = "Edit";
    nextButton = 'NextButton';
    previousButton = 'previousButton';
    @track index = 0;
    @track newCSS;
    newPageId;
    @track newMainFormName;
    fieldcount = 0;
    removeObjFields = [];
    fieldvalidationdiv = false;
    @track tab = 'tab-2';
    @track fieldId;
    @track fieldName;

    @track isReorderingDrag = false;
    @track startFielId = '';

    @track hovercss;
    @track focuscss;
    @track fcss;
    @track lcss;
    @track pagecss;
    @track formcss;
    @track btncss;
    @track btnpos;
    @track isFieldView;
    objname = '';
    @track filesignread;

    //error_popup
    @api error_popup;
    @track error_popup1;
    @track error_message;

    @track formtitle;
    @track description;
    @track ispreview_show_msg_captcha = true;
    @track ispreview_show_msg = false;
    @track pi = true;
    @track ct = true;
    @track l_All_Types;
    @track TypeOptions;
    @track FormDetails;
    @track PageDetails;
    @wire(getProgressindicator) records;
    @wire(getCaptchatype) captcharecords;
    @track l_All_Types_2;
    @track TypeOptions_2;
    @track Progressbarvalue;
    @track captchTypeparent;

    @track global_options
    pageeeee
    @track pagetitle;
    @track pagenumber;
    @track pagetitle2;
    @track pagenumber2;
    @track submit = false;
    @track randomString;

    connectedCallback() {
        this.submit = false;
        this.FormNamevalue = this.FormName;
        this.error_popup1 = this.error_popup;
        this.randomString = this.generateRandomString();

        formdetails({
                id: this.ParentMessage
            })
            .then(result => {
                this.formcss = result.Form_Styling__c;
                this.btncss = result.Button_CSS__c;
                this.pagecss = result.Page_CSS__c;
                this.hovercss = result.All_Field_Hover__c;
                this.focuscss = result.All_Field_Focus__c
                this.fcss = result.All_Field_Styling__c;
                this.lcss = result.Label_CSS__c;
                this.btnpos = result.Button_Position__c;

            }).catch(e => {
                this.spinnerDataTable = false;
                this.error_message = 'Something Went Wrong In Form Builder Page' + e.message;
                this.showerror();
            })
        this.spinnerDataTable = true;
        this.activesidebar = true;
        this.reloadform();
        loadStyle(this, helptextcss);
        // loadStyle(this, date_timecss);
    }

    reloadform() {
        GetFormPage({
                Form_Id: this.ParentMessage
            })
            .then(result => {
                this.PageList = result;


            }).catch(e => {

                this.spinnerDataTable = false;
                this.error_message = 'Something Went Wrong In Form Builder Page' + e.message;
                this.showerror();
            });
        getFieldsRecords({
                id: this.ParentMessage
            })
            .then(result => {

                this.FieldList = result;
                this.setPageField(result);
                if (this.tab == 'tab-2') {
                    var allDiv = this.template.querySelector('.tab-2');
                    allDiv.style = 'background-color: #8EBFF0;padding: 12%;border-radius: 50%;';
                }

            })
            .catch(e => {
                this.error_message = 'Something Went Wrong In Form Builder Page' + e.message;
                var allDiv = this.template.querySelector('.tab-2');
                allDiv.style = 'background-color: #8EBFF0;padding: 12%;border-radius: 50%;';
            });

        if (this.tab == 'tab-2') {
            this.activesidebar = true;
        } else if (this.tab == 'tab-3') {
            this.activeDesignsidebar = true;
        }
        this.isFieldView = true;
        this.filesignread = true;
    }

    renderedCallback() {

        this.tempararyfun();
        if (this.formcss != undefined && this.formcss != null) {


            let array = this.template.querySelector('.myform');
            let str = this.formcss;
            array.style = str;
        }

        if (this.btncss != undefined && this.btncss != null) {
            let str = this.btncss;
            let arr = this.template.querySelectorAll('.btn1');
            for (let i = 0; i < arr.length; i++) {
                const element = arr[i];
                element.style = str;
            }
            let arr2 = this.template.querySelectorAll('.footer');
            let str2 = this.btnpos;

            for (let i = 0; i < arr2.length; i++) {
                const element = arr2[i];
                element.style = str2;
            }

        }

        if (this.lcss != undefined && this.lcss != null) {
            let Arr = this.template.querySelectorAll("c-quickformfieldcomponent");
            for (let i = 0; i < Arr.length; i++) {
                const element = Arr[i];

                element.LabelCSSUpdate(this.lcss);
            }
        }

        if (this.pagecss != undefined && this.pagecss != null) {


            let array = this.template.querySelectorAll('.page');
            let str = this.pagecss;
            for (let i = 0; i < array.length; i++) {
                const element = array[i];

                element.style = str;
            }
        }
    }

    get isIndexZero() {

        if (this.index == 0) {
            this.index += 1;
            return true;
        }
        return false;
    }
    get isIndexIsNotLast() {

        if (this.index != this.PageList.length - 1) {
            this.index += 1;
            return true;
        }
        return false;
    }
    get isIndexLast() {
        if (this.index == this.PageList.length - 1) {
            return true;
        }
        return false;
    }

    handlelabelcss(event) {
        this.newCSS = event.detail;
        this.lcss = event.detail;

        let Arr = this.template.querySelectorAll("c-quickformfieldcomponent");
        for (let i = 0; i < Arr.length; i++) {
            const element = Arr[i];

            element.LabelCSSUpdate(this.newCSS);
        }

    }

    handlehovercss(event) {

        this.hovercss = event.detail;
        let Arr = this.template.querySelectorAll("c-quickformfieldcomponent");
        for (let i = 0; i < Arr.length; i++) {
            const element = Arr[i];

            element.handleeffect('hover', event.detail);
        }

    }

    handlefocuscss(event) {
        this.focuscss = event.detail;

        let Arr = this.template.querySelectorAll("c-quickformfieldcomponent");
        for (let i = 0; i < Arr.length; i++) {
            const element = Arr[i];

            element.handleeffect('focus', event.detail);
        }

    }

    handlepagecss(event) {
        try {
            this.spinnerDataTable = false;

            if (event.detail != null && event.detail != undefined) {
                this.pagecss = event.detail;
                this.spinnerDataTable = false;
            }

            let array = this.template.querySelectorAll('.page');
            let str = this.pagecss;
            for (let i = 0; i < array.length; i++) {
                const element = array[i];
                element.style = str;
            }
            this.spinnerDataTable = false;
        } catch (error) {
            console.error(error);
            this.spinnerDataTable = false;
        }
    }



    handleformcss(event) {
        try {
            this.spinnerDataTable = false;
            if (event.detail != null && event.detail != undefined) {
                this.formcss = event.detail;
            }

            let array = this.template.querySelector('.myform');
            let str = this.formcss;
            array.style = str;
        } catch (error) {
            console.error(error);
            this.spinnerDataTable = false;
        }
    }
    formerrormsg() {
        let toast_error_msg = 'File size should be less than the 4MB';
        this.error_toast = true;
        this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
    }


    handlebtnpos(event) {
        var str = event.detail;
        if (str != undefined || str != '' || str != null) {
            this.btnpos = str;
        } else {
            str = this.btnpos;
        }

        let Arr = this.template.querySelectorAll(".footer");

        for (let i = 0; i < Arr.length; i++) {
            const element = Arr[i];

            element.style = str;
        }
    }

    handlebtncss(event) {
        var str = event.detail;
        if (event.detail == null || event.detail == undefined) {
            str = this.btncss;
        } else {
            this.btncss = str;
        }
        let arr = this.template.querySelectorAll('.btn1');
        for (let i = 0; i < arr.length; i++) {
            const element = arr[i];
            element.style = str;
        }
        let arr2 = this.template.querySelectorAll('.footer');
        let str2 = this.btnpos;

        for (let i = 0; i < arr2.length; i++) {
            const element = arr2[i];
            element.style = str2;
        }
    }

    handlenewCSS(event) {
        try {
            this.fcss = event.detail;


            let array = this.template.querySelectorAll('c-quickformfieldcomponent');

            let str = '';
            if (this.fcss == undefined || this.fcss == null || this.fcss == '') {
                str = this.getFieldCSS1;
            } else {
                str = this.fcss;
            }

            for (let i = 0; i < array.length; i++) {
                const element = array[i];
                element.FieldCSSUpdate(str);
            }
        } catch (error) {

            this.spinnerDataTable = false;
        }
    }


    handleActive(event) {
        this.tab = event.currentTarget.dataset.title;
        var divid = '.' + event.currentTarget.dataset.title;

        var allDiv = this.template.querySelectorAll('.image-tab');

        for (var i = 0; i < allDiv.length; i++) {
            allDiv[i].style = 'background-color:none';
        }
        var Div = this.template.querySelector(divid);

        Div.style = 'background-color: #8EBFF0;padding: 12%;border-radius: 50%;';



        if (event.currentTarget.dataset.title == 'tab-1') {

            let cmpDef = {
                componentDef: "c:qf_home",
            };
            let encodedDef = btoa(JSON.stringify(cmpDef));

            this[NavigationMixin.Navigate]({
                type: "standard__webPage",
                attributes: {
                    url: "/one/one.app#" + encodedDef
                }
            });
        } else if (event.currentTarget.dataset.title == 'tab-2' || event.currentTarget.dataset.title == 'tab-3') {


            if (event.currentTarget.dataset.title == 'tab-2') {
                if (this.fieldvalidationdiv == true) {
                    this.template.querySelector('.fieldvalidationdiv').style = "display:none;";
                    this.fieldvalidationdiv = false;
                }
                if (this.activesidebar == false) {
                    this.spinnerDataTable = true;
                }
                this.activeDropZone = true

                this.activesidebar = true;
                this.activeDesignsidebar = false;
                this.activeNotification = false;
                this.activethankyou = false;

            } else if (event.currentTarget.dataset.title == 'tab-3') {
                if (this.fieldvalidationdiv == true) {
                    this.template.querySelector('.fieldvalidationdiv').style = "display:none;";
                    this.fieldvalidationdiv = false;
                }
                this.activeDesignsidebar = true;
                this.activesidebar = false;
                this.activeNotification = false;
                this.activethankyou = false;
                this.activeDropZone = true;
            }



            this.activepreview = false;
            this.activeqf_publish = false;
            this.activeDropZone = true;

        } else if (event.currentTarget.dataset.title == 'tab-4') {

            this.fieldvalidationdiv = false;
            this.activeDesignsidebar = false;
            this.activesidebar = false;
            this.activeDropZone = false;
            this.activeNotification = true;
            this.activethankyou = false;
            this.activepreview = false;
            this.activeqf_publish = false;
        } else if (event.currentTarget.dataset.title == 'tab-5') {
            this.fieldvalidationdiv = false;
            this.activeDesignsidebar = false;
            this.activesidebar = false;
            this.activeDropZone = false;
            this.activeNotification = false;
            this.activethankyou = true;
            this.activepreview = false;
            this.activeqf_publish = false;
        } else if (event.currentTarget.dataset.title == 'tab-6') {
            this.fieldvalidationdiv = false;
            this.activeDesignsidebar = false;
            this.activesidebar = false;
            this.activeDropZone = false;
            this.activeNotification = false;
            this.activethankyou = false;
            this.activepreview = false;
            this.activeqf_publish = false;
        } else if (event.currentTarget.dataset.title == 'tab-7') {
            this.fieldvalidationdiv = false;
            this.activepreview = true;
            this.activeqf_publish = false;
            this.activeDesignsidebar = false;
            this.activesidebar = false;
            this.activeDropZone = false;
            this.activeNotification = false;
            this.activethankyou = false;
        } else if (event.currentTarget.dataset.title == 'tab-8') {
            this.fieldvalidationdiv = false;
            this.activeDesignsidebar = false;
            this.activesidebar = false;
            this.activeDropZone = false;
            this.activeNotification = false;
            this.activethankyou = false;
            this.activepreview = false;
            this.activeqf_publish = true;
        } else {
            this.fieldvalidationdiv = false;
            this.activesidebar = false;
            this.activeDropZone = false;
            this.activeDesignsidebar = false;

        }
    }

    dragLeave() {

    }

    onDragOver(event) {
        try {

            event.preventDefault();
        } catch (error) {

            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page';
            this.showerror();
        }
    }

    /***************************************************************
     ** Author             : Nitin
     ** Created Date       : 22/02/2023
     ** Last Modified Date : 22/02/2023
     ** Description        : Used when field is draged for Reordering
     ***************************************************************/
    onDragStart(event) {
        try {
            this.isReorderingDrag = true;

            this.startFielId = event.target.dataset.fieldId;

            event.dataTransfer.setData('fielddivId', JSON.stringify(event.target.dataset));

        } catch (error) {

            this.spinnerDataTable = false;

            this.error_message = 'Something Went Wrong In Form Builder Page';
            this.showerror();
        }
    }

    async onDrop(event) {

        const newdata = event.dataTransfer.getData('fielddivId');
        let myList = JSON.parse(newdata);
        const formId = myList.formId;
        const randomStrin = myList.randomStr;
        if (formId == this.ParentMessage && randomStrin == this.randomString) {
            if (this.isReorderingDrag) {
                this.spinnerDataTable = true;
                var dropFieldId = event.target.dataset.fieldId;
                var dropPageId = event.target.dataset.pageRecord;
                this.isReorderingDrag = false;
                // Checking variable is undefined or not if undifined that it will be replaced with empty string.
                dropFieldId = typeof dropFieldId === 'undefined' ? '' : dropFieldId;
                if (this.activeDesignsidebar == false && this.activesidebar == false) {
                    this.template.querySelector('.fieldvalidationdiv').style = "display:none;";
                    this.reloadform();
                }


                reOrderField({
                        dropFieldId: dropFieldId,
                        currentFieldId: this.startFielId,
                        dropPageId: dropPageId
                    })
                    .then((result) => {

                        this.spinnerDataTable = false;
                        this.setPageField(result);

                    })
                    .catch(e => {

                        this.spinnerDataTable = false;
                        this.error_message = 'Something Went Wrong In Form Builder Page' + e.message;
                        this.showerror();
                    });

            } else {
                this.spinnerDataTable = true;
                let dropzone = this.template.querySelectorAll('.example-dropzone');
                for (let i = 0; i < dropzone.length; i++) {
                    let field = dropzone[i].querySelectorAll('.field');
                    if (field.length == 0) {
                        dropzone[i].style = "opacity:1.0;background-image:none;height:auto";
                    } else {
                        dropzone[i].style = "opacity:1.0";
                    }
                }

                let Fieldid = event.dataTransfer.getData('fielddivId');
                let FieldLabel = JSON.parse(Fieldid);
                var classname = event.target.className;
                var pageIdOfField = '';
                var PageRecordId = event.target.dataset.pageRecord;
                var position = 0;
                var OldFieldSend = false;
                let fieldLabelOfRemovedFeild = FieldLabel.record;
                var object = FieldLabel.name;



                let isPageBreak = false;

                if (FieldLabel.record == 'QFPAGEBREAK') {
                    isPageBreak = true;
                }

                if (classname == 'field') {
                    if (FieldLabel.type == 'field') {
                        OldFieldSend = true;

                        pageIdOfField = FieldLabel.PageId;
                        position = event.target.dataset.orderId - 1;

                    } else {
                        position = event.target.dataset.orderId;
                    }

                }

                if (classname == '') {
                    classname = event.target.parentElement.className;
                    PageRecordId = event.target.parentElement.dataset.pageRecord;
                    if (FieldLabel.type == 'field') {
                        OldFieldSend = true;
                        pageIdOfField = FieldLabel.PageId;

                        position = event.target.parentElement.dataset.orderId - 1;

                    } else {
                        position = event.target.parentElement.dataset.orderId;
                    }


                }


                var FieldName = FieldLabel.record;


                if (FieldLabel.type != 'Extra' && FieldLabel.type != 'field') {
                    FieldName = FieldName + ',' + FieldLabel.type;

                }

                if (FieldLabel.type == 'Extra') {

                    this.checkCount(FieldName);

                    FieldName = FieldName + ',' + FieldLabel.type + ',' + this.count;




                }


                if (isPageBreak) {
                    dropFieldId = event.target.dataset.fieldId;

                    dropFieldId = typeof dropFieldId === 'undefined' ? '' : dropFieldId;


                    await this.makePageBreak(FieldName, PageRecordId, position, dropFieldId);
                } else {
                    await this.SaveFields(FieldName, PageRecordId, position, OldFieldSend, pageIdOfField, fieldLabelOfRemovedFeild, object);


                }
                this.spinnerDataTable = false;

            }

        }

    }

    async makePageBreak(FieldName, pageId, position, dropFieldId) {
        try {

            addPageBreak({
                    FormId: this.ParentMessage,
                    Name: FieldName,
                    Position: position,
                    Form_Page_Id: pageId,
                    dropFieldId: dropFieldId
                })
                .then(result => {
                    this.FieldList = result.fieldList;

                    this.PageList = result.pageList;
                    this.setPageField(result.fieldList);
                })
                .catch(e => {

                    this.spinnerDataTable = false;
                    this.error_message = 'Something Went Wrong In Form Builder Page' + e.message;
                    this.showerror();
                })
        } catch (error) {

            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page';
            this.showerror();
        }

    }


    async SaveFields(FieldName, pageId, position, OldFieldSend, fieldPageId, fieldlabelname, object) {


        CreateFieldRecord({
            Form_Id: this.ParentMessage,
            Name: FieldName,
            Form_Page_Id: pageId,
            Field_Page_Id: fieldPageId,
            Position: position,
            isold: OldFieldSend,
            obj: object
        }).then(result => {
            this.FieldList = result;
            this.setPageField(result);

        }).catch(e => {

            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page' + e.message;
            this.showerror();
        });

        let fielddetail = [];
        fielddetail.push({
            Name: fieldlabelname,
            Object: object
        });

        this.template.querySelector("c-fields-section-component").removeField(fielddetail[0]);

    }

    passToParent(event) {
        if (event.detail == true) {

            let dropzone = this.template.querySelectorAll('.example-dropzone');
            for (let i = 0; i < dropzone.length; i++) {
                let field = dropzone[i].querySelectorAll('.field');
                if (field.length <= 0) {
                    dropzone[i].style = "background-image: url('/resource/dropHere');background-size: contain;background-repeat: no-repeat;height:160px; weight:300px !important;";
                } else {
                    dropzone[i].style = "opacity:0.4";
                }
            }
        } else {

            let dropzone = this.template.querySelectorAll('.example-dropzone');
            for (let i = 0; i < dropzone.length; i++) {
                let field = dropzone[i].querySelectorAll('.field');
                if (field.length == 0) {

                    dropzone[i].style = 'background-image:none;height:auto;opacity:1.0';
                } else {
                    dropzone[i].style = "opacity:1.0";
                }
            }
        }
    }


    setPageField(fieldList) {
        try {

            let outerlist = [];
            let isIndexZero = false;
            let islast = false;
            let isnotlast = false;
            for (let i = 0; i < this.PageList.length; i++) {
                let innerlist = [];
                if (i == 0) {
                    isIndexZero = true;
                } else if (i == this.PageList.length - 1) {
                    islast = true;
                } else if (i != this.PageList.length - 1) {
                    isnotlast = true;
                }
                for (let j = 0; j < fieldList.length; j++) {
                    if (this.PageList[i].Id == fieldList[j].Form_Page__c) {
                        this.objname = fieldList[j].Mapped_Obj__c;
                        let fieldofObj = fieldList[j].Name.split(',');
                        let fieldtype;
                        if (fieldofObj[1] == 'Extra') {
                            fieldtype = false;
                        } else {
                            fieldtype = true;
                        }
                        if (fieldofObj.length == 2) {

                            if (fieldofObj[1] != 'Extra' && fieldofObj[1] != undefined && fieldofObj[1] != 'undefined') {
                                this.removeObjFields.push({
                                    Name: fieldofObj[0],
                                    Object: this.objname
                                });
                            }
                        }

                        for (let index = 0; index < this.removeObjFields.length; index++) {
                            if (this.activeDesignsidebar == true) {
                                this.activesidebar = true;
                                this.activeDesignsidebar = false;
                                var Div = this.template.querySelector('.tab-2');
                                Div.style = 'background-color: #8EBFF0;padding: 12%;border-radius: 50%;';
                                var Div2 = this.template.querySelector('.tab-3');
                                Div2.style = 'background-color: none';
                                setTimeout(() => {
                                    this.template.querySelector('c-fields-section-component').removeField(this.removeObjFields[index]);
                                }, 2000);

                            }
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

                        if (fieldList[j].Field_Validations__c) {
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
                                Richtext: Richtext
                            });
                        }
                        innerlist.push(fieldList[j]);
                    }
                }

                let temp = {
                    pageName: this.PageList[i].Name,
                    pageId: this.PageList[i].Id,
                    isIndexZero: isIndexZero,
                    isIndexLast: islast,
                    isIndexIsNotLast: isnotlast,
                    FieldData: innerlist
                };
                isIndexZero = false;
                islast = false;
                isnotlast = false;
                outerlist.push(temp);
            }
            this.MainList = outerlist;
        } catch (error) {

            this.spinnerDataTable = false;
        }

    }

    tempararyfun() {
        for (let i = 0; i < this.removeObjFields.length; i++) {

            this.template.querySelector("c-fields-section-component").removeField(this.removeObjFields[i]);
        }
    }

    checkCount(fieldname) {

        let fieldAttributeList = [];
        let count1 = 0;
        for (let i = 0; i < this.FieldList.length; i++) {
            var tmmp = this.FieldList[i].Name;
            fieldAttributeList = tmmp.split(',');
            if (fieldAttributeList.length == 3) {

                if (fieldAttributeList[0] == fieldname) {
                    count1 = count1 + 1;
                }
            }
        }

        this.count = count1;
    }

    editPageName(event) {
        this.newFormName = event.currentTarget.dataset.record;


        this.template.querySelector("div[data-record-id =" + event.currentTarget.dataset.id + "]").style.display = 'none';
        this.template.querySelector("div[data-name =" + event.currentTarget.dataset.id + "]").style.display = 'flex';
        event.stopPropagation();
        return false;
    }

    renameForm(event) {

        this.template.querySelector("div[data-record-id =" + event.currentTarget.dataset.id + "]").style.display = 'block';

        this.template.querySelector("div[data-name =" + event.currentTarget.dataset.id + "]").style.display = 'none';

        if (this.newFormName.length > 0 && this.newFormName.replaceAll(' ', '').length > 0) {
            renameform({
                id: event.currentTarget.dataset.id,
                rename: this.newFormName,
                FormId: this.ParentMessage
            }).then(result => {
                this.FieldList = result.fieldList;

                this.PageList = result.pageList;
                this.setPageField(result.fieldList);


            }).catch(e => {

                this.error_message = 'Something Went Wrong In Form Builder Page' + e.message;
                this.showerror();
                this.spinnerDataTable = false;
            })
        }
    }

    rename(event) {

        this.newFormName = event.target.value;
    }

    cancleRenameForm(event) {

        this.template.querySelector("div[data-record-id =" + event.currentTarget.dataset.id + "]").style.display = 'block';
        this.template.querySelector("div[data-name =" + event.currentTarget.dataset.id + "]").style.display = 'none';
    }

    handleeditForm() {
        this.isModalOpen = true;
        formdetails({
            id: this.ParentMessage
        }).then(result => {
            this.FormDetails = result;
            if (this.FormDetails.Name != null) {
                this.formtitle = this.FormDetails.Name;
                this.FormNamevalue = this.FormDetails.Name;
            }
            if (this.FormDetails.hasOwnProperty.call(this.FormDetails, "Captcha_Type__c")) {
                this.captchTypeparent = this.FormDetails.Captcha_Type__c;
                if (this.captchTypeparent == 'None') {
                    this.testtest = true;
                    this.ct = false;
                }
                this.template.querySelector('c-captcha-type').preview_chptchatype(this.captchTypeparent);
            } else {
                this.captchTypeparent = 'None';
                if (this.captchTypeparent == 'None') {
                    this.testtest = true;
                    this.ct = false;
                }
            }

            if (this.FormDetails.hasOwnProperty.call(this.FormDetails, "Progress_Indicator__c")) {
                this.Progressbarvalue = this.FormDetails.Progress_Indicator__c;
                if (this.Progressbarvalue == 'None') {
                    this.ispreview_show_msg = true;
                    this.pi = false;
                } else {
                    this.template.querySelector('c-progress-indicator').tesmethod(this.Progressbarvalue);
                }
            } else {
                this.Progressbarvalue = 'None';
            }
            if (this.FormDetails.hasOwnProperty.call(this.FormDetails, "Form_Description__c")) {
                this.description = this.FormDetails.Form_Description__c;
            }
        }).catch(e => {
            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page' + e.message;
        })
    }


    handleAddPage() {
        try {
            this.isModalOpen1 = true;
        } catch (error) {

            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page';
            this.showerror();
        }
    }


    openmodal2(event) {

        this.isModalOpen2 = true;

        this.IdId = event.currentTarget.dataset.id;
        pageDetails({
            FormId: this.ParentMessage,
            PageId: event.currentTarget.dataset.id
        }).then(result => {

            this.PageDetails = result;

            if (this.PageDetails.Name != null) {
                this.pagetitle2 = this.PageDetails.Name;

            }
            if (this.PageDetails.hasOwnProperty.call(this.PageDetails, "Page_Number__c")) {

                this.pagenumber2 = this.PageDetails.Page_Number__c;
                this.pageeeee = this.PageDetails.Page_Number__c;

            }
        }).catch(() => {

            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page';
            this.showerror();
        })
    }

    changePageTitle(event) {
        this.pagetitle = event.target.value;

    }

    changePageTitle2(event) {

        this.pagetitle2 = event.target.value;

    }

    changePageNo(event) {
        let value = parseInt(event.target.value);
        if (value <= 0) {
            let nameCmp1 = this.template.querySelector(".rkerrorclass");
            nameCmp1.setCustomValidity("Please enter a value greater than zero");
        } else {
            this.pagenumber = value;
            let nameCmp2 = this.template.querySelector(".rkerrorclass");
            nameCmp2.setCustomValidity("");
        }
    }

    changePageNo2(event) {
        this.pagenumber2 = event.target.value;

    }

    handleeditPage() {

        if (this.pagenumber2 < this.pageeeee) {
            this.pagenumber2 = this.pagenumber2 - 1;
        }
        updatePage({
            formId: this.ParentMessage,
            pageId: this.IdId,
            pageTitle: this.pagetitle2,
            pageNumber: this.pagenumber2
        }).then(result => {
            this.FieldList = result.fieldList;
            this.PageList = result.pageList;
            this.setPageField(result.fieldList);
            let toast_error_msg = 'Form Page is updated Successfully';
            this.error_toast = true;
            this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);
        }).catch(() => {

            this.spinnerDataTable = false;
            let toast_error_msg = 'Error while updating in the form page, Please try again later';
            this.error_toast = true;
            this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
        })
        this.isModalOpen2 = false;
    }

    handleValidation() {
        let nameCmp = this.template.querySelector(".nameCls");


        let FName = nameCmp.value;
        if (!nameCmp.value || nameCmp.value.trim().length == 0) {

            nameCmp.setCustomValidity("Form Title is required");
        } else if (FName.length >= 80) {
            nameCmp.setCustomValidity("Input must be no longer than 80 characters.");
        } else {
            nameCmp.setCustomValidity(""); // clear previous value
            this.submitDetails();
        }
        nameCmp.reportValidity();
    }

    handleValidation1() {
        try {
            let nameCmp1 = this.template.querySelector(".nameCls1");
            let nameCmp2 = this.template.querySelector(".rkerrorclass");
            if (!nameCmp1.value || nameCmp1.value.trim().length == 0) {
                nameCmp1.setCustomValidity("Page Title is required");
            } else {
                nameCmp1.setCustomValidity(""); // clear previous value

                if (!(nameCmp2.value != '' && nameCmp2.value != null && nameCmp2.value != undefined && nameCmp2.value <= 0)) {
                    nameCmp2.setCustomValidity("");
                    this.handlecreatePage();
                }
            }
            nameCmp1.reportValidity();
        } catch (error) {
            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page';
            this.showerror();
        }
    }

    handleValidation2() {
        let nameCmp1 = this.template.querySelector(".nameCls2");
        let nameCmp2 = this.template.querySelector(".rkerrorclass1");
        if (!nameCmp1.value || nameCmp1.value.trim().length == 0) {
            nameCmp1.setCustomValidity("Page Title is required");
        } else {
            nameCmp1.setCustomValidity(""); // clear previous value            

            if (nameCmp2.value != '' && nameCmp2.value != null && nameCmp2.value != undefined && nameCmp2.value <= 0) {
                nameCmp2.setCustomValidity("Please enter a value greater than zero");
            } else {
                nameCmp2.setCustomValidity("");
                this.handleeditPage();
            }
        }
        nameCmp2.reportValidity();
    }

    handlecreatePage() {
        this.spinnerDataTable = true;
        try {
            createPage({
                pageNumber: this.pagenumber,
                totalPages: this.PageList.length,
                formId: this.ParentMessage,
                pagename: this.pagetitle
            }).then(result => {
                this.FieldList = result.fieldList;
                this.PageList = result.pageList;
                this.setPageField(result.fieldList);
                let toast_error_msg = 'Form Page is created Successfully';
                this.spinnerDataTable = false;
                this.error_toast = true;
                this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);
            }).catch(e => {
                let toast_error_msg = 'Error while creating page, Please try again later' + e.message;
                this.error_toast = true;
                this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
            })
            this.isModalOpen1 = false;
            this.handleModalClose();

        } catch (error) {

            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page';
            this.showerror();
        }
    }
    handleModalClose() {
        this.pagetitle = '';
        this.pagenumber = null;
    }

    closeModal1() {
        this.isModalOpen1 = false;
        this.handleModalClose();
    }

    closeModal2() {
        this.isModalOpen2 = false;
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


    changeFormTitle(event) {
        this.formtitle = event.target.value;

        this.isModalOpen_2 = false;
    }

    changeDescription(event) {
        this.description = event.target.value;


    }

    changeProgressIndicator(event) {
        try {
            this.Progressbarvalue = event.detail.value;
            if (this.Progressbarvalue == 'None') {
                this.ispreview_show_msg = true;
                this.pi = false;
            } else {
                this.ispreview_show_msg = false;
                this.pi = true;
                this.template.querySelector('c-progress-indicator').tesmethod(this.Progressbarvalue);
            }
        } catch (error) {
            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page';
        }
    }

    changeCaptchaType(event) {
        try {
            this.captchTypeparent = event.detail.value;

            if (this.captchTypeparent == 'None') {
                this.testtest = true;
                this.ct = false;
            } else {
                this.testtest = false;
                this.ct = true;
                this.template.querySelector('c-captcha-type').preview_chptchatype(this.captchTypeparent);
            }

        } catch (error) {
            this.spinnerDataTable = false;
            this.error_message = 'Something Went Wrong In Form Builder Page';
        }

    }

    @wire(Objects_Type, {})
    WiredObjects_Type_2({
        error,
        data
    }) {

        if (data) {

            try {
                this.l_All_Types = data;
                let options = [];

                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({
                        sr: data[key].sr__c,
                        label: data[key].Label,
                        value: data[key].DeveloperName
                    });

                    // Here Name and Id are fields from sObject list.
                }
                this.TypeOptions = options;


            } catch (error) {

                this.error_message = 'Something Went Wrong In Form Builder Page';
                this.showerror();
            }
        } else if (error) {

            this.error_message = 'Something Went Wrong In Form Builder Page';
            this.showerror();
            this.spinnerDataTable = false;
        }

    }

    @wire(Objects_Type_2, {})
    WiredObjects_Type({
        error,
        data
    }) {

        if (data) {


            try {
                this.l_All_Types_2 = data;

                let options_2 = [];

                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options_2.push({
                        sr: data[key].sr__c,
                        label: data[key].Label,
                        value: data[key].DeveloperName
                    });

                    // Here Name and Id are fields from sObject list.
                }

                this.TypeOptions_2 = options_2;


            } catch (error) {

                this.error_message = 'Something Went Wrong In Form Builder Page';
                this.showerror();
                this.spinnerDataTable = false;
            }
        } else if (error) {

            this.error_message = 'Something Went Wrong In Form Builder Page';
            this.showerror();
            this.spinnerDataTable = false;
        }

    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing

        this.FormNamevalue = this.formtitle;
        editFormSubmit({
            id: this.ParentMessage,
            name: this.formtitle,
            progressIn: this.Progressbarvalue,
            captcha: this.captchTypeparent
        }).then(() => {

            let toast_error_msg = 'Form Changes Done Successfully';
            this.error_toast = true;
            this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);

        }).catch(() => {

            this.spinnerDataTable = false;
            let toast_error_msg = 'Error while changes in the form, Please try again later';
            this.error_toast = true;
            this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
        });
        this.isModalOpen = false;
    }

    openfieldvalidation(event) {
        this.fieldId = event.currentTarget.dataset.id;
        this.fieldName = event.currentTarget.dataset.fieldName;
        this.activesidebar = false;
        this.activeDesignsidebar = false
        this.fieldvalidationdiv = true;
        this.template.querySelector('.fieldvalidationdiv').style = "display:block;";
        var array = this.template.querySelectorAll('.field');
        for (let index = 0; index < array.length; index++) {
            const element = array[index];
            if (event.currentTarget.dataset.id == element.dataset.id) {
                element.style = "background-color:rgba(210,201,201,0.4); border-radius:4px";
            } else {
                element.style = "background-color:none;";
            }
        }
        this.template.querySelector('c-field-validation').openvalidation(this.tab, this.fieldId, this.fieldName);
    }

    closevalidation(event) {
        this.spinnerDataTable = true;
        this.tab = event.detail;
        this.activeDesignsidebar = false;
        this.activeNotification = false;
        this.activethankyou = false;
        this.fieldvalidationdiv = false;
        this.reloadform();
        if (this.tab == 'tab-2') {
            this.activesidebar = true;
        } else if (this.tab == 'tab-3') {
            this.activeDesignsidebar = true;
        }
        this.template.querySelector('.fieldvalidationdiv').style = "display:none;";
        var array = this.template.querySelectorAll('.field');
        for (let index = 0; index < array.length; index++) {
            const element = array[index];
            element.style = "background-color:none;";
        }
        this.spinnerDataTable = false;
    }

    afterfielddelete() {
        let cmpDef = {
            componentDef: "c:formBuilder",
            attributes: {
                ParentMessage: this.ParentMessage != "" ? this.ParentMessage : "No Record Created",
                FormName: this.FormNamevalue != "" ? this.FormNamevalue : "No Name Given"
            }
        };
        let encodedDef = btoa(JSON.stringify(cmpDef));
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: "/one/one.app#" + encodedDef
            }
        });

    }

    bin = iconsZip + '/Iconfolder/bin.png';
    deletepopup = false;
    pageIds;

    handleDeleteAction(event) {
        this.pageIds = event.currentTarget.dataset.record;
        this.deletepopup = true;
    }

    deleteyes() {
        this.spinnerDataTable = true;
        if (this.PageList.length > 1) {
            this.deletepopup = false;
            deletePage({
                FormId: this.ParentMessage,
                PageId: this.pageIds
            }).then(result => {
                this.spinnerDataTable = false;
                this.FieldList = result.fieldList;
                var pagelength = result.pageList.length == this.PageList.length;
                this.PageList = result.pageList;
                this.setPageField(result.fieldList);
                if (pagelength) {
                    let toast_error_msg = 'You cannot delete the page.';
                    this.error_toast = true;
                    this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
                } else {
                    let toast_error_msg = 'Page is deleted successfully.';
                    this.error_toast = true;
                    this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);
                }
            }).catch(e => {
                this.spinnerDataTable = false;
                this.error_message = 'Something Went Wrong In Form Builder Page' + e.message;
                this.showerror();
            })
        } else {
            this.spinnerDataTable = false;
            this.deletepopup = false;
            let toast_error_msg = 'A Form must contain atleast one page.';
            this.error_toast = true;
            this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
        }
    }

    deleteno() {
        this.deletepopup = false;
        this.error_toast = false;
    }

    errorpopupcall() {
        location.reload();
    }

    @api showerror() {
        this.error_popup1 = true;

        let errordata = {
            header_type: 'Form Builder ',
            Message: this.error_message
        };
        this.showerrorpopup({
            detail: errordata
        })
    }

    @api showerrorpopup(event) {
        this.error_popup1 = true;
        var mess = event.detail.Message;
        var type = event.detail.header_type;
        var child = this.template.querySelector('.errorpopup_class');
        child.errormessagee(type, mess);
    }

    generateRandomString() {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let randomString = '';
        for (let i = 0; i < 15; i++) {
            randomString += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return randomString;
    }

    @api
    getrequestforcloserefencefield(){
        try {
            var quickfields = this.template.querySelectorAll('c-quickformfieldcomponent');
            for (let index = 0; index < quickfields.length; index++) {
                const element = quickfields[index];
                element.changeMessage();
            }
        } catch (error) {
            console.error(error.message);
        }
        
    }

}