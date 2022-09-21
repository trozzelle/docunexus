<template>
<div class="container">         
    <div v-if="!$root.loggedIn">
        <login></login>
    </div>
    <div v-else>
        <div class="row mt-3 mb-2 border-bottom">  
            <div class="col-8">
                <h1 class="display-1"><i class="fas fa-fw fa-user-check text-success"></i> Voter match</h1>
            </div>
            <div class="col-4">                 
                 <router-link tag="button" type="button" to="/home" class="mt-1 btn btn-primary btn-sm float-right"><i class="fas fa-arrow-left"></i> Back to home</router-link>
            </div>
        </div>        
        <div v-show="step == 1">
            <div class="row">
                <div class="col">
                    <h4 class="display-4"><span class="badge-success badge">1</span> Upload a .csv file for matching</h4>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <div class="input-group">
                        <div class="custom-file">
                            <input type="file" :key="key" accept=".csv" class="custom-file-input" ref="fileUpload" id="inputGroupFile" v-on:change="setFile">
                            <label class="custom-file-label" for="inputGroupFile">
                                <span v-if="!file.name">Choose a file to load</span>
                                <span v-else>{{file.name}}</span>
                            </label>
                        </div>
                        <div class="input-group-append">
                            <button class="btn btn-primary" v-on:click="loadFile()" :disabled="!file.name" type="button" id="inputGroupFileAddon"><i class="fas fa-upload"></i> Load</button>
                        </div>                
                    </div>
                </div>
            </div>            
        </div>

        <div v-show="step == 2">            
            <div class="row">
                <div class="col-8">
                    <h4 class="display-4"><span class="badge-success badge">2</span> Map file columns to lookup fields</h4>
                </div>
                <div class="col pt-1">
                    <button class="float-right btn btn-primary" v-on:click="startOver()" type="button"><i class="fas fa-redo"></i> Start over</button>
                </div>
            </div>
            <div class="row">                
                <div class="col">
                    <div class="mt-1 mb-2 custom-control custom-checkbox">
                        <input type="checkbox" class="custom-control-input" id="headerRow" v-model="autoMapChecked" v-on:change="doSearch()">
                        <label class="custom-control-label text-primary" for="headerRow">Auto-map fields using the header row</label>
                    </div>
                </div>
            </div>
            <div class="row" v-if="autoMapAlert">
                <div class="col">
                    <div class="alert alert-primary">
                        <i class="fas fa-info-circle"></i> Some fields have been mapped automatically, please check them for accuracy before continuing.
                    </div>
                </div>
            </div>
            <div class="row" style="overflow: auto">     
                <div class="col">           
                    <table class="table">
                        <thead>
                            <tr>
                                <th class="mapping" :key=k :class="{'mapped': autoMapAlert && autoMap[idx].data > '' && autoMapResult[idx].data.id == autoMap[idx].data.id}" v-for="(f, k, idx) in upload.preview[0]" scope="col">                                    
                                    <select v-on:change="mapSelect($event.target.value, idx)" class="custom-select">
                                        <option value="">Not used</option>
                                        <option :key="k1" :disabled="inMap(m.id)" v-for="(m, k1) in mainMapping" :selected="autoMap[idx].data.id == m.id" :value="JSON.stringify(m)">{{m.name}}</option>
                                    </select>                                                                            

                                    <select 
                                        v-model="autoMap[idx].data.type"
                                        v-if="autoMap[idx].data.typeValue == 'OTHER_ID_TYPE_1' || autoMap[idx].data.typeValue == 'OTHER_ID_TYPE_2'" 
                                        class="custom-select">
                                        <option value="">Select an ID type</option>
                                        <option :key="k2" v-for="(i, k2) in idType" :selected="autoMap[idx].data.value == i.code" :value="i.code">{{i.description}}</option>         
                                    </select>
                                    <select 
                                        v-model="autoMap[idx].data.type"
                                        v-if="autoMap[idx].data.typeValue == 'ECONTACT_TYPE_1' || autoMap[idx].data.typeValue == 'ECONTACT_TYPE_2'" 
                                        class="custom-select">
                                        <option value="">Select an e-Contact type</option>
                                        <option :key="k3" v-for="(i, k3) in econtactType" :selected="autoMap[idx].data.value == i.code" :value="i.code">{{i.description}}</option>         
                                    </select>
                                    <select 
                                        v-model="autoMap[idx].data.type"
                                        v-if="autoMap[idx].data.typeValue == 'EMAIL_TYPE_CODE_1' || autoMap[idx].data.typeValue == 'EMAIL_TYPE_CODE_2'" 
                                        class="custom-select">
                                        <option value="">Select an email type</option>
                                        <option :key="k4" v-for="(e, k4) in emailType" :value="e.code">{{e.description}}</option>            
                                    </select>
                                    <select
                                        v-model="autoMap[idx].data.type" 
                                        v-if="autoMap[idx].data.typeValue == 'TELEPHONE_TYPE_CODE_1' || autoMap[idx].data.typeValue == 'TELEPHONE_TYPE_CODE_2' || autoMap[idx].data.typeValue == 'TELEPHONE_TYPE_CODE_3'" 
                                        class="custom-select">
                                        <option value="">Select a telephone type</option>
                                        <option :key="k5" v-for="(p, k5) in phoneType" :value="p.code">{{p.description}}</option>            
                                    </select>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr :key="r" v-for="(row, r) in upload.preview">
                                <td :key="i" v-for="(item, i) in row" scope="col">
                                    {{item}}
                                </td>
                            </tr>
                        </tbody>
                    </table>   
                </div>                         
            </div>       
            <div class="row">
                <div class="col mt-2">
                    <button v-if="!submitting" class="btn btn-primary" v-on:click="submitBatch()" :disabled="mappingInvalid" type="button"><i class="fas fa-upload"></i> Submit for matching</button>
                    <button v-if="submitting" class="btn btn-primary" disabled="disabled" type="button"><i class="fas fa-sync fa-spin"></i> Please wait while your file is submitted...</button>
                </div>
            </div>     
        </div>
        <div v-show="step == 3">
            <div class="row">
                <div class="col-8">
                    <h4 class="display-4"><span class="badge-primary badge">3</span> Your batch was submitted successfully</h4>
                </div>
                <div class="col pt-1">
                    <button class="float-right btn btn-primary" v-on:click="startOver()" type="button"><i class="fas fa-redo"></i> Start over</button>
                </div>
            </div>
            <div class="row">
                <div class="col mt-2">
                    <div role="alert" class="alert alert-success">
                        <i class="fas fa-lg fa-check" aria-hidden="true"></i> The file {{upload.file}} was submitted for batch matching.  It will be available in your <a href="./history/">matching history</a> for download shortly.
                    </div> 
                </div>
            </div>
        </div>  
    </div>    
</div>
</template>
<script>
import Fuse from 'fuse.js';
export default {   
    data: function() {
        return {      
            loading: false,
            step: 1,                
            submitting: false,
            file: {},            
            key: 0,
            upload: {
                file: '',
                header: false,
                mapping: false,
                preview: []
            },
            mapping: [
                {name: 'Last name', id: 'last_name', size: '50', show: true}
                ,{name: 'First name', id: 'first_name', size: '50', show: true}
                ,{name: 'Middle name', id: 'middle_name', size: '50', show: true}
                ,{name: 'Suffix', id: 'name_suffix', size: '10', show: true}
                /*,{name: 'Residence number', id: 'residence_num', size: '10', show: true}
                ,{name: 'Residence fractional address', id: 'residence_halfnum', size: '10', show: true}
                ,{name: 'Residence apartment', id: 'residence_aptnum', size: '15', show: true}
                ,{name: 'Residence pre street direction', id: 'residence_pre_street_dir', size: '10', show: true}
                ,{name: 'Residence street name', id: 'residence_street_name', size: '70', show: true}
                ,{name: 'Residence post street direction', id: 'Residence_post_street_dir', size: '10', show: true}
                ,{name: 'Residence city', id: 'residence_city', size: '50', show: true}
                ,{name: 'Residence zipcode', id: 'residence_zip', size: '5', show: true}
                ,{name: 'Residence zip+4', id: 'residence_zip_4', size: '4', show: true}*/
                //,{name: 'Mailing address 1', id: 'mailing_address_1', size: '100', show: true}
                ,{name: 'Street address', id: 'street_address_1', size: '100', show: true}
                ,{name: 'City', id: 'residence_city', size: '50', show: true}
                ,{name: 'State', id: 'residence_state', size: '50', show: true}
                ,{name: 'Zipcode', id: 'residence_zip', size: '5', show: true}
                ,{name: 'Zip+4', id: 'residence_zip_4', size: '4', show: true}
                ,{name: 'Mailing address', id: 'mailing_address_1', size: '100', show: true}
                ,{name: 'Mailing city', id: 'mailing_address_2', size: '50', show: true}                
                ,{name: 'Mailing state', id: 'mailing_address_3', size: '50', show: true}
                ,{name: 'Mailing zip', id: 'mailing_address_4', size: '5', show: true}                
                ,{name: 'Date of birth', id: 'date_of_birth', size: '8', dateFmt: '%Y%m%d', show: true}
                ,{name: 'Age', id: 'birth_year', size: '3', show: true}
                ,{name: 'Gender', id: 'gender', size: '1', show: true}
                ,{name: 'Enrollment', id: 'enrollment', size: '3', show: true}
                //,{name: 'Other party', id: 'other_party', size: '30', show: true}
                ,{name: 'County', id: 'county_code', size: '2', lookup: 'county', show: true}
                ,{name: 'Election district', id: 'election_district', size: '3', show: true}
                ,{name: 'Legislative district', id: 'legislative_district', size: '3', show: true}
                ,{name: 'Town/city', id: 'town_city', size: '30', show: true}
                ,{name: 'Ward', id: 'ward', size: '3', show: true}
                ,{name: 'Congressional district', id: 'congressional_district', size: '3', show: true}
                ,{name: 'Senate district', id: 'senate_district', size: '3', show: true}
                ,{name: 'Assembly district', id: 'assembly_district', size: '3', show: true}
              /*  ,{name: 'Last voted date', id: 'last_voted_date', size: '8', dateFmt: 'Ymd', show: true}
                ,{name: 'Last voted year', id: 'last_voted_year', size: '4', dateFmt: 'Y', show: true}
                ,{name: 'Last voted county', id: 'last_voted_county', size: '2', lookup: 'county', show: true}
                ,{name: 'Last registered address', id: 'previous_address', size: '100', show: true}
                ,{name: 'Last registered name', id: 'last_registered_name', size: '150', show: true}
                ,{name: 'County voter reg. number', id: 'county_voter_reg_num', size: '50', show: true}
                ,{name: 'Application date', id: 'application_date', size: '8', dateFmt: 'Ymd', show: true}
                ,{name: 'Application source', id: 'application_source', size: '10', show: true}
                ,{name: 'Identification required flag', id: 'id_required', size: '1', show: true}
                ,{name: 'Identification required met', id: 'id_required_met', size: '1', show: true}                
                ,{name: 'Voter status reason', id: 'voter_status_reason', size: '15', show: true}
                ,{name: 'Voter status', id: 'voter_status', size: '10', show: true}
                ,{name: 'Inactive date', id: 'inactive_date', size: '8', dateFmt: 'Ymd', show: true}
                ,{name: 'Purged date', id: 'purge_date', size: '8', dateFmt: 'Ymd', show: true}*/
                ,{name: 'Email address', id: 'email', size: '50', show: true}
                ,{name: 'Telephone', id: 'telephone', size: '50', show: true}
            ],
            searchKeys: ['name', 'id'],
            autoMap: [],
            autoMapDefault: [],
            autoMapResult: [],
            autoMapChecked: false,
            autoMapAlert: false
        }
    },
    methods: {
        setFile: function() {
            this.file = this.$refs.fileUpload.files[0];
            this.key = this.key + 1;        
        },
        mapSelect: function(value, key) {     
            var v = {};
            if (value) {
                v = JSON.parse(value);
            }
            this.autoMap[key].data = v;
        },
        inMap: function(id) {            
            return this.autoMap.filter(n => {
                return n.data.id == id;
            }).length || false;
        }, 
        loadFile: function() {
            var _this = this;
            var formData = new FormData();            
            formData.append('file', this.file);
            formData.append("token", JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
            this.axios.post(this.$root.baseURI+'/match/file.upload', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(response => {             
                 _this.$root.handleTokenError(response.data);                                                  
                if (response.data.error) {
                    this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    this.step = 2;
                    this.upload = response.data;                             
                    for (var key in this.upload.preview[0]) {
                        this.autoMap.push({key: key, data: ''});
                    }
                    this.autoMapDefault = JSON.parse(JSON.stringify(this.autoMap));  
                }
            }).catch(error => {
                this.$root.setAlert(true, error, 'alert-danger');
                return;
            });
        },
        doSearch: function() {
            if (this.autoMapChecked) {
                var options = {
                    keys: ['name', 'id'],
                    threshold: 0.2
                };
                var fuse = new Fuse(this.mapping, options);                  
                var header = this.upload.preview[0]; //First row of results              
                var result = []; 
                var anyMatch = false;   
                var _this = this;            
                for (var key in header) {                
                    //Get the array of matches via the fuse fuzzy lookup
                    result = fuse.search(header[key]);                                                             
                    //Get the array key we're auto-mapping
                    var e = _this.autoMap.find(function(a) {
                        return a.key == key;
                    });                         
                    e.data = '';
                    //Loop through the fuzzy match results
                    for (var j = 0; j < result.length; j++) {                           
                        //If the result doesn't exist in the autoMap array, add it                           
                        if (!_this.inMap(result[j].item.id)) {                            
                            //Add the data from the mapping object
                            e.data = _this.mapping.find(function(m) {
                                return m.id == result[j].item.id;
                            });                                                                        
                            anyMatch = true;
                            break;
                        }                        
                    }                                
                    result = [];                                            
                }
                if (anyMatch) {                    
                    this.autoMapAlert = true;
                    this.autoMapResult = JSON.parse(JSON.stringify(this.autoMap));
                }
            } else {
                this.autoMap = JSON.parse(JSON.stringify(this.autoMapDefault));
                this.autoMapResult = JSON.parse(JSON.stringify(this.autoMapDefault));
                this.autoMapAlert = false;
            }
        },
        submitBatch: function() {
            var _this = this;
            this.submitting = true;
            var map = {};
            for (var i = 0; i < this.autoMap.length; i++) {
                if (this.autoMap[i].data > '') {
                    map[this.autoMap[i].key] = this.autoMap[i].data;
                }
            }            
            var formData = new FormData();
            formData.append('userid', this.$root.user.userid);
            formData.append('file', this.file);
            formData.append('map', JSON.stringify(map));
            formData.append('header', this.autoMapChecked);   
            formData.append("token", JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
            this.axios.post(this.$root.baseURI+'/match/file.map', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(response => {                
                 _this.$root.handleTokenError(response.data);        
                this.submitting = false;                                
                if (response.data.error) {
                    this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    this.step = 3;
                }
            }).catch(error => {
                this.$root.setAlert(true, error, 'alert-danger');
                return;
            });
        },
        startOver: function() {
            this.file = {};
            this.upload = {
                file: '',
                header: false,
                mapping: false,
                preview: []
            };
            this.step = 1;
            this.autoMap = [];
            this.autoMapDefault = [];
            this.autoMapResult = [];
            this.autoMapChecked = false;
            this.autoMapAlert = false;
        }
    },
    computed: {
        mainMapping: function() {
            return this.mapping.filter(n => {
                return n.show === true;
            });
        },
        mappingInvalid: function() {
            return JSON.stringify(this.autoMap) == JSON.stringify(this.autoMapDefault);
        }     
    }
}
</script>
<style scoped>
.mapped {
    background-color: #cce5ff;
}
.table thead th {
    vertical-align: top;
}
.mapping, .mapping  select{
    width: 230px;   
}

.custom-control-label {
    font-size: 1.25rem;
}

.custom-control-label::before, 
.custom-control-label::after {
    top: .45rem;
    width: 1.25rem;
    height: 1.25rem;
}
</style>