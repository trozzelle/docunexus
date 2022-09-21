<template>
<div class="container">
        <div v-if="!$root.loggedIn">
            <login></login>
        </div>
        <div v-else>
            <div class="row mt-3 mb-1 border-bottom">
                <div class="col-8">
                    <h1 class="display-1">
                    <i class="fad fa-fw fa-globe-stand text-primary"></i> Region management
                    </h1>
                </div>           
                 <div class="col-4 text-right">
                    <button v-if="$root.user.admin.site_admin == 'Y'" type="button" class="btn btn-sm btn-primary" v-on:click="addRegion()"><i class="fas fa-plus"></i> Add a region</button>
                </div>     
            </div> 
            <div class="row">
                <div class="col-12">
                    <div class="row" v-if="!regions.length">
                        <div class="col">
                            <h5>No regions have been added, yet.</h5>
                        </div>
                    </div>
                    <div class="row border-bottom pl-1 pr-1 pt-2 pb-2" v-else :key="k" v-for="(r, k) in paginatedData">
                        <div class="col-9 pt-1">   
                            <div class="row" v-if="!r.editing">                          
                                <div class="col-3"><strong>Region name</strong></div>
                                <div class="col-9">{{r.region_name}}</div>
                            </div>   
                            <div class="row" v-if="r.editing">
                                <div class="col-12">                                
                                    <div class="form-label-group mb-0">
                                        <input type="text" :name="k+'_description'" class="form-control" placeholder="Region name" v-model="toEdit" />
                                        <label>Region name</label>
                                    </div>
                                </div>                                
                            </div>
                        </div>
                        <div class="col-3 text-right" :class="{'mt-2': r.editing}">
                            <span v-if="!r.editing">                                  
                                <button type="button" class="btn btn-sm btn-info mr-1" v-on:click="startEdit(r)"><i class="fas fa-pen-alt"></i> Edit</button>
                                <button v-if="$root.user.admin.site_admin == 'Y'" type="button" :disabled="r.deleting" class="btn btn-sm btn-danger" v-on:click="r.deleting = true"><i class="fas fa-times"></i> Delete</button>
                            </span>
                            <span v-if="r.editing">                                  
                                <button type="button" class="btn btn-sm btn-danger mr-1" v-on:click="endEdit(r, false)"><i class="fas fa-ban"></i> Cancel</button>
                                <button :disabled="saveDisabled(r)" type="button" class="btn btn-sm btn-success" v-on:click="saveEdit(r, 'update')"><i class="fas fa-save"></i> Save</button>
                            </span>
                            <div class="mt-1" v-if="r.deleting">
                                <span class="text-danger mr-1">Are you sure?</span>
                                <button type="button" class="btn btn-sm btn-success mr-1" v-on:click="saveEdit(r, 'delete')"><i class="fas fa-check"></i> Yes</button>
                                <button type="button" v-on:click="r.deleting = false;" class="btn btn-sm btn-danger"><i class="fas fa-times"></i> No</button>
                            </div>
                        </div>
                    </div>                    
                </div>                 
            </div> 
        </div>
    </div>
</template>
<script>
export default { 
    components: {
        
    },
    data: function() {
        return {      
            regions: [],
            toEdit: false,
            size: 10,
            pageNumber: 0
        }
    },
    methods: {
        saveDisabled: function(region) {
            var out = true;            
            if (this.toEdit != region.region_name && this.toEdit.trim() > '') {
                out = false;                
            }
            return out;
        },
        addRegion: function() {
            var r = {regionid: null, region_name: 'New region', editing: false, deleting: false};
            this.startEdit(r);
            this.saveEdit(r, 'add');
        },      
        startEdit: function(record) {
            for (var i = 0; i < this.regions.length; i++) {
                this.endEdit(this.regions[i], false);
            }
            record.editing = true;
            this.toEdit = record.region_name;
        },
        endEdit: function(record, save) {
            record.editing = false;
            if (save) {
                record.region_name = this.toEdit;
            }
        },
        saveEdit: function(record, action) {
            var _this = this;   
            var params = {
                action: action,
                regionid: record.regionid,
                region_name: this.toEdit,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            }               
            this.axios.get(this.$root.baseURI+'/admin/regions/regions.update', {                    
                params: params
            }).then(function (response) {   
                _this.$root.handleTokenError(response.data);
                _this.queryLoading = false;                                     
                if (response.data.error) {                    
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    if (response.data.length) {      
                        switch (action) {
                            case 'add':
                                _this.endEdit(record, true);    
                                var r = response.data[0];
                                r.editing = false;
                                r.deleting = false;
                                _this.regions.push(r);
                                _this.$root.setAlert(true, '"'+_this.toEdit+'" updated successfully', 'alert-success');       
                            break;
                            case 'update':
                                _this.endEdit(record, true);                
                                _this.$root.setAlert(true, '"'+_this.toEdit+'" updated successfully', 'alert-success');
                            break;
                            case 'delete':
                                _this.regions = _this.regions.filter(region => { return region.regionid != record.regionid; });
                                _this.$root.setAlert(true, '"'+record.region_name+'" deleted successfully', 'alert-success');
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
        getData: function() {
            var _this = this;                     
            var params = {              
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };          
            this.axios.get(this.$root.baseURI+'/admin/regions/regions.lookup', {
                params: params
            }).then(function (response) { 
                _this.$root.handleTokenError(response.data);                                                                            
                if (response.data.error) {                    
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    if (response.data.length) {                                              
                        for (var i = 0; i < response.data.length; i++) {
                            response.data[i].editing = false;
                            response.data[i].deleting = false;                            
                            if (_this.$root.user.admin.site_admin == 'Y' || _this.userRegions.includes(response.data[i].regionid)) {
                                _this.regions.push(response.data[i]);                            
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
        }
    },
    computed: {    
        paginatedData: function() {   
            var pn = this.pageNumber;
            if (this.pageNumber >= this.pageCount) {                
                pn = 0;
            }
            var s = pn * this.size;
            var e = s + this.size;
            return this.regions.slice().slice(s,e);            
        },
        userRegions: function() {
            return this.$root.user.regions.filter(region => {
                return region.region_admin == 'Y';
            }).map(function(r) {
                return r.regionid;
            });         
        },
        pageCount: function() {
            let l = this.regions.length;
            let s = this.size;
            var c = Math.ceil(l/s);                
            return c;
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