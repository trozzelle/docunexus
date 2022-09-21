<template>
    <div class="row">
        <div class="col">
            <div class="card batch-list mb-3">
                <ul class="list-group list-group-flush">
                    <li v-for="(n, k) in paginatedData" :key="k" class="list-group-item">
                        <div class="row">
                            <div class="col-5 mt-1">
                                <h5>
                                    <span v-if="!n.editing">{{ n.title }}</span>
                                    <span v-else>
                                    <input v-model="n.title" type="text" name="pageTitle"
                                        class="form-control" :placeholder="n.title"/>
                                    <button type="button" class="btn btn-sm btn-success fa fa-check"
                                        @click="emitEdit(n.saveid,n.title)"></button>
                                    <button type="button" class="btn btn-sm btn-danger fa fa-times"
                                        @click="n.editing = false"></button>
                                    </span>
                                </h5>
                            </div>
                            <div class="col-3 mt-1">
                                <h5>
                                    <span>{{ n.type }}</span>
                                </h5>
                            </div>
                            <div class="col-3">
                                <div class="text-right">
                                    <Go-Button :route="n.route_name" :params="n.route_params" :page-type="n.type"/>
                                    <Edit-Button :record="n" :page-type="pageType" :saveid="n.saveid" :title="n.title"/>
                                    <Delete-Button :record="n" :saveid="n.saveid"/>
                                </div>
                            </div>
                        </div>
                        <div v-if="n.deleting" class="row">
                            <div class="col mb-2 text-right">
                                <strong>Are you sure?</strong>
                                <button v-if="n.deleting" type="button" class="btn btn-sm btn-success mx-1"
                                    @click="emitDelete(n.saveid)">Yes
                                </button>
                                <button type="button" class="btn btn-sm btn-danger mx-1"
                                    @click="n.deleting = false">No
                                </button>
                            </div>
                        </div>
                        <hr>
                        <div class="row p-1">
                            <div class="col-6">
                                <div class="row">
                                    <div class="col-5"><strong>Date saved</strong></div>
                                    <div class="col-7">
                                        <span>{{ formatDate(n.time_saved) }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6">
                            </div>
                        </div>
                    </li>
                </ul>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-2">
                            <button class="btn btn-primary" type="button" :disabled="pageNumber == 0" @click="prevPage">
                            <i class="fas fa-chevron-left"></i> Back
                            </button>
                        </div>
                        <div class="col-8 mt-2" style="text-align: center">
                            <span v-if="pageCount > 0">page {{ pageNumber + 1 }} of {{ pageCount }}</span>
                        </div>
                        <div class="col">
                            <button class="float-right btn btn-primary" type="button"
                                :disabled="pageNumber == pageCount - 1 || pageCount == 0" @click="nextPage">Next <i
                                class="fas fa-chevron-right"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
    /**
     * Favorites List component as the core view for navigating users' saved data.
     *
     * In the process of being refactored into utility components and then prettified.
     *
     */
    import goButton from '../common/goButton';
    import editButton from '../common/editButton';
    import deleteButton from '../common/deleteButton';
    
    export default {
      name: 'favoritesList',
      components: { deleteButton, editButton, goButton },
      props: {
        records: Array,
        saveid: String,
        pageType: String,
      },
      data: function () {
        return {
          batches: [],
          currentRecord: {},
          size: 5,
          pageNumber: 0,
          refreshRecordList: false,
        }
      },
      computed: {
        pageCount: function () {
          let l = this.records.length
          let s = this.size
          var c = Math.ceil(l / s)
          return c
        },
        paginatedData: function () {
          if (this.pageNumber >= this.pageCount) {
            this.pageNumber = 0
          }
          const start = this.pageNumber * this.size
          const end = start + this.size
          return this.records.slice(start, end)
        },
      },
      methods: {
        nextPage: function () {
          if (this.pageNumber < this.pageCount) {
            this.pageNumber++
          }
        },
        prevPage: function () {
          if (this.pageNumber > 0) {
            this.pageNumber--
          }
        },
        emitDelete: function (saveid) {
          var params = { saveid }
          this.$emit('delete', params)
        },
        emitEdit: function (saveid, title) {
          var params = { saveid, title }
          this.$emit('edit', params)
        },
      },
    }
</script>
<style scoped>
    .table thead th {
    vertical-align: top;
    }
    .card-footer .row {
    background-color: transparent;
    }
</style>