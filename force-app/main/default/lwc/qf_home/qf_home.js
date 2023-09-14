import {
  LightningElement,
  wire,
  track,
  api
} from 'lwc';


import iconsZip from '@salesforce/resourceUrl/Iconfolder';

import Id from '@salesforce/user/Id';
import {
  getRecord
} from 'lightning/uiRecordApi';
import UserNameFIELD from '@salesforce/schema/User.Name';

import records from '@salesforce/apex/QuickFormHome.getFormRecords';
import status from '@salesforce/apex/QuickFormHome.getFormsByStatus';
import deleteform from '@salesforce/apex/QuickFormHome.deleteFormRecord';
import search from '@salesforce/apex/QuickFormHome.searchForms';
import renameform from '@salesforce/apex/QuickFormHome.renameFormRecord';
import {
  NavigationMixin, CurrentPageReference
} from "lightning/navigation";

export default class Qf extends NavigationMixin(LightningElement) {
  PaginationList;

  bNoRecordsFound = true;
  NoRecordsFound = true;
  spinnerDataTable = false;
  deletepopup = false;
  spinnerdelete = false;
  error_toast = true;
  data = false;
  @track activepreview = false;
  @track activehome = true;
  isModalOpen_2;
  renamediv;
  pencheck = false;
  count;
  searchkey;
  formId;
  formname;
  isOpenRenameForm;
  indexval = 1;
  outsideClick;
  keyCode;
  isModalOpen = false;


  searchicon = iconsZip + '/Iconfolder/searchBoxIcon.jpg';
  addicon = iconsZip + '/Iconfolder/addIcon.png';
  previewicon = iconsZip + '/Iconfolder/previewIcon.png';
  logo = iconsZip + '/Iconfolder/Quickformlogo.png';
  feedbackIcon = iconsZip + '/Iconfolder/feedbackIcon.png';
  helpIcon = iconsZip + '/Iconfolder/helpIcon.png';
  cross = iconsZip + '/Iconfolder/cross.png';
  right = iconsZip + '/Iconfolder/right.png';
  bin = iconsZip + '/Iconfolder/bin.png';
  editpen = iconsZip + '/Iconfolder/editpen.png';

  @api error_popup = false;
  @track error_popupNewValue;
  @track message;

  @wire(CurrentPageReference)
  setCurrentPageReference(currentPageReference) {
    this.currentPageReference = currentPageReference;
    if (currentPageReference.state) {
      if (currentPageReference.attributes.apiName == 'MVQF__Home') {
        this.indexval = 1;
        this.fetchRecords();
        this.searchkey = '';
      }
    }
  }

  @track currentUserName;
  @wire(getRecord, {
    recordId: Id,
    fields: [UserNameFIELD]
  })
  currentUserInfo({

    data
  }) {
    if (data) {
      this.currentUserName = data.fields.Name.value;
    }
  }


  connectedCallback() {
    try {
      this.error_popupNewValue = this.error_popup;
      this.spinnerDataTable = true;
      this.fetchRecords();
    } catch (error) {
      console.log('error');
    }
  }

  fetchRecords() {
    try {
      records()
        .then(result => {
          this.indexval = 1;
          this.count = result.length;
          if (this.count > 0) {
            this.PaginationList = result;
            this.data = true;
            this.bNoRecordsFound = true;
          } else {
            this.bNoRecordsFound = false;
          }
          this.spinnerDataTable = false;
        }).catch(() => {
          this.spinnerDataTable = false;
        })
    } catch (error) {
      this.spinnerDataTable = false;
      this.message = 'Something Went Wrong In Home Page';
      this.showerror();
    }
  }

  search(event) {
    this.spinnerDataTable = true;
    this.searchkey = event.target.value;
    try {
      search({
        searchkey: this.searchkey
      }).then(result => {
        this.indexval = 1;
        this.spinnerDataTable = false;
        this.count = result.length;
        if (this.count > 0) {
          this.PaginationList = result;
          this.data = true;
          this.bNoRecordsFound = true;
        } else {
          this.bNoRecordsFound = false;
        }
      }).catch(() => {

      });
    } catch (e) {
      this.spinnerDataTable = false;
      this.message = 'Something Went Wrong In Home Page' + e.message;
      this.showerror();
    }
  }


  changestatus(event) {
    this.formId = event.target.dataset.id;
    this.spinnerDataTable = true;
    try {
      status({
        id: this.formId,
        searchkey: this.searchkey
      }).then(result => {
        this.PaginationList = result;
        this.spinnerDataTable = false;
      }).catch(() => {

      });
    } catch (e) {
      this.spinnerDataTable = false;
      this.message = 'Something Went Wrong In Home Page' + e.message;
      this.showerror();
    }
  }

  handleSelectAction(event) {
    try {
      if (event.detail.value == 'Delete') {
        this.deletepopup = true;
        this.formId = event.target.dataset.id;
        this.spinnerdelete = true;
      } else if (event.detail.value == 'Edit') {
        this.formId = event.target.dataset.id;
        let FormName = event.target.dataset.name;
        let cmpDef = {
          componentDef: "MVQF:formBuilder",
          attributes: {
            ParentMessage: this.formId != "" ? this.formId : "No Record Created",
            FormName: FormName != "" ? FormName : "No Name Given"
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
    } catch (e) {
      this.spinnerDataTable = false;
      this.message = 'Something Went Wrong In Home Page' + e.message;
      this.showerror();
    }

  }

  rename(event) {
    this.formname = event.target.value;
    this.keyCode = 13;
    this.error_toast = false;
  }

  cancleRenameForm(event) {
    try {
      this.renamediv = true;
      this.pencheck = false;
      document.removeEventListener('click', this.outsideClick);
      if (event.target.dataset.id != this.formId) {
        this.template.querySelector("div[data-name =" + this.formId + "]").style.display = 'none';
        this.template.querySelector("lightning-formatted-text[data-id =" + this.formId + "]").style.display = 'block';
      }
    } catch (error) {
      this.message = 'Something Went Wrong In Home Page';
      this.showerror();
    }
  }


  insideClick(event) {
    event.stopPropagation();
    return false;
  }

  renameForm() {
    try {
      let nameCmp = this.template.querySelector(".rename_input");
      if (this.keyCode === 13) {
        let FName = nameCmp.value;
        if (FName.length <= 80) {
          if (this.formname.length > 0 && this.formname.replaceAll(' ', '').length > 0) {
            this.spinnerDataTable = true;
            this.error_toast = false;
            renameform({
              id: this.formId,
              rename: this.formname,
              searchkey: this.searchkey
            }).then(result => {
              this.PaginationList = result;
              this.template.querySelector("div[data-name =" + this.formId + "]").style.display = 'none';
              this.template.querySelector("lightning-formatted-text[data-id =" + this.formId + "]").style.display = 'block';
              this.isOpenRenameForm = false;
              this.spinnerDataTable = false;
              this.renamediv = true;
              this.pencheck = false;
            }).catch(() => {
              this.message = 'Something Went Wrong In Home Page';
              this.showerror();
              this.spinnerDataTable = false;
            })
          } else {
            this.error_toast = true;
          }
        } else {
          this.error_toast = true;
          this.template.querySelector('c-toast-component').showToast('error', 'Input must be no longer than 80 characters.', 3000);
        }
      }
    } catch (error) {
      this.message = 'Something Went Wrong In Home Page';
      this.showerror();
      this.spinnerDataTable = false;
    }
  }

  new_rename(event) {
    try {
      this.formId = event.currentTarget.dataset.id;
      this.formname = event.currentTarget.dataset.name;
      this.pencheck = true;
      this.renamediv = true;
      this.template.querySelector("lightning-formatted-text[data-id =" + event.currentTarget.dataset.id + "]").style.display = 'none';
      this.template.querySelector("div[data-name =" + event.currentTarget.dataset.id + "]").style.display = 'flex';
      if (this.pencheck == true) {
        this.template.querySelector("span[data-id =" + event.currentTarget.dataset.id + "]").style.display = 'none';
      }
      document.addEventListener('click', this.outsideClick = this.cancleRenameForm.bind(this));
      event.stopPropagation();
      return false;
    } catch (error) {
      this.message = 'Something Went Wrong In Home Page';
      this.showerror();
    }
  }

  showpen(event) {
    try {
      if (this.pencheck == false) {
        document.addEventListener('click', this.outsideClick = this.cancleRenameForm.bind(this));
        this.template.querySelector("span[data-id =" + event.currentTarget.dataset.id + "]").style.display = 'block';
      }
    } catch (error) {
      console.log('error');
    }
  }

  hidepen(event) {
    try {
      this.template.querySelector("span[data-id =" + event.currentTarget.dataset.id + "]").style.display = 'none';
      if (this.renamediv == false) {
        this.template.querySelector("div[data-name =" + this.formId + "]").style.display = 'none';
        this.template.querySelector("lightning-formatted-text[data-id =" + this.formId + "]").style.display = 'block';
      }
    } catch (error) {
      console.log('error');
    }
  }

  deleteyes() {
    this.deletepopup = false;
    this.spinnerDataTable = true;
    try {
      deleteform({
        id: this.formId,
        searchkey: this.searchkey
      }).then(result => {
        this.PaginationList = result;
        this.count -= 1;
        if (this.count === 0) {
          this.bNoRecordsFound = false;
        }
        this.spinnerdelete = false;
        this.spinnerDataTable = false;
        let toast_error_msg = 'Form is successfully deleted';
        this.error_toast = true;
        this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);
      }).catch(() => {
        this.message = 'Something Went Wrong In Home Page';
        this.showerror();
      });

    } catch (error) {
      this.spinnerDataTable = false;
      let toast_error_msg = 'Error while deleting the form, Please try again later';
      this.error_toast = true;
      this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
    }
  }

  deleteno() {
    this.deletepopup = false;
  }

  openModal() {
    this.isModalOpen = true;
  }

  modalpopupclose() {
    this.isModalOpen = false;
  }

  key(event) {
    this.keyCode = event.keyCode;
    this.renameForm();
  }

  get index() {
    if (this.indexval > this.count) {
      this.indexval = 1;
    }
    return this.indexval++;
  }

  onpreview(event) {
    try {
      this.formId = event.currentTarget.dataset.id;
      let cmpDef = {
        componentDef: "MVQF:previewFormCmp",
        attributes: {
          nosubmission: true,
          activepreviews: true,
          formid: this.formId != "" ? this.formId : "No Record Created",
        }
      };
      let encodedDef = btoa(JSON.stringify(cmpDef));
      this[NavigationMixin.Navigate]({
        type: "standard__webPage",
        attributes: {
          url: "/one/one.app#" + encodedDef
        }
      });
    } catch (error) {
      console.log('error');
    }
  }
  @track showquickbot = false;
  quickbot() {
    if (this.showquickbot == true) {
      this.showquickbot = false;
    } else if (this.showquickbot == false) {
      this.showquickbot = true;
    }
  }
  modalbotclose() {
    this.showquickbot = false;
  }
  sendsuccesspopup() {
    try {
      this.error_toast = true;
      let toast_error_msg = 'Message Sent Successfully';
      this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);
    } catch (error) {
      console.log('error');
    }

  }
  senderrorpopup() {
    try {
      this.error_toast = true;
      let toast_error_msg = 'Email was not Sent. Something went Wrong, Please try again';
      this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
    } catch (error) {
      console.log('error');
    }
  }

  userconfig() {
    try {
      let cmpDef = {
        componentDef: "MVQF:qf_guide2"
      };
      let encodedDef = btoa(JSON.stringify(cmpDef));
      this[NavigationMixin.Navigate]({
        type: "standard__webPage",
        attributes: {
          url: "/one/one.app#" + encodedDef
        }
      });
    } catch (error) {
      console.log('error');
    }
  }

  @api showerror() {
    try {
      this.error_popupNewValue = true;
      let errordata = {
        header_type: 'Test Thank You page',
        Message: this.message
      }
      const showpopup = new CustomEvent('showerrorpopup', {
        detail: errordata
      });
      this.dispatchEvent(showpopup);
    } catch (error) {
      console.log('error');
    }
  }

}