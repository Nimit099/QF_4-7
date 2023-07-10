import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';
import EmojiRating1 from '@salesforce/resourceUrl/EmojiRating1';
import EmojiRating5 from '@salesforce/resourceUrl/EmojiRating5';
import EmojiRating2 from '@salesforce/resourceUrl/EmojiRating2';
import EmojiRating3 from '@salesforce/resourceUrl/EmojiRating3';
import EmojiRating4 from '@salesforce/resourceUrl/EmojiRating4';
import multiright from '@salesforce/resourceUrl/multiright';
import multileft from '@salesforce/resourceUrl/multileft';
import multitick from '@salesforce/resourceUrl/multitick';
import getScaleRating from '@salesforce/apex/FormBuilderController.getScaleRating';
import getreferencevalue from '@salesforce/apex/FormBuilderController.getreferencevalue';
import getpicklistvalue from '@salesforce/apex/FormBuilderController.getpicklistvalue';
import blackcross from '@salesforce/resourceUrl/blackcross';
import QuickBot_Cross from '@salesforce/resourceUrl/QuickBot_Cross';
import groupRadio from '@salesforce/resourceUrl/groupRadio'
import helptextcss from '@salesforce/resourceUrl/helptextcss'
import {
    loadStyle
} from 'lightning/platformResourceLoader';

let isDownFlag,
    isDotFlag = false,
    prevX = 0,
    currX = 0,
    prevY = 0,
    currY = 0;

let x = "#0000A0"; //blue color
let y = 1.5; //weight of line width and dot.       

let canvasElement, ctx; //storing canvas context
// let dataURL, convertedDataURI; //holds image data


export default class Quickformfieldcomponent extends LightningElement {
    Cross = QuickBot_Cross;
    messageContext
    message;

    @api isFieldView;
    @api isPreviewView;
    @api filesignread;
    @api submit;
    // icons'
    multiright = multiright;
    multileft = multileft;
    multitick = multitick;
    emojiRating1 = EmojiRating1;
    emojiRating2 = EmojiRating2;
    emojiRating3 = EmojiRating3;
    emojiRating4 = EmojiRating4;
    emojiRating5 = EmojiRating5;
    blackcross = blackcross;

    @api compview = '';
    @api tView = '';
    @track tView1 = '';
    @api disableField = '';
    @api fieldAttribute = '';
    @api fieldAttributeValue = '';
    @api fieldId = '';
    @api formid = '';
    @track scaleRating = [];
    @track isFieldDesabled = false;

    @track FieldShown = true;
    @track LabelShown = true;
    // @api isReqired;
    @api isReqired = '';
    @track fieldHelpText = 'please fill the help text';
    @track fieldValidations = '';
    FieldLabel = '';
    FieldType = '';
    count = '';
    @track Address = 'Address';
    @track onfocus = false;
    @api getLabelCSS1 = '';
    @api hovercssproperty = '';
    @api focuscssproperty = '';
    @track hovercssproperty1 = '';
    @track focuscssproperty1 = '';
    @api labelvalue = '';
    @api labelcheck = '';
    @api salutationvalue = '';
    @api helptextcheck = '';
    @api helptextvalue = '';
    @api isdisabled = '';
    @api placeholder = '';
    @api fieldtype = '';
    @api termsAndConditionValue = '';
    @api fieldName;
    @track fieldcount = true;
    // d = false;
    @track picklistvalue = [];
    usrViewBool = false;
    referencevalue = [];
    outsideClick;
    selectedmultipicklistvalues = [];
    @track searchkey = '';
    @track showCrossIcon = false;
    selmultipicklistvalues = [];
    @track focused = '';
    @api fieldcss = '';
    @api labelcss = '';
    @track updatedfieldcss = this.fieldcss;
    @track updatedlabelcss = this.labelcss;
    usricon = true;
    reficon;
    @api minimum;
    @api maximum;
    @api minimumtime;
    @api maximumtime;
    @api minimumdatetime;
    @api maximumdatetime;
    @api minimumdate;
    @api maximumdate;
    @track FieldListname = [];
    @api fieldmapping;
    @api firstobjvallist = {};
    @api secondobjvallist = {};
    @api thirdobjvallist = {};
    @api extobjvallist = {};
    @track all_filde_value = {};
    @track file_upload = {};
    @api formobject;
    @track fildval = '';
    @api validation;
    @track chexk_val_list = [];
    @track sec_val = ''; //This variable is used to temporary stor the value of apply_val();
    @track thi_val = ''; //This variable is used to temporary stor the value of apply_val();
    @track for_val = ''; //This variable is used to temporary stor the value of apply_val();
    @track fiv_val = ''; //This variable is used to temporary stor the value of apply_val();
    @track six_val = ''; //This variable is used to temporary stor the value of apply_val();
    @track sstreet = null; //This variable is used to temporary stor the value of apply_val();
    @track scity = null; //This variable is used to temporary stor the value of apply_val();
    @track sstate = null; //This variable is used to temporary stor the value of apply_val();
    @track szipcode = null; //This variable is used to temporary stor the value of apply_val();
    @track scountry = null; //This variable is used to temporary stor the value of apply_val();
    @track s_salutation = null; //This variable is used to temporary stor the value of apply_val();
    @track s_f_name = null; //This variable is used to temporary stor the value of apply_val();
    @track s_l_name = null; //This variable is used to temporary stor the value of apply_val();
    @track dataURL;
    @track convertedDataURI;
    @track sig_filde_id; //This variable is used to temporary stor the Signature fieldID.
    @track city;
    @track street;
    @track state;
    @track postalcode;
    @track country;
    @track referecnereadonly = false;
    @track bol_ver = false;
    fileuploadrk = false;
    uploadfilename;
    fileuploadrkAtt = false;
    uploadfilenameAtt;
    @api error_popup = false;
    @track messagetrack = '';
    @track showErrorMessage = false;
    @track salutation;
    @track firstname;
    @track lastname;
    @track errordata;
    fielddatarating;
    @track referencevaling = false;
    @track referencevalings = false;
    @track tosvalue;
    @api totalfilesize;
    @track fsize;
    str1;
    str2;
    str3;
    str4;
    str5;

    doneTypingInterval = 700;
    typingTimer = 100;
    spinnerdatatable = false;

    showerrorpopup() {
        this.template.querySelector('c-errorpopup').errormessagee('QuickForm Field Component Error', this.messagetrack);
    }

    get cross_img() {
        return `background-image:url(${blackcross})`;
    }

    connectedCallback() {
        this.tView1 = this.tView;
        this.hovercssproperty1 = this.hovercssproperty;
        this.focuscssproperty1 = this.focuscssproperty;
        this.fieldstype = this.tView1.split(',')[1];
        this.tView1 = this.tView1.split(',')[0];
        if (this.fieldstype == 'PICKLIST' || this.fieldstype == 'COMBOBOX') {
            this.picklistvalues();
        } else if (this.fieldstype == 'MULTIPICKLIST') {
            this.picklistvalues();
        }
        this.getScaleRatingValue();
        this.onfocus = false;
        loadStyle(this, groupRadio);
        loadStyle(this, helptextcss);
    }

    renderedCallback() {
        try {
            if (this.fieldcss != undefined) {
                let array = this.template.querySelectorAll('.slds-input');
                let array2 = this.template.querySelectorAll('.dropuser');
                let str = this.fieldcss;
                this.updatedfieldcss = str;
                if (str != undefined) {
                    let Arr = str.split(';color:');
                    let Arr2 = Arr[1].split(';');
                    let pcolor = Arr2[0];
                    for (let i = 0; i < array.length; i++) {
                        const element = array[i];
                        element.style = str;
                        element.style.setProperty("--c", pcolor);
                    }
                    for (let i = 0; i < array2.length; i++) {
                        const element = array2[i];
                        element.style = str;
                        element.style.setProperty("--c", pcolor);
                    }
                }

                array = this.template.querySelectorAll('.flabel');
                let Arr = this.template.querySelectorAll('.labeldiv');
                if (this.labelcss != undefined) {
                    str = this.labelcss;
                    for (let i = 0; i < array.length; i++) {
                        const element = array[i];
                        element.style = 'display:flex;' + str;
                    }
                    let str23 = str.split('margin-bottom:')[0] + str.split('margin-bottom:')[1].slice(3);
                    for (let i = 0; i < Arr.length; i++) {
                        const element = Arr[i];
                        element.style = 'display:flex;' + str23 + ';margin-top:0px;';
                    }
                    let array2 = this.template.querySelectorAll('.slds-popover--tooltip ');
                    let str2 = ((this.labelcss.split('margin-top:'))[1].split(';'))[0];
                    for (let j = 0; j < array2.length; j++) {
                        const element = array2[j];
                        element.style = 'margin:top:' + str2;
                    }
                }
            }
        } catch (e) {
            this.messagetrack = 'Something went wrong in Rendered callback' + e.message;
        }

        //Label css using style property
        try {
            if (this.labelcss != undefined) {
                this.updatedlabelcss = this.labelcss;
                let array = this.template.querySelectorAll('.flabel');
                let Arr = this.template.querySelectorAll('.labeldiv');
                let str = this.labelcss;
                for (let i = 0; i < array.length; i++) {
                    const element = array[i];
                    element.style = 'display:flex;' + str;
                }
                let str23 = str.split('margin-bottom:')[0] + str.split('margin-bottom:')[1].slice(3);
                for (let i = 0; i < Arr.length; i++) {
                    const element = Arr[i];
                    element.style = 'display:flex;' + str23 + ';margin-top:0px;';
                }
                let array2 = this.template.querySelectorAll('.slds-popover--tooltip ');
                let str2 = ((this.labelcss.split('margin-top:'))[1].split(';'))[0];
                let str3 = ((this.labelcss.split('margin-bottom:'))[1].split(';'))[0];
                for (let j = 0; j < array2.length; j++) {
                    const element = array2[j];
                    element.style = 'margin:top:' + str2 + ';margin:bottom:' + str3;
                }
                const event1 = CustomEvent('startsppiner');
                this.dispatchEvent(event1);
            }
        } catch (e) {
            this.messagetrack = 'Something went wrong in Rendered callback' + e.message;
            const event1 = CustomEvent('startsppiner');
            this.dispatchEvent(event1);
        }
        this.s_address();
        this.apply_val();

    }

    getScaleRatingValue() {
        getScaleRating()
            .then(result => {
                if (result != undefined) {
                    this.scaleRating = result;
                }
            }).catch(() => {
                this.messagetrack = 'Something went wrong in Get Scale Rating';
                this.showerrorpopup();
            });
    }

    //This function is used to locate the header address field, then caret and apply field mapping in the address subfield.
    s_address() {
        let filde_name = this.fieldmapping;
        if (filde_name != '' && filde_name != null && filde_name != undefined) {
            let api_name = filde_name.split('<!@!>');
            let add_name = api_name[0].split('Address');
            this.street = add_name[0] + 'Street<!@!>' + api_name[1];
            this.city = add_name[0] + 'City<!@!>' + api_name[1];
            this.state = add_name[0] + 'State<!@!>' + api_name[1];
            this.postalcode = add_name[0] + 'PostalCode<!@!>' + api_name[1];
            this.country = add_name[0] + 'Country<!@!>' + api_name[1];
            // This condition is used to create field_name of stander fullname.
            if (api_name[0] == 'LastName') {
                this.salutation = 'Salutation<!@!>' + api_name[1];
                this.firstname = 'FirstName<!@!>' + api_name[1];
                this.lastname = 'LastName<!@!>' + api_name[1];
            }
            if (this.isTrueRating == true) {
                this.str1 = this.fieldmapping + '<QFSTR>1';
                this.str2 = this.fieldmapping + '<QFSTR>2';
                this.str3 = this.fieldmapping + '<QFSTR>3';
                this.str4 = this.fieldmapping + '<QFSTR>4';
                this.str5 = this.fieldmapping + '<QFSTR>5';
            }
        }

    }

    // This function is used to remove separator and set value on field.
    set_value_in_field(valueArr) {
        let nameArr = valueArr;
        this.fildval = nameArr[0];
        this.sec_val = nameArr[1];
        this.thi_val = nameArr[2];
        this.for_val = nameArr[3];
        this.fiv_val = nameArr[4];
        //This condition is used to set the value of the picklist field.
        if (this.fildval == 'select-one') {
            let pic_val = nameArr[1];
            let p_list = this.template.querySelector(`[data-id="${pic_val}"]`);
            p_list.selected = true;
        }
        //This condition is used to set the value of the multi picklist field.
        else if (nameArr[0] == 'm_pick') {
            let list_len = this.selectedmultipicklistvalues.length;
            if (list_len == 0) {
                for (let t = 1; t < nameArr.length; t++) {
                    let pic_lit = nameArr[t];
                    let m_listArr = pic_lit.split('<?QF>');
                    if (m_listArr[1] != '' && m_listArr[0] != '') {
                        this.selectedmultipicklistvalues.push({
                            key: m_listArr[1],
                            value: m_listArr[0]
                        });
                    }
                }
            }
            for (let j = 0; j < this.selectedmultipicklistvalues.length; j++) {
                let s_list = this.selectedmultipicklistvalues[j].value;
                let val_in = 'yes';
                let m_listArr = '';
                for (let t = 1; t < nameArr.length; t++) {
                    let pic_lit = nameArr[t];
                    m_listArr = pic_lit.split('<?QF>');
                    if (s_list == m_listArr[0]) {
                        val_in = 'no'
                    }
                }
                if (val_in == 'yes') {
                    this.selectedmultipicklistvalues.push({
                        key: m_listArr[1],
                        value: m_listArr[0]
                    });
                }
            }
        }
        //This condition is used to set the value of the DateTime field.
        else if (nameArr[0] == 'datetime') {
            this.fildval = nameArr[1];
        }
        //This condition is used to set the value of the Refernce field.
        else if (nameArr[0] == 'refernce') {
            if (nameArr[1] == null || nameArr[1] == undefined) {
                this.searchkey = '';
            } else {
                this.searchkey = nameArr[1];
            }
        }
        // This condition is used to set the value of the Check Box field.
        else if (nameArr[0] == 'chk_box') {
            var CheckBox = this.template.querySelector(`[data-name="${this.fieldmapping}"]`);
            this.bol_ver = nameArr[1];
            if (nameArr[1] == 'true') {
                CheckBox.checked = true;
            } else {
                CheckBox.checked = false;
            }
        } else if (nameArr[0] == 'attbase64') {
            this.fileuploadrkAtt = true;
            this.uploadfilenameAtt = nameArr[1];
        }

    }

    // This function is used to set the sAddress value on the next and previous buttons.
    set_value_in_sAddress(obj_list, arr) {
        let addArr = arr;
        this.sstreet = obj_list[addArr[0] + 'Street'];
        if (obj_list[addArr[0] + 'City'] == undefined) {
            this.scity = null;
        } else {
            let city = obj_list[addArr[0] + 'City'];
            let addArrCity = city.split('<QF>');
            this.scity = addArrCity[0];
        }
        if (obj_list[addArr[0] + 'State'] == undefined) {
            this.sstate = null;
        } else {
            let state = obj_list[addArr[0] + 'State'];
            let addArrState = state.split('<QF>');
            this.sstate = addArrState[0];
        }
        if (obj_list[addArr[0] + 'PostalCode'] == undefined) {
            this.szipcode = null;
        } else {
            let zipcode = obj_list[addArr[0] + 'PostalCode'];
            let addArrPostalCode = zipcode.split('<QF>');
            this.szipcode = addArrPostalCode[0];
        }
        if (obj_list[addArr[0] + 'Country'] == undefined) {
            this.scountry = null;
        } else {
            let country = obj_list[addArr[0] + 'Country'];
            let addArrCountry = country.split('<QF>');
            this.scountry = addArrCountry[0];
        }

    }
    // This function is used to set the fullname of stander field value on the next and previous buttons.
    set_value_fullname(obj_list) {
        if (obj_list['Salutation'] != undefined) {
            var p_list = this.template.querySelector(`[name="s_salutation"]`)
            p_list.value = obj_list['Salutation'];
        }
        if (obj_list['FirstName'] == undefined) {
            this.s_f_name = null;
        } else {
            this.s_f_name = obj_list['FirstName'];
        }
        if (obj_list['LastName'] == undefined) {
            this.s_l_name = null;
        } else {
            this.s_l_name = obj_list['LastName'];
        }

    }

    // this function used to set field value on next previous button as object vais 
    apply_val() {
        try {
            var tempararyList = this.fieldmapping.split('<!@!>');
            let fildname = tempararyList[0];
            let fildobject = tempararyList[1];
            let frst_map_obj = this.firstobjvallist.sobjectType;
            let second_map_obj = this.secondobjvallist.sobjectType;
            let third_map_obj = this.thirdobjvallist.sobjectType;
            // This condition is used to set the value of only the first object field.
            if (fildobject == frst_map_obj) {
                var obj_one_lst = [];
                obj_one_lst = Object.keys(this.firstobjvallist);
                for (let i = 0; i < obj_one_lst.length; i++) {
                    this.set_value_fullname(this.firstobjvallist);
                    let addArr = this.fieldmapping.split('Address');
                    if (addArr[1] != undefined) {
                        this.set_value_in_sAddress(this.firstobjvallist, addArr);
                    }
                    if (obj_one_lst[i] == fildname) {
                        let vel_of_filde = this.firstobjvallist[obj_one_lst[i]];
                        var nameArr = vel_of_filde.split('<QF>');
                        this.set_value_in_field(nameArr);
                    }
                }
            }
            // This condition is used to set the value of only the second object field.
            else if (fildobject == second_map_obj) {
                var obj_two_lst = [];
                obj_two_lst = Object.keys(this.secondobjvallist);
                for (let i = 0; i < obj_two_lst.length; i++) {
                    this.set_value_fullname(this.secondobjvallist);
                    let addArr = this.fieldmapping.split('Address');
                    if (addArr[1] != undefined) {
                        this.set_value_in_sAddress(this.secondobjvallist, addArr);
                    }
                    if (obj_two_lst[i] == fildname) {
                        let vel_of_filde = this.secondobjvallist[obj_two_lst[i]];
                        let nameArr = vel_of_filde.split('<QF>');
                        this.set_value_in_field(nameArr);
                    }
                }
            }
            // This condition is used to set the value of only the third object field.
            else if (fildobject == third_map_obj) {
                var obj_three_lst = [];
                obj_three_lst = Object.keys(this.thirdobjvallist);
                for (let i = 0; i < obj_three_lst.length; i++) {
                    this.set_value_fullname(this.thirdobjvallist);
                    let addArr = this.fieldmapping.split('Address');
                    if (addArr[1] != undefined) {
                        this.set_value_in_sAddress(this.thirdobjvallist, addArr);
                    }
                    if (obj_three_lst[i] == fildname) {
                        let vel_of_filde = this.thirdobjvallist[obj_three_lst[i]];
                        let nameArr = vel_of_filde.split('<QF>');
                        this.set_value_in_field(nameArr);
                    }
                }
            }
            // This condition is used to set the value of only the extra object field.
            else {
                var ex_obj_lst = [];
                ex_obj_lst = Object.keys(this.extobjvallist);
                for (let i = 0; i < ex_obj_lst.length; i++) {
                    if (ex_obj_lst[i] == fildname) {
                        let vel_of_filde = this.extobjvallist[ex_obj_lst[i]];
                        let nameArr = vel_of_filde.split('<QF>');
                        this.fildval = nameArr[0];
                        this.sec_val = nameArr[1];
                        this.thi_val = nameArr[2];
                        this.for_val = nameArr[3];
                        this.fiv_val = nameArr[4];
                        this.six_val = nameArr[5];
                        this.searchkey = nameArr[1];
                        var strString = nameArr[1];
                        if (this.fildval == 'redio') {
                            var radiobtn = this.template.querySelector(`[data-id="${strString}"]`)
                            radiobtn.checked = true;
                        } else if (this.fildval == 'star') {
                            var selectStar = this.sec_val.split(' ')[0];
                            for (let j = 1; j <= selectStar; j++) {
                                var testkey = fildname + '<!@!>Extra<QFSTR>' + j;
                                const myElement = this.template.querySelector(`[data-id="${testkey}"]`);
                                myElement.style.color = '#c59b08';
                            }

                        } else if (this.fildval == 'chkbox') {
                            for (let k = 2; k < nameArr.length; k++) {
                                var chk_val = nameArr[k];
                                var CheckBox = this.template.querySelector(`[data-id="${chk_val}"]`)
                                CheckBox.checked = true;
                            }
                        } else if (this.fildval == 'select-one') {
                            var pic_val = nameArr[1];
                            var p_list = this.template.querySelector(`[data-id="${pic_val}"]`)
                            p_list.checked = true;
                        } else if (this.fildval == 'emoji') {
                            var emojiSelectedEle = this.template.querySelectorAll('.emoji-ratingfield-Selected');
                            emojiSelectedEle.forEach(element => {
                                element.classList.remove('emoji-ratingfield-Selected');
                            });
                            var emojiEle = this.template.querySelector('label[title="' + nameArr[1] + '"]');
                            emojiEle.classList.add('emoji-ratingfield-Selected');

                        } else if (this.fildval == 'sig') {
                            var canvas = this.template.querySelector(`[data-name="${this.fieldmapping}"]`);
                            var ctx = canvas.getContext('2d');
                            var img = new Image();
                            img.src = this.sec_val;
                            img.onload = () => {
                                ctx.drawImage(img, 10, 10);
                            };
                        } else if (this.fildval == 'file_u') {
                            this.fileuploadrk = true;
                            this.uploadfilename = this.sec_val;
                        } else if (this.fildval == 'fullname') {
                            let pic_val = nameArr[1];
                            let p_list = this.template.querySelector(`[name="salutation"]`)
                            p_list.value = pic_val;
                        } else if (nameArr[0] == 'chk_box') {
                            let cheval = 'true';
                            let CheckBox = this.template.querySelector(`[data-id="${cheval}"]`);
                            this.bol_ver = nameArr[1];
                            if (nameArr[1] == 'true') {
                                CheckBox.checked = true;
                            } else {
                                CheckBox.checked = false;
                            }
                        }
                    }
                }

            }
        } catch (e) {
            this.messagetrack = 'Something went wrong in apply val' + e.message;
        }
    }

    @api FieldCSSUpdate(CSSString) {
        if (CSSString != undefined) {
            try {
                this.updatedfieldcss = CSSString;
                let array = this.template.querySelectorAll('.slds-input');
                let array2 = this.template.querySelectorAll('.dropuser');
                let str = '';
                if (CSSString == undefined || CSSString == null || CSSString == '') {
                    if (this.fieldcss != undefined) {
                        str = this.fieldcss;
                    }
                } else {
                    str = CSSString;
                }
                if (str != undefined) {
                    let Arr = str.split(';color:');
                    let Arr2 = Arr[1].split(';');
                    let pcolor = Arr2[0];
                    if (pcolor != undefined || pcolor != null) {
                        if (array != undefined) {
                            for (let i = 0; i < array.length; i++) {
                                const element = array[i];
                                element.style = str;
                                element.style.setProperty("--c", pcolor);
                            }
                        }
                        if (array2 != undefined) {
                            for (let i = 0; i < array2.length; i++) {
                                const element = array2[i];
                                element.style = str;
                                element.style.setProperty("--c", pcolor);
                            }
                        }
                    }
                }
            } catch (e) {
                this.messagetrack = 'Something went wrong in apply css property' + e.message;
            }
        }
    }

    @api LabelCSSUpdate(CSSString) {
        try {
            if (CSSString != undefined) {
                this.updatedlabelcss = CSSString;
                let array = this.template.querySelectorAll('.flabel');
                let Arr = this.template.querySelectorAll('.labeldiv');
                let str = this.updatedlabelcss;
                for (let i = 0; i < array.length; i++) {
                    const element = array[i];
                    element.style = 'display:flex;' + str;
                }
                let str23 = str.split('margin-bottom:')[0] + str.split('margin-bottom:')[1].slice(3);
                for (let i = 0; i < Arr.length; i++) {
                    const element = Arr[i];
                    element.style = 'display:flex;' + str23 + ';margin-top:0px;';
                }
                let array2 = this.template.querySelectorAll('.slds-popover--tooltip');
                let str2 = ((this.getLabelCSS1.split('margin-top:'))[1].split(';'))[0];
                let str3 = ((this.getLabelCSS1.split('margin-bottom:'))[1].split(';'))[0];
                if (str2 != undefined) {
                    for (let j = 0; j < array2.length; j++) {
                        const element = array2[j];
                        element.style = 'margin:top:' + str2 + ';margin-bottom:' + str3;
                    }
                }
            }
        } catch (e) {
            this.messagetrack = 'Something went wrong in labelcss' + e.message;
        }
    }

    @api handleeffect(type, property) {
        if (type != null && type != undefined && property != null && property != undefined) {
            if (type == 'hover') {
                this.hovercssproperty1 = property;
            } else if (type == 'focus') {
                this.focuscssproperty1 = property;
            }
        }
    }

    handlehover(event) {
        if (this.hovercssproperty1 != undefined) {
            let str = this.hovercssproperty1;
            if (this.onfocus) {
                if (event.target.dataset.id == undefined || event.target.dataset.id == null) {
                    this.handlefocus(event)
                } else {
                    if (event.target.dataset.id == this.focused) {
                        this.handlefocus(event)
                    } else {
                        event.target.style = str;
                        let array = this.template.querySelector('.listbox-item');
                        for (let i = 0; i < array.length; i++) {
                            const element = array[i];
                            element.style = str;
                        }
                    }
                }
            } else {
                event.target.style = str;
            }
        }
    }

    handlefocus(event) {
        if (this.focuscssproperty1 != undefined) {
            if (event.target.dataset.id != undefined && event.target.dataset.id != null) {
                this.focused = event.target.dataset.id;
            }
            let str = this.focuscssproperty1;
            event.target.style = str;
            this.onfocus = true;
        }
    }

    handleblur(event) {
        if (this.onfocus != undefined) {
            if (this.onfocus) {
                if (event.target.dataset.id == undefined || event.target.dataset.id == null) {
                    this.handlefocus(event)
                } else {
                    if (event.target.dataset.id == this.focused) {
                        this.handlefocus(event)
                    } else {
                        event.target.style = this.fieldcss;
                    }
                }
            } else {
                event.target.style = this.fieldcss;
            }
        }
    }

    handleblur1(event) {
        this.onfocus = false;
        if (this.fieldcss != undefined) {
            event.target.style = this.fieldcss
        }
        if (this.updatedfieldcss != undefined) {
            this.FieldCSSUpdate(this.updatedfieldcss)
        }
    }

    get CheckBoxOp() {
        return [{
            label: 'first',
            value: 'option1'
        },
        {
            label: 'second',
            value: 'option2'
        },
        ];
    }


    @track placeHolder = 'New Field';
    get isFieldCompView() {
        return this.compview == 'Field';
    }
    get isFullView() {
        return this.compview == 'Full';
    }
    get isTrueEmail() {
        let tView2 = this.tView1.split(',')[0];
        return tView2 == 'QFEMAILID' || this.FieldLabel == 'QFEMAILID';
    }
    get isTrueFullName() {
        return this.tView1 == 'QFFULLNAME' || this.FieldLabel == 'QFFULLNAME';
    }
    get isTrueName() {
        return this.tView1 == 'QFNAME' || this.FieldLabel == 'QFNAME';
    }
    get isTrueAddress() {
        return this.tView1 == 'QFADDRESS' || this.FieldLabel == 'QFADDRESS';
    }
    get isTruePhone() {
        return this.tView1 == 'QFPHONE';
    }
    get isTrueCheckBox() {
        return this.tView1 == 'QFCHECKBOX';
    }
    get isTruePageBreak() {
        return this.tView1 == 'QFPAGEBREAK';
    }
    get isTrueShortText() {
        return this.tView1 == 'QFSHORTTEXT';
    }
    get isTrueLongText() {
        return this.tView1 == 'QFLONGTEXT';
    }
    get isTrueFileUpload() {
        return this.tView1 == 'QFFILEUPLOAD';
    }
    get isTrueRadioButton() {
        return this.tView1 == 'QFRADIOBUTTON';
    }
    get isTrueDropDown() {
        return this.tView1 == 'QFDROPDOWN';
    }
    get isTrueNumber() {
        return this.tView1 == 'QFNUMBER';
    }
    get isTruePrice() {
        return this.tView1 == 'QFPRICE';
    }
    get isTrueDate() {
        return this.tView1 == 'QFDATE';
    }
    get isTrueTime() {
        return this.tView1 == 'QFTIME';
    }
    get isTrueDateTime() {
        return this.tView1 == 'QFDATETIME';
    }
    get isTrueRating() {
        return this.tView1 == 'QFRATING';
    }
    get isTrueEmojiRating() {
        return this.tView1 == 'QFEMOJIRATING';
    }
    get isTrueScaleRating() {
        return this.tView1 == 'QFSCALERATING';
    }
    get isTrueTerms() {
        return this.tView1 == 'QFTERMSOFSERVICE';
    }
    get isTrueLink() {
        return this.tView1 == 'QFLINK';
    }
    get isTrueSign() {
        return this.tView1 == 'QFSIGNATURE';
    }
    get isTrueRichText() {
        return this.tView1 == 'QFRICHTEXT';
    }

    get sTrueEmail() {
        if (this.fieldstype == 'EMAIL') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueName() {
        if (this.fieldstype == 'STRING') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueAddress() {
        if (this.fieldstype == 'QFADDRESS') {
            return true;
        } else {
            return false;
        }
    }
    get sTruePhone() {
        if (this.fieldstype == 'PHONE') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueFullName() {
        if (this.fieldstype == 'QFFULLNAME') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueCheckBox() {
        if (this.fieldstype == 'BOOLEAN') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueLongText() {
        if (this.fieldstype == 'TEXTAREA') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueNumber() {
        if (this.fieldstype == 'DOUBLE') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueDate() {
        if (this.fieldstype == 'DATE') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueTime() {
        if (this.fieldstype == 'TIME') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueDateTime() {
        if (this.fieldstype == 'DATETIME') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueLink() {
        if (this.fieldstype == 'URL') {
            return true;
        } else {
            return false;
        }
    }
    get sTruePassword() {
        if (this.fieldstype == 'ENCRYPTEDSTRING') {
            return true;
        } else {
            return false;
        }
    }
    get sTruePercent() {
        if (this.fieldstype == 'PERCENT' || this.fieldstype == 'INTEGER') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueCurrency() {
        if (this.fieldstype == 'CURRENCY') {
            return true;
        } else {
            return false;
        }
    }
    get sTruePicklist() {
        if (this.fieldstype == 'PICKLIST' || this.fieldstype == 'COMBOBOX') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueMultiPicklist() {
        if (this.fieldstype == 'MULTIPICKLIST') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueBase64() {
        if (this.fieldstype == 'BASE64') {
            return true;
        } else {
            return false;
        }
    }
    get sTrueRefernce() {
        if (this.fieldstype == 'REFERENCE') {
            return true;
        } else {
            return false;
        }
    }

    handleSubscribe() {
        this.referencevalue = [];
        this.referencevaling = false;
        this.referencevalings = false;
        this.referecnereadonly = true;
        this.usrViewBool = false;
    }

    getreferncevalue(event) {
        try {

            this.spinnerdatatable = true;

            if (this.referencevalue.length == 0) {
                this.sendrequesttoclosereferencefield();
                document.addEventListener('click', this.outsideClick = this.closereference.bind(this));
                event.stopPropagation();


                getreferencevalue({
                    id: this.fieldId,
                    searchkey: this.searchkey
                })
                    .then(result => {
                        this.spinnerdatatable = false;
                        this.referecnereadonly = false;
                        if (result.referenceval.length > 0) {
                            this.referencevaling = true;
                            this.referencevalings = false;
                            this.referencevalue = result.referenceval;
                            this.reficon = result.objicon;
                            this.usricon = true;
                            this.usrViewBool = true;
                        } else {
                            this.usrViewBool = true;
                            this.usricon = false;
                            this.referencevaling = false;
                            this.referencevalings = true;
                        }
                        return false;
                    }).catch(e => {
                        this.messagetrack = 'Something went wrong in Get Reference Value(A)' + e.message;
                        this.showerrorpopup();
                    });
            } else {
                this.referencevalue = [];
                this.usrViewBool = false;
            }

        } catch (e) {
            this.usrViewBool = false;
            this.messagetrack = 'Something went wrong in Get Reference Value' + e.message;
            this.showerrorpopup();
        }
    }

    closereference() {
        this.referencevaling = false;
        this.referencevalings = false;
        this.referencevalue = [];
        if (typeof document !== 'undefined') {
            document.removeEventListener('click', this.outsideClick);
        }
        this.usrViewBool = false;
    }

    selectreferencevalue(event) {
        if (this.submit == true) {
            try {
                document.addEventListener('click', this.outsideClick = this.closereference.bind(this));
                event.stopPropagation();
                this.referecnereadonly = true;
                this.showCrossIcon = true;
                this.searchkey = event.currentTarget.dataset.id;
                let key = event.currentTarget.dataset.name;
                let select_name = event.currentTarget.dataset.id;
                let vale = event.currentTarget.dataset.title;
                let splitparetan = '<!@!>';
                let splitparetan_2 = '<QF>';
                let fulldata = key + splitparetan + 'refernce<QF>' + select_name + splitparetan_2 + vale;
                let new_fulldata = key + splitparetan + select_name;
                const csseventaddval = new CustomEvent("addinputvaljosn", {
                    detail: new_fulldata
                });
                this.dispatchEvent(csseventaddval);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
                this.usrViewBool = false;
                const cssevent3 = new CustomEvent("nextbtvaltrue", {
                    detail: key
                });
                this.dispatchEvent(cssevent3);
                this.usrViewBool = false;
            } catch (e) {
                this.messagetrack = 'Something went wrong in Select Reference Value' + e.message;
                this.showerrorpopup();
            }
        }
    }

    referencevalues(event) {
        try {
            this.referencevaling = false;
            this.referencevalings = false;
            this.spinnerdatatable = true;
            this.searchkey = event.target.value;
            this.showCrossIcon = this.searchkey.length > 0;

            clearTimeout(this.typingTimer);
            this.typingTimer = setTimeout(() => {
                getreferencevalue({
                    id: this.fieldId,
                    searchkey: this.searchkey
                })
                    .then(result => {
                        this.spinnerdatatable = false;
                        if (result.referenceval.length > 0) {
                            this.referencevaling = true;
                            this.referencevalings = false;
                            this.referencevalue = result.referenceval;
                            this.reficon = result.objicon;
                            this.usricon = true;
                            this.usrViewBool = true;
                        } else {
                            this.usrViewBool = true;
                            this.usricon = false;
                            this.referencevaling = false;
                            this.referencevalings = true;
                            this.referencevalue = [{
                                Id: 'none',
                                Name: 'There is no such records'
                            }]
                        }
                    });
            }, 700);


        } catch (error) {
            this.usrViewBool = false;
            this.messagetrack = 'Something went wrong in Get Reference Value';
            this.showerrorpopup();
        }
    }
    picklistvalues() {
        try {
            getpicklistvalue({
                id: this.fieldId
            })
                .then(result => {

                    for (let key in result) {
                        this.picklistvalue.push({
                            value: result[key],
                            key: key
                        });
                    }
                    if (this.selectedmultipicklistvalues.length > 0) {
                        for (let k = 0; k < this.selectedmultipicklistvalues.length; k++) {
                            for (let j = 0; j < this.picklistvalue.length; j++) {
                                if (this.selectedmultipicklistvalues[k].key == this.picklistvalue[j].key) {
                                    this.picklistvalue.splice(j, 1);
                                }
                            }

                        }
                    }


                }).catch(() => {
                    this.messagetrack = 'Something went wrong in Get Picklist Value(A)';
                    this.showerrorpopup();
                });
        } catch (error) {
            this.messagetrack = 'Something went wrong in Picklist Values';
            this.showerrorpopup();
        }
    }

    // This function is to be used to store the emoji rating value in JSON.
    emojiRatingValue(event) {
        this.sendrequesttoclosereferencefield();
        if (this.submit == true) {
            try {
                var emojiValue = event.target.value;
                var emojiName = event.target.name;
                if (emojiName != undefined && emojiValue != undefined) {
                    var emojiSelectedEle = this.template.querySelectorAll('.emoji-ratingfield-Selected');
                    emojiSelectedEle.forEach(element => {
                        element.classList.remove('emoji-ratingfield-Selected');
                    });
                    var emojiEle = this.template.querySelector('label[title="' + emojiName + '"]');
                    emojiEle.classList.add('emoji-ratingfield-Selected');
                    let key = event.target.dataset.name;
                    let splitparetan = '<!@!>';
                    let fulldata = key + splitparetan + 'emoji<QF>' + emojiValue;
                    let new_fulldata = key + splitparetan + emojiValue;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    const cssevent1 = new CustomEvent("passfieldvalue", {
                        detail: fulldata
                    }); //This custom event is used to store values in JSON.
                    this.dispatchEvent(cssevent1);
                }
            } catch (error) {
                this.messagetrack = 'Something went wrong in Emoji Rating Value';
                this.showerrorpopup();
            }
        }
    }

    rating(event) {
        this.fielddatarating = event.target.value;
    }
    fieldrating;
    ratingvalued(event) {
        this.fieldrating = event.target.value;
    }
    handleMouseMove(event) {
        this.searchCoordinatesForEvent('move', event);
    }

    //handler for mouse down operation
    handleMouseDown(event) {
        this.searchCoordinatesForEvent('down', event);
    }

    //handler for mouse up operation
    handleMouseUp(event) {
        this.searchCoordinatesForEvent('up', event);
    }

    //handler for mouse out operation
    handleMouseOut(event) {
        this.searchCoordinatesForEvent('out', event);
    }
    // This function is to be used to clear the signature from canvas & remove emove signature dataURL in JSON.
    handleClearClick(event) {
        if (this.submit == true) {

            canvasElement = this.template.querySelector(`[data-name="${this.fieldmapping}"]`);
            ctx = canvasElement.getContext("2d");
            ctx.clearRect(0, 0, canvasElement.width, canvasElement.height);
            this.convertedDataURI = '';
            let key = event.target.dataset.name;
            var sig_fildeArr = key.split('<!@!>');
            this.sig_filde_id = sig_fildeArr[0];
            let splitparetan = '<!@!>';
            var pera_m = {
                con_id: this.convertedDataURI,
                filde_id: this.sig_filde_id,
            };
            let fulldata = key + splitparetan + 'sig<QF>' + null;
            const cssevent_sing = new CustomEvent("sigconverteddataurl", {
                detail: pera_m
            });
            this.dispatchEvent(cssevent_sing);
            let new_fulldata = key + splitparetan + 'sig<QF>' + null;
            const csseventaddval = new CustomEvent("addinputvaljosn", {
                detail: new_fulldata
            });
            this.dispatchEvent(csseventaddval);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            }); //This custom event is used to remove signature dataURL in JSON
            this.dispatchEvent(cssevent1);
        }
    }

    searchCoordinatesForEvent(requestedEvent, event) {
        event.preventDefault();
        if (requestedEvent === 'down') {
            this.setupCoordinate(event);
            isDownFlag = true;
            isDotFlag = true;
            if (isDotFlag) {
                this.drawDot();
                isDotFlag = false;
            }
        }
        if (requestedEvent === 'up' || requestedEvent === "out") {
            isDownFlag = false;
        }
        if (requestedEvent === 'move') {
            if (isDownFlag) {
                this.setupCoordinate(event);
                this.redraw();
            }
        }
    }

    //This method is primary called from mouse down & move to setup cordinates.
    setupCoordinate(eventParam) {
        const clientRect = canvasElement.getBoundingClientRect();
        prevX = currX;
        prevY = currY;
        currX = eventParam.clientX - clientRect.left;
        currY = eventParam.clientY - clientRect.top;
    }

    //For every mouse move based on the coordinates line to redrawn
    redraw() {
        ctx.beginPath();
        ctx.moveTo(prevX, prevY);
        ctx.lineTo(currX, currY);
        ctx.strokeStyle = x; //sets the color, gradient and pattern of stroke
        ctx.lineWidth = y;
        ctx.closePath(); //create a path from current point to starting point
        ctx.stroke(); //draws the path
    }

    drawDot() {
        ctx.beginPath();
        ctx.fillStyle = x;
        ctx.fillRect(currX, currY, y, y);
        ctx.closePath();
    }

    draw_signature(event) {
        let field_id = event.target.dataset.name;
        canvasElement = this.template.querySelector(`[data-name="${field_id}"]`);
        ctx = canvasElement.getContext("2d");
        this.template.addEventListener('mousemove', this.handleMouseMove.bind(this));
        this.template.addEventListener('mousedown', this.handleMouseDown.bind(this));
        this.template.addEventListener('mouseup', this.handleMouseUp.bind(this));
        this.template.addEventListener('mouseout', this.handleMouseOut.bind(this));
    }

    get_signature(event) {
        if (this.submit == true) {
            let field_id = event.target.dataset.name;
            canvasElement = this.template.querySelector(`[data-name="${field_id}"]`);
            ctx = canvasElement.getContext("2d");
            ctx.globalCompositeOperation = "destination-over";
            ctx.fillStyle = "#FFF"; //white
            ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);
            this.dataURL = canvasElement.toDataURL("image/png"); //convert to png image as dataURL
            this.convertedDataURI = this.dataURL.replace(/^data:image\/(png|jpg);base64,/, ""); //convert that as base64 encoding
            let key = event.target.dataset.name;
            var sig_fildeArr = key.split('<!@!>');
            this.sig_filde_id = sig_fildeArr[0];
            let splitparetan = '<!@!>';
            var pera_m = {
                con_id: this.convertedDataURI,
                filde_id: this.sig_filde_id,
            };
            let fulldata = key + splitparetan + 'sig<QF>' + this.dataURL;
            const cssevent_sing = new CustomEvent("sigconverteddataurl", {
                detail: pera_m
            });
            this.dispatchEvent(cssevent_sing);
            let new_fulldata = key + splitparetan + 'sig<QF>' + this.dataURL;
            const csseventaddval = new CustomEvent("addinputvaljosn", {
                detail: new_fulldata
            });
            this.dispatchEvent(csseventaddval);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            });
            this.dispatchEvent(cssevent1);
            var pera_sig = {
                toast_error_msg: 'Signature has been saved Successfully',
                msg_type: 'success'
            };
            const showpop = new CustomEvent("openpop", {
                detail: pera_sig
            });
            this.dispatchEvent(showpop);
        }
    }

    handleFilesChange(event) {
        try {
            if (event.target.files.length > 0) {
                this.fileuploadrk = true;
                const fileName = event.target.files[0].name;
                this.fileName = fileName;
                this.uploadHelper(event);
            } else {
                this.fileuploadrk = false;
            }
        } catch (error) {
            this.messagetrack = 'Something went wrong in Handle Files Change';
            this.showerrorpopup();
        }
    }

    MAX_FILE_SIZE = 3500000; //Max file size 3.5 MB 
    CHUNK_SIZE = 750000; //Chunk Max size 750Kb 

    uploadHelper(event) {
        if (this.submit == true) {
            try {
                const file = event.target.files[0];
                let key = event.target.dataset.name;
                if (file.size < this.MAX_FILE_SIZE) {
                    const reader = new FileReader();
                    reader.onload = () => {
                        const fileContents = reader.result;
                        const base64 = 'base64,';
                        const dataStart = fileContents.indexOf(base64) + base64.length;
                        const encodedFileContents = fileContents.substring(dataStart);
                        this.uploadProcess(file, encodedFileContents, key);
                    };
                    reader.readAsDataURL(file);
                } else {
                    var pera_file_upload = {
                        toast_error_msg: 'File size limit exceeded. Choose a smaller file.',
                        msg_type: 'error'
                    };
                    const showpop = new CustomEvent("openpop", {
                        detail: pera_file_upload
                    });
                    this.dispatchEvent(showpop);
                }


            } catch (error) {
                this.messagetrack = 'Something went wrong in Upload Helper';
                this.showerrorpopup();
            }
        }
    }

    uploadProcess(file, fileContents, key) {
        try {
            let startPosition = 0;
            let endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
            this.uploadInChunk(file, fileContents, startPosition, endPosition, key);
        } catch (error) {
            this.messagetrack = 'Something went wrong in Upload Process';
            this.showerrorpopup();
        }
    }

    uploadInChunk(file, fileContents, startPosition, endPosition, key) {
        if (this.submit == true) {
            try {
                const getchunk = fileContents.substring(startPosition, endPosition);
                var upload_fildeArr = key.split('<!@!>');
                this.sig_filde_id = upload_fildeArr[0];
                let splitparetan = '<!@!>';
                if (upload_fildeArr[1] == 'Extra') {
                    var pera_m = {
                        con_id: encodeURIComponent(getchunk),
                        filde_id: this.sig_filde_id,
                        fileName: file.name,
                        contentType: file.type
                    };
                    let fulldata = key + splitparetan + 'file_u<QF>' + file.name + '<QF>' + encodeURIComponent(getchunk);
                    const file_upload = new CustomEvent("fileuploadpra", {
                        detail: pera_m
                    });
                    this.dispatchEvent(file_upload);
                    let new_fulldata = key + splitparetan + 'file_u<QF>' + file.name + '<QF>' + encodeURIComponent(getchunk);
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    const cssevent1 = new CustomEvent("passfieldvalue", {
                        detail: fulldata
                    });
                    this.dispatchEvent(cssevent1);
                    this.uploadfilename = file.name;
                } else {
                    const base64String = encodeURIComponent(getchunk);
                    let new_fulldata = key + splitparetan + base64String;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    const cssevent1 = new CustomEvent("passfieldvalue", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(cssevent1);
                }
            } catch (e) {
                this.messagetrack = 'Something went wrong in Select Upload in chunk' + e.message;
            }
        }
    }

    selectedvalues(event) {
        try {
            if (this.selmultipicklistvalues.length > 0) {
                var i;
                this.selmultipicklistvalues.forEach((element, index) => {
                    if (element.value == event.currentTarget.dataset.id) {
                        i = index;
                    }
                })
                if (i == undefined) {
                    this.selmultipicklistvalues.push({
                        value: event.currentTarget.dataset.id,
                        key: event.currentTarget.dataset.name
                    });
                    this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'block';
                } else {
                    this.selmultipicklistvalues.splice(i, 1);
                    this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'none';

                }

            } else {
                this.selmultipicklistvalues.push({
                    value: event.currentTarget.dataset.id,
                    key: event.currentTarget.dataset.name
                });
                this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'block';
            }
        } catch (error) {
            this.messagetrack = 'Something went wrong in Selected Values';
            this.showerrorpopup();
        }
    }

    unselectedvalues(event) {
        try {
            if (this.selmultipicklistvalues.length > 0) {
                var i;
                this.selmultipicklistvalues.forEach((element, index) => {
                    if (element.value == event.currentTarget.dataset.id) {
                        i = index;
                    }
                })
                if (i == undefined) {
                    this.selmultipicklistvalues.push({
                        value: event.currentTarget.dataset.id,
                        key: event.currentTarget.dataset.name
                    });
                    this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'block';
                } else {
                    this.selmultipicklistvalues.splice(i, 1);
                    this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'none';
                }

            } else {
                this.selmultipicklistvalues.push({
                    value: event.currentTarget.dataset.id,
                    key: event.currentTarget.dataset.name
                });
                this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'block';
            }
        } catch (error) {
            this.messagetrack = 'Something went wrong in Unselected Values';
            this.showerrorpopup();
        }
    }

    rightarrowmulti(event) {
        if (this.submit == true) {
            try {
                let splitparetan = '<!@!>';
                let sel_val = event.currentTarget.dataset.name;
                let new_sel_val = event.currentTarget.dataset.name;
                sel_val = sel_val + splitparetan + 'm_pick<QF>';
                new_sel_val = new_sel_val + splitparetan + 'm_pick<QF>';
                let splitparetan_2 = '<QF>';

                for (let i = 0; i < this.selmultipicklistvalues.length; i++) {
                    this.template.querySelector('div[data-id="' + this.selmultipicklistvalues[i].value + '"]').style.display = 'none';
                }
                for (var j = 0; j < this.selmultipicklistvalues.length; j++) {
                    for (var i = 0; i < this.picklistvalue.length; i++) {
                        if (this.picklistvalue[i].value == this.selmultipicklistvalues[j].value) {
                            this.selectedmultipicklistvalues.push(this.selmultipicklistvalues[j]);
                            this.picklistvalue.splice(i, 1);
                        }
                    }
                }
                for (let i = 0; i < this.selectedmultipicklistvalues.length; i++) {
                    let cur_val = this.selectedmultipicklistvalues[i].value;
                    let cur_key = this.selectedmultipicklistvalues[i].key;
                    sel_val = sel_val + cur_val + '<?QF>' + cur_key + splitparetan_2;
                    new_sel_val = new_sel_val + cur_val;
                }
                this.selmultipicklistvalues = [];
                let new_fulldata = new_sel_val;
                const csseventaddval = new CustomEvent("addinputvaljosn", {
                    detail: new_fulldata
                });
                this.dispatchEvent(csseventaddval);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: sel_val
                });
                this.dispatchEvent(cssevent1);
            } catch (error) {
                this.messagetrack = 'Something went wrong in Right Arrow Multi Function';
                this.showerrorpopup();
            }
        }
    }

    leftarrowmulti(event) {
        if (this.submit == true) {
            let splitparetan = '<!@!>';
            let sel_val = event.currentTarget.dataset.name;
            let new_sel_val = event.currentTarget.dataset.name;
            sel_val = sel_val + splitparetan + 'm_pick<QF>';
            new_sel_val = new_sel_val + splitparetan;
            let splitparetan_2 = '<QF>';
            for (let i = 0; i < this.selmultipicklistvalues.length; i++) {
                this.template.querySelector('div[data-id="' + this.selmultipicklistvalues[i].value + '"]').style.display = 'none';
            }
            for (var j = 0; j < this.selmultipicklistvalues.length; j++) {
                for (var i = 0; i < this.selectedmultipicklistvalues.length; i++) {
                    if (this.selectedmultipicklistvalues[i].value == this.selmultipicklistvalues[j].value) {
                        this.picklistvalue.push(this.selmultipicklistvalues[j]);
                        this.selectedmultipicklistvalues.splice(i, 1);
                    }
                }
            }
            for (let i = 0; i < this.selectedmultipicklistvalues.length; i++) {
                let cur_val = this.selectedmultipicklistvalues[i].value;
                let cur_key = this.selectedmultipicklistvalues[i].key;
                sel_val = sel_val + cur_val + '<?QF>' + cur_key + splitparetan_2;
                new_sel_val = new_sel_val + cur_val;
            }
            this.selmultipicklistvalues = [];
            let new_fulldata = new_sel_val;
            const csseventaddval = new CustomEvent("addinputvaljosn", {
                detail: new_fulldata
            });
            this.dispatchEvent(csseventaddval);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: sel_val
            });
            this.dispatchEvent(cssevent1);
        }
    }

    Set_error_msg(msg, datakey) {
        if (this.submit == true) {
            var error = this.template.querySelector(`[data-id="${datakey}"]`);
            error.textContent = msg;
            error.style.color = "red";
            const cssevent2 = new CustomEvent("nextbtval", {
                detail: datakey
            });
            this.dispatchEvent(cssevent2);
        }
    }

    remove_error_msg(key, vale) {
        if (this.submit == true) {
            try {
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + vale;
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
                var error = this.template.querySelector(`[data-id="${key}"]`);
                if (error != null) {
                    error.textContent = "";
                }
                const cssevent3 = new CustomEvent("nextbtvaltrue", {
                    detail: key
                });
                this.dispatchEvent(cssevent3);
            } catch (e) {
                this.messagetrack = 'Something went wrong in remove error message ' + e.message;
                this.showerrorpopup();
            }
        }
    }

    OnFieldClick(event) {
        if (this.submit == true) {
            let key = event.target.dataset.name;
            let vale = event.target.value;
            let fild_teye = event.target.type;
            if (fild_teye == 'select-one') {
                if (vale == '--Select--') {
                    vale = '';
                }
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + 'select-one<QF>' + vale;
                let new_fulldata = key + splitparetan + vale;
                const csseventaddval = new CustomEvent("addinputvaljosn", {
                    detail: new_fulldata
                });
                this.dispatchEvent(csseventaddval);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
                var error = this.template.querySelector(`[data-id="${key}"]`)
                error.textContent = ""
                const cssevent3 = new CustomEvent("nextbtvaltrue", {
                    detail: key
                });
                this.dispatchEvent(cssevent3);
            } else if (fild_teye == 'text') {
                let msg1 = '';
                if (event.target.dataset.type == 'phone') {
                    const regexPattern = /^[0-9+\-\s]{0,15}$/;
                    const isInputValid = regexPattern.test(vale);
                    if (!isInputValid) {
                        msg1 = 'Enter a Valid Phone Number.';
                        this.Set_error_msg(msg1, key);
                    } else {
                        let text_val = vale;
                        let error = this.template.querySelector(`[data-id="${key}"]`);
                        error.textContent = "";
                        const cssevent3 = new CustomEvent("nextbtvaltrue", {
                            detail: key
                        });
                        this.dispatchEvent(cssevent3);
                        let splitparetan = '<!@!>';
                        let fulldata = key + splitparetan + vale;
                        const csseventaddval = new CustomEvent("addinputvaljosn", {
                            detail: fulldata
                        });
                        this.dispatchEvent(csseventaddval);
                        this.remove_error_msg(key, text_val);

                    }
                } else {
                    if (this.minimum > vale.length) {
                        msg1 = 'Please enter a minimum ' + this.minimum + ' character.';
                        this.Set_error_msg(msg1, key);
                    } else {
                        let text_val = vale + '<QF>';
                        let splitparetan = '<!@!>';
                        let fulldata = key + splitparetan + vale;
                        const csseventaddval = new CustomEvent("addinputvaljosn", {
                            detail: fulldata
                        });
                        this.dispatchEvent(csseventaddval);
                        this.remove_error_msg(key, text_val);
                    }
                    if (vale == '' || vale == null || vale == undefined) {
                        let text_val = vale + '<QF>';
                        let splitparetan = '<!@!>';
                        let fulldata = key + splitparetan + vale;
                        const csseventaddval = new CustomEvent("addinputvaljosn", {
                            detail: fulldata
                        });
                        this.dispatchEvent(csseventaddval);
                        this.remove_error_msg(key, text_val);
                    }
                }

            } else if (fild_teye == 'number') {
                let msg1 = '';
                if (vale.length < this.minimum) {
                    msg1 = "Please enter a minimum " + this.minimum + " character.";
                    this.Set_error_msg(msg1, key);
                } else if (vale.length > this.maximum) {
                    msg1 = " maximum character limit is " + this.maximum + " .";
                    this.Set_error_msg(msg1, key);
                } else {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);
                }
                if (vale == '' || vale == null || vale == undefined) {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);
                }

            } else if (fild_teye == 'date') {
                let msg1 = '';
                let min = event.target.min;
                let max = event.target.max;
                if (min != '' && max != '') {
                    if (vale < min || vale > max) {
                        msg1 = "Please enter a date betwin " + min + ' to ' + max;
                        this.Set_error_msg(msg1, key);
                    } else {
                        let splitparetan = '<!@!>';
                        let new_fulldata = key + splitparetan + vale;
                        const csseventaddval = new CustomEvent("addinputvaljosn", {
                            detail: new_fulldata
                        });
                        this.dispatchEvent(csseventaddval);
                        this.remove_error_msg(key, vale);
                    }
                } else if (min != '' && max == '') {
                    if (min <= vale) {
                        let splitparetan = '<!@!>';
                        let new_fulldata = key + splitparetan + vale;
                        const csseventaddval = new CustomEvent("addinputvaljosn", {
                            detail: new_fulldata
                        });
                        this.dispatchEvent(csseventaddval);
                        this.remove_error_msg(key, vale);
                    } else {
                        msg1 = "Please enter a date after to " + min;
                        this.Set_error_msg(msg1, key);
                    }
                } else if (min == '' && max != '') {
                    if (max >= vale) {
                        let splitparetan = '<!@!>';
                        let new_fulldata = key + splitparetan + vale;
                        const csseventaddval = new CustomEvent("addinputvaljosn", {
                            detail: new_fulldata
                        });
                        this.dispatchEvent(csseventaddval);
                        this.remove_error_msg(key, vale);
                    } else {
                        msg1 = "Please enter a date a bove to " + max;
                        this.Set_error_msg(msg1, key);
                    }
                } else {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);
                }
            } else if (fild_teye == 'datetime-local') {
                let msg1 = '';
                let min = event.target.min;
                let max = event.target.max;
                const valdatetime = new Date(vale);
                if (min != '' && max != '') {
                    var min_date_time = min.split('T');
                    var min_time = min_date_time[1];
                    var max_date_time = max.split('T');
                    var max_time = max_date_time[1];
                    var che_max_timeArr = max_time.split(':');
                    var che_min_timeArr = min_time.split(':');
                    var full_max_time = max_date_time[0] + 'T' + che_max_timeArr[0] + ':' + che_max_timeArr[1];
                    var full_min_time = min_date_time[0] + 'T' + che_min_timeArr[0] + ':' + che_min_timeArr[1];
                    const maxdatetime = new Date(full_max_time);
                    const mindatetime = new Date(full_min_time);
                    if (valdatetime < mindatetime || valdatetime > maxdatetime) {
                        msg1 = 'Please enter a date between ' + mindatetime + ' to ' + maxdatetime;
                        this.Set_error_msg(msg1, key);
                    } else {
                        let splitparetan = '<!@!>';
                        let fulldata = key + splitparetan + 'datetime<QF>' + vale;
                        const csseventaddval = new CustomEvent("addinputvaljosn", {
                            detail: fulldata
                        });
                        this.dispatchEvent(csseventaddval);
                        let newvale = 'datetime<QF>' + vale;
                        this.remove_error_msg(key, newvale);
                    }
                } else if (min != '' && max == '') {
                    let min_date_time = min.split('T');
                    let min_time = min_date_time[1];
                    let che_min_timeArr = min_time.split(':');
                    let full_min_time = min_date_time[0] + 'T' + che_min_timeArr[0] + ':' + che_min_timeArr[1];
                    const mindatetime = new Date(full_min_time);
                    if (valdatetime < mindatetime) {
                        msg1 = 'Please enter a date above ' + mindatetime;
                        this.Set_error_msg(msg1, key);
                    } else {
                        let splitparetan = '<!@!>';
                        let fulldata = key + splitparetan + 'datetime<QF>' + vale;
                        const csseventaddval = new CustomEvent("addinputvaljosn", {
                            detail: fulldata
                        });
                        this.dispatchEvent(csseventaddval);
                        let newvale = 'datetime<QF>' + vale;
                        this.remove_error_msg(key, newvale);
                    }
                } else if (min == '' && max != '') {
                    let max_date_time = max.split('T');
                    let max_time = max_date_time[1];
                    let che_max_timeArr = max_time.split(':');
                    let full_max_time = max_date_time[0] + 'T' + che_max_timeArr[0] + ':' + che_max_timeArr[1];
                    const maxdatetime = new Date(full_max_time);
                    if (valdatetime > maxdatetime) {
                        msg1 = 'Please enter a date before ' + maxdatetime;
                        this.Set_error_msg(msg1, key);
                    } else {
                        let splitparetan = '<!@!>';
                        let fulldata = key + splitparetan + 'datetime<QF>' + vale;
                        const csseventaddval = new CustomEvent("addinputvaljosn", {
                            detail: fulldata
                        });
                        this.dispatchEvent(csseventaddval);
                        let newvale = 'datetime<QF>' + vale;
                        this.remove_error_msg(key, newvale);
                    }
                } else {
                    let splitparetan = '<!@!>';
                    let fulldata = key + splitparetan + 'datetime<QF>' + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    let newvale = 'datetime<QF>' + vale;
                    this.remove_error_msg(key, newvale);
                }
            } else if (fild_teye == 'email') {
                var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
                if (vale.match(mailformat)) {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);
                } else if (vale == '' || vale == null || vale == undefined) {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);
                } else {
                    let msg1 = " You have entered an invalid email address! ";
                    this.Set_error_msg(msg1, key);
                }
            } else if (fild_teye == 'textarea') {
                if (this.minimum > vale.length) {
                    let msg1 = 'Please enter a minimum ' + this.minimum + ' character. ';
                    this.Set_error_msg(msg1, key);
                } else {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);
                }
                if (vale == '' || vale == null || vale == undefined) {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);
                }

            } else if (fild_teye == 'url') {
                var expression = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi;
                if (vale.match(expression)) {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);
                } else if (vale == '' || vale == null || vale == undefined) {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);

                } else {
                    let msg1 = " You have entered an invalid Link ";
                    this.Set_error_msg(msg1, key);
                }

            } else if (fild_teye == 'time') {
                let fulltime = 'time<QF>' + vale;
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + fulltime;
                let new_fulldata = key + splitparetan + fulltime;
                const csseventaddval = new CustomEvent("addinputvaljosn", {
                    detail: new_fulldata
                });
                this.dispatchEvent(csseventaddval);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
            } else if (vale == '' || vale == null || vale == undefined) {
                let splitparetan = '<!@!>';
                let new_fulldata = key + splitparetan + vale;
                const csseventaddval = new CustomEvent("addinputvaljosn", {
                    detail: new_fulldata
                });
                this.dispatchEvent(csseventaddval);
                this.remove_error_msg(key, vale);
            } else if (fild_teye == 'checkbox') {
                let che = event.target.checked;
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + 'chk_box<QF>' + che;
                let new_fulldata = key + splitparetan + 'chk_box<QF>' + che;
                const csseventaddval = new CustomEvent("addinputvaljosn", {
                    detail: new_fulldata
                });
                this.dispatchEvent(csseventaddval);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
            } else if (fild_teye == 'password') {

                let vallenth = vale.length;
                if (vallenth < this.minimum) {
                    let msg1 = "Please enter a minimum " + this.minimum + " character.";
                    this.Set_error_msg(msg1, key);
                } else {
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + vale;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    this.remove_error_msg(key, vale);
                }

            } else {
                let splitparetan = '<!@!>';
                let new_fulldata = key + splitparetan + vale;
                const csseventaddval = new CustomEvent("addinputvaljosn", {
                    detail: new_fulldata
                });
                this.dispatchEvent(csseventaddval);
                this.remove_error_msg(key, vale);

            }
        }
    }

    sobj_fullname(event) {
        if (this.submit == true) {
            try {
                let key = event.target.dataset.name;
                let vale = event.target.value;
                this.remove_error_msg(key, vale);
                const cssevent3 = new CustomEvent("nextbtvaltrue", {
                    detail: key
                });
                this.dispatchEvent(cssevent3);
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + vale;
                const csseventaddval = new CustomEvent("addinputvaljosn", {
                    detail: fulldata
                });
                this.dispatchEvent(csseventaddval);

                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);

            } catch (e) {
                this.messagetrack = 'Something went wrong in SObject Fullname' + e.message;
            }
        }
    }

    full_name(event) {
        if (this.submit == true) {
            try {
                let ne = this.template.querySelector(`[name="salutation"]`).value;
                let ne2 = this.template.querySelector(`[name="f_name"]`).value;
                let ne3 = this.template.querySelector(`[name="s_name"]`).value;
                let FullName = 'fullname<QF>' + ne + '<QF>' + ne2 + '<QF>' + ne3;
                let new_fullname = ne + ' ' + ne2 + ' ' + ne3;
                let key = event.target.dataset.name;
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + FullName;
                let new_fulldata = key + splitparetan + new_fullname;
                const csseventaddval = new CustomEvent("addinputvaljosn", {
                    detail: new_fulldata
                });
                this.dispatchEvent(csseventaddval);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
            } catch (error) {
                this.messagetrack = 'Something went wrong in Fullname Function';
            }
        }
    }

    address(event) {
        if (this.submit == true) {
            let street = this.template.querySelector(`[name="street"]`).value;
            let city = this.template.querySelector(`[name="city"]`).value;
            let state = this.template.querySelector(`[name="state"]`).value;
            let zipcode = this.template.querySelector(`[name="zipcode"]`).value;
            let country = this.template.querySelector(`[name="country"]`).value;
            let FullAdd = 'add<QF>' + ' ' + street + '<QF>' + ' ' + city + '<QF>' + ' ' + state + '<QF>' + ' ' + zipcode + '<QF>' + ' ' + country;
            let new_fulladd = street + ' ' + city + ' ' + state + ' ' + zipcode + ' ' + country;
            let key = event.target.dataset.name;
            let splitparetan = '<!@!>';
            let fulldata = key + splitparetan + FullAdd;
            let new_fulldata2 = key + splitparetan + new_fulladd;
            const csseventaddval = new CustomEvent("addinputvaljosn", {
                detail: new_fulldata2
            });
            this.dispatchEvent(csseventaddval);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            });
            this.dispatchEvent(cssevent1);
        }
    }

    radiobutton(event) {
        this.sendrequesttoclosereferencefield();
        if (this.submit == true) {
            let radio_val = event.target.value;
            let key = event.target.dataset.name;
            let splitparetan = '<!@!>';
            let splitparetan2 = 'redio<QF>';
            let fulldata = key + splitparetan + splitparetan2 + radio_val;
            let new_fulldata = key + splitparetan + radio_val;
            const csseventaddval = new CustomEvent("addinputvaljosn", {
                detail: new_fulldata
            });
            this.dispatchEvent(csseventaddval);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            });
            this.dispatchEvent(cssevent1);
        }
    }

    star_rating(event) {
        if (this.submit == true) {
            let radio_val = event.target.value;
            let key = event.target.dataset.name;
            for (let i = 1; i <= 5; i++) {
                var testdataid = key + '<QFSTR>' + i;
                const myElement_1 = this.template.querySelector(`[data-id="${testdataid}"]`);
                myElement_1.style.color = '#ccc';
            }
            var selectStar = radio_val.split(' ')[0];
            for (let j = 1; j <= selectStar; j++) {
                var testkey = key + '<QFSTR>' + j;
                const myElement = this.template.querySelector(`[data-id="${testkey}"]`);
                myElement.style.color = '#c59b08';
            }
            let splitparetan = '<!@!>';
            let splitparetan2 = 'star<QF>';
            let fulldata = key + splitparetan + splitparetan2 + radio_val;
            let new_fulldata = key + splitparetan + radio_val;
            const csseventaddval = new CustomEvent("addinputvaljosn", {
                detail: new_fulldata
            });
            this.dispatchEvent(csseventaddval);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            });
            this.dispatchEvent(cssevent1);
        }
    }

    check_box(event) {
        if (this.submit == true) {
            let radio_val = event.target.value;
            let add_var = 'yes';
            for (let i = 0; i < this.chexk_val_list.length; i++) {
                if (this.chexk_val_list[i] == radio_val) {
                    add_var = 'No';
                    this.chexk_val_list.splice(i, 1);
                }
            }
            if (add_var == 'yes') {
                this.chexk_val_list.push(radio_val);
            }
            let full_cheh_val;
            let new_full_cheh_val;
            for (let i = 0; i < this.chexk_val_list.length; i++) {
                full_cheh_val = full_cheh_val + '<QF>' + this.chexk_val_list[i];
                new_full_cheh_val = new_full_cheh_val + this.chexk_val_list[i];
            }
            let key = event.target.dataset.name;
            let splitparetan = '<!@!>';
            let fulldata = key + splitparetan + 'chkbox<QF>' + full_cheh_val;
            let new_fulldata = key + splitparetan + new_full_cheh_val;
            const csseventaddval = new CustomEvent("addinputvaljosn", {
                detail: new_fulldata
            });
            this.dispatchEvent(csseventaddval);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            });
            this.dispatchEvent(cssevent1);
        }
    }

    get displayText() {
        if (!this.termsAndConditionValue) {
            return 'Terms of Services';
        }
        return this.termsAndConditionValue;
    }
    get displayTexts() {
        if (!this.termsAndConditionValue) {
            return 'Terms of Services';
        }
        const myString = this.termsAndConditionValue;
        const modifiedString = myString.replace(/<[^>]+>/g, '');
        this.tosvalue = modifiedString;

        return this.tosvalue;
    }

    clearreference(event) {
        if (this.submit == true) {
            this.searchkey = '';
            this.showCrossIcon = false;
            this.usrViewBool = false;
            let key = event.target.dataset.id;
            let splitparetan = '<!@!>';
            let fulldata = key + splitparetan + null;
            let new_fulldata = key + splitparetan + null;
            const csseventaddval = new CustomEvent("addinputvaljosn", {
                detail: new_fulldata
            });
            this.dispatchEvent(csseventaddval);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            });
            this.dispatchEvent(cssevent1);
        }
        else {
            this.searchkey = '';
            this.showCrossIcon = false;
            this.usrViewBool = false;
        }
    }

    errorpopupcall() {
        location.reload();
    }

    showerror() {

        this.errordata = {
            header_type: 'Quick From Field',
            Message: this.message
        };

        const showpopup = new CustomEvent('showerrorpopup', {
            detail: this.errordata
        });
        this.dispatchEvent(showpopup);
    }


    optionhover(event) {
        var bcolor = this.hovercssproperty.split('background-color:')[1].split(';')[0];
        event.target.style = 'background-color:' + bcolor;
    }

    optionblur() {
        var Array = this.template.querySelectorAll('.usrnameClass');
        Array.forEach(element => {
            element.style = 'background-color:transparent';
        });
    }

    handleUploadbase64(event) {
        if (this.submit == true) {
            let key = event.target.dataset.name;
            if (event.target.files.length > 0) {
                let file = event.target.files[0];
                if (file.size > 3145728) { // 3MB in bytes
                    // Show error message here
                    var pera_file_upload = {
                        toast_error_msg: 'File size limit exceeded. Choose a smaller file.',
                        msg_type: 'error'
                    };
                    const showpop = new CustomEvent("openpop", {
                        detail: pera_file_upload
                    });
                    this.dispatchEvent(showpop);
                    this.fileuploadrkAtt = false;
                    return;
                }
                this.fileuploadrkAtt = true;
                let reader = new FileReader();
                reader.onload = () => {
                    var base64 = reader.result.split(',')[1];
                    let splitparetan = '<!@!>';
                    let new_fulldata = key + splitparetan + 'attbase64<QF>' + file.name;
                    const csseventaddval = new CustomEvent("addinputvaljosn", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(csseventaddval);
                    const cssevent1 = new CustomEvent("passfieldvalue", {
                        detail: new_fulldata
                    });
                    this.dispatchEvent(cssevent1);
                    var pera_file = {
                        base64: base64,
                        fSize: file.size
                    };
                    const passBase64 = new CustomEvent("base64att", {
                        detail: pera_file
                    });
                    this.dispatchEvent(passBase64);
                    this.fsize = this.totalfilesize;
                    this.uploadfilenameAtt = file.name;

                };

                reader.readAsDataURL(file);
            } else {
                this.fileuploadrkAtt = false;
            }
        }
    }

    removeReceiptImage(event) {
        const divId = event.target.getAttribute('id');
        const removeimg = new CustomEvent("removwfile", {
            detail: divId
        });
        this.dispatchEvent(removeimg);
        this.uploadfilename = null;
        this.fileuploadrk = false;

    }
    removeReceiptImage_att(event) {
        const divId = event.target.getAttribute('id');
        this.fileuploadrkAtt = false;
        this.uploadfilenameAtt = null;
        const removeimg_att = new CustomEvent("removwfileatt", {
            detail: divId
        });
        this.dispatchEvent(removeimg_att);

        event.preventDefault();
    }

    @api
    changeMessage() {
        this.closereference();
    }

    sendrequesttoclosereferencefield() {
        try {
            let paramData = true;
            const ev = new CustomEvent('closefield',
                { detail: paramData }
            );
            this.dispatchEvent(ev);
        } catch (error) {
            console.error(error.message);
        }
    }
}