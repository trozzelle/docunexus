<template>
<div class="container" style="padding-bottom: 80px">
        <div v-if="!$root.loggedIn">
            <login></login>
        </div>
        <div v-else>
            <div class="row mt-3 mb-1 border-bottom">
                <div class="col-8">
                    <h1 class="display-1">
                    <i class="fad fa-fw fa-layer-group text-primary"></i> Group management
                    </h1>
                </div>           
                 <div class="col-4 text-right">
                    <button type="button" class="btn btn-sm btn-primary" v-on:click="addGroup()"><i class="fas fa-plus"></i> Add a group</button>
                </div>     
            </div> 
            <div class="row">
                <div class="col-12">
                    <div class="row" v-if="!groups.length">
                        <div class="col">
                            <h5>No groups have been added, yet.</h5>
                        </div>
                    </div>
                    <div class="row pl-1 pr-1 pt-2 pb-2" v-else :key="k" v-for="(g, k) in paginatedData">
                        <div class="col-9 pt-1">   
                            <div class="row" v-if="!g.editing">                          
                                <div class="col-3"><strong>Group name</strong></div>
                                <div class="col-9">{{g.group_name}}</div>
                                <div class="col-3"><strong>Assigned regions</strong></div>
                                <div class="col-9">{{displayRegions(g)}}</div>
                                <div class="col-3"><strong>Group image</strong></div>
                                <div class="col-9">
                                    <span v-if="g.group_image">
                                        <button type="button" class="btn btn-sm btn-primary" v-on:click="showImage(g.group_image, g.group_name)"><i class="far fa-image"></i> Show image</button>
                                    </span>
                                    <span v-else>No image set</span>                                    
                                </div>
                            </div>   
                            <div class="row" v-if="g.editing">
                                <div class="col-12">                                
                                    <div class="form-label-group mb-0">
                                        <input type="text" :name="k+'_description'" class="form-control" placeholder="Group name" v-model="toEdit" />
                                        <label>Group name</label>
                                    </div>
                                </div>                                
                                <div class="col-12 mt-2 pb-2">
                                    <h5>Assigned regions</h5>
                                </div>
                                <div class="col-12" v-if="g.regions.length">
                                    <div  :key="k" v-for="(r, k) in g.regions">
                                        <div class="row" :class="{'pb-1 mb-1 border-bottom': k < g.regions.length - 1}">
                                            <div class="col-2">
                                                <button :disabled="!userRegions.includes(r.regionid)" type="button" class="btn btn-sm btn-danger" v-on:click="removeRegion(g, r)"><i class="fas fa-times"></i> Remove</button>
                                            </div>
                                            <div class="col-10">
                                                {{r.region_name}}
                                            </div>
                                            
                                        </div>                                    
                                    </div>
                                </div>
                                <div v-else>
                                    <div class="col-12">
                                        No regions assigned
                                    </div>
                                </div>
                                <div class="col-12 mt-2 pt-2">
                                    <div class="row">
                                        <div class="col-6">                                      
                                            <div class="form-label-group">
                                                <select class="form-control" v-model="regionEdit">
                                                    <option value="" selected="selected" disabled="disabled">Select a region</option>
                                                    <option :key="k" v-for="(r, k) in regions" :disabled="hasRegion(g.regions, r.regionid)" :value="r.regionid">{{r.region_name}}</option>
                                                </select>                                                        
                                                <label>Region</label>
                                            </div>                                                            
                                        </div>
                                        <div class="col-2 mt-2 text-right">
                                            <button type="button" :disabled="regionEdit == ''" v-on:click="addRegion(g)" class="btn btn-sm btn-success"><i class="fas fa-plus"></i> Add</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 mt-2 pb-2">
                                    <h5>Group image</h5>
                                </div>
                                <div class="col-12">
                                    <div class="input-group">
                                        <div class="custom-file">
                                            <input type="file" :key="key" accept=".jpg,.jpeg,.png,.bmp" class="custom-file-input" ref="fileUpload" id="inputGroupFile" v-on:change="setFile">
                                            <label class="custom-file-label" for="inputGroupFile">
                                                <span v-if="!file.name">Choose a file to load</span>
                                                <span v-else>{{file.name}}</span>
                                            </label>
                                        </div>
                                        <div class="input-group-append">
                                            <button class="btn btn-danger" v-on:click="file = {}; newImage = ''" :disabled="!file.name" type="button" id="inputGroupFileAddon"><i class="fas fa-ban"></i> Clear</button>
                                        </div>                
                                    </div>
                                </div>
                                <div class="col-6 mt-2 border-right">
                                    <div class="m-2">
                                        <strong>Current image</strong>
                                        <button v-if="!g.imgDelete" :disabled="!g.group_image > ''" v-on:click="g.imgDelete = true" type="button" class="float-right btn btn-sm btn-danger"><i class="fas fa-times"></i> Delete image</button>
                                        <div class="float-right" v-else>
                                            <span class="pr-2">Are you sure?</span>
                                            <button type="button" v-on:click="deleteImage(g)" class="btn btn-sm btn-success"><i class="fas fa-check"></i> Yes</button>
                                            <button type="button" v-on:click="g.imgDelete = false" class="btn btn-sm btn-danger"><i class="fas fa-ban"></i> No</button>
                                        </div>
                                    </div>
                                    <img class="img-fluid" :src="g.group_image">
                                </div>
                                <div class="col-6 mt-2">
                                    <div class="m-2">
                                        <strong>New image</strong>
                                    </div>
                                    <img class="img-fluid" :src="newImage">
                                </div>
                            </div>
                        </div>
                        <div class="col-3 text-right" :class="{'mt-2': g.editing}">
                            <span v-if="!g.editing">                                  
                                <button type="button" class="btn btn-sm btn-info mr-1" v-on:click="startEdit(g)"><i class="fas fa-pen-alt"></i> Edit</button>
                                <button type="button" :disabled="g.deleting" class="btn btn-sm btn-danger" v-on:click="g.deleting = true"><i class="fas fa-times"></i> Delete</button>
                            </span>
                            <span v-if="g.editing">                                  
                                <button type="button" class="btn btn-sm btn-danger mr-1" v-on:click="endEdit(g, false)"><i class="fas fa-ban"></i> Cancel</button>
                                <button :disabled="saveDisabled(g)" type="button" class="btn btn-sm btn-success" v-on:click="saveEdit(g, 'update')"><i class="fas fa-save"></i> Save</button>
                            </span>
                            <div class="mt-1" v-if="g.deleting">
                                <span class="text-danger mr-1">Are you sure?</span>
                                <button type="button" class="btn btn-sm btn-success mr-1" v-on:click="saveEdit(g, 'delete')"><i class="fas fa-check"></i> Yes</button>
                                <button type="button" v-on:click="g.deleting = false;" class="btn btn-sm btn-danger"><i class="fas fa-times"></i> No</button>                             
                            </div>
                        </div>
                    </div>                    
                </div>                 
            </div> 
        </div>        
        <show-image></show-image>
    </div>
</template>
<script>
import showImage from './show.image.vue';


export default {   
    components: {        
        showImage: showImage
    },
    data: function() {
        return {      
            groups: [],
            regions: [],
            regionids: [],
            toEdit: false,
            regionEdit: '',
            size: 10,
            pageNumber: 0,
            groupImage: '',
            groupName: '',
            file: {},
            newImage: '',
            key: 0
        }
    },
    methods: {
        deleteImage: function(group) {
            var _this = this;             
            var params = {   
                groupid: group.groupid,   
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };  
            this.axios.get(this.$root.baseURI+'/admin/groups/group.image.delete', {
                params: params
            }).then(function (response) {    
                 _this.$root.handleTokenError(response.data);                                                             
                if (response.data.error) {                    
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {   
                    group.group_image = '';
                    group.imgDelete = false;
                    this.file = {};
                    this.newImage = '';
                    _this.$root.setAlert(true, 'Group image deleted successfully', 'alert-success');
                }
            });                        
        },
        setFile: function() {            
            this.file = this.$refs.fileUpload[0].files[0];
            var reader = new FileReader();            
            reader.readAsDataURL(this.file);
            reader.onload = () => {                          
                this.newImage = reader.result;                   
            }
            this.key = this.key + 1;        
        },
        showImage: function(img, name) {
            this.groupImage = img;
            this.groupName = name;
             $('#groupImage').modal('show');   
        },
        saveDisabled: function(group) {
            var out = true;            
            if (JSON.stringify(this.regionids) != JSON.stringify(group.regionids) || (this.toEdit != group.group_name && this.toEdit.trim() > '') || this.file.name > '') {
                out = false;                
            }
            return out;
        },
        removeRegion: function(group, region) {            
            group.regions = group.regions.filter(r => {return r.regionid != region.regionid});
            this.regionids = this.regionids.filter(i => {return i != region.regionid});
        },
        addRegion: function(group) {
            var r = this.regions.find(region => region.regionid == this.regionEdit);
            group.regions.push(r);
            this.regionids.push(r.regionid);
            this.regionids.sort();
            this.regionEdit = '';
        },
        hasRegion: function(regions, regionid) {
            var out = true;
            var l = regions.filter(r => {
                return r.regionid == regionid;
            });
            if (l.length == 0) {
                out = false;
            }            
            return out;
        },
        addGroup: function() {
            var g = {groupid: null, group_name: 'New group', regions: [], regionids: [], editing: false, deleting: false};
            this.startEdit(g);
            this.saveEdit(g, 'add');
        },      
        startEdit: function(record) {
            this.regionids = [];
            for (var i = 0; i < this.groups.length; i++) {
                this.endEdit(this.groups[i], false);
            }
            record.editing = true;
            this.toEdit = record.group_name;
            for (var j = 0; j < record.regionids.length; j++) {
                this.regionids.push(record.regionids[j]);
            }
            this.regionids.sort();
        },
        endEdit: function(record, save) {
            record.editing = false;
            if (save) {
                record.group_name = this.toEdit;
                record.regionids = this.regionids;
                record.group_image = this.newImage;                
            }
            this.newImage = '';
            this.file = {};
        },
        saveEdit: function(record, action) {
            var _this = this;
            var formData = new FormData();            
            formData.append('action', action);
            formData.append('groupid', record.groupid);
            formData.append('group_name', this.toEdit);
            formData.append('regionids', this.regionids);
            formData.append('file', this.file);
            formData.append("token", JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
            this.axios.post(this.$root.baseURI+'/admin/groups/groups.update', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(response => {             
                 _this.$root.handleTokenError(response.data);         
                 console.log(response);               
                if (response.data.error) {                    
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    if (response.data.length) {                              
                        switch (action) {
                            case 'add':
                                _this.endEdit(record, true);    
                                var g = response.data[0];                           
                                record.groupid = g['groupid'];                                                  
                                _this.groups.push(record);
                                _this.$root.setAlert(true, '"'+_this.toEdit+'" updated successfully', 'alert-success');       
                            break;
                            case 'update':
                                _this.endEdit(record, true);                
                                _this.$root.setAlert(true, '"'+_this.toEdit+'" updated successfully', 'alert-success');
                            break;
                            case 'delete':
                                _this.groups = _this.groups.filter(group => { return group.groupid != record.groupid; });
                                _this.$root.setAlert(true, '"'+record.group_name+'" deleted successfully', 'alert-success');
                            break;
                        }                                                                    
                    } else {
                        _this.$root.setAlert(true, 'Error editing record', 'alert-danger');
                        return;
                    }
                }
            }).catch(error => {
                _this.queryLoading = false;                
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
        },
        displayRegions: function(group) {
            var out = 'No regions assigned';
            var r = [];
            for (var i = 0; i < group.regions.length; i++) {
                r.push(group.regions[i].region_name);
            }
            if (r.length) {
                out = r.join(', ');
            }
            return out;
        },
        getData: function() {
            var _this = this;     
            var params = {              
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };  
            this.axios.get(this.$root.baseURI+'/admin/groups/groups.regions.lookup', {
                params: params
            }).then(function (response) {    
                 _this.$root.handleTokenError(response.data);                                                             
                if (response.data.error) {                    
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {                    
                    if (response.data.length) {                              
                        for (var i = 0; i < response.data.length; i++) {
                            var assignedRegion = false;
                            response.data[i].editing = false;
                            response.data[i].imgDelete = false;
                            response.data[i].deleting = false;                                                        
                            response.data[i].regionids = [];                            
                            for (var j = 0; j < response.data[i].regions.length; j++) {
                                response.data[i].regionids.push(response.data[i].regions[j].regionid);
                                if (_this.userRegions.includes(response.data[i].regions[j].regionid)) {
                                    assignedRegion = true;
                                }
                            }
                            response.data[i].regionids.sort();
                            if (_this.$root.user.admin.site_admin == 'Y' || assignedRegion) {
                                _this.groups.push(response.data[i]);
                            }
                        }                                        
                    } else {
                        _this.$root.setAlert(true, 'Error getting groups', 'alert-danger');
                        return;
                    }
                }
            }).catch(error => {                             
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
            this.axios.get(this.$root.baseURI+'/admin/regions/regions.lookup', {
                params: params
            }).then(function (response) {  
                 _this.$root.handleTokenError(response.data);                                                                               
                if (response.data.error) {                    
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {                                        
                    if (response.data.length) {                                               
                        if (_this.$root.user.admin.site_admin == 'Y') {
                            _this.regions = response.data;                                      
                        } else {
                            for (var i = 0; i < response.data.length; i++) {
                                if (_this.userRegions.includes(response.data[i].regionid)) {
                                    _this.regions.push(response.data[i]);
                                }
                            }
                        }
                    } else {
                        _this.$root.setAlert(true, 'Error getting regions', 'alert-danger');
                        return;
                    }
                }
            }).catch(error => {                             
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  

        },           
        nextPage: function() {
            if (this.pageNumber < this.pageCount) {                             
                this.pageNumber++;
            }
        },
        prevPage: function() {
            if (this.pageNumber > 0) {                
                this.pageNumber--;
            }
        },            
    },
    computed: {    
        userRegions: function() {
            return this.$root.user.regions.filter(region => {
                return region.region_admin == 'Y';
            }).map(function(r) {
                return r.regionid;
            }); 
        },
        userGroups: function() {
            return this.$root.user.groups.filter(group => {
                return group.group_admin == 'Y';
            }).map(function(g) {
                return g.groupid;
            }); 
        },
        pageCount: function() {
            let l = this.groups.length;
            let s = this.size;
            var c = Math.ceil(l/s);                
            return c;
        },
        paginatedData: function() {
            var pn = this.pageNumber;
            if (this.pageNumber >= this.pageCount) {                
                pn = 0;
            }
            var s = pn * this.size;
            var e = s + this.size;            
            return this.groups.slice().slice(s, e);
        }    
    },
    watch: {
       
    },
    mounted: function() {
        this.getData();
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

.main {
    margin-bottom: 80px;
}
</style>
}