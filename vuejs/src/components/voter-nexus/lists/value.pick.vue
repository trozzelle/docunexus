<template>
    <div class="modal fade bd-example-modal-lg" id="valuePick" tabindex="-1" role="dialog" aria-labelledby="valuePickLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">            
            <div class="modal-content">
                <div class="modal-header">                    
                    <h3 class="display-3"><i class="fad fa-crosshairs"></i> Choose values to include</h3>                
                    <button type="button" class="close" v-on:click="closeModal()" aria-label="Close"><i class="fas fa-times"></i></button>
                </div>
                <div class="modal-body">
                    <div class="form-group row">     
                        <div class="col-4" :key="k" v-for="(v, k) in $parent.selectFields[$parent.vdSelectedField.COLUMN_NAME]">
                            <div class="custom-control custom-checkbox">                                
                                <input type="checkbox" class="custom-control-input" :id="k" :value="v.val" v-model="$parent.vdCurrentValue">
                                <label class="custom-control-label" :for="k">{{v.display}}</label>
                            </div>
                        </div>
                    </div>                             
                </div>
                <div class="modal-footer text-right">                    
                    <button type="button" class="btn btn-sm btn-success" v-on:click="saveValues()"><i class="fas fa-check"></i> Finish</button>                
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
            $('#valuePick').modal('hide');   
            this.list_name = ''; 
        },
        saveValues: function() {              
            this.closeModal();            
        }
    }
}
</script>