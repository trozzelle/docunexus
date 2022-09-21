<template>
  <div class="container-fluid" style="padding-bottom: 80px">
    <div v-if="!$root.loggedIn">
      <login></login>
    </div>
    <div v-else>
      <div class="container" style="max-width: 1400px;">
        <div class="row mt-3 mb-2 border-bottom">
          <div class="col-8">
            <h1 class="display-1">
              <i
                  class="fas fa-fw text-primary"
                  :class="{ 'fa-history': !filerLoading, 'fa-circle-notch fa-spin': filerLoading }"
              ></i>
              Filer Overview
            </h1>
          </div>
          <div class="col-4">
            <router-link
                tag="button"
                type="button"
                to="/home"
                class="mt-1 btn btn-primary float-right"
            ><i class="fas fa-arrow-left"></i> Back to home
            </router-link>
            <bookmark v-if="filerDetails.filer_id" :page-details="this.pageDetails"></bookmark>
          </div>
        </div>
        <div v-if="!filerDetails.filer_id && !filerLoading && !fundraisingLoading">
          <h4>No details are available for filer ID {{ $route.params.filerID }}</h4>
        </div>
        <div v-else>
          <div class="row gutters mt-3">
            <div class="col-3">
              <filer-card v-if="!filerLoading && !fundraisingLoading" :filer-details="this.filerDetails"></filer-card>
            </div>
            <div class="col-9">
              <filer-container
                  v-if="!filerLoading && !fundraisingLoading"
                  :filer-details="this.filerDetails"
                  :fundraising-details="this.fundraisingDetails"
                  @set-filing="setSelectedFiling"
                  @set-summary="setGridData"
              ></filer-container>
            </div>
          </div>
          <div v-if="!fundraisingLoading && !gridLoading" class="row mt-3">
            <div class="col-12">
              <ag-grid-vue
                  style="width: 100%; height: 600px"
                  class="ag-theme-alpine"
                  pagination="true"
                  :column-defs="columnDefs"
                  :row-data="gridData"
                  @first-data-rendered="onFirstDataRendered"
                  :statusBar="statusBar"
                  :enableBrowserTooltips="true"
              >
              </ag-grid-vue>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
/**
 * Filer detail card component for filer overview.
 *
 *
 *
 */
import bookmark from '@/components/common/bookmark.vue';
import filerCard from './filerCard.vue';
import filerContainer from './filerContainer.vue';
import {filerSummaryDefault} from "@/components/nexus-index/assets/js/formConstants";

import 'ag-grid-enterprise/dist/styles/ag-grid.css';

import {AgGridVue} from 'ag-grid-vue';
import 'ag-grid-enterprise';
import {
  gridAddressGetter,
  gridNameGetter,
  gridDateGetter,
  gridCurrencyFormatter,
  gridDateFormatter,
} from '@/mixins/AGGridHelpers';

var defaultQuery = {
  filerID: '',
};

// var fundraisingColumnDefs = [
//     { headerName: 'Filer', field: 'filer_id', sortable: true, filter: true },
//     { headerName: 'Year', field: 'election_year', sortable: true, filter: true },
//     {
//         headerName: 'Filing Period',
//         field: 'filing_description',
//         sortable: true,
//         filter: true,
//     },
//     {
//         headerName: 'Raise',
//         field: 'contributions',
//         sortable: true,
//         filter: true,
//         valueFormatter: currencyFormatter,
//     },
//     {
//         headerName: 'Spend',
//         field: 'expenditures',
//         sortable: true,
//         filter: true,
//         valueFormatter: currencyFormatter,
//     },
//     {
//         headerName: 'Period Net',
//         field: 'net_raise',
//         sortable: true,
//         filter: true,
//         valueFormatter: currencyFormatter,
//         cellStyle: (params) => {
//             if (params.value > 0) {
//                 return { color: 'green' };
//             } else {
//                 return { color: 'red' };
//             }
//         },
//     },
//
//     {
//         headerName: 'Calculated Cash on Hand',
//         field: 'cash_on_hand',
//         sortable: true,
//         filter: true,
//         valueFormatter: currencyFormatter,
//     },
// ]

var fundraisingColumnDefs = [
  {
    headerName: 'Filer',
    field: 'filer_id',
    sortable: true,
    filter: true,
    width: 110,
    minWidth: 110,
    maxWidth: 150,
  },
  {
    headerName: 'Year',
    field: 'election_year',
    sortable: true,
    filter: true,
    width: 110,
    minWidth: 110,
    maxWidth: 150,
    sort: 'desc'
  },
  {
    headerName: 'Filing Period',
    field: 'filing_description',
    sortable: true,
    filter: true,
  },
  {
    headerName: 'Raise',
    valueGetter: params => Number(params.data.contributions),
    valueFormatter: params => gridCurrencyFormatter(params.value),
    sortable: true,
    filter: true,
  },
  {
    headerName: 'Spend',
    valueGetter: params => Number(params.data.expenditures),
    valueFormatter: params => gridCurrencyFormatter(params.value),
    sortable: true,
    filter: true,
  },
  {
    headerName: 'Period Net',
    valueGetter: params => Number(params.data.net_raise),
    valueFormatter: params => gridCurrencyFormatter(params.value),
    sortable: true,
    filter: true,
    cellStyle: (params) => {
      if (params.value > 0) {
        return {color: 'green'};
      } else {
        return {color: 'red'};
      }
    },
  },

  {
    headerName: 'Calculated Cash on Hand',
    valueGetter: params => Number(params.data.cash_on_hand),
    valueFormatter: params => gridCurrencyFormatter(params.value),
    sortable: true,
    filter: true,
  },
];

var transactionColumnDefs = [
  {
    headerName: 'Name',
    valueGetter: (params) => {
      if (params.data.donor_organization_name) {
        return gridNameGetter([params.data.donor_organization_name]);
      } else {
        return gridNameGetter([params.data.donor_first_name, params.data.donor_middle_name, params.data.donor_last_name]);
      }
    },
    sortable: true,
    filter: true,
    width: 300,
    minWidth: 200,
    maxWidth: 350,
  },
  {
    headerName: 'Address',
    valueGetter: params => gridAddressGetter([params.data.donor_address,
      params.data.donor_city,
      params.data.donor_state,
      params.data.donor_zip,]),
    sortable: true,
    filter: true,
    width: 300,
    minWidth: 200,
    maxWidth: 400,
  },
  {
    headerName: 'Date',
    valueGetter: params => gridDateGetter(params.data.transaction_date),
    valueFormatter: params => gridDateFormatter(params.value),
    sortable: true,
    filter: true,
    sort: 'desc'
  },
  {
    headerName: 'Amount',
    valueGetter: params => Number(params.data.original_amount),
    valueFormatter: params => gridCurrencyFormatter(params.value),
    sortable: true,
    filter: "agNumberColumnFilter",
    filterParams: {
      suppressAndOrCondition: true,
      filterOptions: ["greaterThan"]
    },
  },
  {
    headerName: 'Type',
    field: 'filing_abbreviation',
    valueGetter: params => {
      return filerSummaryDefault.FILING_SCHEDULE_KEY.find(f => f.val === params.data.filing_schedule_abbreviation).short + " (" + params.data.filing_schedule_abbreviation + ")";
    },
    sortable: true,
    filter: true,
  },
  {
    headerName: 'Transaction ID',
    field: 'transaction_number',
    sortable: true,
    filter: true,
  },
];

export default {
  components: {
    bookmark,
    filerCard,
    filerContainer,
    AgGridVue,
  },
  props: ['filerID'],
  data: function () {
    return {
      name: 'Filer Overview',
      filerLoading: true,
      fundraisingLoading: false,
      pageDetails: {
        userid: this.$root.user.userid,
        pagetitle: '',
        pagetype: 'Filer Overview',
        routename: this.$route.name,
        routeparams: this.$route.params,
        pagelocation: this.$route.path,
        token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}],
      },
      query: JSON.parse(JSON.stringify(defaultQuery)),
      queryLoading: false,
      filerDetails: [],
      fundraisingDetails: [],
      queryCount: false,
      pageTitle: '',
      //ag-grid configuration
      gridLoading: false,
      gridData: [],
      gridOptions: null,
      gridApi: null,
      columnApi: null,
      columnDefs: fundraisingColumnDefs,
      statusBar: '',
    };
  },
  computed: {},
  watch: {
    $route: function () {
    },
    filerID: {
      handler: 'initializePage',
      immediate: true,
    },
  },
  beforeMount() {
    this.gridOptions = {};
    this.statusBar = {
      statusPanels: [
        {
          statusPanel: 'agAggregationComponent',
          statusPanelParams: {
            aggFuncs: ['count', 'sum'],
          },
        },
      ],
    };
    this.gridApi = this.gridOptions.api;
    this.gridColumnApi = this.gridOptions.columnApi;
  },
  mounted: function () {
  },
  methods: {
    initializePage: async function () {
      this.query.filerid = this.filerID;
      var _this = this;
      this.filerLoading = true;
      this.fundraisingLoading = true;

      const filerRequest = this.getRequestAsync(this.$root.baseURI + '/filer/filer.get', this.query);
      const fundraisingRequest = this.getRequestAsync(
          this.$root.baseURI + '/filer/fundraising-summary.get',
          this.query
      );

      const requestArray = [filerRequest, fundraisingRequest];

      // Make sure data loads at the same time
      Promise.allSettled(requestArray).then(function (responses) {
        if (responses[0].status === 'fulfilled') {
          _this.filerDetails = responses[0].value[0];
          _this.pageDetails.pagetitle = _this.filerDetails.filer_name;
          _this.filerLoading = false;
        }
        if (responses[1].status === 'fulfilled') {
          _this.fundraisingDetails = responses[1].value;
          _this.setGridData(_this.fundraisingDetails);
          _this.fundraisingLoading = false;
        }
      });
    },
    setGridData: function () {
      this.columnDefs = fundraisingColumnDefs;
      this.gridData = this.fundraisingDetails;
      this.fundraisingLoading = false;
    },
    setNewGridData: function (transactionDetails) {
      this.columnDefs = transactionColumnDefs;
      this.gridData = transactionDetails;
      this.gridLoading = false;
    },
    setSelectedFiling: async function (filing, transactionType) {
      var filerID = this.filerID;
      var electionYear = filing[0];
      var filingAbbreviation = filing[1];

      this.gridLoading = true;

      var query = {
        filerid: filerID,
        electionyear: electionYear,
        filingabbreviation: filingAbbreviation,
        transactiontype: transactionType,
        action: 'query',
      };

      var getTransactionDataRoute = this.$root.baseURI + '/filer/filing.get';

      this.getRequestAsync(getTransactionDataRoute, query)
          .then((response) => {
            this.setNewGridData(response);
          }).catch();
    },
    onFirstDataRendered(params) {
      params.api.sizeColumnsToFit();
    },
  },
};
</script>
<style scoped>
/* New css */

</style>
