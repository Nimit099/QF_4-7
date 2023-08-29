import { LightningElement,track,api} from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import CancleIcon from '@salesforce/resourceUrl/cancleIcon';
import cross_gery from '@salesforce/resourceUrl/cross_gery';
export default class ToastComponent extends LightningElement {
    @track type='success';
    @track message;
    @track messageIsHtml=true;
    @track showToastBar_success = false;
    @track showToastBar_error = false;
    @track autoCloseTime = 3000;
    @track icon='';
    cross_gery_img = cross_gery;
    
    @api messagee ;
    
    

    @api
    showToast(type, message, time) {
        try {
            if (type != undefined && message != undefined){
                this.type = type;
                this.message = message;
                
                
                if(this.type == "success"){
                    this.showToastBar_success = true;
                    this.showToastBar_error = false;
                }
                else{
                    this.showToastBar_success = false;
                    this.showToastBar_error = true;
    
                }
    
                setTimeout(() => {
                    this.closeModel();
                }, (time == null || time == undefined) ? this.autoCloseTime : time);
            }
        } catch (error) {
          console.log(error);
        }
    }

    
    closeModel() {
        this.showToastBar_success = false;
        this.showToastBar_error = false;
        this.type = '';
        this.message = '';
    }

    renderedCallback(){
        try {
            Promise.all([
                loadStyle( this, CancleIcon )
            ]);
        } catch (error) {
          console.log(error);
        }
    }
 
    get outerClass() {
        return 'slds-notify slds-notify_toast ';
    }
}