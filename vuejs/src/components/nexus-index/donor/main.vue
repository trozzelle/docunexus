<template>
  <div id="nexus-index" class="container-fluid main">
    <div v-if="!$root.loggedIn">
      <login></login>
    </div>
    <div v-else>
      <div class="container mb-0">
        <div class="row mt-3 mb-2 align-items-center border-bottom">
          <div class="col-sm-12 col-md-6 col-lg-5 text-center text-md-left">
            <h1 class="display-1">
              <i
                  class="fas fa-fw text-primary"
                  :class="{ 'fa-search': !loading, 'fa-circle-notch fa-spin': loading }"
              ></i> Donor Lookup
            </h1>
          </div>
          <div class="col-sm-12 col-md-6 col-lg-7 mb-1 text-center text-md-right">
            <div class="float-none float-md-right">
              <div v-if="queryCount">
                <button type="button" class="mt-1 ml-1 btn btn-sm btn-primary" @click="resetLookup()"><i
                    class="fas fa-undo"></i> Start over
                </button>
                <button type="button" class="mt-1 ml-1 btn btn-sm btn-secondary" @click="modifyLookup()"><i
                    class="fas fa-pen"></i> Modify lookup
                </button>
                <download :query="query" :query-route="queryRoute" search-type="Donor Search"></download>
                <!-- If a user has selected rows, we pass that row ID array instead of the full row ID to Save List -->
                <save-list class="d-none d-sm-none d-lg-inline-flex" :query-parameters="query" :query-count="queryCount"
                           :row-i-ds="selectedRowIDs.length > 0 ? selectedRowIDs : rowIDs" search-type="Donor Search"
                           route-name="donor" :time-ran="searchTimestamp"></save-list>
                <save-search class="d-none d-sm-none d-lg-inline-flex" :query-parameters="query"
                             :query-count="queryCount"
                             search-type="Donor Search" route-name="donor" :time-ran="searchTimestamp"></save-search>
              </div>
              <div v-else>
                <router-link tag="button" type="button" to="/home"
                             class="mt-1 btn btn-primary btn-sm float-none float-md-right"><i
                    class="fas fa-arrow-left"></i> Back to home
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
      <transition name="fade" mode="out-in">
        <div class="container" v-if="!queryCount && loadExistingSearch == false">
          <div class="row">
            <div class="col border-bottom">
              <h4 class="display-4">Donor Name</h4>
            </div>
          </div>
          <div class="row ml-1 mt-2">
            <div class="col-sm-12 col-md-3">
              <div class="form-label-group">
                <input v-model="query.donor_last_name" type="text" name="donor_last_name" class="form-control"
                       placeholder="Last name"/>
                <label>Last name</label>
              </div>
            </div>
            <div class="col-sm-12 col-md-3">
              <div class="form-label-group">
                <input v-model="query.donor_first_name" type="text" name="donor_first_name" class="form-control"
                       placeholder="First name"/>
                <label>First name</label>
              </div>
            </div>
            <div class="col-sm-12 col-md-2">
              <div class="form-label-group">
                <input v-model="query.donor_middle_name" type="text" name="donor_middle_name" class="form-control"
                       placeholder="Middle initial"/>
                <label>Middle</label>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col border-bottom">
              <h4 class="display-4">Business Name</h4>
            </div>
          </div>
          <div class="row ml-1 mt-2">
            <div class="col-sm-12 col-md-6">
              <div class="form-label-group">
                <input v-model="query.donor_organization_name" type="text" name="donor_organization_name"
                       class="form-control"
                       placeholder="Business, Organization, or PAC name"/>
                <label>Business, Organization, or PAC name</label>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col border-bottom">
              <h4 class="display-4">Address</h4>
            </div>
          </div>
          <div class="row ml-1 mt-2">
            <div class="col-sm-12 col-md-3">
              <div class="form-label-group">
                <input v-model="query.donor_address" type="text" name="donor_address" class="form-control"
                       placeholder="Address"/>
                <label>Address</label>
              </div>
            </div>
            <div class="col-sm-12 col-md-3">
              <div class="form-label-group">
                <input v-model="query.donor_city" type="text" name="donor_city" class="form-control"
                       placeholder="City"/>
                <label>City</label>
              </div>
            </div>
            <div class="col-sm-12 col-md-3 col-lg-2">
              <div class="form-label-group">
                <input v-model="query.donor_zip_low" type="text" name="donor_zip_low" class="form-control"
                       placeholder=""/>
                <label>From Zipcode</label>
              </div>
            </div>
            <div class="col-sm-12 col-md-3 col-lg-2">
              <div class="form-label-group">
                <input v-model="query.donor_zip_high" type="text" name="donor_zip_high" class="form-control"
                       placeholder=""/>
                <label>To Zipcode</label>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col border-bottom">
              <h4 class="display-4">Transaction Details</h4>
            </div>
          </div>
          <div class="row mt-2 ml-1">
            <div class="col-sm-12 col-md-6">
              <h5>Amount</h5>
              <div class="row">
                <div class="col-12">
                  <div class="row mb-1">
                    <div class="col-12">
                      <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="dollarRange" id="greaterThan" value="greater"
                               v-model="query.dollarRange">
                        <label class="form-check-label" for="greaterThan">Equal or greater than</label>
                      </div>
                      <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="dollarRange" id="lessThan" value="less"
                               v-model="query.dollarRange">
                        <label class="form-check-label" for="lessThan">Equal or less than</label>
                      </div>
                      <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="ageRange" id="between" value="between"
                               v-model="query.dollarRange">
                        <label class="form-check-label" for="between">Between</label>
                      </div>
                    </div>
                  </div>
                  <div class="row">
                    <div class="col-5">
                      <div class="form-label-group">
                        <input type="text" :disabled="query.dollarRange == ''" name="dollarLow" class="form-control"
                               :placeholder="{'Low amount': !query.dollarRange, 'Amount': query.dollarRange != 'between'}"
                               v-model="query.original_amount_low"/>
                        <label v-if="query.dollarRange != 'between'">Amount</label>
                        <label v-if="query.dollarRange == 'between'">Low</label>
                      </div>
                    </div>
                    <div v-if="query.dollarRange == 'between'" class="col-2 text-center pt-2">
                      <strong>and</strong>
                    </div>
                    <div v-if="query.dollarRange == 'between'" class="col-5">
                      <div class="form-label-group">
                        <input type="text" name="dollarHigh" class="form-control" placeholder="High amount"
                               v-model="query.original_amount_high"/>
                        <label>High</label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-sm-12 col-md-6">
              <h5>Date</h5>
              <div class="row">
                <div class="col-6">
                  <div class="form-label-group">
                    <v-date-picker :input-props='{ class: "form-control date-picker",  placeholder: "Start date"}'
                                   mode="single" v-model="query.transaction_date_low"></v-date-picker>
                    <label :class="{'populated': query.transaction_date_low > ''}">Start date</label>
                  </div>
                </div>
                <div class="col-6">
                  <div class="form-label-group">
                    <v-date-picker :input-props='{ class: "form-control date-picker",  placeholder: "End date"}'
                                   mode="single" v-model="query.transaction_date_high"></v-date-picker>
                    <label :class="{'populated': query.transaction_date_high > ''}">End date</label>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col border-bottom">
              <h4 class="display-4">Recipient Details</h4>
            </div>
          </div>
          <div class="row ml-1 mt-2">
            <div class="col-sm-12 col-md-6">
              <div class="form-label-group">
                <input v-model="query.filer_name" type="text" name="donor_last_name" class="form-control"
                       placeholder="Recipient name"/>
                <label>Recipient name</label>
              </div>
            </div>
            <div class="col-sm-6 col-md-4 col-lg-2">
              <div class="form-label-group">
                <input v-model="query.filer_id" type="text" name="donor_first_name" class="form-control"
                       placeholder="Recipient ID"/>
                <label>Recipient ID</label>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col border-bottom">
              <h4 class="display-4">Filing</h4>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-12 col-md-6 mt-2">
              <div class="input-group">
                <input type="text" disabled="disabled" placeholder="Election year" class="form-control"
                       :value="selectFields.election_year.filter(item => query.election_year.includes(item.val)).map(v => {return v.display}).join(', ')">
                <div class="input-group-append">
                  <button type="button" v-on:click="pickValue('election_year', selectFields.election_year)"
                          class="float-right btn btn-primary">Pick
                  </button>
                  <button type="button" :disabled="query.election_year.length == 0"
                          v-on:click="query.election_year = [];" class="float-right btn btn-secondary">Clear
                  </button>
                </div>
              </div>
            </div>
            <div class="col-sm-12 col-md-6 mt-2">
              <div class="input-group">
                <input type="text" disabled="disabled" placeholder="Filing" class="form-control"
                       :value="selectFields.filing.filter(item => query.filing.includes(item.val)).map(v => {return v.display}).join(', ')">
                <div class="input-group-append">
                  <button type="button" v-on:click="pickValue('filing', selectFields.filing)"
                          class="float-right btn btn-primary">Pick
                  </button>
                  <button type="button" :disabled="query.filing.length == 0" v-on:click="query.filing = [];"
                          class="float-right btn btn-secondary">Clear
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-12 col-md-6 mt-2">
              <div class="input-group">
                <input type="text" disabled="disabled" placeholder="Filing schedule" class="form-control"
                       :value="selectFields.filing_schedule.filter(item => query.filing_schedule.includes(item.val)).map(v => {return v.display}).join(', ')">
                <div class="input-group-append">
                  <button type="button" v-on:click="pickValue('filing_schedule', selectFields.filing_schedule)"
                          class="float-right btn btn-primary">Pick
                  </button>
                  <button type="button" :disabled="query.filing_schedule.length == 0"
                          v-on:click="query.filing_schedule = [];" class="float-right btn btn-secondary">Clear
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div class="row mt-2">
            <div class="col border-bottom">
              <h4 class="display-4">Lookup behavior</h4>
            </div>
          </div>
          <div class="row ml-1 mt-2">
            <div class="col-12 form-inline">
              <span>Limit results to </span><input v-model="query.limit" type="text" name="countLimit"
                                                   class="ml-2 col-3 mr-2 form-control"
                                                   placeholder=""/><span> records </span>
            </div>
          </div>
          <div class="row mt-2">
            <div class="col-12 col-md-4 border-top pt-2">
              <button class="btn btn-primary" :disabled="queryDisabled || queryLoading"
                      @click="submitQuery(false)">
                <span v-if="!queryLoading"><i class="fas fa-search"></i> Do lookup</span>
                <span v-if="queryLoading"><i class="fas fa-circle-notch fa-spin"></i> Searching</span>
              </button>
            </div>
          </div>
        </div>
        <div class="container-fluid" style="max-width: 1400px" v-if="queryCount">
          <div class="row my-2">
            <div class="col-12">
              <h4 class="display-4">
                {{ Number(queryCount).toLocaleString() }} record<span v-if="queryCount != 1">s</span> match<span
                  v-if="queryCount == 1">es</span> your search<span
                  v-if="queryCount > 1000">, viewing the first 1,000</span>
              </h4>
              <span v-if="queryCount > 1000">Go back and refine your search by adding additional criteria.</span>
            </div>
          </div>
          <div class="row" style="height:800px">
            <!-- TODO: Make Responsive -->
            <div id="grid-wrapper" class="col-12 mt-1" style="width: 100%; height: 100%;">
              <ag-grid-vue style="width: 100%; height: 100%;"
                           class="ag-theme-alpine"
                           debug=true
                           :context="context"
                           :grid-options="gridOptions"
                           :column-defs="columnDefs"
                           :default-col-def="defaultColDef"
                           :row-data="queryResults"
                           :row-selection="rowSelection"
                           :row-multi-select-with-click="true"
                           :master-detail="true"
                           detail-cell-renderer-framework="transactionDetail"
                           :detail-row-height="detailRowHeight"
                           :framework-components="frameworkComponents"
                           @first-data-rendered="onFirstDataRendered"
                           @grid-size-changed="onGridSizeChanged"
                           @row-selected="onRowSelected"
              >
              </ag-grid-vue>
            </div>
          </div>
        </div>
      </transition>
    </div>
    <value-picker></value-picker>
  </div>
</template>
<script>
/**
 *  Donor Search component. Allows users to search through the transaction data over specific criteria.
 *
 *  At the current moment, search is slow on non-indexed fields because the table is not properly normalized. Also,
 *  for development purposes, we're returning A LOT of data from the request. This is until the columns /
 *  cell rendering / master-detail is locked into place and we know exactly what fields we need. Because we're only
 *  displaying the data, I've tried to freeze the response objects where possible.
 */
import {donorSearchDefault} from '../assets/js/formConstants.js';
import {AgGridVue} from 'ag-grid-vue';
import 'ag-grid-enterprise';
import {
  gridAddressGetter,
  gridDateGetter,
  gridDateFormatter,
  gridCurrencyFormatter,
  gridCurrencyGetter,
  gridNameGetter,
} from '@/mixins/AGGridHelpers';

// SFC component that defines and gets mounted as the inside of the detail in
// the Master -> Detail view
import transactionDetail from '../common/transactionDetail.vue';

const download = () => import('../common/download.vue');
const saveSearch = () => import('../common/saveSearch.vue');
const saveList = () => import('../common/saveList.vue');

import valuePicker from './value.pick.vue';

var defaultQuery = {
  donor_last_name: '',
  donor_first_name: '',
  donor_middle_name: '',
  donor_organization_name: '',
  election_year: [],
  filing: [],
  filing_schedule: [],
  filer_name: '',
  filer_id: '',
  donor_address: '',
  donor_city: '',
  donor_zip_low: '',
  donor_zip_high: '',
  donor_zip: '',
  original_amount_low: '',
  original_amount_high: '',
  dollarRange: '',
  transaction_date_low: '',
  transaction_date_high: '',
  limit: 1000,
  offset: 0,
};
export default {
  name: 'donorSearch',
  components: {
    AgGridVue,
    download,
    saveSearch,
    saveList,
    valuePicker,
    transactionDetail,
  },
  props: {
    loadExistingSearch: {
      default: false,
      type: Boolean,
    },
    userID: Number,
    saveID: Number,
    savedListParams: String,
  },
  data: function () {
    return {
      queryLoading: false,
      downloading: false,
      defaultQuery: JSON.parse(JSON.stringify(defaultQuery)),
      query: JSON.parse(JSON.stringify(defaultQuery)),
      queryRoute: '/donor/donor-search',
      queryResults: [],
      dateSyncLow: new Date().toISOString().substr(0, 10),
      dateSyncHigh: new Date().toISOString().substr(0, 10),
      dateMenuLow: false,
      dateMenuHigh: false,
      loading: false,
      searchTimestamp: '',
      queryCount: false,
      rowIDs: [],
      // This should probably be done globally and made available to every component
      windowBreakpoint: this.getBreakpoint(this.windowWidth),
      // ag Grid options
      gridOptions: null,
      gridApi: null,
      columnApi: null,
      columnDefs: null,
      defaultColDef: null,
      detailCellRendererParams: null,
      rowSelection: null,
      selectedRowIDs: [],
      detailCellRenderer: null,
      detailRowHeight: null,
      groupDefaultExpanded: null,
      frameworkComponents: null,
      selectFields: {
        election_year: donorSearchDefault.ELECTION_YEARS,
        filing: donorSearchDefault.FILING_KEY,
        filing_schedule: donorSearchDefault.FILING_SCHEDULE_KEY
      },
      selectList: [],
      selectModel: '',
    };
  },
  validations: {},
  computed: {
    queryDisabled: function () {
      return (
          this.query.donor_last_name === '' &&
          this.query.donor_first_name === '' &&
          this.query.donor_middle_name === '' &&
          this.query.original_amount_low === '' &&
          this.query.original_amount_high === '' &&
          this.query.transaction_date_low === '' &&
          this.query.transaction_date_high === '' &&
          this.query.filing_schedule.length === 0 &&
          this.query.filing.length === 0 &&
          this.query.election_year.length === 0 &&
          this.query.filer_name === '' &&
          this.query.filer_id === '' &&
          this.query.donor_address === '' &&
          this.query.donor_city === '' &&
          this.query.donor_zip_low === '' &&
          this.query.donor_zip_high === '' &&
          this.query.donor_zip === '' &&
          this.query.donor_organization_name === ''
      );
    },
  },
  watch: {},
  beforeMount: function () {
    this.gridOptions = {
      // This is fine to have in production. Suppresses debug info on colDefs
      suppressPropertyNamesCheck: true,
      sideBar: {
        toolPanels: [
          {
            id: 'columns',
            labelDefault: 'Columns',
            labelKey: 'columns',
            iconKey: 'columns',
            toolPanel: 'agColumnsToolPanel',
            toolPanelParams: {
              suppressRowGroups: true,
              suppressValues: true,
              suppressPivots: true,
              suppressPivotMode: true,
            },
          },
          {
            id: 'filters',
            labelDefault: 'Filters',
            labelKey: 'filters',
            iconKey: 'filter',
            toolPanel: 'agFiltersToolPanel',
          },
        ],
        position: 'right',
        defaultToolPanel: '',
      },
    },
        /**
         *  Column definitions for the grid. We define the label, the field from the queryResults object
         *  and then apply a valueGetter or valueFormatter that give us the presentation data.
         *
         *  Cell renderers modify the structure of the cell itself. Here we're using them to create
         *  programmatic navigation to either link to another route with params or to force the current
         *  component to submit a new query with new parameters but without leaving the page.
         */
        (this.columnDefs = [
          {
            headerName: 'Donor Name',
            field: 'donor_name',
            breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
            width: 200,
            minWidth: 100,
            maxWidth: 300,
            suppressSizeToFit: true,
            valueGetter: (params) => {
              if (params.data.donor_organization_name) {
                return gridNameGetter([params.data.donor_organization_name]);
              } else if (params.data.donor_first_name || params.data.donor_last_name) {
                return gridNameGetter([params.data.donor_first_name, params.data.donor_middle_name, params.data.donor_last_name]);
              } else {
                return '[Donor Name Missing]';
              }
            },
            cellRenderer: (params) => {
              var _this = this;
              const link = document.createElement('a');
              link.href = '';
              link.innerText = params.value;
              link.addEventListener('click', (e) => {
                e.preventDefault();
                // Reset query
                var newQuery = {
                  donor_first_name: params.data.donor_first_name,
                  donor_middle_name: params.data.donor_middle_name,
                  donor_last_name: params.data.donor_last_name,
                  donor_organization_name: params.data.donor_organization_name,
                };
                _this.changeQuery(newQuery);
              });
              return link;
            },
          },
          {
            headerName: 'Address',
            field: 'donor_address',
            valueGetter: params => gridAddressGetter([params.data.donor_address,
              params.data.donor_city,
              params.data.donor_state,
              params.data.donor_zip,]),
            breakpoints: ['lg', 'xl'],
            width: 275,
            minWidth: 200,
            maxWidth: 400,
            cellRenderer: (params) => {
              var _this = this;
              const link = document.createElement('a');
              link.href = '';
              link.innerText = params.value;
              link.addEventListener('click', (e) => {
                e.preventDefault();
                // Reset query
                var newQuery = {
                  donor_address: params.data.donor_address,
                  donor_city: params.data.donor_city,
                  donor_zip_low: params.data.donor_zip,
                  donor_state: params.data.donor_state,
                };
                _this.changeQuery(newQuery);
              });
              return link;
            },
          },
          // {
          //   headerName: 'City',
          //   field: 'donor_city',
          //   breakpoints: ['md','lg','xl'],
          //   width: 150,
          //   minWidth: 100,
          //   maxWidth: 200,
          //   cellRenderer: (params) => {
          //     var _this = this
          //     const link = document.createElement('a')
          //     link.href = ''
          //     link.innerText = params.value
          //     link.addEventListener('click', (e) => {
          //       e.preventDefault()
          //       // Reset query
          //       var newQuery = {
          //         donor_city: params.data.donor_city
          //       }
          //       _this.changeQuery(newQuery)
          //     })
          //     return link
          //   },
          // },
          {
            headerName: 'Amount',
            field: 'original_amount',
            valueGetter: params => gridCurrencyGetter(params.data.original_amount),
            valueFormatter: params => gridCurrencyFormatter(params.value),
            breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
            width: 110,
            minWidth: 75,
            maxWidth: 150,
          },
          {
            headerName: 'Date',
            field: 'transaction_date',
            valueGetter: params => gridDateGetter(params.data.transaction_date),
            valueFormatter: params => gridDateFormatter(params.value),
            breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
            width: 110,
            minWidth: 100,
            maxWidth: 150,
            sort: 'desc'
          },
          /***
           * @TODO Implemnent custom sorting for transaction IDs. Most are numeric but many aren't.
           * */
          {
            headerName: 'ID',
            field: 'transaction_number',
            breakpoints: ['lg', 'xl'],
            width: 100,
            minWidth: 100,
            maxWidth: 150,
            hide: true,
          },
          {
            headerName: 'Filer ID',
            field: 'filer_id',
            width: 100,
            minWidth: 100,
            maxWidth: 100,
            breakpoints: ['lg', 'xl'],
            cellRenderer: (params) => {
              const route = {
                name: 'filer',
                params: {filerID: params.data.filer_id},
              };
              const link = document.createElement('a');
              link.href = this.$router.resolve(route).href;
              link.innerText = params.value;
              link.addEventListener('click', (e) => {
                e.preventDefault();
                this.$router.push(route);
              });
              return link;
            },
          },
          {
            headerName: 'Filer Name',
            field: 'filer_name',
            sortable: true,
            filter: true,
            breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
            width: 300,
            minWidth: 200,
            maxWidth: 350,
            suppressSizeToFit: true,
            cellRenderer: (params) => {
              var _this = this;
              const link = document.createElement('a');
              link.href = '';
              link.innerText = params.value;
              link.addEventListener('click', (e) => {
                e.preventDefault();
                // Reset query
                var newQuery = {
                  filer_name: params.data.filer_name,
                };
                _this.changeQuery(newQuery);
              });
              return link;
            },
          },
          {
            headerName: 'Details',
            sortable: false,
            filter: false,
            resizable: false,
            breakpoints: ['lg', 'xl'],
            width: 125,
            minWidth: 100,
            maxWidth: 150,
            valueGetter: () => 'Expand',
            cellRenderer: 'agGroupCellRenderer',
          },
        ]),
        (this.detailCellRendererParams = {
          detailGridOptions: {
            columnDefs: [
              {header: 'Filer Name', field: 'filer_name'},
              {
                header: 'Original Amount',
                field: 'original_amount',
                valueFormatter: gridCurrencyFormatter,
              },
            ],
            defaultColDef: {flex: 1},
          },
        }),
        (this.context = {
          componentParent: this
        });
    this.defaultColDef = {
      resizable: true,
      sortable: true,
      filter: true,
      menuTabs: ['columnsMenuTab', 'filterMenuTab', 'generalMenuTab'],
      sideBar: true,
    };
    this.detailRowHeight = 250;
    this.groupDefaultExpanded = 1;
    this.rowSelection = 'multiple';
  },
  created: function () {

    // Set the initial breakpoint before the rest is rendered.
    this.windowBreakpoint = this.getBreakpoint(this.windowWidth);

    // If certain props are set at component creation, either retrieve an existing search
    // from nxsidx_ny.saved_searches or run a search on parameters coming from a saved list.
    if (this.userID && this.saveID) {
      this.loadExistingSearch = true;
      this.getExistingSearch();
    }
    if (this.userID && this.savedListParams) {
      this.loading = true;
      var params = JSON.parse(this.savedListParams);
      this.query = params;
      this.submitQuery();
    }
  },
  mounted: function () {
    this.gridApi = this.gridOptions.api;
    this.gridColumnApi = this.gridOptions.columnApi;
  },
  methods: {
    pickValue: function (val, list) {
      this.selectList = list;
      this.selectModel = val;
      $('#dValuePick').modal('show');
    },
    submitQuery: function () {
      var _this = this;
      if (this.queryDisabled) {
        return;
      }
      this.queryLoading = true;
      this.loading = true;
      this.query.action = 'query';
      var params = {
        query: this.query,
        token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
      };
      this.axios.get(this.$root.baseURI + '/donor/donor-search', {
        params: params
      }).then(function (response) {
        _this.$root.handleTokenError(response.data);
        _this.queryLoading = false;
        _this.loading = false;
        if (response.data.error) {
          _this.$root.setAlert(true, response.data.error, 'alert-danger');
          return;
        } else {
          if (response.data.length) {
            _this.queryCount = response.data[0][0].records;
            _this.queryResults = Object.freeze(response.data[1]);
            // We keep tabs on the row ids to pass to the Save List component
            _this.rowIDs = _this.queryResults.map((row) => row.unique_id);
            _this.searchTimestamp = _this.formattedNow();

          } else {
            _this.$root.setAlert(true, 'Error performing query', 'alert-danger');
            return;
          }
        }
      }).catch(error => {
        _this.queryLoading = false;
        _this.loading = false;
        _this.$root.setAlert(true, error, 'alert-danger');
        return;
      });
    },
    getExistingSearch: function () {
      this.loading = true;
      var query = {
        userid: this.$root.user.userid,
        saveid: this.saveID,
      };
      this.getRequestAsync(this.$root.baseURI + '/user-favorites/get.saved-search', query)
          .then((response) => {
            this.query = JSON.parse(response[0]['search_parameters']);
          })
          .then(() => {
            this.submitQuery();
          })
          .catch(() => {
          });
    },
    modifyLookup: function () {
      this.loadExistingSearch = false;
      this.queryCount = false;
      this.queryResults = false;
      this.pageNumber = 0;
    },
    resetLookup: function () {
      this.loadExistingSearch = false;
      this.queryCount = false;
      this.queryResults = false;
      this.query = JSON.parse(JSON.stringify(defaultQuery));
      this.pageNumber = 0;
    },
    //ag Grid methods
    getResponsiveColDefs: function (breakpoint, columns) {
      var hiddenColumns = columns.map(column => {
        if (column.colDef.breakpoints && !column.colDef.breakpoints.includes(breakpoint)) {
          return column.colId;
        }
      });

      var visibleColumns = columns.map(column => {
        if (column.colDef.breakpoints && column.colDef.breakpoints.includes(breakpoint)) {
          return column.colId;
        }
      });
      return [visibleColumns, hiddenColumns];
    },
    showCheckboxSelection: function () {
      var columnDefs = this.gridOptions.api.getColumnDefs();

      var indexColumnDef = columnDefs[0];
      indexColumnDef = {
        ...indexColumnDef,
        checkboxSelection: true,
        headerCheckboxSelection: true,
        headerCheckboxSelectionFilteredOnly: true,
      };
      columnDefs[0] = indexColumnDef;
      this.rowSelection = true;
      this.gridApi.setColumnDefs(columnDefs);
      this.gridApi.refreshCells();
    },
    hideCheckboxSelection: function () {
      var columnDefs = this.gridOptions.api.getColumnDefs();

      var indexColumnDef = columnDefs[0];
      indexColumnDef = {
        ...indexColumnDef,
        checkboxSelection: false,
        headerCheckboxSelection: false,
        headerCheckboxSelectionFilteredOnly: false,
      };
      columnDefs[0] = indexColumnDef;
      this.rowSelection = false;
      this.gridApi.setColumnDefs(columnDefs);
      this.gridApi.refreshCells();
    },
    onFirstDataRendered(params) {

      params.api.sizeColumnsToFit();
      this.gridApi = this.gridOptions.api;

      // Moved from default col def to setting
      // prop based on initial screen size
      if (['xs', 'sm', 'md'].includes(this.windowBreakpoint)) {
        this.hideCheckboxSelection();
      } else {
        this.showCheckboxSelection();
      }

    },
    // This method hides/shows columns when the grid is resized.
    // Calls new method getResponsiveColDefs to change definition
    // according to breakpoint
    onGridSizeChanged(params) {

      // Set new breakpoint on resize
      this.windowBreakpoint = this.getBreakpoint(this.windowWidth);

      // Get existing column definitions and figure out
      // what columns don't have that breakpoint in their def
      var allColumns = params.columnApi.getAllColumns();
      var [columnsToShow, columnsToHide] = this.getResponsiveColDefs(this.windowBreakpoint, allColumns);

      params.columnApi.setColumnsVisible(columnsToShow, true);
      params.columnApi.setColumnsVisible(columnsToHide, false);
      params.api.sizeColumnsToFit();

      // On small screens, we're going to hide the save methods
      // and the checkboxes

      if (['xs', 'sm', 'md'].includes(this.windowBreakpoint)) {
        this.hideCheckboxSelection();
      } else {
        this.showCheckboxSelection();
      }

    },
    onRowSelected() {
      let selectedNodes = this.gridApi.getSelectedNodes();
      let selectedData = selectedNodes.map((node) => node.data);
      this.selectedRowIDs = selectedData.map((row) => row.unique_id);
      return selectedData;
    },
    changeQuery: function (newQuery) {
      this.gridOptions.api.setRowData([]);
      this.queryCount = [];
      this.queryResults = [];
      this.query = JSON.parse(JSON.stringify(defaultQuery));
      this.query = Object.assign(this.query, newQuery);
      this.submitQuery();
    },
  },
};
</script>
<style lang="scss" scoped>
@import "../assets/nexusStyle.css";

.fade-enter-active, .fade-leave-active {
  transition: all .3s ease;
}

.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */
{
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