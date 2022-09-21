<template>
    <div class="modal fade" id="dValuePick" tabindex="-1" role="dialog" aria-labelledby="dValuePickLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="display-3"><i class="text-primary fad fa-clipboard-list-check"></i> Choose values to include</h3>
                    <button type="button" class="close" v-on:click="closeModal()" aria-label="Close"><i class="fas fa-times"></i></button>
                </div>                
                <div class="modal-body">    
                    <div class="form-row mt-2">
                        <div class="col search input-group form-label-group">
                            <input type="text" class="form-control" v-model="search" placeholder="Search for values">
                            <label>Search for values</label>
                            <div class="input-group-append">
                                <button type="button" :disabled="search == ''" v-on:click="search = ''" class="btn btn-secondary"><i class="fas fa-times"></i> Clear</button>
                            </div>
                        </div>
                    </div>                                    
                    <div class="form-group row">
                        <div :class="{'col-6': $parent.selectModel == 'filing_schedule', 'col-4': $parent.selectModel != 'filing_schedule'}" :key="k" v-for="(v, k) in filtered">                        
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" :id="k" :value="v.val" v-model="$parent.query[$parent.selectModel]">
                                <label class="custom-control-label" :for="k" v-html="$options.filters.highlight(v.display, search)"></label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-right">
                    <button type="button" class="btn btn-sm btn-primary" v-on:click="saveValues()"><i class="fas fa-save"></i> Save</button>
                    <button type="button" class="btn btn-sm btn-danger" v-on:click="closeModal()"><i class="fas fa-ban"></i> Cancel</button>
                </div>                
            </div>
        </div>
    </div>
</template>
<script>

export default {
    data: function () {
        return {
            values: [],
            search: ''
        }
    },
    methods: {
        closeModal: function () {
            $('#dValuePick').modal('hide');
            this.$parent.query[this.$parent.selectModel] = this.values;
            this.$parent.selectModel = '';
            this.search = '';
        },
        saveValues: function () {
            $('#dValuePick').modal('hide');
            this.$parent.selectModel = '';
            this.search = '';
        }
    },
    computed: {
        filtered: function() {          
            var s = this.search.toLowerCase();
            return this.$parent.selectList.filter(a => {                
               return a.display.toLowerCase().includes(s);
            });        
        }
    },
    watch: {
        '$parent.selectModel': function (newVal) {
            var out = [];
            if (newVal > '') {
                out = JSON.parse(JSON.stringify(this.$parent.query[this.$parent.selectModel]));
            } else {
                out = [];
            }
            this.values = out;
        }
    }
}
</script>