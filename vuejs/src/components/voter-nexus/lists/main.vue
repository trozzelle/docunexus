<template>
<div class="container main">         
    <div v-if="!$root.loggedIn">
        <login></login>
    </div>
    <div v-else>    
        <div class="row mt-3 mb-2 border-bottom">
            <div class="col-8">
                <h1 class="display-1">
                   <i class="fas fa-fw fa-list text-success"></i> Analyze and edit
                </h1>                
            </div>  
            <div class="col-4">
                <router-link tag="button" type="button" to="/home" class="mt-1 btn btn-primary btn-sm float-right"><i class="fas fa-arrow-left"></i> Back to home</router-link>
            </div>
        </div>
        <transition name="fade" mode="out-in">
            <div class="mt-2" v-if="mode == 'default'" key="default">
                <div class="row p-2">
                    <div class="col-8">
                        <h3 class="display-3"><i class="fad fa-bullseye-arrow"></i> My targets</h3>                                    
                    </div>
                    <div class="col-4">                        
                        <button type="button" v-on:click="resetList('newList');" class="btn btn-sm btn-primary float-right"><i class="fas fa-bullseye"></i> Create a new target</button>                        
                    </div>
                </div>
                <div v-if="!lists.length">
                    <h4>You haven't created any targets, yet.</h4>                    
                </div>
                <div v-else>                    
                    <ul class="list-group">
                        <li class="list-group-item" :key="key" v-for="(l, key) in lists">
                            <div class="row">                                
                                <div class="col-8">                                                                   
                                    <strong>{{l.list_name}}</strong>
                                    <div>{{parseInt(l.list_count).toLocaleString()}} record<span v-if="l.list_count != 1">s</span> in target</div>
                                    <div class="list-detail">Last edited on {{l.date_modified}}</div>
                                </div>
                                <div class="col-4 text-right">
                                    <div>
                                        <!-- <button v-on:click="downloadList(l)" :disabled="downloading" class="btn btn-sm btn-success mr-1" type="button"> -->
                                        <button disabled="disabled" class="btn btn-sm btn-success mr-1" type="button">                                            
                                            <span v-if="!downloading"><i class="fas fa-download"></i> Download</span>
                                            <span v-if="downloading"><i class="fas fa-sync fa-spin"></i> Downloading...</span>
                                        </button>   
                                        <router-link tag="button" class="btn btn-sm btn-warning mr-1" type="button" exact :to="{name: 'targets', params: {listid: l.listid}}"><i class="fas fa-pencil"></i> Edit</router-link>                                        
                                        <button v-on:click="l.deleting = true" class="btn btn-sm btn-danger" type="button"><i class="fas fa-times"></i> Delete</button> 
                                    </div>
                                    <div v-if="l.deleting">
                                        <div class="mt-2 text-right">
                                            <strong class="mr-1">Are you sure?</strong>                                    
                                            <button type="button" v-if="l.deleting" v-on:click="deleteList(l)" class="btn btn-sm btn-success mr-1">Yes</button>
                                            <button type="button" v-on:click="l.deleting = false" class="btn btn-sm btn-danger">No</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                        </li>
                    </ul>
                </div>
            </div>
            <div class="mt-2" v-if="mode == 'newList' || mode == 'editList'" key="newList">
                <div class="row p-2">
                    <div class="col-8">
                        <h3 class="display-3" v-if="mode == 'newList'"><i class="fad fa-bullseye"></i> Create a new target</h3>
                        <h3 class="display-3" v-if="mode == 'editList'"><i class="fad fa-edit"></i> Editing target "{{list.list_name}}"</h3>                    
                    </div>
                    <div class="col-4">
                        <button type="button" v-on:click="resetList('default');" class="btn btn-sm btn-primary float-right"><i class="fas fa-arrow-left"></i> Back to targets</button>
                    </div>
                </div>                    
                <div class="border-top mt-1 pt-2" v-show="step == 1">
                    <div class="row">                        
                        <div class="col">
                            <h4><span class="badge-primary badge">1</span> Choose a source for your target lookup</h4>
                        </div>
                    </div>
                    <div class="row pt-2">
                        <div class="col">
                            <div class="input-group">
                                <select :disabled="matchtables.length === 0" class="form-control" v-on:change="previewMatchTable(matchid)" v-model="matchid">
                                    <option value="" selected="selected" disabled="disabled">Select a data source</option>
                                    <option :key="k" v-for="(s, k) in matchtables" :value="s.matchid">{{s.matchfile_name}}</option>
                                </select>                            
                            </div>
                        </div>
                    </div>  
                    <div v-if="matchtables.length === 0" class="border-top mt-2 pt-2">
                        <div class="alert alert-warning">
                            <i class="fas fa-lightbulb-exclamation text-warning"></i> Voter match files are used to create targets, create a voter match first.
                        </div>
                    </div>                  
                    <div v-if="preview.length">
                        <div  class="row mt-2" style="overflow: auto">                             
                            <div class="col">           
                                <table class="table">
                                    <tbody>
                                        <tr :key="r" v-for="(row, r) in preview">
                                            <td :key="i" v-for="(item, i) in row" scope="col">
                                                {{item}}
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>   
                            </div>
                        </div>      
                        <div class="row mt-2">
                            <div class="col">
                                <button type="button" v-on:click="getMatchTable(matchid, null)" class="btn btn-sm btn-success float-right">Continue with this source <i class="fas fa-arrow-right"></i></button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="border-top mt-1 pt-1" v-show="step == 2">
                    <div class="row mt-2 mb-2">
                        <div class="col-8">
                            <h4 v-if="mode == 'newList'"><span class="badge-primary badge">2</span> Build your target</h4>
                        </div>
                        <div v-if="mode == 'newList'" class="col-4">
                            <button type="button" v-on:click="resetList('newList')" class="btn btn-sm btn-primary float-right"><i class="fas fa-arrow-left" aria-hidden="true"></i> Back to source selection</button>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <h5><i class="far fa-database"></i> Fields from your data source</h5>
                        </div>
                        <div class="col-4">                            
                            <div class="form-group">                
                                <select class="form-control" v-on:change="currentOperator = ''" v-model="selectedField" id="field">
                                    <option value="" selected="selected" disabled="disabled">Select a field</option>
                                    <option :key="key" v-for="(field, key) in fields" :value="field">{{field.COLUMN_NAME}}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-2">
                            <select v-if="selectedField.COLUMN_NAME" class="form-control" v-on:change="currentValue = []" v-model="currentOperator" id="operator">
                                <option value="" selected="selected" disabled="disabled">Compare...</option>
                                <option :key="key" v-for="(op, key) in selectedField.OPERATORS" :value="op">{{op.display}}</option>
                            </select>
                        </div>
                        <div class="col-6" v-if="selectedField.COLUMN_NAME">
                            <div class="form-group" v-if="currentOperator.label != 'NULL' && currentOperator.label != 'NOTNULL'">
                                <!-- BETWEEN -->
                                <span v-if="currentOperator.label == 'BETWEEN'">                
                                    <input type="text" class="form-control" :maxlength="selectedField.CHARACTER_MAXIMUM_LENGTH" :placeholder="selectedField.placeholder" v-model="currentValue[0]"> and <input type="text" class="form-control" :maxlength="selectedField.length" v-model="currentValue[1]">
                                </span>
                                <!-- IN, NOTIN -->
                                <span v-else-if="currentOperator.label == 'IN' || currentOperator.label == 'NOTIN'">                                                                       
                                   <div class="input-group">                                        
                                        <input type="text" class="form-control" :maxlength="selectedField.CHARACTER_MAXIMUM_LENGTH" :placeholder="selectedField.placeholder" v-model="currentValue[0]">
                                        <div class="input-group-append">
                                            <button type="button" :disabled="addListDisabled" v-on:click="addValue()" class="float-right btn btn-success">Add</button>
                                        </div>
                                    </div>     
                                    <div v-if="currentValue.length > 0">
                                        <div class="input-group mt-2" :key="k" v-for="(v, k) in currentValue.slice(1)">
                                            <input type="text" class="form-control" :maxlength="selectedField.CHARACTER_MAXIMUM_LENGTH" :placeholder="selectedField.placeholder" v-model="currentValue.slice(1)[k]">
                                            <div class="input-group-append">
                                                <button type="button" v-on:click="removeValue(k)" class="float-right btn btn-danger">Remove</button>
                                            </div>
                                        </div>
                                    </div>
                                </span>
                                <!-- All others -->
                                <span v-else>                  
                                    <input type="text" class="form-control" :maxlength="selectedField.CHARACTER_MAXIMUM_LENGTH" :placeholder="selectedField.placeholder" v-model="currentValue[0]">
                                </span>                            
                            </div> 
                        </div>
                    </div>                                   
                    <div class="row">
                        <div class="col">                            
                            <button type="button" :disabled="addQueryDisabled" v-on:click="addToQuery('user')" class="btn btn-sm btn-success mr-1"><i class="fas fa-plus"></i> Add to lookup</button>
                            <button type="button" :disabled="!query.length" v-on:click="resetQuery()" class="btn btn-sm btn-danger"><i class="fas fa-undo"></i> Start over</button>                            
                        </div>
                    </div> 

                    <div class="row border-top mt-3 pt-2">
                        <div class="col-12">
                            <h5><i class="fad fa-database"></i> Fields from NYS voter data</h5>
                        </div>
                        <div class="col-4">                            
                            <div class="form-group">                
                                <select class="form-control" v-on:change="this.vdCurrentOperator = '';" v-model="vdSelectedField" id="field">
                                    <option value="" selected="selected" disabled="disabled">Select a field</option>
                                    <option :key="key" v-for="(field, key) in vdFields" :value="field">{{field.COLUMN_NAME}}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-2">
                            <select v-if="vdSelectedField.COLUMN_NAME" class="form-control" v-on:change="vdCurrentValue = []" v-model="vdCurrentOperator" id="operator">
                                <option value="" selected="selected" disabled="disabled">Compare...</option>
                                <option :key="key" v-for="(op, key) in vdSelectedField.OPERATORS" :value="op">{{op.display}}</option>
                            </select>
                        </div>
                        <div class="col-6" v-if="vdSelectedField.COLUMN_NAME">
                            <div class="form-group" v-if="vdCurrentOperator.label != 'NULL' && vdCurrentOperator.label != 'NOTNULL'">
                                <!-- BETWEEN -->
                                <span v-if="vdCurrentOperator.label == 'BETWEEN'">                
                                    <input type="text" class="form-control" :maxlength="vdSelectedField.CHARACTER_MAXIMUM_LENGTH" :placeholder="vdSelectedField.placeholder" v-model="vdCurrentValue[0]"> and <input type="text" class="form-control" :maxlength="vdSelectedField.length" v-model="vdCurrentValue[1]">
                                </span>
                                <!-- IN, NOTIN -->
                                <span v-else-if="vdCurrentOperator.label == 'IN' || vdCurrentOperator.label == 'NOTIN'">
                                    <div v-if="selectFields[vdSelectedField.COLUMN_NAME]">
                                        <div class="input-group">
                                            <input type="text" disabled="disabled" class="form-control" :value="selectFields[vdSelectedField.COLUMN_NAME].filter(item => vdCurrentValue.includes(item.val)).map(v => {return v.display}).join(', ')">
                                            <div class="input-group-append">
                                                <button type="button" v-on:click="vdPickValue()" class="float-right btn btn-success">Pick</button>
                                                <!-- <button type="button" v-on:click="vdPickValue(vdCurrentValue, selectFields[vdSelectedField.COLUMN_NAME])" class="float-right btn btn-success">Pick</button> -->
                                            </div>
                                        </div>   
                                    </div>
                                    <div v-else>
                                        <div class="input-group">
                                            <input type="text" class="form-control" :maxlength="vdSelectedField.CHARACTER_MAXIMUM_LENGTH" :placeholder="vdSelectedField.placeholder" v-model="vdCurrentValue[0]">
                                            <div class="input-group-append">
                                                <button type="button" :disabled="vdAddListDisabled" v-on:click="vdAddValue()" class="float-right btn btn-success">Add</button>
                                            </div>
                                        </div>                            
                                        <div class="input-group mt-2" :key="k" v-for="(v, k) in vdCurrentValue.slice(1)">
                                            <input type="text" class="form-control" :maxlength="vdSelectedField.CHARACTER_MAXIMUM_LENGTH" :placeholder="vdSelectedField.placeholder" v-model="vdCurrentValue.slice(1)[k]">
                                            <div class="input-group-append">
                                                <button type="button" v-on:click="vdRemoveValue(k)" class="float-right btn btn-danger">Remove</button>
                                            </div>                                        
                                        </div>
                                    </div>
                                </span>
                                <!-- All others -->
                                <span v-else>    
                                    <select class="form-control" v-if="selectFields[vdSelectedField.COLUMN_NAME]" v-model="vdCurrentValue[0]">
                                        <option value="">Please select...</option>
                                        <option :key="k" v-for="(o, k) in selectFields[vdSelectedField.COLUMN_NAME]" :value="o.val">{{o.display}}</option>
                                    </select>
                                    <input v-else type="text" class="form-control" :maxlength="vdSelectedField.CHARACTER_MAXIMUM_LENGTH" :placeholder="vdSelectedField.placeholder" v-model="vdCurrentValue[0]">
                                </span>                            
                            </div> 
                        </div>
                    </div>                                   
                    <div class="row">
                        <div class="col">                            
                            <button type="button" :disabled="vdAddQueryDisabled" v-on:click="addToQuery('voter')" class="btn btn-sm btn-success mr-1"><i class="fas fa-plus"></i> Add to lookup</button>
                            <button type="button" :disabled="!query.length" v-on:click="resetQuery()" class="btn btn-sm btn-danger"><i class="fas fa-undo"></i> Start over</button>                            
                        </div>
                    </div> 

                    <div class="border-top mt-3 pt-2" v-if="query.length">
                        <h5><i class="fad fa-filter"></i> My list filters</h5>
                        <ul class="mt-3 list-group">
                            <li class="list-group-item" :key="key" v-for="(q, key) in query">
                                <div class="row">                                
                                    <div class="col">
                                        <button v-on:click="removeFromQuery(key)" class="mr-2 btn btn-sm btn-danger" type="button"><i class="fas fa-times"></i> Remove</button>                                
                                        <span class="handle">                                                                                       
                                            {{q.field}} {{q.operator}} {{q.display.join(', ')}}
                                        </span>
                                    </div>
                                </div>
                            </li>
                        </ul>  
                        <div class="row mt-3">
                            <div class="col">
                                <button type="button" :disabled="!query.length || previewLoading" v-on:click="previewQuery()" class="btn btn-sm btn-info">
                                    <span v-if="!previewLoading"><i class="fas fa-search"></i> Preview this list</span>
                                    <span v-if="previewLoading"><i class="fas fa-sync fa-spin"></i> Loading...</span>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div v-if="list_count != null && previewed" class="border-top mt-3 pt-2">
                        <div class="row">
                            <div class="col-12">
                                <h5><i class="fad fa-user-friends"></i> {{parseInt(list_count).toLocaleString()}} record<span v-if="list_count != 1">s</span> match your lookup</h5>
                            </div>
                            <div class="col-12" v-if="listPreview.length && list_count > 0">
                                <div class="row mt-2" style="overflow: auto">                             
                                    <div class="col">           
                                        <table class="table">
                                        <tbody>
                                            <tr :key="r" v-for="(row, r) in listPreview">
                                                <td :key="i" v-for="(item, i) in row" scope="col">
                                                    {{item}}
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>   
                                    </div>
                                </div>      
                                <div class="row mt-2">
                                    <div class="col text-right">
                                        <button type="button" :disabled="downloading" v-on:click="downloadList()" class="btn btn-sm btn-info mr-1">
                                            <span v-if="!downloading"><i class="fas fa-download"></i> Download results</span>
                                            <span v-if="downloading"><i class="fas fa-sync fa-spin"></i> Downloading...</span>
                                        </button>
                                        <div v-if="mode == 'editList'" class="btn-group" role="group">
                                            <button id="btnGroupDrop1" type="button" class="btn btn-sm btn-success dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <i class="fas fa-save"></i> Save
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="btnGroupDrop1">
                                                <a class="dropdown-item text-info" v-on:click.prevent="updateList()"><i class="fas fa-pen"></i> Overwrite "{{list.list_name}}"</a>
                                                <a class="dropdown-item text-success" data-toggle="modal" data-backdrop="static" data-target="#listSave"><i class="fas fa-save"></i> Save list as</a>
                                            </div>
                                        </div>
                                        <button v-if="mode == 'newList'" type="button" data-toggle="modal" data-backdrop="static" data-target="#listSave" class="btn btn-sm btn-success"><i class="fas fa-save"></i> Save this list</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                    
                </div>
            </div>
        </transition>
        <list-save></list-save>
        <value-picker></value-picker>
    </div>
</div>
</template>
<script>
import valuePicker from './value.pick.vue';
import listSave from './list.save.vue';

export default {   
    components: {
        valuePicker: valuePicker,
        listSave: listSave
    },
    data: function() {
        return {                          
            matchtables: [],
            lists: [],
            list: {},
            preview: [],
            listPreview: [],
            fields: [],
            vdFields: [],
            list_count: null,            
            listsLoading: false,
            matchtablesLoading: false,            
            fieldsLoading: false,            
            previewLoading: false,
            previewed: false,
            downloading: false,            
            source: '',
            mode: 'default',
            step: '1',
            matchid: '',            
            selectedField: '',
            currentOperator: '',
            currentValue: [],
            vdSelectedField: '',
            vdCurrentOperator: '',
            vdCurrentValue: [],
            selectFields: {assembly_rep: [], congressional_rep: [], senate_rep: [], enrollment: [], counties: []},      
            query: [],
            fieldSource: null
        }
    },
    methods: {    
        resetList: function(mode) {
            this.mode = mode;
            this.preview = []; 
            this.step = 1;
            this.matchid = '';
            this.resetQuery();
            //If we're in list editing mode, go back to lists
            if (mode == 'default' && this.$route.params.listid) {
                this.router.push({ path: '/targets' });
            }
        },
        updateList: function() {              
            var formData = new FormData();            
            var _this = this;     
            formData.append("list_count", this.list_count);
            formData.append("listid", this.list.listid);
            formData.append("userid", this.list.userid);            
            formData.append("query", JSON.stringify(this.query));    
            formData.append('token', JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
            this.axios({
                method: 'post',
                url: this.$root.baseURI+'/lists/list.update',
                data: formData                
            }).then(function (response) {   
                _this.$root.handleTokenError(response.data);                 
                 if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');                    
                } else {                      
                    _this.$root.setAlert(true, "List '"+_this.list.list_name+"' saved successfully", 'alert-success');                    
                }
            }).catch(error => {
            _this.$root.setAlert(true, error, 'alert-danger');
            return;
            });    
        },
        getList: function(listid) {                                  
            var _this = this;
            var data = {                                
                listid: listid,
                userid: this.$root.user.userid,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };              
            this.axios.get(this.$root.baseURI+'/lists/get.list', {             
                params: data
            }).then(function (response) {   
                _this.$root.handleTokenError(response.data);                                                            
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {                    
                    if (response.data.length) {
                        _this.mode = 'editList';   
                        _this.list = response.data[0];                                              
                        _this.query = JSON.parse(_this.list.query);    
                        _this.getMatchTable(null, _this.list.source);
                    } else {
                        _this.$root.setAlert(true, 'That list does not exist or you do not have rights to edit it', 'alert-danger');
                        return;
                    }
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });             
        },
        deleteList: function(list) {
            var _this = this;
             var data = {                                
                listid: list.listid,
                userid: this.$root.user.userid,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };  
            this.axios.get(this.$root.baseURI+'/lists/list.delete', {             
                params: data
            }).then(function (response) {    
                _this.$root.handleTokenError(response.data);                                                           
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {                    
                    if (response.data.length) {
                        _this.lists = _this.lists.filter(function(l) {
                            return l.listid != response.data[0]['listid'];
                        });                   
                        _this.$root.setAlert(true, 'List "'+list.list_name+'" deleted successfully', 'alert-success');
                    }
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            }); 

        },
        previewQuery: function() {               
            this.previewLoading = true;
            var formData = new FormData();            
            var _this = this;     
            formData.append("source", this.source);
            formData.append("action", "query");
            formData.append('token', JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
            if (this.query.length) {       
                formData.append("data", JSON.stringify(this.query));
            }
            this.axios({
                method: 'post',
                url: this.$root.baseURI+'/lists/list.query',
                data: formData                
            }).then(function (response) {                    
                _this.$root.handleTokenError(response.data);               
                _this.previewed = true;           
                _this.previewLoading = false;   
                _this.list_count = response.data[0] || 0;
                _this.listPreview = response.data[1] || [];                
            }).catch(error => {
                _this.previewLoading = false; 
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });                        
        },
        downloadList: function(list) {            
            this.downloading = true;          
            var formData = new FormData();            
            var _this = this;     
            var prefix = this.source;
            formData.append("source", this.source);
            formData.append("action", "download");
            formData.append('token', JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
            if (list) {
                formData.append("listid", list.listid);
                formData.append("userid", list.userid);
                prefix = list.list_name;
            }
            if (this.query.length) {       
                formData.append("data", JSON.stringify(this.query));
            }

            this.axios.post(this.$root.baseURI+'/lists/list.query', formData, {
                headers: { 'Content-Type': 'multipart/form-data' },
                responseType: 'blob'                
            }).then(response => {                      
                if (response.data.type == 'text/html') {
                    var d = new Blob([response.data]);
                    var r = new FileReader();
                    r.addEventListener('loadend', (e) => {
                        const err = e.target.result;
                        _this.$root.handleTokenError(err);  
                        _this.$root.setAlert(true, err, 'alert-danger');
                    });
                    r.readAsText(d);                                        
                    _this.downloading = false;
                    return;
                }                                        
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    _this.downloading = false;
                    return;
                } else {                       
                    const url = window.URL.createObjectURL(new Blob([response.data]));
                    const link = document.createElement('a');
                    link.href = url;
                    link.setAttribute('download', prefix+'-download.csv');
                    document.body.appendChild(link);
                    link.click();
                    _this.downloading = false;        
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                _this.downloading = false;
                return;
            });  
        },
        resetQuery: function() {
            this.previewed = false;
            this.query = [];   
            this.selectedField = '';
            this.currentOperator = '';
            this.currentValue = [];    
            this.vdSelectedField = '';
            this.vdCurrentOperator = '';
            this.vdCurrentValue = []; 
            this.list_count = null; 
        },
        addToQuery: function(source) {
            this.previewed = false;
            var q = {};
            var display = '';
            switch (source) {
                case 'user':
                    display = this.currentValue;
                    q = {
                        display: display,
                        field: this.selectedField.COLUMN_NAME, 
                        operator: this.currentOperator.code, 
                        value: this.currentValue,
                        type: this.selectedField.DATA_TYPE,
                        alias: 'a',
                        lop: 'AND'
                    };            
                    this.query.push(q);
                    this.selectedField = '';
                    this.currentOperator = '';
                    this.currentValue = [];
                break;
                case 'voter':
                    var a = 'b';
                    if (this.vdSelectedField.COLUMN_NAME == 'year_voted') {
                        a = 'c';
                    }
                    display = this.vdCurrentValue;
                    var overrideField = '';
                    if (this.selectFields[this.vdSelectedField.COLUMN_NAME]) {                        
                        display = this.selectFields[this.vdSelectedField.COLUMN_NAME].filter(item => this.vdCurrentValue.includes(item.val)).map(v => {return v.display});                                                 
                        overrideField = this.vdSelectedField.OVERRIDE_FIELD 
                    }
                    q = {         
                        display: display,               
                        field: this.vdSelectedField.COLUMN_NAME, 
                        operator: this.vdCurrentOperator.code, 
                        value: this.vdCurrentValue,
                        type: this.vdSelectedField.DATA_TYPE,
                        alias: a,                        
                        overrideField: overrideField,
                        lop: 'AND'
                    };                              
                    this.query.push(q);                    
                    this.vdSelectedField = '';
                    this.vdCurrentOperator = '';
                    this.vdCurrentValue = [];
                break;
            }
            
        },             
        removeFromQuery: function(key) {
            this.previewed = false,
            this.query.splice(key, 1);
        },
        addValue: function() {
            this.currentValue.push(this.currentValue[0]);
            this.currentValue[0] = '';
        },
        removeValue: function(key) {
            this.currentValue.splice(key, 1);
        },
        vdAddValue: function() {                        
            this.vdCurrentValue.push(this.vdCurrentValue[0]);
            this.vdCurrentValue[0] = '';
        },
        vdRemoveValue: function(key) {
            this.vdCurrentValue.splice(key, 1);
        },
        //vdPickValue(value, values) {
        vdPickValue() {
            $('#valuePick').modal('show');

        },
        getMatchTable: function(matchid, tablename) {
            this.step = 2;
            this.fieldsLoading = true;
            var _this = this;
            var data = {                                
                matchid: matchid,
                tablename: tablename,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };  
            this.axios.get(this.$root.baseURI+'/lists/matchtable.fields', {             
                params: data
            }).then(function (response) { 
                _this.$root.handleTokenError(response.data);                                             
                _this.fieldsLoading = false;                                 
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {                    
                    if (response.data.length) {                                      
                        _this.fields = response.data[0];
                        _this.vdFields = response.data[1];
                        _this.source = response.data[2];
                    }
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
        },
        previewMatchTable: function(matchid) {            
            this.previewLoading = true;
            var _this = this;
            var data = {              
                userid: this.$root.user.userid,                  
                matchid: matchid,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };  
            this.axios.get(this.$root.baseURI+'/lists/matchtable.preview', {             
                params: data
            }).then(function (response) {   
                _this.$root.handleTokenError(response.data);                                            
                _this.previewLoading = false;                                 
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {                                
                    if (response.data.preview.length) {                                                         
                        _this.preview = response.data.preview;                                  
                    }                    
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
        },
        getUserLists: function() {
            this.listsLoading = true;
            var _this = this;
            var data = {                                
                userid: this.$root.user.userid,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };  
            this.axios.get(this.$root.baseURI+'/lists/lists.get', {                    
                params: data
            }).then(function (response) {    
                _this.$root.handleTokenError(response.data);                            
                _this.listsLoading = false;                                 
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    if (response.data.length) {   
                        for (var i = 0; i < response.data.length; i++) {
                            response.data[i].deleting = false;
                        }
                        _this.lists = response.data;                        
                    }
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
        },
        getUserMatchtables: function() {
            this.matchtablesLoading = true;
            var _this = this;
            var data = {                                
                userid: this.$root.user.userid,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };  
            this.axios.get(this.$root.baseURI+'/lists/matchtable.get', {                    
                params: data
            }).then(function (response) {                   
                _this.$root.handleTokenError(response.data);                          
                _this.matchtablesLoading = false;                                 
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    if (response.data.length) {                                      
                        _this.matchtables = response.data;                        
                    }
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
        },
        getSelectFields: function() {
            var _this = this;
            var data = {
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };
            this.axios.get(this.$root.baseURI+'/lists/selectFields.get', {                    
                params: data
            }).then(function (response) {                    
                _this.$root.handleTokenError(response.data);                                    
                _this.matchtablesLoading = false;                                 
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {                    
                    if (response.data) {                                      
                        _this.selectFields = response.data;        
                    }
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
        }
    },
    computed: {
        addListDisabled: function() {
            var out = true;
            if (Array.isArray(this.currentValue) && this.currentValue.length && this.currentValue[0].trim() > '') {
                out = false;
            }
            return out;
        },
        vdAddListDisabled: function() {
            var out = true;
            if (Array.isArray(this.vdCurrentValue) && this.vdCurrentValue.length && this.vdCurrentValue[0].trim() > '') {
                out = false;
            }
            return out;
        },
        addQueryDisabled: function() {
            var out = true;
            if (this.selectedField.COLUMN_NAME && this.currentOperator > '') {
                if (this.currentOperator.label == 'NULL' || this.currentOperator.label == 'NOTNULL') {
                    out = false;
                } else if (this.currentOperator.label == 'BETWEEN' && (Array.isArray(this.currentValue) && this.currentValue.length && this.currentValue[0].trim() > '')) {
                    if (this.currentValue.length == 2 && this.currentValue[1].trim() > '') {
                        out = false;
                    }
                } else if (this.currentOperator.label == 'IN' || this.currentOperator.label == 'NOTIN') {
                    if (Array.isArray(this.currentValue) && this.currentValue.length > 1) {
                        if (this.currentValue[1].trim() > '') {
                            out = false;
                        }
                    } 
                } else {
                    if (Array.isArray(this.currentValue) && this.currentValue.length && this.currentValue[0].trim() > '') {
                        out = false;
                    }
                }
            }
            return out;
        },
        vdAddQueryDisabled: function() {
            var out = true;
            if (this.vdSelectedField.COLUMN_NAME && this.vdCurrentOperator > '') {
                if (this.vdCurrentOperator.label == 'NULL' || this.vdCurrentOperator.label == 'NOTNULL') {
                    out = false;
                } else if (this.vdCurrentOperator.label == 'BETWEEN' && (Array.isArray(this.currentValue) && this.vdCurrentValue.length && this.vdCurrentValue[0].trim() > '')) {
                    if (this.vdCurrentValue.length == 2 && this.vdCurrentValue[1].trim() > '') {
                        out = false;
                    }
                } else if (this.vdCurrentOperator.label == 'IN' || this.vdCurrentOperator.label == 'NOTIN') {
                    var comp = 1;
                    if (this.selectFields[this.vdSelectedField.COLUMN_NAME]) {  
                        comp = 0;
                    }
                    if (Array.isArray(this.vdCurrentValue) && this.vdCurrentValue.length > comp) {
                        if (this.vdCurrentValue[comp].trim() > '') {
                            out = false;
                        }
                    }                 
                } else {
                    if (Array.isArray(this.vdCurrentValue) && this.vdCurrentValue.length && this.vdCurrentValue[0].trim() > '') {
                        out = false;
                    }
                }
            }
            return out;
        }
    },
    mounted: function() {
        this.getUserLists();
        this.getUserMatchtables();
        this.getSelectFields();
        if (this.$route.params.listid) {
            this.getList(this.$route.params.listid);             
        }
    },
    watch: {
        '$route': function() {      
            if (this.$route.params.listid) {
                this.getList(this.$route.params.listid);             
            }
        }
    }
};
</script>
<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: all .3s ease;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
  transform: translateX(100px);
}

.fade-leave, .fade-enter-to {
    opacity: 1;
    transform: translateX(0);
}

td {
    white-space:nowrap;
}
.list-detail {
    font-size: 0.9rem;    
}

.dropdown-menu a {
    cursor: pointer;
}

</style>