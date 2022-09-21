<template>
  <div id="nexus-index" class="container-fluid main">
    <div v-if="!$root.loggedIn">
      <login></login>
    </div>
    <div v-else>
      <div class="container mb-0">
        <div class="row mt-3 mb-2 border-bottom">
          <div class="col-5">
            <h1 class="display-1">
              <i class="text-primary fad fa-fw fa-file-search"></i> Filer search
            </h1>
          </div>
          <div class="col-7">
            <div class="float-right">
              <div v-if="queryCount">
                <button type="button" class="mt-1 ml-1 btn btn-sm btn-primary" @click="resetLookup()"><i
                    class="fas fa-undo"></i> Start over
                </button>
                <button type="button" class="mt-1 ml-1 btn btn-sm btn-secondary" @click="modifyLookup()"><i
                    class="fas fa-pen"></i> Modify lookup
                </button>
                <download :query="query" :query-route="queryRoute" search-type="Filer Search"></download>
                <!-- If a user has selected rows, we pass that row ID array instead of the full row ID to Save List -->
                <save-list :query-parameters="query" :query-count="queryCount"
                           :row-i-ds="selectedRowIDs.length > 0 ? selectedRowIDs : rowIDs" search-type="Filer Search"
                           route-name="filer-search" :time-ran="searchTimestamp"></save-list>
                <save-search :query-parameters="query" :query-count="queryCount"
                             search-type="Filer Search" route-name="filer-search"
                             :time-ran="searchTimestamp"></save-search>
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

        <div class="container" v-if="!queryCount && loadExistingSearch == false">
          <b-card class="mb-2">
            <div class="row ml-1">
              <div class="col border-bottom">
                <h5>Filer Name</h5>
              </div>
            </div>
            <div class="row ml-1 mt-2 border-bottom">
              <div class="col-sm-12 col-md-6 col-lg-6">
                <div class="form-label-group">
                  <input v-model="query.filerName" type="text" name="organizationName" class="form-control"
                         placeholder=""/>
                  <label>Candidate, Committee, or PAC name</label>
                </div>
              </div>
              <div class="col-sm-12 col-md-2 col-lg-2">
                <div class="form-label-group">
                  <input v-model="query.filerID" type="text" name="organizationName" class="form-control"
                         placeholder=""/>
                  <label>Filer ID</label>
                </div>
              </div>
            </div>
            <div class="row ml-1 mt-2 border-bottom">
              <div class="row col-sm-12 col-md-4">
                <div class="col-12">
                  <h5>Compliance type</h5>
                </div>
                <div class="col-12">
                  <div class="form-group form-check-inline">
                    <input type="checkbox" class="form-check-input" id="complianceCommittee" value="COMMITTEE"
                           v-model="query.complianceTypeSelect">
                    <label class="form-check-label" for="complianceCommittee">Committee</label>
                  </div>
                  <div class="form-group form-check-inline">
                    <input type="checkbox" class="form-check-input" id="complianceCandidate" value="CANDIDATE"
                           v-model="query.complianceTypeSelect">
                    <label class="form-check-label" for="complianceCandidate">Candidate</label>
                  </div>
                </div>
              </div>
              <div class="row col-sm-12 col-md-4">
                <div class="col-12">
                  <h5>Filer type</h5>
                </div>
                <div class="col-12">
                  <div class="form-group form-check-inline">
                    <input type="checkbox" class="form-check-input" id="filerCounty" value="COUNTY"
                           v-model="query.filerTypeSelect">
                    <label class="form-check-label" for="filerCounty">County</label>
                  </div>
                  <div class="form-group form-check-inline">
                    <input type="checkbox" class="form-check-input" id="filerState" value="STATE"
                           v-model="query.filerTypeSelect">
                    <label class="form-check-label" for="filerState">State</label>
                  </div>
                </div>
              </div>
              <div class="row col-sm-12 col-md-4">
                <div class="col-12">
                  <h5>Filer status</h5>
                </div>
                <div class="col-12">
                  <div class="form-group form-check-inline">
                    <input type="checkbox" class="form-check-input" id="statusActive" value="ACTIVE"
                           v-model="query.filerStatusSelect">
                    <label class="form-check-label" for="statusActive">Active</label>
                  </div>
                  <div class="form-group form-check-inline">
                    <input type="checkbox" class="form-check-input" id="statusInactive" value="INACTIVE"
                           v-model="query.filerStatusSelect">
                    <label class="form-check-label" for="statusInactive">Inactive</label>
                  </div>
                </div>
              </div>
            </div>
            <div class="row ml-1 mt-2">
              <div class="row col-sm-12 col-md-6">
                <div class="col-12">
                  <h5>Committee type</h5>
                </div>
                <div class="col-12">
                  <div class="input-group">
                    <input type="text" disabled="disabled" placeholder="Committee type" class="form-control"
                           :value="selectFields.committeeTypes.filter(item => query.committeeTypeSelect.includes(item.val)).map(v => {return v.display}).join(', ')">
                    <div class="input-group-append">
                      <button type="button" v-on:click="pickValue('committeeTypeSelect', selectFields.committeeTypes)"
                              class="float-right btn btn-primary">Pick
                      </button>
                      <button type="button" :disabled="query.committeeTypeSelect.length == 0"
                              v-on:click="query.committeeTypeSelect = [];" class="float-right btn btn-secondary">Clear
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <div class="row col-sm-12 col-md-6">
                <div class="col-12">
                  <h5>Office type</h5>
                </div>
                <div class="col-12">
                  <div class="input-group">
                    <input type="text" disabled="disabled" placeholder="Office type" class="form-control"
                           :value="selectFields.officeTypes.filter(item => query.officeTypeSelect.includes(item.val)).map(v => {return v.display}).join(', ')">
                    <div class="input-group-append">
                      <button type="button" v-on:click="pickValue('officeTypeSelect', selectFields.officeTypes)"
                              class="float-right btn btn-primary">Pick
                      </button>
                      <button type="button" :disabled="query.officeTypeSelect.length == 0"
                              v-on:click="query.officeTypeSelect = [];" class="float-right btn btn-secondary">Clear
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="row ml-1 mt-2">
              <div class="row col-sm-12 col-md-6">
                <div class="col-12">
                  <h5>County</h5>
                </div>
                <div class="col-12">
                  <div class="input-group">
                    <input type="text" disabled="disabled" placeholder="Counties" class="form-control"
                           :value="selectFields.countyList.filter(item => query.counties.includes(item.val)).map(v => {return v.display}).join(', ')">
                    <div class="input-group-append">
                      <button type="button" v-on:click="pickValue('counties', selectFields.countyList)"
                              class="float-right btn btn-primary">Pick
                      </button>
                      <button type="button" :disabled="query.counties.length == 0" v-on:click="query.counties = [];"
                              class="float-right btn btn-secondary">Clear
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="row ml-1 mt-3">
              <div class="col border-bottom">
                <h5>Committee Addresss</h5>
              </div>
            </div>
            <div class="row ml-1 mt-2">
              <div class="col-sm-12 col-md-6">
                <div class="row">
                  <div class="col-sm-12 col-md-6">
                    <div class="form-label-group">
                      <input v-model="query.committeeAddress" type="text" name="address" class="form-control"
                             placeholder="Address"/>
                      <label>Address</label>
                    </div>
                  </div>
                  <div class="col-sm-12 col-md-6">
                    <div class="form-label-group">
                      <input v-model="query.committeeCity" type="text" name="city" class="form-control"
                             placeholder="City"/>
                      <label>City</label>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-sm-12 col-md-6">
                <div class="row">
                  <div class="col-sm-12 col-md-6">
                    <div class="form-label-group">
                      <input v-model="query.committeeZipcodeLow" type="text" name="zipcodeLow" class="form-control"
                             placeholder="From Zip"/>
                      <label>From Zipcode</label>
                    </div>
                  </div>
                  <div class="col-sm-12 col-md-6">
                    <div class="form-label-group">
                      <input v-model="query.committeeZipcodeHigh" type="text" name="zipcodeHigh" class="form-control"
                             placeholder="To Zipcode"/>
                      <label>To Zipcode</label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="row ml-1 mt-3">
              <div class="col border-bottom">
                <h5>Treasurer Details</h5>
              </div>
            </div>
            <div class="row ml-1 mt-2">
              <div class="col-sm-12 col-md-3">
                <div class="form-label-group">
                  <input v-model="query.treasurerFirstName" type="text" name="firstName" class="form-control"
                         placeholder="First Name"/>
                  <label>First Name</label>
                </div>
              </div>
              <div class="col-sm-12 col-md-3">
                <div class="form-label-group">
                  <input v-model="query.treasurerLastName" type="text" name="firstName" class="form-control"
                         placeholder="Last Name"/>
                  <label>Last Name</label>
                </div>
              </div>
            </div>
            <div class="row ml-1 mt-2">
              <div class="col-sm-12 col-md-6">
                <div class="row">
                  <div class="col-sm-12 col-md-6">
                    <div class="form-label-group">
                      <input v-model="query.treasurerAddress" type="text" name="firstName" class="form-control"
                             placeholder="Address"/>
                      <label>Address</label>
                    </div>
                  </div>
                  <div class="col-sm-12 col-md-6">
                    <div class="form-label-group">
                      <input v-model="query.treasurerCity" type="text" name="city" class="form-control"
                             placeholder="City"/>
                      <label>City</label>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-sm-12 col-md-6">
                <div class="row">
                  <div class="col-sm-12 col-md-6">
                    <div class="form-label-group">
                      <input v-model="query.treasurerZipcodeLow" type="text" name="suffix" class="form-control"
                             placeholder="From Zip"/>
                      <label>From Zipcode</label>
                    </div>
                  </div>
                  <div class="col-sm-12 col-md-6">
                    <div class="form-label-group">
                      <input v-model="query.treasurerZipcodeHigh" type="text" name="suffix" class="form-control"
                             placeholder="To Zipcode"/>
                      <label>To Zipcode</label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="row mt-2">
              <div class="col-12 border-top pt-2">
                <button class="btn btn-primary" :disabled="queryDisabled || queryLoading"
                        @click="submitFilerSearch(false)">
                  <span v-if="!queryLoading"><i class="fas fa-search"></i> Do lookup</span>
                  <span v-if="queryLoading"><i class="fas fa-circle-notch fa-spin"></i> Searching</span>
                </button>
              </div>
            </div>
          </b-card>
        </div>
        <div class="container-fluid" style="max-width: 1400px" v-if="queryCount">
          <b-card>
            <div class="row">
              <div class="col-12">
                <h4 class="display-4">
                  {{ Number(queryCount).toLocaleString() }} record<span v-if="queryCount !== 1">s</span> match<span
                    v-if="queryCount === 1">es</span> your search<span
                    v-if="queryCount > 10000">, viewing the first 10,000</span>
                </h4>
              </div>
            </div>
            <div class="row" style="height:800px">
              <div class="col-12">
                <div style="height: 100%">
                  <ag-grid-vue style="width: 100%; height: 100%;"
                               class="ag-theme-alpine"
                               debug=true
                               :context="context"
                               :grid-options="gridOptions"
                               :statusBar="statusBar"
                               :column-defs="columnDefs"
                               :default-col-def="defaultColDef"
                               :row-data="queryResults"
                               :row-selection="rowSelection"
                               :row-multi-select-with-click="true"
                               :enableBrowserTooltips="true"

                               @first-data-rendered="onFirstDataRendered"
                               @grid-size-changed="onGridSizeChanged"
                               @row-selected="onRowSelected"
                  >
                  </ag-grid-vue>
                </div>
              </div>
            </div>
          </b-card>
        </div>
      </transition>
    </div>
    <value-pick></value-pick>
  </div>
</template>
<script>
/**
 * Filer search for lookup of NYS campaign committees
 *
 * @TODO implement tooltips for user guidance
 * @TODO implement validation and cleaning of input
 */
import {AgGridVue} from 'ag-grid-vue';
import 'ag-grid-enterprise';
import valuePick from './value.pick.vue';
import {gridAddressGetter, gridNameGetter} from "@/mixins/AGGridHelpers";

// Form key, value arrays and other constants live in FormConstants to declutter the components
import {filerSearchDefault} from '../assets/js/formConstants.js';

const download = () => import('../common/download.vue');
const saveSearch = () => import('../common/saveSearch.vue');
const saveList = () => import('../common/saveList.vue');

var defaultQuery = {
  filerName: '',
  filerID: '',
  complianceTypeSelect: ['COMMITTEE'],
  filerTypeSelect: ['COUNTY', 'STATE'],
  filerStatusSelect: ['ACTIVE'],
  committeeAddress: '',
  committeeCity: '',
  committeeZipcodeLow: '',
  committeeZipcodeHigh: '',
  treasurerFirstName: '',
  treasurerLastName: '',
  treasurerAddress: '',
  treasurerCity: '',
  treasurerZipcodeLow: '',
  treasurerZipcodeHigh: '',
  counties: [],
  committeeTypeSelect: [],
  officeTypeSelect: [],
  limit: ''
};
export default {
  components: {
    AgGridVue,
    download,
    saveList,
    saveSearch,
    valuePick
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
      loading: false,
      queryLoading: false,
      defaultQuery: JSON.parse(JSON.stringify(defaultQuery)),
      query: JSON.parse(JSON.stringify(defaultQuery)),
      queryCount: false,
      queryResults: [],
      queryRoute: '/filer-search/search.filers',
      rowIDs: [],
      searchTimestamp: '',
      windowBreakpoint: this.getBreakpoint(this.windowWidth),
      // AG Grid options
      gridOptions: null,
      gridApi: null,
      columnApi: null,
      columnDefs: null,
      defaultColDef: null,
      detailCellRendererParams: null,
      rowSelection: null,
      selectedRows: [],
      selectedRowIDs: [],
      detailCellRenderer: null,
      detailRowHeight: null,
      groupDefaultExpanded: null,
      frameworkComponents: null,
      selectFields: {
        committeeTypes: filerSearchDefault.COMMITTEE_TYPES,
        officeTypes: filerSearchDefault.OFFICE_TYPES,
        countyList: filerSearchDefault.COUNTY_LIST
      },
      selectList: [],
      selectModel: '',
      statusBar: null,
    };
  },
  computed: {
    queryDisabled: function () {
      return (
          this.query.filerName === '' &&
          this.query.filerID === '' &&
          this.query.treasurerLastName === '' &&
          this.query.treasurerAddress === '' &&
          this.query.treasurerCity === '' &&
          this.query.treasurerZipcodeLow === '' &&
          this.query.treasurerZipcodeHigh === '' &&
          this.query.committeeAddress === '' &&
          this.query.committeeCity === '' &&
          this.query.committeeZipcodeLow === '' &&
          this.query.committeeZipcodeHigh === '' &&
          this.query.officeTypeSelect.length === '' &&
          this.query.counties.length === 0
      );
    },
  },
  beforeMount: function () {
    this.statusBar = {
      statusPanels: [
        {
          statusPanel: 'agTotalAndFilteredRowCountComponent',
          align: 'left',
        },
        {
          statusPanel: 'agTotalRowCountComponent',
          align: 'center',
        },
        {statusPanel: 'agFilteredRowCountComponent'},
        {statusPanel: 'agSelectedRowCountComponent'},
        {statusPanel: 'agAggregationComponent'},
      ],
    };
    this.gridOptions = {
      // This is fine to have in production. Suppresses debug info on colDefs
      tooltipShowDelay: 1000,
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
    };
    (this.columnDefs = [
      {
        headerName: 'Committee Name',
        field: 'committee_name',
        tooltipField: 'committee_name',
        // headerCheckboxSelection: true,
        // headerCheckboxSelectionFilteredOnly: true,
        // checkboxSelection: true,
        suppressSizeToFit: true,
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        // Cell renderer replacement for router-link
        // using render methods and programmatic navigation
        width: 275,
        minWidth: 100,
        maxWidth: 350,
        cellRenderer: (params) => {
          // Only create links for filer overview to committees, not candidates.
          // both exist in the filer data and are relevant but only committees have transactions
          if (params.data.compliance_type === 'COMMITTEE') {
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
          } else {
            return params.value;
          }
        },
        sort: 'asc'
      },
      {
        headerName: 'ID',
        valueGetter: params => Number(params.data.filer_id),
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        width: 75,
        minWidth: 75,
        maxWidth: 110,
      },
      {
        headerName: 'Filer Status',
        field: 'filer_status',
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        width: 120,
        minWidth: 120,
        maxWidth: 150,
        hide: true,
      },
      {
        headerName: 'Filer Type',
        field: 'filer_type',
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        hide: true,
        width: 120,
        minWidth: 120,
        maxWidth: 150,
      },
      {
        headerName: 'Type',
        field: 'compliance_type',
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        hide: true,
        width: 100,
        minWidth: 100,
        maxWidth: 150,
      },
      {
        headerName: 'Committee Type',
        field: 'committee_type',
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        hide: true,
        width: 140,
        minWidth: 140,
        maxWidth: 150,
      },
      {
        headerName: 'Candidate',
        field: 'candidate_name',
        tooltipField: 'candidate_name',
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        width: 175,
        minWidth: 140,
        maxWidth: 250,
        suppressSizeToFit: true,

      },
      {
        headerName: 'Office',
        field: 'candidate_office',
        tooltipField: 'candidate_office',
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        width: 150,
        minWidth: 140,
        maxWidth: 200,
      },
      {
        headerName: 'District',
        field: 'candidate_district',
        tooltipField: 'candidate_district',
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        width: 90,
        minWidth: 75,
        maxWidth: 110,
      },
      {
        headerName: 'County',
        field: 'candidate_county',
        tooltipField: 'candidate_county',
        breakpoints: ['xs', 'sm', 'md', 'lg', 'xl'],
        width: 100,
        minWidth: 100,
        maxWidth: 125,
      },
      {
        headerName: 'Address',
        field: 'committee_address',
        tooltipField: 'committee_address',
        valueGetter: params => gridAddressGetter([params.data.committee_address,
          params.data.committee_city, params.data.committee_state, params.data.committee_zip]),
        breakpoints: ['lg', 'xl'],
        suppressSizeToFit: true,
        width: 250,
        minWidth: 250,
        maxWidth: 350,
      },
      {
        headerName: 'Treasurer',
        field: 'treasurer_first_name',
        tooltipField: 'treasurer_first_name',
        valueGetter: params => gridNameGetter([params.data.treasurer_first_name,
          params.data.treasurer_middle_name, params.data.treasurer_last_name]),
        breakpoints: ['md', 'lg', 'xl'],
        hide: true,
      },
      {
        headerName: 'Treasurer Address',
        field: 'treasurer_address',
        tooltipField: 'treasurer_first_name',
        valueGetter: params => gridAddressGetter([params.data.treasurer_address,
          params.data.treasurer_city, params.data.treasurer_state, params.data.treasurer_zip]),
        breakpoints: ['lg', 'xl'],
        hide: true,
      }
      // Removed until cell renderer is written
      // {
      //   headerName: 'Details',
      //   sortable: false,
      //   filter: false,
      //   resizable: false,
      //   width: 125,
      //   minWidth: 100,
      //   maxWidth: 150,
      // },
    ]),
        (this.context = {componentParent: this});
    this.defaultColDef = {
      resizable: true,
      sortable: true,
      filter: true,
      skipHeaderOnAutoSize: true,
      menuTabs: ['columnsMenuTab', 'filterMenuTab', 'generalMenuTab'],
    };

    this.detailRowHeight = 250;
    this.groupDefaultExpanded = 1;

    this.rowSelection = 'multiple';
  },
  created: function () {
    this.windowBreakpoint = this.getBreakpoint(this.windowWidth);

    //Restore from Saved Search and Saved List
    if (this.userID && this.saveID) {
      this.loadExistingSearch = true;
      this.getExistingSearch();
    }
    if (this.userID && this.savedListParams) {
      this.loading = true;
      var params = JSON.parse(this.savedListParams);
      this.query = params;
      this.submitFilerSearch();
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
      $('#fValuePick').modal('show');
    },
    submitFilerSearch: async function () {
      if (this.queryDisabled) {
        return;
      }
      var _this = this;
      this.queryLoading = true;
      this.loading = true;

      this.query.action = 'query';

      this.getRequestAsync(this.$root.baseURI + '/filer-search/search.filers', this.query)
          .then((response) => {

            _this.queryCount = response[0];
            _this.queryResults = Object.freeze(response[1]);
            _this.rowIDs = this.queryResults.map((row) => row.id);
            _this.searchTimestamp = this.formattedNow();
            _this.queryLoading = false;
            _this.loading = false;
          })
          .catch(() => {
            _this.loading = false;
            _this.queryLoading = false;
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
          }).then(() => {
            this.submitFilerSearch();
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
    //AG Grid methods
    getResponsiveColDefs: function (breakpoint, columns) {
      var hiddenColumns = columns.map(column => {
        if ((column.colDef.breakpoints && !column.colDef.breakpoints.includes(breakpoint)) || column.colDef.hide) {
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
    onFirstDataRendered(params) {
      // params.api.sizeColumnsToFit();
      params.columnApi.autoSizeAllColumns(true);

      this.gridApi = this.gridOptions.api;
    },
    onRowSelected() {
      let selectedNodes = this.gridApi.getSelectedNodes();
      let selectedData = selectedNodes.map((node) => node.data);
      this.selectedRowIDs = selectedData.map((row) => row.id);
      return selectedData;
    },
    onGridSizeChanged(params) {

      // Set new breakpoint on resize
      this.windowBreakpoint = this.getBreakpoint(this.windowWidth);

      // Get existing column definitions and figure out
      // what columns don't have that breakpoint in their def
      var allColumns = params.columnApi.getAllColumns();
      var [columnsToShow, columnsToHide] = this.getResponsiveColDefs(this.windowBreakpoint, allColumns);

      params.columnApi.setColumnsVisible(columnsToShow, true);
      params.columnApi.setColumnsVisible(columnsToHide, false);
      // params.columnApi.autoSizeAllColumns(true);
      params.api.sizeColumnsToFit();

    },
  }
};
</script>
<style scoped>
.main {
  margin-bottom: 80px;
}
</style>