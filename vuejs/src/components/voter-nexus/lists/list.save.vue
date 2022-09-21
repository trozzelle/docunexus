<template>
    <div class="modal fade bd-example-modal-lg" id="listSave" tabindex="-1" role="dialog" aria-labelledby="listSaveLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">            
            <div class="modal-content">
                <div class="modal-header">                    
                    <h3 class="display-3"><i class="fad fa-save text-success"></i> Save your list</h3>                
                    <button type="button" class="close" v-on:click="closeModal()" aria-label="Close"><i class="fas fa-times"></i></button>
                </div>
                <div class="modal-body">
                    <div class="form-group row">
                        <label for="list_nameInput" class="col-sm-3 col-form-label">Name of your list:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="list_nameInput" v-model="list_name">
                        </div>
                    </div>                    
                </div>
                <div class="modal-footer text-right">                    
                    <button type="button" :disabled="list_name.trim() == ''" class="btn btn-sm btn-success" v-on:click="saveList()"><i class="fas fa-save"></i> Save</button>                
                    <button type="button" class="btn btn-sm btn-danger" v-on:click="closeModal()"><i class="fas fa-ban"></i> Cancel</button>                
                </div> 
            </div>
        </div>
    </div>
</template>
<script>

export default {   
    data: function() {
        return {              
            list_name: '',
            saving: false
        }
    },
    methods: {   
        closeModal: function() {
            $('#listSave').modal('hide');   
            this.list_name = ''; 
        },
        saveList: function() {              
            this.saving = true;
            var formData = new FormData();            
            var _this = this;     
            formData.append("list_count", this.$parent.list_count);
            formData.append("userid", this.$root.user.userid);            
            formData.append("list_name", this.list_name);
            formData.append("source", this.$parent.source);
            formData.append("query", JSON.stringify(this.$parent.query)); 
            formData.append('token', JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
            this.axios({
                method: 'post',
                url: this.$root.baseURI+'/lists/list.save',
                data: formData                
            }).then(function (response) {   
                 _this.$root.handleTokenError(response.data);                   
                 if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');                    
                } else {  
                    _this.closeModal();
                    response.data[0].deleting = false;
                    _this.$parent.lists.unshift(response.data[0]);
                    _this.$root.setAlert(true, "List '"+response.data[0]['list_name']+"' saved successfully", 'alert-success');                    
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });                        
        }
    }
}
</script>