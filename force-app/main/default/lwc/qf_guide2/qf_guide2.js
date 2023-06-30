import { LightningElement, track } from 'lwc';
import getSites from '@salesforce/apex/qf_guide2_Controller.getSites';
import getSettingData from '@salesforce/apex/qf_guide2_Controller.getSettingData';
import saveSecureUrl from '@salesforce/apex/qf_guide2_Controller.saveSecureUrl';
import assignPermissionSet from '@salesforce/apex/qf_guide2_Controller.assignPermissionSet';
import getUserEmail from '@salesforce/apex/qf_guide2_Controller.getUserEmail';
import updateUserEmail from '@salesforce/apex/qf_guide2_Controller.updateUserEmail';
  
export default class Qf_guide2 extends LightningElement {
  @track isModalOpen = false;
  @track issiteModelopen = false;
  @track sites = [];
  @track selectedSite;
  @track preselectedSiteName = '';
  @track selectedSiteName = '';
  @track spinnerdatatable = false;
  error_toast = true;
  @track message;
  @track guestuseremailid;
  guId;
  @track sharingrulemodal = false;
  connectedCallback() {
    this.spinnerdatatable = true;
    this.getSiteDetails();
  }

  getSiteDetails() {
    getSites()
      .then(result => {
        var tempSite = [];
        result.forEach(siteval => {
          tempSite.push({
            label: siteval.MasterLabel,
            value: siteval.Id,
            guestuserId: siteval.GuestUserId});
        });
        this.sites = tempSite;
        this.getSettinsDataValue();
      }).catch(() => {
        this.spinnerdatatable = false;
        this.message = 'Something went wrong in Get Site Details';
        this.showerrorpopup();
      });
  }

  getSettinsDataValue() {
    getSettingData()
      .then(data => {
        if(data != null || data != undefined) {
          this.selectedSite = data.siteId;
          this.guId = data.userId;
          this.getuseremailid(this.guId);
        }
        this.spinnerdatatable = false;
      }).catch( () => {
        this.spinnerdatatable = false;
        this.message = 'Something went wrong in Get Sites(A)';
        this.showerrorpopup();
      });
  }

  handleSave() {
    if(this.sites.length > 0){
    this.spinnerdatatable = true;
      const comboboxField = this.template.querySelector('[data-id="sitesave"]');
          const comboboxValue = comboboxField.value;
          const selectedOption = this.sites.find(option => option.value === comboboxValue).label;
          this.selectedSiteName = selectedOption;
      
    if (this.selectedSite) {
      saveSecureUrl({selectedSiteid: this.selectedSite})
        .then(result => {
          this.guestuseremailid = result;
          this.spinnerdatatable = false;
          this.error_toast = true;
          // this.template.querySelector('c-toast-component').showToast('success', 'Successfully Inserted', 3000);
          this.template.querySelector('.rkclass').disabled = false;
        }).catch(() => {
          this.spinnerdatatable = false;
          this.error_toast = true;
          this.template.querySelector('c-toast-component').showToast('error', 'Uh oh, something went wrong', 3000);
        });
      assignPermissionSet({oldselectedSiteName : this.preselectedSiteName,
        newselectedSiteName : this.selectedSiteName
      }).then(() => {
        this.spinnerdatatable = false;
        this.error_toast = true;
        this.template.querySelector('c-toast-component').showToast('success', 'Successfully Assign Permission Set To Selected Site User', 3000);
          this.template.querySelector('.rkclass').disabled = false;
      }).catch(() => {
        this.spinnerdatatable = false;
        this.error_toast = true;
        this.template.querySelector('c-toast-component').showToast('error', 'Uh oh, something went wrong', 3000);
      });
    }
  }
    else{
      this.spinnerdatatable = false;
            this.error_toast = true;
            this.template.querySelector('c-toast-component').showToast('error', 'Please select a site or activate a site.', 3000);

    }
  }


  
  handleSiteChange(event) {
    if(this.sites.length == 0 ){
     this.template.querySelector('c-toast-component').showToast('error', 'Uh First Create a Site or Active a Sites', 3000);
    }else{

    this.selectedSite = event.detail.value;
    const selectedLabel = this.sites.find(option => option.value === this.selectedSite).label;
    const selecteduserId = this.sites.find(option => option.value === this.selectedSite).guestuserId;
    this.preselectedSiteName = this.selectedSiteName;
    this.selectedSiteName = selectedLabel;
    this.guId = selecteduserId;
      this.template.querySelector('.rkclass').disabled = true;
  }
  }

  renderedCallback() {
    this.template.querySelectorAll("a").forEach(element => {
      element.addEventListener("click", evt => {
        let target = evt.currentTarget.dataset.tabId;

        this.template.querySelectorAll("a").forEach(tabel => {
          if (tabel === element) {
            tabel.classList.add("active-tab");
          } else {
            tabel.classList.remove("active-tab");
          }
        });
        this.template.querySelectorAll(".tab").forEach(tabdata => {
          tabdata.classList.remove("active-tab-content");
        });
        this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
      });
    });
  }


  closesiteModel() {
    this.isModalOpen = false;
    this.sharingrulemodal = false;
    const target = "tab1";
    this.template.querySelectorAll("a").forEach(tabel => {
      tabel.classList.remove("active-tab");
    });
    this.template.querySelectorAll(".tab").forEach(tabdata => {
      tabdata.classList.remove("active-tab-content");
    });
    this.template.querySelector('[data-tab-id="' + target + '"]').classList.add("active-tab");
    this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
  }

  openModel(event) {
    if (event.currentTarget.dataset.name == 'SharingRule') {
      this.sharingrulemodal = true;
    } else {
    this.isModalOpen = true;
  }
  }

  openCreateEditModel() {
    this.issiteModelopen = true;
  }

  closeModel() {
    this.issiteModelopen = false;

    const target = "tab1";
    this.template.querySelectorAll("a").forEach(tabel => {
      tabel.classList.remove("active-tab");
    });
    this.template.querySelectorAll(".tab").forEach(tabdata => {
      tabdata.classList.remove("active-tab-content");
    });
    this.template.querySelector('[data-tab-id="' + target + '"]').classList.add("active-tab");
    this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
  }

  opensite(event) {
    try {
      if (event.currentTarget.dataset.name == 'SharingRule') {
        const baseUrl = window.location.origin + '/lightning/setup/SecuritySharing/home';
        window.open(baseUrl, '_blank');
      } else {
      const baseUrl = window.location.origin + '/lightning/setup/CustomDomain/home';
      window.open(baseUrl, '_blank');
      }
    } catch (error) {
      this.message = 'Something went wrong in Open Site Function';
      this.showerrorpopup();
    }
  }
  tabing() {
    const target = "tab1";
    this.template.querySelectorAll("a").forEach(tabel => {
      tabel.classList.remove("active-tab");
    });
    this.template.querySelectorAll(".tab").forEach(tabdata => {
      tabdata.classList.remove("active-tab-content");
    });
    this.template.querySelector('[data-tab-id="' + target + '"]').classList.add("active-tab");
    this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
  }

  showerrorpopup() {
    this.template.querySelector('c-errorpopup').errormessagee("User Configuration Page", this.message);
  }

  getuseremailid(uidguest) {
    getUserEmail({uid: uidguest})
    .then(result => {
      var tempid = result;
      this.guestuseremailid = tempid;
      this.spinnerdatatable = false;
    }).catch(() => {
      this.spinnerdatatable = false;
      this.message = 'Something went wrong in Get Site Details';
      this.showerrorpopup();
    });
  }
  isEmailValid(email) {
    // Regular expression to validate email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

  handleemailChange(event) {
    this.guestuseremailid = event.detail.value;
  }

  handleSaveValid(){
    let userid = this.guestuseremailid;
    if (userid != null && userid != '') {
      let isValid = this.isEmailValid(userid);
      if (isValid) {
        this.handleSaveemail();
      } else {
        this.error_toast = true;
        this.template.querySelector('c-toast-component').showToast('error', 'Please Enter a valid Email Address.', 3000);
      }
    }else{
      this.error_toast = true;
      this.template.querySelector('c-toast-component').showToast('error', 'Email address field can not be empty.', 3000);
    } 
  }
  handleSaveemail() {
    this.spinnerdatatable = true;
    updateUserEmail({newEmail: this.guestuseremailid,userId: this.guId})
        .then(() => {
          this.spinnerdatatable = false;
          this.error_toast = true;
          this.template.querySelector('c-toast-component').showToast('success', 'Email Address Added Successfully', 3000);
        }).catch(() => {
          this.spinnerdatatable = false;
          this.error_toast = true;
          this.template.querySelector('c-toast-component').showToast('error', 'Uh oh, something went wrong', 3000);
        });
    
  }

  
}