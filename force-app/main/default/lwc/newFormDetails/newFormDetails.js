import {
    LightningElement,
    track,
    wire,
} from 'lwc';
import getProgressindicator from '@salesforce/apex/QuickFormHome.getProgressindicator';
import Objects_Type from "@salesforce/apex/QuickFormHome.f_Get_Types";
import getCaptchatype from '@salesforce/apex/QuickFormHome.getCaptchatype';
import Objects_Type_2 from "@salesforce/apex/QuickFormHome.Get_Captcha_Types";
import ParentObject from '@salesforce/apex/objectSelection.fetchParentObject';
import section_One from '@salesforce/resourceUrl/Section1';
import section_Two from '@salesforce/resourceUrl/Section2';
import section_Three from '@salesforce/resourceUrl/Section3';
import ParentObjectTemp2 from '@salesforce/apex/objectSelection.temp2';
import ParentObjectTemp3 from '@salesforce/apex/objectSelection.temp3';
import fetchChildObject from '@salesforce/apex/objectSelection.fetchChildObject';
import saveMapped_object from '@salesforce/apex/objectSelection.saveMapped_object';
import { NavigationMixin } from "lightning/navigation";
import { loadStyle } from 'lightning/platformResourceLoader';
import selectobject_dropdown from '@salesforce/resourceUrl/selectobject_dropdown';


export default class NewFormDetails extends NavigationMixin(LightningElement) {
    @track isModalOpen_3 = false;
    @track isModalOpen_2 = false;
    @track isModalOpen = true;
    @track progressindicator;
    @track formdetails = true;
    @track objectselection = false;
    @wire(getProgressindicator) records;
    @wire(getCaptchatype) captcharecords;
    @track formtitle;
    @track ispreview_show_msg_captcha = true;
    @track ispreview_show_msg = false;
    @track testtest = false;
    @track pi = true;
    @track ct = true;
    @track l_All_Types;
    @track TypeOptions;
    @track description;

    @track l_All_Types_2;
    @track TypeOptions_2;
    @track Progressbarvalue = 'Standard_Steps';
    @track captchTypeparent = 'Normal_Captcha';

    global_options = [];

    section_One_img = section_One;
    section_Two_img = section_Two;
    section_Three_img = section_Three;
    @track isselect_msg = true;
    @track popup_2 = false;
    @track temp_One = false;
    @track temp_Two = false;
    @track temp_Third = false;
    @track errorModal = false;
    @track tamplate = '';
    value1 = ''
    value2 = ''
    value3 = ''
    options_object1 = [];
    options_object2 = [];
    options_object2_2 = [];
    spinnerDataTable = true;
    toast_error_msg = 'Please Enter Form Title';
    @track temp1;
    @track temp2;
    recordid;
    saveerror = false;
    objecterror = false;
    @track sec_obj_error = false;
    @track tep3_sec_obj_error_2 = false;

    @track message;
    @track sameobjecterror = false;

    connectedCallback() {
        this.spinnerDataTable = true;
        this.global_options = [];
        this.getParentObject();

    }
    renderedCallback() {
        try {
            Promise.all([
                loadStyle(this, selectobject_dropdown)
            ]).then(() => { })
                .catch(() => {
                    this.message = 'Something Went Wrong In New Form Detail Page';
                    this.showerror();
                });
        } catch (error) {
            console.log(error);
        }
    }

    @wire(Objects_Type, {})
    WiredObjects_Type_2({
        error,
        data
    }) {
        this.spinnerDataTable = true;
        if (data) {
            try {
                this.l_All_Types = data;
                let options = [];

                for (var key in data) {
                    options.push({
                        sr: data[key].sr__c,
                        label: data[key].Label,
                        value: data[key].DeveloperName
                    });
                }
                this.TypeOptions = options.sort(
                    (teamA, teamB) => teamA.sr - teamB.sr,
                )


            } catch (error) {
                this.message = 'Something Went Wrong In NewFormDetails';
                this.showerror();
            }
        } else if (error) {
            this.message = 'Something Went Wrong In Form BUilder Page';
            this.showerror();
        }
        this.spinnerDataTable = false;
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
                    options_2.push({
                        sr: data[key].sr__c,
                        label: data[key].Label,
                        value: data[key].DeveloperName
                    });
                }
                this.TypeOptions_2 = options_2.sort(
                    (teamA, teamB) => teamA.sr - teamB.sr,
                )
            } catch (error) {
                this.spinnerDataTable = false;
                this.message = 'Something Went Wrong In NewFormDetails';
                this.showerror();
            }
        } else if (error) {
            this.spinnerDataTable = false;
            this.message = 'Something Went Wrong In Form BUilder Page';
            this.showerror();
        }

    }

    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        try {
            this.dispatchEvent(new CustomEvent('popupclose'));
        } catch (error) {
            console.log(error);
        }
    }
    submitDetails() {
        try {
            this.dispatchEvent(new CustomEvent('popupclose'));
        } catch (error) {
            console.log(error);
        }
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
                this.spinnerDataTable = true;
                this.ispreview_show_msg = true;
                this.pi = false;
                this.spinnerDataTable = false;
            } else {
                this.spinnerDataTable = true;
                this.ispreview_show_msg = false;
                this.pi = true;
                this.template.querySelector('c-progress-indicator').tesmethod(this.Progressbarvalue);
                this.spinnerDataTable = false;
            }

        } catch (error) {
            this.spinnerDataTable = false;
            this.message = 'Something Went Wrong In NewFormDetails';
            this.showerror();
        }
    }

    changeCaptchaType(event) {
        try {
            this.captchTypeparent = event.detail.value;
            if (this.captchTypeparent == 'None') {
                this.spinnerDataTable = true;
                this.testtest = true;
                this.ct = false;
                this.spinnerDataTable = false;
            } else {
                this.spinnerDataTable = true;
                this.testtest = false;
                this.ct = true;
                this.template.querySelector('c-captcha-type').error_msg();
                this.template.querySelector('c-captcha-type').preview_chptchatype(this.captchTypeparent);
                this.spinnerDataTable = false;
            }

        } catch (error) {
            this.spinnerDataTable = false;
            this.message = 'Something Went Wrong In NewFormDetails';
            this.showerror();
        }

    }

    handleValidation() {
        try {
            let nameCmp = this.template.querySelector(".nameCls");
            let fName = nameCmp.value;
            if (!nameCmp.value || nameCmp.value.trim().length == 0) {
                nameCmp.setCustomValidity("Form Title is required");
            } else if (fName.length >= 80) {
                nameCmp.setCustomValidity("Input must be no longer than 80 characters.");
            } else {
                nameCmp.setCustomValidity("");
                this.formdetails = false;
                this.objectselection = true;
            }
            nameCmp.reportValidity();
        } catch (error) {
            console.log(error);
        }
    }
    handleFocus() {
        try {
            let nameCmp = this.template.querySelector(".nameCls");
            nameCmp.setCustomValidity("");
        } catch (error) {
            console.log(error);
        }
    }
    next_bt() {
        try {
            if (this.formtitle != '' && this.formtitle != null) {
                if (this.formtitle.length > 0 && this.formtitle.replaceAll(' ', '').length > 0) {
                    this.formdetails = false;
                    this.objectselection = true;
                } else {
                    this.isModalOpen_2 = true;
                    this.template.querySelector('c-toast-component').showToast('error', this.toast_error_msg, 3000);
                }

            } else {
                this.isModalOpen_2 = true;
                this.template.querySelector('c-toast-component').showToast('error', this.toast_error_msg, 3000);
            }
        } catch (error) {
            console.log(error);
        }
    }
    Previouus_bt() {
        this.tep3_sec_obj_error_2 = false;
        this.sec_obj_error = false;
        this.formdetails = true;
        this.objectselection = false;
    }

    getParentObject() {
        try {
            ParentObject()
                .then(result => {
                    this.global_options = result
                    this.spinnerDataTable = false;
                })
                .catch(() => {
                    this.spinnerDataTable = false;
                    this.message = 'Something Went Wrong In NewFormDetails';
                    this.showerror();
                })
        } catch (error) {
            console.log(error);
        }
    }

    selcel_object_errormsg() {
        if (this.value1 == '') {
            this.sec_obj_error = true;
            this.tep3_sec_obj_error_2 = false;
        }
    }
    tep3_selcel_object_errormsg_2() {
        if (this.value1 == '') {
            this.sec_obj_error = false;
            this.tep3_sec_obj_error_2 = true;
        }

    }

    firstTemp() {
        try {
            this.value1 = '';
            this.value2 = '';
            this.value3 = '';
            this.options_object1 = [];
            this.options_object2 = [];
            this.options_object2_2 = [];
            this.temp_One = true;
            this.temp_Two = false;
            this.temp_Third = false;
            this.spinnerDataTable = true;
            this.isselect_msg = false;
            this.popup_2 = true;
            this.sec_obj_error = false;
            this.tep3_sec_obj_error_2 = false;
            this.options_object1 = this.global_options;

            ParentObject()
                .then(result => {
                    let opp = [];
                    for (var i = 0; i < result.length; i++) {
                        opp.push({
                            label: result[i],
                            value: result[i]
                        });
                    }
                    this.options_object1 = opp;
                    this.spinnerDataTable = false;
                })
                .catch(() => {
                    this.spinnerDataTable = false;
                    this.message = 'Something Went Wrong In NewFormDetails';
                    this.showerror();
                })
        } catch (error) {
            console.log(error);
        }
    }

    secondTemp() {
        try {
            this.value1 = '';
            this.value2 = '';
            this.value3 = '';
            this.options_object2 = [];
            this.options_object2_2 = [];
            this.temp_One = false;
            this.temp_Two = true;
            this.temp_Third = false;
            this.spinnerDataTable = true;
            this.isselect_msg = false;
            this.popup_2 = true;
            this.sec_obj_error = false;
            this.tep3_sec_obj_error_2 = false;
            this.options_object1 = this.global_options;
            ParentObjectTemp2({
                parent: this.global_options
            })
                .then(result => {
                    let opp = [];
                    for (var i = 0; i < result.length; i++) {
                        opp.push({
                            label: result[i],
                            value: result[i]
                        });
                    }
                    this.options_object1 = opp;
                    this.spinnerDataTable = false;
                }).catch(() => {
                    this.spinnerDataTable = false;
                    this.message = 'Something Went Wrong In Form BUilder Page';
                    this.showerror();
                })
        } catch (error) {
            console.log(error);
        }
    }

    thirdTemp() {
        try {
            this.value1 = '';
            this.value2 = '';
            this.value3 = '';
            this.options_object2 = [];
            this.options_object2_2 = [];
            this.temp_One = false;
            this.temp_Two = false;
            this.temp_Third = true;
            this.spinnerDataTable = true;
            this.isselect_msg = false;
            this.popup_2 = true;
            this.sec_obj_error = false;
            this.tep3_sec_obj_error_2 = false;
            this.options_object1 = this.global_options;
            ParentObjectTemp3({
                parent: this.global_options
            })
                .then(result => {
                    let opp = [];
                    for (var i = 0; i < result.length; i++) {
                        opp.push({
                            label: result[i],
                            value: result[i]
                        });
                    }
                    this.options_object1 = opp;
                    this.spinnerDataTable = false;
                })
                .catch(() => {
                    this.spinnerDataTable = false;
                    this.message = 'Something Went Wrong In NewFormDetails';
                    this.showerror();
                })
        } catch (error) {
            console.log(error);
        }
    }

    object1(event) {
        try {
            this.sec_obj_error = false;
            this.tep3_sec_obj_error_2 = false;
            this.value1 = event.detail.value;
            this.spinnerDataTable = true;
            if (this.value1 != '') {

                fetchChildObject({
                    parent: this.value1
                })
                    .then(result => {
                        this.value2 = null;
                        this.value3 = null;
                        let opp = [];
                        for (var i = 0; i < result.length; i++) {
                            opp.push({
                                label: result[i],
                                value: result[i]
                            });
                        }
                        this.options_object2 = opp;
                        this.options_object2_2 = opp;
                        this.spinnerDataTable = false;
                    })
                    .catch(() => {
                        this.spinnerDataTable = false;
                        this.message = 'Something Went Wrong In NewFormDetails';
                        this.showerror();
                    })
            }
        } catch (error) {
            console.log(error);
        }
    }

    object2_1(event) {
        this.value2 = event.detail.value;
        if (this.value2 == this.value3) {
            this.sameobjecterror = true;
        } else {
            this.sameobjecterror = false;
        }
        this.errorModal = false;
    }

    object2_2(event) {
        this.value3 = event.detail.value;
        if (this.value2 == this.value3) {
            this.sameobjecterror = true;
        } else {
            this.sameobjecterror = false;
        }
        this.errorModal = false;
    }

    save() {
        try {
            this.spinnerDataTable = true;
            if (this.temp_One == true || this.temp_Two == true || this.temp_Third == true) {
                if (this.temp_One == true) {
                    if (this.value1 != null && this.value1 != '') {
                        const Mapped_Objects = this.value1;
                        saveMapped_object({
                            Mapped_Objects: Mapped_Objects,
                            FormTitle: this.formtitle,
                            FormDesc: this.description,
                            ProgressIndicator: this.Progressbarvalue,
                            CaptchaType: this.captchTypeparent
                        })
                            .then(result => {
                                this.spinnerDataTable = true;
                                this.recordid = result;
                                let cmpDef = {
                                    componentDef: "c:formBuilder",
                                    attributes: {
                                        ParentMessage: this.recordid != "" ? this.recordid : "No Record Created",
                                        FormName: this.formtitle != "" ? this.formtitle : "No Name"
                                    }
                                };
                                let toast_error_msg_object = 'Your Form is Created Successfully';
                                this.template.querySelector('c-toast-component').showToast('success', toast_error_msg_object, 3000);
                                let encodedDef = btoa(JSON.stringify(cmpDef));

                                this[NavigationMixin.Navigate]({
                                    type: "standard__webPage",
                                    attributes: {
                                        url: "/one/one.app#" + encodedDef
                                    }
                                });
                                this.spinnerDataTable = false;
                                this.dispatchEvent(new CustomEvent('popupclose'));
                            }).catch(() => {
                                this.spinnerDataTable = false;
                                this.message = 'Something Went Wrong In NewFormDetails';
                                this.showerror();
                            });


                    } else {
                        this.spinnerDataTable = false;
                        this.objecterror = false;
                        this.saveerror = true;
                        this.errorModal = true;
                        let toast_error_msg_object = 'Please select the object first';
                        this.template.querySelector('c-toast-component').showToast('error', toast_error_msg_object, 3000);
                    }
                } else if (this.temp_Two == true) {
                    if (this.value1 != null && this.value2 != null && this.value1 != '' && this.valu2 != '') {
                        const Mapped_Objects = this.value1 + ',' + this.value2;
                        saveMapped_object({
                            Mapped_Objects: Mapped_Objects,
                            FormTitle: this.formtitle,
                            FormDesc: this.description,
                            ProgressIndicator: this.Progressbarvalue,
                            CaptchaType: this.captchTypeparent
                        })
                            .then(result => {
                                this.spinnerDataTable = true;
                                this.recordid = result;
                                let cmpDef = {
                                    componentDef: "c:formBuilder",
                                    attributes: {
                                        ParentMessage: this.recordid != "" ? this.recordid : "No Record Created",
                                        FormName: this.formtitle != "" ? this.formtitle : "No Name"
                                    }
                                };
                                let toast_error_msg_object = 'Your Form is Created Successfully';
                                this.template.querySelector('c-toast-component').showToast('success', toast_error_msg_object, 3000);
                                let encodedDef = btoa(JSON.stringify(cmpDef));
                                this[NavigationMixin.Navigate]({
                                    type: "standard__webPage",
                                    attributes: {
                                        url: "/one/one.app#" + encodedDef
                                    }
                                });
                                this.spinnerDataTable = false;
                                this.dispatchEvent(new CustomEvent('popupclose'));
                            }).catch(() => {
                                this.spinnerDataTable = false;
                                this.message = 'Something Went Wrong In NewFormDetails';
                                this.showerror();
                            });

                    } else {
                        this.spinnerDataTable = false;
                        this.objecterror = false;
                        this.saveerror = true;
                        this.errorModal = true;
                        let toast_error_msg_object = 'Please select the object';
                        this.template.querySelector('c-toast-component').showToast('error', toast_error_msg_object, 3000);
                    }

                } else if (this.temp_Third == true) {
                    if (this.sameobjecterror == false) {

                        if (this.value1 != null && this.value2 != null && this.value3 != null && this.value1 != '' && this.value2 != '' && this.value3 != '') {
                            const Mapped_Objects = this.value1 + ',' + this.value2 + ',' + this.value3;
                            saveMapped_object({
                                Mapped_Objects: Mapped_Objects,
                                FormTitle: this.formtitle,
                                FormDesc: this.description,
                                ProgressIndicator: this.Progressbarvalue,
                                CaptchaType: this.captchTypeparent
                            })
                                .then(result => {
                                    this.spinnerDataTable = true;
                                    this.recordid = result;
                                    let cmpDef = {
                                        componentDef: "c:formBuilder",
                                        attributes: {
                                            ParentMessage: this.recordid != "" ? this.recordid : "No Record Created",
                                            FormName: this.formtitle != "" ? this.formtitle : "No Name"
                                        }
                                    };
                                    let toast_error_msg_object = 'Your Form is Created Successfully';
                                    this.template.querySelector('c-toast-component').showToast('success', toast_error_msg_object, 3000);
                                    let encodedDef = btoa(JSON.stringify(cmpDef));
                                    this[NavigationMixin.Navigate]({
                                        type: "standard__webPage",
                                        attributes: {
                                            url: "/one/one.app#" + encodedDef
                                        }
                                    });

                                    this.spinnerDataTable = false;
                                    this.dispatchEvent(new CustomEvent('popupclose'));
                                }).catch(() => {
                                    this.spinnerDataTable = false;
                                    this.message = 'Something Went Wrong In NewFormDetails';
                                    this.showerror();
                                });
                        } else {
                            this.objecterror = false;
                            this.saveerror = true;
                            this.errorModal = true;
                            let toast_error_msg_object = 'Please select the object ';
                            this.template.querySelector('c-toast-component').showToast('error', toast_error_msg_object, 3000);
                            this.spinnerDataTable = false;
                        }
                    } else {
                        this.saveerror = true;
                        this.spinnerDataTable = false;
                        this.errorModal = true;
                        let toast_error_msg_object = 'Please ensure that you choose two distinct objects for your selection.';
                        this.template.querySelector('c-toast-component').showToast('error', toast_error_msg_object, 3000);
                    }
                }
            } else {
                this.spinnerDataTable = false;
                this.isModalOpen_3 = true;
                let toast_error_msg_object = 'Please select the object';
                this.template.querySelector('c-toast-component').showToast('error', toast_error_msg_object, 3000);
            }

        } catch (error) {
            console.log(error);
        }
    }

    closeModalerror() {
        this.isModalOpen = false;
    }
    closeModalerrortoast() {
        this.isModalOpen_2 = false;
    }
    closeerror() {
        this.errorModal = false;
    }

    handleTypeChange(event) {
        this.value = event.detail.value;
    }
    closeModal_2() {
        this.isModalOpen_2 = false;
    }
    errorpopupcall() {
        location.reload();
    }

    showerror() {
        try {
            let errorData = {
                header_type: 'New Form Details Page',
                Message: this.message
            };
            const showPopup = new CustomEvent('showerrorpopup', {
                detail: errorData
            });
            this.dispatchEvent(showPopup);
        } catch (error) {
            console.log(error);
        }
    }

    showerrorpopup(event) {
        this.template.querySelector('c-errorpopup').errormessagee(event.detail.header_type, event.detail.Message);
    }

}