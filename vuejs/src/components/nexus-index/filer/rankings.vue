<template>
  <div id="nexus-index" class="container">
    <div v-if="!$root.loggedIn">
      <login></login>
    </div>
    <div v-else>
      <div class="row mt-3 mb-2 border-bottom">
        <div class="col-8">
          <h1 class="display-1">
            <i class="text-primary fad fa-fw"
               :class="{ 'fad fa-trophy': !loading, 'fa-circle-notch fa-spin': loading }"></i> Filer Rankings</h1>
        </div>
        <div class="col-4">
          <router-link
              tag="button"
              type="button"
              to="/home"
              class="mt-1 btn btn-sm btn-primary float-right"
          ><i class="fas fa-arrow-left"></i> Back to home
          </router-link>
        </div>
      </div>
      <div class="row gutters mt-3">
        <div class="col-12">
          <b-card class="mb-2">
            <b-card-title class="text-center" style="font-size: 28px;">{{ cardTitle }}</b-card-title>
            <b-card-sub-title class="text-center pb-2" style="font-size: 20px;">{{ cardSubtitle }}</b-card-sub-title>
            <b-tabs v-model="tabIndex" align="center" :small="tabsSmall" card>
              <!-- Lazy loading tabs mount/unmount each grid instance and fixes autoColumnSize -->
              <b-tab title="Candidates" lazy>
                <div class="row mt-3">
                  <div class="col-12">
                    <ag-grid-vue
                        style="width: 100%; height: 600px"
                        class="ag-theme-alpine"
                        pagination="true"
                        :column-defs="columnDefs"
                        :enableBrowserTooltips="true"
                        :row-data="candidatesResults"
                        @first-data-rendered="onFirstDataRendered"
                        @grid-size-changed="onGridSizeChanged"
                    >
                    </ag-grid-vue>
                  </div>
                </div>
              </b-tab>
              <b-tab title="Multi-Candidate" lazy>
                <div class="row mt-3">
                  <div class="col-12">
                    <ag-grid-vue
                        style="width: 100%; height: 600px"
                        class="ag-theme-alpine"
                        pagination="true"
                        :column-defs="columnDefs"
                        :enableBrowserTooltips="true"
                        :row-data="multiCandidatesResults"
                        @first-data-rendered="onFirstDataRendered"
                        @grid-size-changed="onGridSizeChanged"
                    >
                    </ag-grid-vue>
                  </div>
                </div>
              </b-tab>
              <b-tab title="PACs" lazy>
                <div class="row mt-3">
                  <div class="col-12">
                    <ag-grid-vue
                        style="width: 100%; height: 600px"
                        class="ag-theme-alpine"
                        pagination="true"
                        :column-defs="columnDefs"
                        :row-data="pacResults"
                        @first-data-rendered="onFirstDataRendered"
                        @grid-size-changed="onGridSizeChanged"
                    >
                    </ag-grid-vue>
                  </div>
                </div>
              </b-tab>
              <b-tab title="Party Committees" lazy>
                <div class="row mt-3">
                  <div class="col-12">
                    <ag-grid-vue
                        style="width: 100%; height: 600px"
                        class="ag-theme-alpine"
                        pagination="true"
                        :column-defs="columnDefs"
                        :row-data="partyResults"
                        @first-data-rendered="onFirstDataRendered"
                        @grid-size-changed="onGridSizeChanged"
                    >
                    </ag-grid-vue>
                  </div>
                </div>
              </b-tab>
              <b-tab title="I.E. Committees" lazy>
                <div class="row mt-3">
                  <div class="col-12">
                    <ag-grid-vue
                        style="width: 100%; height: 600px"
                        class="ag-theme-alpine"
                        pagination="true"
                        :column-defs="columnDefs"
                        :row-data="indExpResults"
                        @first-data-rendered="onFirstDataRendered"
                        @grid-size-changed="onGridSizeChanged"
                    >
                    </ag-grid-vue>
                  </div>
                </div>
              </b-tab>
            </b-tabs>
            <b-row class="my-4 justify-content-center">
              <b-col sm="10" md="8">
                <b-form inline class="mt-3 justify-content-center">
                  <label class="d-none d-md-flex mr-md-3 flex-sm-column" for="filing-select">Filing</label>
                  <b-form-select id="filing-select"
                                 v-model="selectedFiling"
                                 :options="availableFilings"
                                 class="mb-2 mr-sm-1 mb-sm-0 flex-sm-column">
                  </b-form-select>
                  <b-button class="mt-sm-3 mt-md-0 ml-md-3 flex-sm-column btn-primary" @click="setSelectedFiling()">Go</b-button>
                </b-form>
              </b-col>
            </b-row>
          </b-card>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
/**
 * Filings Summary component. Top ranking of contributions by for each filing by filer type.
 *
 * Pulls definitions of each type from formConstants, so we can add/subtract
 *
 */
import {filerRankingsDefault} from '../assets/js/formConstants.js';

import 'ag-grid-enterprise/dist/styles/ag-grid.css';
import 'ag-grid-enterprise/dist/styles/ag-theme-alpine.css';

import {AgGridVue} from 'ag-grid-vue';
import 'ag-grid-enterprise';
import {
  gridCurrencyFormatter,
  gridCurrencyGetter,
  gridNumberGetter,
} from '@/mixins/AGGridHelpers';

// Hard-coded for now. This will become dynamic once filing order method is finished
const initialFiling = ['2021', 'K'];

export default {
  name: 'Filer-Rankings',
  components: {
    AgGridVue
  },
  data: function () {
    return {
      cardTitle: "Top Raisers Per Filing",
      tabIndex: 0,
      loading: true,
      candidatesResults: null,
      multiCandidatesResults: null,
      pacResults: null,
      partyResults: null,
      indExpResults: null,
      activeFiling: initialFiling,
      selectedFiling: initialFiling,
      availableFilings: initialFiling,
      limit: 50,
      // Responsiveness variables
      windowBreakpoint: this.getBreakpoint(this.windowWidth),
      tabsSmall: false,
      //ag-grid configuration
      gridLoading: true,
      gridData: null,
      gridOptions: null,
      gridApi: null,
      columnApi: null,
      columnDefs: [],
    };
  },
  computed: {
    // Look up the display value of the filing abbreviation for the subtitle
    cardSubtitle: function () {
      return "(" + this.activeFiling[0] + " " + filerRankingsDefault.FILING_KEY.find(filing => filing.val === this.activeFiling[1]).display + ")";
    },
  },
  beforeMount() {
    this.gridOptions = {};
    this.columnDefs = [
      {
        headerName: '#',
        field: 'rank',
        sortable: true,
        filter: true,
        breakpoints: ['md','lg','xl'],

        width: 75
      },
      {
        headerName: 'Name',
        field: 'filer_name',
        sortable: true,
        filter: true,
        tooltipField: 'filer_name',
        breakpoints: ['xs','sm','md','lg','xl'],
        width: 350,
        cellRenderer: (params) => {
          var _this = this;
          const route = {
            name: 'filer',
            params: {filerID: params.data.filer_id},
          };
          const link = document.createElement('a');
          link.href = _this.$router.resolve(route).href;
          link.innerText = params.value;
          link.addEventListener('click', (e) => {
            e.preventDefault();
            _this.$router.push(route);
          });
          return link;
        },
      },
      {
        headerName: 'ID',
        field: 'filer_id',
        valueGetter: params => gridNumberGetter(params.data.filer_id),
        sortable: true,
        filter: true,
        breakpoints: ['md','lg','xl'],
        width: 100,
        minWidth: 100,
        maxWidth: 100,
      },
      {
        headerName: 'Year',
        field: 'election_year',
        sortable: true,
        filter: true,
        breakpoints: ['md','lg','xl'],
        width: 100,
        minWidth: 100,
        maxWidth: 100,
      },
      {
        headerName: 'Raise',
        valueGetter: params => gridCurrencyGetter(params.data.contributions),
        valueFormatter: params => gridCurrencyFormatter(params.value),
        sortable: true,
        filter: true,
        breakpoints: ['xs','sm','md','lg','xl'],
        sort: 'desc',
      },
      {
        headerName: 'Period Net',
        valueGetter: params => gridCurrencyGetter(params.data.net_raise),
        valueFormatter: params => gridCurrencyFormatter(params.value),
        sortable: true,
        filter: true,
        breakpoints: ['md','lg','xl'],
        cellStyle: (params) => {
          if (params.value > 0) {
            return {color: 'green'};
          } else {
            return {color: 'red'};
          }
        },
      },
    ];
    this.gridApi = this.gridOptions.api;
    this.gridColumnApi = this.gridOptions.columnApi;
  },
  created: function () {
    this.windowBreakpoint = this.getBreakpoint(this.windowWidth)

    this.setResponsiveProperties(this.windowBreakpoint)
    this.getAvailableFilings();
    this.getGridData();
  },
  methods: {
    setResponsiveProperties: function(breakpoint) {
      if (['xs','sm'].includes(breakpoint)) {
        this.tabsSmall = true;
      }
      else {
        this.tabsSmall = false;
      }
    },
    getAvailableFilings: async function () {
      this.getRequestAsync(this.$root.baseURI + '/filer/get.available-filings')
          .then((response) => {

            var availableFilings = response.map(filing => {
              return {
                "text": filing.election_year + " " + filing.filing_description,
                "value": [filing.election_year, filing.filing_abbreviation],
                "key": filing.filing_abbreviation,
                "year": filing.election_year
              };
            });
            this.availableFilings = availableFilings.sort((a, b) => {
              return b.value[0].localeCompare(a.value[0]) - a.value[0].localeCompare(b.value[0]) || filerRankingsDefault.FILING_ORDER.findIndex(f => f.abbrev == b.value[1]) - filerRankingsDefault.FILING_ORDER.findIndex(f => f.abbrev == a.value[1])});
          })
          // @TODO: Error handling for failed request
          .catch(() => {
          });
    },
    // Loads the data for all of the grids
    // Gets the data for the current tab first, then requests data for the others
    getGridData: function () {

      var candidatesQuery = {
        electionyear: this.selectedFiling[0],
        filingabbrev: this.selectedFiling[1],
        committeetypes: filerRankingsDefault.CANDIDATE_TYPE,
        limit: this.limit
      };

      var multiCandidatesQuery = {
        electionyear: this.selectedFiling[0],
        filingabbrev: this.selectedFiling[1],
        committeetypes: filerRankingsDefault.MULTI_CANDIDATE_TYPE,
        limit: this.limit
      };

      var pacQuery = {
        electionyear: this.selectedFiling[0],
        filingabbrev: this.selectedFiling[1],
        committeetypes: filerRankingsDefault.PAC_TYPES,
        limit: this.limit
      };

      var partyQuery = {
        electionyear: this.selectedFiling[0],
        filingabbrev: this.selectedFiling[1],
        committeetypes: filerRankingsDefault.PARTY_TYPES,
        limit: this.limit
      };

      var indExpQuery = {
        electionyear: this.selectedFiling[0],
        filingabbrev: this.selectedFiling[1],
        committeetypes: filerRankingsDefault.IND_EXPEND_TYPES,
        limit: this.limit
      };

      var route = this.$root.baseURI + '/filer/get.filer-rankings';

      var requestArr = [{key: 'candidatesResults', route: route, query: candidatesQuery},
        {key: 'multiCandidatesResults', route: route, query: multiCandidatesQuery},
        {key: 'pacResults', route: route, query: pacQuery},
        {key: 'partyResults', route: route, query: partyQuery},
        {key: 'indExpResults', route: route, query: indExpQuery}];

      this.getRequestAsync(requestArr[this.tabIndex].route, requestArr[this.tabIndex].query)
          .then((response) => {
            this[requestArr[this.tabIndex].key] = response;
            this.activeFiling = this.selectedFiling;

          })
          .then(() => {
            requestArr.splice(this.tabIndex, 1);

            requestArr.forEach(requestType => {
              this.getRequestAsync(requestType.route, requestType.query)
                  .then(response => {
                    this[requestType.key] = response;

                  });
            });
          })
          .finally(() => this.loading = false);
    },
    // AG Grid methods
    getResponsiveColDefs: function(breakpoint, columns) {
      var hiddenColumns = columns.map(column => {
        if(column.colDef.breakpoints && !column.colDef.breakpoints.includes(breakpoint)){
          return column.colId;
        }
      });

      var visibleColumns = columns.map(column => {
        if(column.colDef.breakpoints && column.colDef.breakpoints.includes(breakpoint)){
          return column.colId;
        }
      });
      return [visibleColumns, hiddenColumns];
    },
    setSelectedFiling: async function () {
      this.gridApi.showLoadingOverlay();
      this.getGridData();
    },
    onFirstDataRendered(params) {
      this.gridApi = params.api;
      params.api.sizeColumnsToFit();
    },
    onGridSizeChanged(params) {

      // Set new breakpoint on resize
      this.windowBreakpoint = this.getBreakpoint(this.windowWidth);
      this.setResponsiveProperties(this.windowBreakpoint)

      // Get existing column definitions and figure out
      // what columns don't have that breakpoint in their def
      var allColumns = params.columnApi.getAllColumns();
      var [columnsToShow, columnsToHide] = this.getResponsiveColDefs(this.windowBreakpoint, allColumns)

      params.columnApi.setColumnsVisible(columnsToShow, true);
      params.columnApi.setColumnsVisible(columnsToHide, false);
      params.api.sizeColumnsToFit();

    },
  },
};
</script>
<style scoped>

</style>
