<template>
    <div class="modal fade bd-example-modal-lg" id="groupImage" tabindex="-1" role="dialog" aria-labelledby="groupImageLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">            
            <div class="modal-content">                
                <div class="modal-header">                    
                    <h3 class="display-3"><i class="far fa-image"></i> Group image for "{{this.$parent.groupName}}"</h3>                
                    <button type="button" class="close" v-on:click="closeModal()" aria-label="Close"><i class="fas fa-times"></i></button>
                </div>
                <div class="modal-body">
                    <div class="row">     
                        <div class="col">
                            <img class="img-fluid mx-auto d-block" style="max-height: 400px" :src="this.$parent.groupImage">
                        </div>
                    </div>                                    
                </div>
                <div class="modal-footer text-right">                                        
                    <button type="button" class="btn btn-sm btn-danger" v-on:click="closeModal()"><i class="fas fa-ban"></i> Close</button>                
                </div> 
            </div>
        </div>
    </div>
</template>
<script>

export default {
    data: function() {
        return {              
            src: this.$parent.groupImage
        }
    },
    methods: {   
        closeModal: function() {
            $('#groupImage').modal('hide');   
            this.$parent.groupImage = '';            
            this.$parent.groupName = '';  
        }
    }
}
</script>