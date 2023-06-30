import { LightningElement, track, api } from 'lwc';
import GetFieldsMetaData from '@salesforce/apex/FormBuilderController.GetFieldsMetaData';
import getFields from '@salesforce/apex/FormBuilderController.getFields';
import ObjName from '@salesforce/apex/FormBuilderController.ObjName';

export default class FieldsSectionComponent extends LightningElement {
    spinner = false;
    spinner1 = false;
    imageSpinner = false;
    pageImageSpinner = false;
    notShowField = true;
    showField = false;
    baseField = [];
    @track objectoneicon;
    @track objecttwoicon;
    @track objectthreeicon;
    @track ObjectName = [];
    @track ObjectName1;
    @track ObjectName2;
    @track ObjectName3;
    @track accfields = [];
    @track confields = [];
    @track oppfields = [];
    @track ContactDetailes = [];
    @track Essential = [];
    @track UploadandConsent = [];
    @track DateandTime = [];
    @track Rating = [];
    @track Other = [];
    @track activeDropZone = false;
    @track StylesProp;
    //dropzone variables
    @track PageList = [];
    storeRemovedField = [];
    @track FormTitle = 'tempvlaue';
    @track FieldList = [];
    @api formid;
    @api randomstr;
    @track storeremoveobj = [];
    fieldsdetail = [];
    //error_popup
    @api error_popup = false;
    @track error_popup1;
    @track message;
    @track obj1st
    @track obj2nd
    @track obj3rd

    connectedCallback() {
        this.error_popup1 = this.error_popup;
        ObjName({
            id: this.formid
        }).then(result => {
            this.ObjectName = result.split(',');
            var Obj1 = '';
            var Obj2 = '';
            if (this.ObjectName.length == 4) {
                this.obj1st = this.ObjectName[0];
                this.obj2nd = this.ObjectName[1];
                Obj1 = this.ObjectName[0].replaceAll('__c', '');
                Obj2 = this.ObjectName[1].replaceAll('__c', '');
                this.ObjectName1 = Obj1.replaceAll('_', ' ');
                this.ObjectName2 = Obj2.replaceAll('_', ' ');
                this.objectoneicon = this.ObjectName[2];
                this.objecttwoicon = this.ObjectName[3];
            } else if (this.ObjectName.length == 6) {
                this.obj1st = this.ObjectName[0];
                this.obj2nd = this.ObjectName[1];
                this.obj3rd = this.ObjectName[2];
                Obj1 = this.ObjectName[0].replaceAll('__c', '');
                Obj2 = this.ObjectName[1].replaceAll('__c', '');
                var Obj3 = this.ObjectName[2].replaceAll('__c', '');
                this.ObjectName1 = Obj1.replaceAll('_', ' ');
                this.ObjectName2 = Obj2.replaceAll('_', ' ');
                this.ObjectName3 = Obj3.replaceAll('_', ' ');
                this.objectoneicon = this.ObjectName[3];
                this.objecttwoicon = this.ObjectName[4];
                this.objectthreeicon = this.ObjectName[5];
            } else if (this.ObjectName.length == 2) {
                this.obj1st = this.ObjectName[0];
                Obj1 = this.ObjectName[0].replaceAll('__c', '');
                this.ObjectName1 = Obj1.replaceAll('_', ' ');
                this.objectoneicon = this.ObjectName[1];
            }
        }).catch(() => {
            this.message = 'Something went wrong in Object Name(A)';
            this.showerrorpopup();
        })

        getFields({
            id: this.formid
        }).then(result => {
            let LabelList = [];
            let obj1 = result[0];
            let obj2 = result[1];
            let obj3 = result[2];
            var innerList = [];
            if (this.fieldsdetail.length > 0) {
                if (result.length >= 1) {
                    for (let i = 0; i < obj1.length; i++) {
                        let label = obj1[i].split('./.')[0];
                        let type = obj1[i].split('./.')[1];
                        let object = obj1[i].split('./.')[2];
                        var check = false;
                        for (let j = 0; j < this.fieldsdetail.length; j++) {
                            if (this.fieldsdetail[j].Name == label && this.fieldsdetail[j].Object == object) {
                                check = true;
                            }
                        }
                        if (check == false) {
                            let labelObj = {
                                Label: label,
                                Type: type,
                                Object: object
                            };
                            innerList.push(labelObj);
                        }
                    }
                    LabelList.push(innerList);
                }
                if (result.length >= 2) {
                    innerList = [];
                    for (let i = 0; i < obj2.length; i++) {
                        let label = obj2[i].split('./.')[0];
                        let type = obj2[i].split('./.')[1];
                        let object = obj2[i].split('./.')[2];
                        let check = false;
                        for (let j = 0; j < this.fieldsdetail.length; j++) {
                            if (this.fieldsdetail[j].Name == label && this.fieldsdetail[j].Object == object) {
                                check = true;
                            }
                        }
                        if (check == false) {
                            let labelObj = {
                                Label: label,
                                Type: type,
                                Object: object
                            };
                            innerList.push(labelObj);
                        }
                    }
                    LabelList.push(innerList);
                }
                if (result.length == 3) {
                    innerList = [];
                    for (let i = 0; i < obj3.length; i++) {
                        let label = obj3[i].split('./.')[0];
                        let type = obj3[i].split('./.')[1];
                        let object = obj3[i].split('./.')[2];
                        let check = false
                        for (let j = 0; j < this.fieldsdetail.length; j++) {
                            if (this.fieldsdetail[j].Name == label && this.fieldsdetail[j].Object == object) {
                                check = true;
                            }
                        }
                        if (check == false) {
                            let labelObj = {
                                Label: label,
                                Type: type,
                                Object: object
                            };
                            innerList.push(labelObj);
                        }
                    }
                    LabelList.push(innerList);
                }
            } else {
                if (result.length >= 1) {
                    innerList = [];
                    for (let i = 0; i < obj1.length; i++) {
                        let label = obj1[i].split('./.')[0];
                        let type = obj1[i].split('./.')[1];
                        let object = obj1[i].split('./.')[2];
                        let labelObj = {
                            Label: label,
                            Type: type,
                            Object: object
                        };
                        innerList.push(labelObj);
                    }
                    LabelList.push(innerList);
                }
                if (result.length >= 2) {
                    innerList = [];
                    for (let i = 0; i < obj2.length; i++) {
                        let label = obj2[i].split('./.')[0];
                        let type = obj2[i].split('./.')[1];
                        let object = obj2[i].split('./.')[2];
                        let labelObj = {
                            Label: label,
                            Type: type,
                            Object: object
                        };
                        innerList.push(labelObj);
                    }
                    LabelList.push(innerList);
                }
                if (result.length == 3) {
                    innerList = [];
                    for (let i = 0; i < obj3.length; i++) {
                        let label = obj3[i].split('./.')[0];
                        let type = obj3[i].split('./.')[1];
                        let object = obj3[i].split('./.')[2];
                        let labelObj = {
                            Label: label,
                            Type: type,
                            Object: object
                        };
                        innerList.push(labelObj);
                    }
                    LabelList.push(innerList);
                }
            }
            this.accfields = LabelList[0];
            if (LabelList.length != 1) {
                this.confields = LabelList[1];
                if (LabelList.length != 2) {
                    this.oppfields = LabelList[2];
                }
            }

        }).catch(() => {
            this.isLoaded = false;
            this.message = 'Something went wrong in Get Fields(A)';
            this.showerrorpopup();
        });

        GetFieldsMetaData()
            .then(result => {
                this.baseField = result;
                for (let i = 0; i < this.baseField.length; i++) {
                    if (this.baseField[i].DataRecord__c == 'QFFULLNAME' || this.baseField[i].DataRecord__c == 'QFNAME' || this.baseField[i].DataRecord__c == 'QFPHONE' || this.baseField[i].DataRecord__c == 'QFEMAIL ID' || this.baseField[i].DataRecord__c == 'QFADDRESS') {
                        this.ContactDetailes.push(this.baseField[i]);
                    }
                    if (this.baseField[i].DataRecord__c == 'QFSHORTTEXT' || this.baseField[i].DataRecord__c == 'QFLONGTEXT' || this.baseField[i].DataRecord__c == 'QFDROPDOWN' || this.baseField[i].DataRecord__c == 'QFRICHTEXT' || this.baseField[i].DataRecord__c == 'QFRADIOBUTTON' || this.baseField[i].DataRecord__c == 'QFCHECKBOX' || this.baseField[i].DataRecord__c == 'QFPRICE' || this.baseField[i].DataRecord__c == 'QFNUMBER') {
                        this.Essential.push(this.baseField[i]);
                    }
                    if (this.baseField[i].DataRecord__c == 'QFSIGNATURE' || this.baseField[i].DataRecord__c == 'QFFILEUPLOAD' || this.baseField[i].DataRecord__c == 'QFTERMSOFSERVICE' || this.baseField[i].DataRecord__c == 'QFLINK' || this.baseField[i].DataRecord__c == 'QFPAGEBREAK') {
                        this.UploadandConsent.push(this.baseField[i]);
                    }
                    if (this.baseField[i].DataRecord__c == 'QFDATE' || this.baseField[i].DataRecord__c == 'QFTIME' || this.baseField[i].DataRecord__c == 'QFDATETIME') {
                        this.DateandTime.push(this.baseField[i]);
                    }
                    if (this.baseField[i].DataRecord__c == 'QFRATING' || this.baseField[i].DataRecord__c == 'QFEMOJIRATING' || this.baseField[i].DataRecord__c == 'QFSCALERATING') {
                        this.Rating.push(this.baseField[i]);
                    }
                    if (this.baseField[i].DataRecord__c == 'QFLOOKUP') {
                        this.Other.push(this.baseField[i]);
                    }
                }
                if(typeof window !== 'undefined') {
                    const stopspinner = new CustomEvent("stopspinner", {
                        detail: Array[0]
                    });
                    this.dispatchEvent(stopspinner);
                }
            }).catch(() => {
                this.message = 'Something went wrong in Get Field Metadata(A)';
                this.showerrorpopup();
            });
    }

    renderedCallback() {
    }

    get hasMainObj() {
        return this.accfields.length != 0;
    }
    get hasSecondChild() {
        return this.oppfields.length != 0;
    }
    get hasFirstChild() {
        return this.confields.length != 0;
    }

    onDragStart(event) {
        try {
            var DraggedLabel = event.target.dataset.record;
            if (DraggedLabel == null) {
                event.preventDefault();
                this.onDragOver();
            } else {                
                event.dataTransfer.setData('fielddivId', JSON.stringify(event.target.dataset));
                this.activeDropZone = true;
                if(typeof window !== 'undefined') {
                    const custEvent = new CustomEvent(
                        'callpasstoparent', {
                            detail: this.activeDropZone
                        });
                    this.dispatchEvent(custEvent);
                }
            }
        } catch (error) {
            this.message = 'Something went wrong in On Drag Start Function';
            this.showerrorpopup();
        }
    }

    onDragOver(event) {
        try {
            this.activeDropZone = false;
            if(typeof window !== 'undefined') {
                const custEvent = new CustomEvent(
                    'callpasstoparent', {
                        detail: this.activeDropZone
                    });
                this.dispatchEvent(custEvent);
            }
            event.preventDefault();
        } catch (error) {
            this.message = 'Something went wrong in On Drag Over Function';
            this.showerrorpopup();
        }
    }

    @api removeField(field) {
        try {
            var name = field.Name;
            var objname = field.Object;
            this.fieldsdetail.push({
                Name: field.Name,
                Object: field.Object
            });
            this.storeRemovedField.push(name);
            this.storeremoveobj = (objname);
            let tempararyArray = [];
            if (objname == this.obj1st) {
                for (let i = 0; i < this.accfields.length; i++) {
                    if (this.accfields[i].Label != name) {
                        tempararyArray.push(this.accfields[i]);
                    }
                }
                this.accfields = tempararyArray;
                tempararyArray = [];
            }
            if (objname == this.obj2nd) {
                for (let i = 0; i < this.confields.length; i++) {
                    if (this.confields[i].Label != name) {
                        tempararyArray.push(this.confields[i]);
                    }
                }
                this.confields = tempararyArray;
                tempararyArray = [];
            }
            if (objname == this.obj3rd) {
                for (let i = 0; i < this.oppfields.length; i++) {
                    if (this.oppfields[i].Label != name) {
                        tempararyArray.push(this.oppfields[i]);
                    }
                }
                this.oppfields = tempararyArray;
            }
        } catch {
            this.message = 'Something went wrong in Remove Field Function';
            this.showerrorpopup();
        }
    }

    @api AddField(name) {
        const index = this.storeRemovedField.indexOf(name);
        if (index != -1) {
            this.storeRemovedField.splice(index, 1);
        }
        getFields({
            id: this.formid
        }).then(result => {
            let LabelList = [];
            for (let i = 0; i < result.length; i++) {
                let innerList = [];
                for (let j = 0; j < result[i].length; j++) {
                    let label = result[i][j].split('./.');
                    let nottakeField = false;
                    for (let k = 0; k < this.storeRemovedField.length; k++) {
                        if (this.storeRemovedField[k] == label[0]) {
                            nottakeField = true;
                        }
                    }
                    if (nottakeField == false) {
                        let labelObj = {
                            Label: label[0],
                            Type: label[1]
                        };
                        innerList.push(labelObj);
                    }
                }
                LabelList.push(innerList);
            }
            this.accfields = LabelList[0];
            if (LabelList.length != 1) {
                this.confields = LabelList[1];
                if (LabelList.length != 2) {
                    this.oppfields = LabelList[2];
                }
            }
        }).catch(() => {
            this.isLoaded = false;
            this.message = 'Something went wrong in Get Fields(A)';
            this.showerrorpopup();
        });
    }

    showerrorpopup() {
        this.template.querySelector('c-errorpopup').errormessagee('Fields Section Component Error', this.message);
    }
}