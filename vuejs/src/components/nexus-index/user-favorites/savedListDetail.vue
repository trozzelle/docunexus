<template>
  <div class="container-fluid main">
    <div v-if="!$root.loggedIn">
      <login></login>
    </div>
    <div v-else>
      <div class="container mb-0">
        <div class="row mt-3 mb-2 border-bottom">
          <div class="col-4">
            <h1 class="display-1">
              <i class="fas fa-fw fa-search"></i> Saved List
            </h1>
          </div>
          <div class="col-8">
            <div class="float-right">
              <div v-if="queryCount">
                <button type="button" class="mt-1 ml-1 btn btn-sm btn-primary" @click="runNewSearch()"><i
                    class="fas fa-undo"></i> Run search
                </button>
                <download :query="JSON.parse(this.queryMetadata.search_parameters)" :query-route="this.queryRoute"
                          search-type="Donor Search"></download>
<!--                <save-list :disabled="true"></save-list>-->
<!--                <save-search :query-parameters="this.query" :query-count="this.queryCount"-->
<!--                             :saved-search-name="this.queryMetadata.save_name"-->
<!--                             search-type="Donor Search" :time-ran="this.timeSearchRan"></save-search>-->
              </div>
              <div v-else>
                <router-link tag="button" type="button" to="/home" class="mt-1 btn btn-primary btn-sm float-right"><i
                    class="fas fa-arrow-left"></i> Back to home
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
      <transition name="fade" mode="out-in">
        <div v-if="loading">
          <div class="text-center">
            <b-spinner label="Spinning"></b-spinner>
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
            <div class="col-12 mt-1">
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
                           @row-selected="onRowSelected"
              >
              </ag-grid-vue>
            </div>
          </div>
        </div>
        <div v-if="failureMode">
          <div class="row my-2">
            <div class="col-12">
              <h4 class="display-4">
                Unable to retrieve search. Try refreshing the page.
              </h4>
            </div>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>
<!--suppress JSUnresolvedVariable -->
<script>
/***
 *  Saved List Detail component.
 *
 *  A grid component to load saved lists from the DB and present them. Saved user lists are decoupled from
 *  the transaction data and represent a past state saved for reference in case the data changes (mostly when
 *  filings are amended).
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
  gridNameGetter
} from '@/mixins/AGGridHelpers';

import download from '../common/download.vue';

import saveSearch from '../common/saveSearch.vue';
import saveList from '../common/saveList.vue';

import transactionDetail from '../common/transactionDetail.vue';

var defaultQuery = {
  donor_last_name: '',
  donor_first_name: '',
  donor_middle_name: '',
  donor_organization_name: '',
  election_year: '',
  filing: '',
  filing_schedule: '',
  filer_name: '',
  filer_id: '',
  donor_address: '',
  donor_city: '',
  donor_zip_low: '',
  donor_zip_high: '',
  donor_zip: '',
  original_amount_low: '',
  original_amount_high: '',
  transaction_date_low: '',
  transaction_date_high: '',
  limit: 1000,
  offset: 0,
};

export default {
  name: 'SavedList',
  components: {
    AgGridVue,
    download: download,
    // saveSearch,
    // saveList,
    transactionDetail,
  },
  props: {
    loadExistingSearch: {
      default: false,
      type: Boolean,
    },
    userID: String,
    saveID: String,
  },
  data: function () {
    return {
      queryLoading: false,
      downloading: false,
      defaultQuery: JSON.parse(JSON.stringify(defaultQuery)),
      failureMode: false,
      query: JSON.parse(JSON.stringify(defaultQuery)),
      queryRoute: '/donor/donor-search',
      queryResults: [],
      queryMetadata: [],
      dateSyncLow: new Date().toISOString().substr(0, 10),
      dateSyncHigh: new Date().toISOString().substr(0, 10),
      dateMenuLow: false,
      dateMenuHigh: false,
      loading: false,
      savedSearchName: 'Default',
      timeSearchRan: '',
      queryCount: false,
      rowIDs: [],
      //Multiselect keys
      electionYears: donorSearchDefault.ELECTION_YEARS,
      filingKey: donorSearchDefault.FILING_KEY,
      filingScheduleKey: donorSearchDefault.FILING_SCHEDULE_KEY,
      // ag Grid options
      gridOptions: null,
      gridApi: null,
      columnApi: null,
      columnDefs: null,
      defaultColDef: null,
      detailCellRendererParams: null,
      rowSelection: null,
      selectedRows: [],
      detailCellRenderer: null,
      detailRowHeight: null,
      groupDefaultExpanded: null,
      frameworkComponents: null,
    };
  },
  watch: {},
  beforeMount: function () {
    this.gridOptions = {
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
    };
    (this.columnDefs = [
      {
        headerName: 'Donor Name',
        field: 'donor_name',
        headerCheckboxSelection: true,
        headerCheckboxSelectionFilteredOnly: true,
        checkboxSelection: true,
        valueGetter: (params) => {
          if (params.data.donor_organization_name) {
            return gridNameGetter([params.data.donor_organization_name]);
          } else if (params.data.donor_first_name || params.data.donor_last_name) {
            return gridNameGetter([params.data.donor_first_name, params.data.donor_middle_name, params.data.donor_last_name]);
          } else {
            return '[Donor Name Missing]';
          }
        },
      },
      {
        headerName: 'Address',
        field: 'donor_address',
        valueGetter: params => gridAddressGetter([params.data.donor_address,
          params.data.donor_city,
          params.data.donor_state,
          params.data.donor_zip,]),
      },
      {
        headerName: 'Amount',
        valueGetter: params => gridCurrencyGetter(params.data.original_amount),
        valueFormatter: params => gridCurrencyFormatter(params.value),
        width: 110,
        minWidth: 110,
        maxWidth: 150,
      },
      {
        headerName: 'Date',
        valueGetter: params => gridDateGetter(params.data.transaction_date),
        valueFormatter: params => gridDateFormatter(params.value),
        width: 110,
        minWidth: 110,
        maxWidth: 150,
        sort: 'desc'
      },
      /***
       * @TODO Implemnent custom sorting for transaction IDs. Most are numeric but many aren't.
       * */
      {
        headerName: 'Transaction ID',
        field: 'transaction_number',
        width: 100,
        minWidth: 100,
        maxWidth: 150,
      },
      {
        headerName: 'Filer ID',
        field: 'filer_id',
        width: 100,
        minWidth: 100,
        maxWidth: 100,
      },
      {
        headerName: 'Filer Name',
        field: 'candidate_committee_name',
        sortable: true,
        filter: true,
        width: 300,
        minWidth: 200,
        maxWidth: 350,
      },
      {
        headerName: 'Details',
        sortable: false,
        filter: false,
        resizable: false,
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
        (this.context = {componentParent: this});
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
    if (this.userID && this.saveID) {
      this.loading = true;
      this.getSavedList();
    }
  },
  mounted: function () {
    this.gridApi = this.gridOptions.api;
    this.gridColumnApi = this.gridOptions.columnApi;
  },
  methods: {
    getSavedList: function () {
      this.queryLoading = true;
      this.loading = true;

      var query = {
        userid: this.$root.user.userid,
        saveid: this.saveID,
      };

      this.getRequestAsync(this.$root.baseURI + '/user-favorites/get.saved-list', query)
          .then((response) => {
            this.queryCount = response[1].length;
            this.queryResults = Object.freeze(response[1]);
            this.queryMetadata = response[0][0];
            this.query = JSON.parse(this.queryMetadata.search_parameters);
            this.rowIDs = this.queryResults.map((row) => row.unique_id);
            this.timeSearchRan = this.$dayjs().format('YYYY-MM-DD HH:mm:ss');
            this.queryLoading = false;
            this.loading = false;
          })
          .catch(() => {
            this.loading = false;
            this.queryLoading = false;
            this.failureMode = true;
          });
    },
    runNewSearch: function () {
      this.$router.push({
        name: 'donor',
        params: {
          loadExistingSearch: true,
          userID: this.$root.user.userid,
          savedListParams: this.queryMetadata.search_parameters,
        },
      });
    },
    //ag Grid methods
    onFirstDataRendered(params) {
      params.api.sizeColumnsToFit();
      this.gridApi = this.gridOptions.api;
    },
    onRowSelected() {
      let selectedNodes = this.gridApi.getSelectedNodes();
      let selectedData = selectedNodes.map((node) => node.data);
      this.selectedRows = JSON.stringify(selectedData);
      console.log(this.selectedRows);
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
<style scoped>

.main {
  margin-bottom: 80px;
}
</style>