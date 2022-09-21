<template>
<div class="container">
        <div v-if="!$root.loggedIn">
            <login></login>
        </div>
        <div v-else>
            <div class="row mt-3 mb-2 border-bottom">
                <div class="col-8">
                    <h1 class="display-1">
                    <i class="fad fa-fw fa-unlock-alt text-primary"></i> Rights management
                    </h1>
                </div>         
                <div class="col-4 text-right">
                    <button type="button" class="btn btn-sm btn-primary" v-on:click="addRights()"><i class="fas fa-plus"></i> Add a rights group</button>
                </div>
            </div> 
            <div class="row">
                <div class="col-8">
                    <h3>System rights groups</h3>
                </div>                
            </div>
            <div class="row">
                <div class="col-12">
                    <div class="row pt-1 pb-1 ml-1 mr-1 border-bottom" :key="k" v-for="(r, k) in paginatedData">
                        <div class="col-8 pt-1">                            
                            <span v-if="!r.editing">{{r.rights_name}}</span>
                            <div v-if="r.editing" class="form-label-group mb-0">
                                <input type="text" :name="k+'_description'" class="form-control" placeholder="Rights description" v-model="toEdit" />
                                <label>Rights description</label>
                            </div>
                        </div>
                        <div class="col-4 text-right">
                            <button v-if="!r.editing" type="button" class="btn btn-sm btn-info" v-on:click="startEdit(r)"><i class="fas fa-pen-alt"></i> Edit</button>
                            <span v-if="r.editing">                                  
                                <button v-if="r.editing" type="button" class="btn btn-sm btn-danger" v-on:click="endEdit(r, false)"><i class="fas fa-ban"></i> Cancel</button>
                                <button v-if="r.editing" :disabled="toEdit == r.rights_name || toEdit.trim() == ''" type="button" class="btn btn-sm btn-success" v-on:click="saveEdit(r, 'update')"><i class="fas fa-save"></i> Save</button>
                            </span>
                        </div>
                    </div>
                </div>                
            </div> 

            <div class="row mt-3 pt-3">
                <div class="col-12">
                    <h3>User-defined rights groups</h3>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div class="row" v-if="!userRights.length">
                        <div class="col">
                            <h5>No user-defined rights groups have been added, yet.</h5>
                        </div>
                    </div>
                    <div class="row p-1" v-else :key="k" v-for="(r, k) in userRights">
                        <div class="col-8 pt-1">                            
                            <span v-if="!r.editing">{{r.rights_name}}</span>
                            <div v-if="r.editing" class="form-label-group mb-0">
                                <input type="text" :name="k+'_description'" class="form-control" placeholder="Rights description" v-model="toEdit" />
                                <label>Rights description</label>
                            </div>
                        </div>
                        <div class="col-4 text-right">
                            <span v-if="!r.editing">                                  
                                <button type="button" class="btn btn-sm btn-info mr-1" v-on:click="startEdit(r)"><i class="fas fa-pen-alt"></i> Edit</button>
                                <button type="button" :disabled="r.deleting" class="btn btn-sm btn-danger" v-on:click="r.deleting = true"><i class="fas fa-times"></i> Delete</button>
                            </span>
                            <span v-if="r.editing">                                  
                                <button type="button" class="btn btn-sm btn-danger mr-1" v-on:click="endEdit(r, false)"><i class="fas fa-ban"></i> Cancel</button>
                                <button :disabled="toEdit == r.rights_name || toEdit.trim() == ''" type="button" class="btn btn-sm btn-success" v-on:click="saveEdit(r, 'update')"><i class="fas fa-save"></i> Save</button>
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
            rights: [],
            toEdit: false,
            size: 10,
            pageNumber: 0
        }
    },
    methods: {
        addRights: function() {
            var r = {rightsid: null, rights_name: 'New rights group', can_delete: 'Y', editing: false, deleting: false};
            this.startEdit(r);
            this.saveEdit(r, 'add');
        },      
        startEdit: function(record) {
            for (var i = 0; i < this.rights.length; i++) {
                this.endEdit(this.rights[i], false);
            }
            record.editing = true;
            this.toEdit = record.rights_name;
        },
        endEdit: function(record, save) {
            record.editing = false;
            if (save) {
                record.rights_name = this.toEdit;
            }
        },
        saveEdit: function(record, action) {
            var _this = this;   
            var params = {
                action: action,
                rightsid: record.rightsid,
                rights_name: this.toEdit,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            }               
            this.axios.get(this.$root.baseURI+'/admin/rights/rights.update', {                    
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
                                _this.rights.push(r);
                                _this.$root.setAlert(true, '"'+_this.toEdit+'" updated successfully', 'alert-success');       
                            break;
                            case 'update':
                                _this.endEdit(record, true);                
                                _this.$root.setAlert(true, '"'+_this.toEdit+'" updated successfully', 'alert-success');
                            break;
                            case 'delete':
                                _this.rights = _this.rights.filter(right => { return right.rightsid != record.rightsid; });
                                _this.$root.setAlert(true, '"'+record.rights_name+'" deleted successfully', 'alert-success');
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
            this.axios.get(this.$root.baseURI+'/admin/rights/rights.lookup', {
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
                            _this.rights.push(response.data[i]);
                        }                                        
                    } else {
                        _this.$root.setAlert(true, 'Error getting user rights', 'alert-danger');
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
        systemRights: function() {
            return this.rights.filter(right => { return right.can_delete == 'N'; });
        },
        userRights: function() {
            return this.rights.filter(right => { return right.can_delete == 'Y'; });
        },
        pageCount: function() {
            let l = this.rights.length;
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
            return this.systemRights.slice().slice(s,e);            
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