<template>
    <div class="modal fade" id="niShowAll" tabindex="-1" role="dialog" aria-labelledby="niShowAllLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="display-3"><i class="text-primary fad fa-clipboard-list-check"></i> Select a {{itemName.title}}</h3>
                    <button type="button" class="close" v-on:click="closeModal()" aria-label="Close"><i class="fas fa-times"></i></button>
                </div>                
                <div class="modal-body">                        
                    <div class="form-row mt-2">
                        <div class="col search input-group form-label-group">
                            <input type="text" class="form-control" v-model="search" placeholder="Search for values">
                            <label>Search for a {{itemName.placeholder}}</label>
                            <div class="input-group-append">
                                <button type="button" :disabled="search == ''" v-on:click="search = ''" class="btn btn-secondary"><i class="fas fa-times"></i> Clear</button>
                            </div>
                        </div>
                    </div>  
                    <div class="card">                                  
                        <ul v-if="listType == 'searches' || listType == 'lists'" class="list-group list-group-flush">
                            <li v-for="(s, key) in paginatedData" :key="key" class="list-group-item">
                                <div class="row">
                                    <div class="col-8">
                                        <strong>
                                            <router-link tag="a" exact :to="{
                                                name: 'saved-list',
                                                params: {
                                                userID: s.userid,
                                                saveID: s.saveid}, }"><span v-on:click="closeModal()" v-html="$options.filters.highlight(s.save_name, search)"></span>
                                            </router-link>
                                        </strong>
                                        <div>Found {{parseInt(s.record_count).toLocaleString() }} record<span v-if="s.record_count != 1">s</span>
                                        </div>
                                        <div class="list-detail">Type: {{ s.search_type }} | Last edited on {{ s.time_saved }}
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                        <ul v-if="listType == 'pages'" class="list-group list-group-flush">
                            <li v-for="(p, key) in paginatedData" :key="key" class="list-group-item">
                                <div class="row">
                                    <div class="col-9">
                                        <strong>
                                            <router-link tag="a" exact :to="p.location"><span v-on:click="closeModal()" v-html="$options.filters.highlight(p.page_title, search)"></span></router-link>
                                        </strong>
                                        <div class="list-detail">Page type: {{ p.page_type }} | Saved on {{ p.time_saved }}</div>
                                    </div>
                                </div>
                                <div v-if="p.deleting" class="row mt-1">
                                    <div class="col text-right mr-2">
                                        <strong>Are you sure?</strong>
                                        <button v-if="p.deleting" type="button" class="btn btn-sm btn-success" v-on:click="deleteList(l)">Yes
                                        </button>
                                        <button type="button" class="btn btn-sm btn-danger" v-on:click="p.deleting = false">No</button>
                                    </div>
                                </div>
                            </li>
                        </ul>
                        <div class="card-footer">
                            <div class="row">
                                <div class="col-2">
                                    <button class="btn btn-primary" type="button" :disabled="pageNumber == 0" v-on:click="prevPage()"><i class="fas fa-chevron-left"></i> Back</button>
                                </div>
                                <div class="col-8 mt-2" style="text-align: center">
                                    <span v-if="pageCount > 0">page {{pageNumber + 1}} of {{pageCount}}</span>
                                    <span v-else>Your search returned no results</span>
                                </div>
                                <div class="col">
                                    <button class="float-right btn btn-primary" type="button" :disabled="pageNumber == pageCount - 1 || pageCount == 0" v-on:click="nextPage()">Next <i class="fas fa-chevron-right"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>                    
                </div>
                
                <div class="modal-footer text-right">                    
                    <button type="button" class="btn btn-sm btn-danger" v-on:click="closeModal()"><i class="fas fa-times"></i> Close</button>
                </div>                
            </div>
        </div>
    </div>
</template>
<script>

export default {
    props: {
        records: Array,
        listType: String
    },
    data: function () {
        return {            
            search: '',            
            size: 5, //Elements per page
            pageNumber: 0 //Current page number
        }
    },
    methods: {
        closeModal: function () {
            $('#niShowAll').modal('hide');
            this.$parent.listType = '';
            this.$parent.records = [];            
            this.search = '';
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
        itemName: function() {
            var out = {title: '', placeholder: ''};
            switch (this.listType) {
                case 'searches':
                    out.placeholder = 'saved search';
                    out.title = 'Saved Search';
                break;
                case 'lists':
                    out.placeholder = 'saved list';
                    out.title = 'Saved List';
                break;
                case 'pages':
                    out.placeholder = 'favorite';
                    out.title = 'Favorite';                    
                break;                
            }         
            return out;
        },
        filtered: function() {          
            var s = this.search.toLowerCase();
            var out = [];
            switch (this.listType) {
                case 'searches':
                case 'lists':
                    out = this.records.filter(a => {                
                        return a.save_name.toLowerCase().includes(s);
                    });        
                break;
                case 'pages':
                    out = this.records.filter(a => {                
                        return a.page_title.toLowerCase().includes(s);
                    });
                break;                
            }         
            return out;   
        },
        pageCount: function() {
            let l = this.filtered.length;
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
            return this.filtered.slice().slice(s,e);
            
        } 
    },
   /* watch: {
        '$parent.selectModel': function (newVal) {
            var out = [];
            if (newVal > '') {
                out = JSON.parse(JSON.stringify(this.$parent.query[this.$parent.selectModel]));
            } else {
                out = [];
            }
            this.values = out;
        }
    }*/
}
</script>