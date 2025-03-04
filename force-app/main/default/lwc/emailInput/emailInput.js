import { LightningElement, track, api } from "lwc";
import { loadStyle } from 'lightning/platformResourceLoader';
import notification_css from '@salesforce/resourceUrl/notification_css';
import search from "@salesforce/apex/EmailClass.search";
export default class EmailInput extends LightningElement {
    @api listto =[];
    @api pillid = 'cc';
    @track email_msg = false;
    @track items = [];
    @track getprogreshbar;
    @track to_list;
    searchTerm = "";
    blurTimeout;
    boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    _selectedValues = [];
    selectedValuesMap = new Map();

    //error_popup
    @api error_popup = false;
    message;

    renderedCallback(){
    
        Promise.all([
            loadStyle( this, notification_css )
            ]).then(() => {
            })
            .catch(error => {
                this.message = 'Something Went Wrong In Email Input Page';
                this.showerror(this.message);
        });
    }
    

    get selectedValues() {
        return this._selectedValues;
    }
    set selectedValues(value) {
        this._selectedValues = value;
        const selectedValuesEvent = new CustomEvent("selection", { detail: { selectedValues: this._selectedValues} });
        this.dispatchEvent(selectedValuesEvent);
    }

    handleInputChange(event) {
        event.preventDefault();
        if (event.target.value.length < 3) {
            return;
        }

        search({ searchString: event.target.value })
            .then((result) => {
                this.items = result;
                if (this.items.length > 0) {
                    this.boxClass =
                        "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open";
                }
            })
            .catch((error) => {
                console.error("Error:", error);
                this.message = 'Something Went Wrong In Email Input Page';
                this.showerror(this.message);
            });
    }

    handleBlur() {
        console.log("In onBlur");
        this.blurTimeout = setTimeout(() => {
            this.boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
            const value = this.template.querySelector('input.input').value
            if (value !== undefined && value != null && value !== "") {
                this.selectedValuesMap.set(value, value);
                this.selectedValues = [...this.selectedValuesMap.keys()];
            }

            this.template.querySelector('input.input').value = "";
        }, 300);
    }

    get hasItems() {
        return this.items.length;
    }

    handleKeyPress(event) {
        if (event.keyCode === 13) {
            event.preventDefault(); // Ensure it is only this code that runs
            const value = this.template.querySelector('lightning-input.input2').value;
        var pattern =/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        var validation = pattern.test(value);

        if (validation == false) {
           this.email_msg = true;
           this.dispatchEvent(new CustomEvent('removeerrormessage'))
        }
        else{
            this.email_msg = false;
            this.selectedValuesMap.set(value, value);
            this.selectedValues = [...this.selectedValuesMap.keys()];
                    

        }

            this.template.querySelector('lightning-input.input2').value = "";
            // var mailformat = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            // if(emailId.value.match(mailformat)){
            //     console.log('OUTPUT : ');
                // if (value !== undefined && value != null && value !== "") {
                //     this.selectedValuesMap.set(value, value);
                //     this.selectedValues = [...this.selectedValuesMap.keys()];
                // }
                // this.template.querySelector('lightning-input.input2').value = "";
            // }
            // else{
            //     alert("Invalid email address.");
            // }
        }
        // else{
        //     const value = this.template.querySelector('lightning-input.input2').value;

        //     this.email_msg = false;
        //     this.selectedValuesMap.set(value, value);
        //     this.selectedValues = [...this.selectedValuesMap.keys()];
        // }
    }

    handleRemove(event) {
        const item = event.target.label;
        this.selectedValuesMap.delete(item);
        this.selectedValues = [...this.selectedValuesMap.keys()];
    }

    onSelect(event) {
        this.template.querySelector('input.input').value = "";
        let ele = event.currentTarget;
        let selectedId = ele.dataset.id;
        let selectedValue = this.items.find((record) => record.Id === selectedId);
        this.selectedValuesMap.set(selectedValue.Email, selectedValue.Name);
        this.selectedValues = [...this.selectedValuesMap.keys()];

        //As a best practise sending selected value to parent and inreturn parent sends the value to @api valueId
        let key = this.uniqueKey;
        const valueSelectedEvent = new CustomEvent("valueselect", {
            detail: { selectedId, key }
        });
        this.dispatchEvent(valueSelectedEvent);

        if (this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    }

    @api reset() {
        this.selectedValuesMap = new Map();
        this.selectedValues = [];
    }

    @api validate() {
        this.template.querySelector('input').reportValidity();
        const isValid = this.template.querySelector('input').checkValidity();
        return isValid;
    }
    @api to_email(strString){
        // console.log('hiii');
        this.getprogreshbar = strString;
        // console.log('this.getprogreshbar>>',this.getprogreshbar);
        this.to_list = this.getprogreshbar.split(',');
            // console.log('to',this.to_list[1]);
            for(var i=0; i<this.to_list.length; i++){
                const value = this.to_list[i];
                // console.log('to :-',value);
                this.selectedValuesMap.set(value, value);
                this.selectedValues = [...this.selectedValuesMap.keys()];
                // this.selectedValues=value;
            }
    }
    @api email_erroe_msg(){
        this.email_msg = false;
    }
    // @api
    // handleValidationtest() {
    //     console.log('u r in chiled');
    //     let input2 = this.template.querySelector(".nameCls");
    //     console.log({input2});
    //         console.log('test for form titel');
    //         input2.setCustomValidity("Form email is required");
    //     input2.reportValidity();
    // }

    errorpopupcall(event){
        location.reload();
    }

    @api showerror(){
        console.log('this.error_popup => ',this.error_popup);
        this.error_popup = true;
        let errordata = {header_type: 'Email input error',Message : this.message};
        const showpopup = new CustomEvent('showerrorpopup',{detail:errordata});
        this.dispatchEvent(showpopup);
    }
    
    showerrorpopup(event){
        console.log('showerrorpopup',event.detail.Message);
        this.template.querySelector('c-errorpopup').errormessagee(event.detail.header_type,event.detail.Message);
    }
}