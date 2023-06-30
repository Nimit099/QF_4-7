import {
    api,
    LightningElement,
    track
} from 'lwc';
import ParentObject from '@salesforce/apex/objectSelection.fetchParentObject';
import section_One from '@salesforce/resourceUrl/Section1';
import section_Two from '@salesforce/resourceUrl/Section2';
import section_Three from '@salesforce/resourceUrl/Section3';
import section_Four from '@salesforce/resourceUrl/Section4';
import section_Five from '@salesforce/resourceUrl/Section5';
import section_Six from '@salesforce/resourceUrl/Section6';
import fetchChildObject1 from '@salesforce/apex/objectSelection.fetchChildObject1';

export default class QfPopUp extends LightningElement {
    section_One_img = section_One;
    section_Two_img = section_Two;
    section_Three_img = section_Three;
    section_Four_img = section_Four;
    section_Five_img = section_Five;
    section_Six_img = section_Six;
    @track temp_One = false;
    @track temp_Two = false;
    @track temp_Third = false;
    value1 = ''
    value2 = ''
    value3 = ''
    @track primaryObject = [];
    @track childObject1 = [];
    @track options_object1 = [];
    @track options_object2 = [];
    @track options_object3 = [];
    @track isModalOpen = false;

    //error_popup
    @api error_popup = false;
    @track error_popup2 = false;
    @track message;

    connectedCallback(){
        this.error_popup2 = this.error_popup
    }

    renderedCallback() {
        ParentObject()
            .then(result => {
                this.primaryObject = result;
            }).catch(error => {
                this.message = 'Something Went Wrong In Popup Page' + error.message;
                this.showerror();
                this.spinnerDataTable = false;
            })
    }

    firstTemp() {
        this.temp_One = true;
        this.temp_Two = false;
        this.temp_Third = false;

        let opp = [];
        for (var i = 0; i < this.primaryObject.length; i++) {
            opp.push({
                label: this.primaryObject[i],
                value: this.primaryObject[i]
            });
        }
        this.options_object1 = opp;
    }

    secondTemp() {
        this.temp_One = false;
        this.temp_Two = true;
        this.temp_Third = false;

        let opp = [];
        for (var i = 0; i < this.primaryObject.length; i++) {
            opp.push({
                label: this.primaryObject[i],
                value: this.primaryObject[i]
            });
        }
        this.options_object1 = opp;

        let opp1 = [];
        for (var j = 0; j < this.childObject1.length; j++) {
            opp1.push({
                label: this.childObject1[j],
                value: this.childObject1[j]
            });
        }
        this.options_object2 = opp1;
    }

    thirdTemp() {
        this.temp_One = false;
        this.temp_Two = false;
        this.temp_Third = true;

        let opp = [];
        for (var i = 0; i < this.primaryObject.length; i++) {
            opp.push({
                label: this.primaryObject[i],
                value: this.primaryObject[i]
            });
        }
        
        let opp1 = [];
        this.options_object2 = opp1;
        for (var j = 0; j < this.childObject1.length; j++) {
            opp1.push({
                label: this.childObject1[j],
                value: this.childObject1[j]
            });
        }
        this.options_object2 = opp1;
    }

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    object1(event) {
        this.value1 = event.detail.value;
        if (this.value1 != '') {
            fetchChildObject1({
                    parent: this.value1
                })
                .then(result => {
                    this.childObject1 = result;
                }).catch(error => {
                    this.message = 'Something Went Wrong In Popup Page' + error.message;
                    this.showerror();
                })
            let opp = [];
            for (var i = 0; i < this.primaryObject.length; i++) {
                opp.push({
                    label: this.primaryObject[i],
                    value: this.primaryObject[i]
                });
            }
            this.options_object1 = opp;
        }
    }
    object2_1(event) {
        this.value2 = event.detail.value;
        if (this.value1 != '') {
            fetchChildObject1({
                    parent: this.value1
                })
                .then(result => {
                    this.childObject1 = result;
                }).catch(error => {
                    this.message = 'Something Went Wrong In Popup Page' + error.message;
                    this.showerror();
                })
            let opp = [];
            for (var i = 0; i < this.primaryObject.length; i++) {
                opp.push({
                    label: this.primaryObject[i],
                    value: this.primaryObject[i]
                });
            }
            this.options_object1 = opp;

            let opp1 = [];
            for (var j = 0; j < this.childObject1.length; j++) {
                opp1.push({
                    label: this.childObject1[j],
                    value: this.childObject1[j]
                });
            }
            this.options_object2 = opp1;
        }
    }
    object2_2(event) {
        this.value3 = event.detail.value;
    }

    errorpopupcall() {
        location.reload();
    }

    @api showerror() {
        this.error_popup2 = true;
        let errordata = {
            header_type: 'Popup Page',
            Message: this.message
        };
        const showpopup = new CustomEvent('showerrorpopup', {
            detail: errordata
        });
        this.dispatchEvent(showpopup);
    }

    showerrorpopup(event) {
        this.template.querySelector('c-errorpopup').errormessagee(event.detail.header_type, event.detail.Message);
    }

}