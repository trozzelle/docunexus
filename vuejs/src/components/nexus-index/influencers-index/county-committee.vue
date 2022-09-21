<template>
  <div id="nexus-index" class="container-xl">
    <div v-if="!$root.loggedIn">
      <login></login>
    </div>
    <div v-else>


      <b-overlay :show="showModal" rounded="sm"
                 :opacity=0.4
                 blur="5px">
        <template #overlay>
          <div class="text-center w-100">
            <b-card body-class="committee-modal shadow" bg-variant="primary" text-variant="text-white">

            <b-row class="mb-5">
            <h1>New Features for Premium Subscribers</h1>
            </b-row>
            <b-row class="text-left mx-1">
              <p>We are in the process of rolling out new features, like this <em>Influencers Index</em> for each NYS county, to Nexus subscribers.</p>

              <p>If you would like to join the beta and get access to these tools early,
              sign up with your email below and a team member will be in touch.</p>
            </b-row>
              <b-row v-if="!modalEmailSubmitted" class="ml-2 mt-2">
                <b-form class="ml-3" @submit.prevent="submitEmail" inline>
                  <label class="sr-only" for="inline-form-input-name">Name</label>
                  <b-form-input
                      v-model="modalName"
                      id="inline-form-input-name"
                      class="mb-2 mr-sm-2 w-25 mb-sm-0 shadow"
                      placeholder="John Doe"
                  ></b-form-input>

                  <label class="sr-only" for="inline-form-input-email">Email Address</label>
                  <b-input-group class="mb-2 mr-sm-2 mb-sm-0 shadow">
                    <b-form-input v-model="modalEmail" id="inline-form-input-email" placeholder="Email"></b-form-input>
                  </b-input-group>

                  <b-button type="submit" class="ml-2 shadow" variant="primary" style="background-color:#d05454;">Sign Up</b-button>
                </b-form>
              </b-row>
              <b-row v-if="modalEmailSubmitted" class="mt-2 text-center">
                <b-col>
                Email submitted! We will reach out shortly.
                </b-col>
              </b-row>
            </b-card>


          </div>
        </template>
      <div class="row mt-3 mb-2 border-bottom">
        <div class="col-8">
          <h1 class="display-1"><i class="fas fa-fw text-primary"
                                   :class="{'fa-map-marked-alt': !loading, 'fa-circle-notch fa-spin': loading}"></i>
            {{ pageTitle }}</h1>
        </div>
        <div class="col-4">
            <div class="float-right">
                <router-link tag="button" type="button" to="/home" class="mt-1 mr-1 btn btn-sm btn-primary"><i
                    class="fas fa-arrow-left"></i> Back to home
                </router-link>
                <bookmark class="btn-sm" :page-details="this.pageDetails"></bookmark>
            </div>
        </div>
      </div>
        <b-card>
        <div class="row">
          <div class="col-5 mx-auto text-center committee-header">
            <h3>{{ committeeList.length }} Committee Members on File </h3> <h4>{{ affiliationCount }} </h4>
          </div>
        </div>
      <div class="row">
        <div class="col-12">
          <l-map style="height: 300px;z-index: 0;" :zoom="zoom" :center="geocode">
            <l-tile-layer :url="url"></l-tile-layer>
            <l-geo-json :geojson="geojson"></l-geo-json>
          </l-map>
        </div>
      </div>
        </b-card>
      <!-- @TODO Make grid responsive -->
      <div class="row">
        <div class="col-12 mt-2" style="height:600px">
          <ag-grid-vue style="width: 100%; height: 100%;"
                       class="ag-theme-alpine"
                       debug=true
                       :context="context"
                       :grid-options="gridOptions"
                       :column-defs="columnDefs"
                       :default-col-def="defaultColDef"
                       :row-data="committeeList"
                       :row-selection="rowSelection"
                       :row-multi-select-with-click="true"
                       @first-data-rendered="onFirstDataRendered"
                       @row-selected="onRowSelected"
          >
          </ag-grid-vue>
        </div>
      </div>
      </b-overlay>
    </div>

  </div>
</template>
<script>
/**
 *  County Committee Detail component, which lists the county committee members
 *  on file and their contact information.
 *
 *  At the moment, only 2 counties have their information populated, although
 *  most of the counties have return their FOILs to us. Some of the data is in
 *  a spreadsheet-native format but most are copies of print-outs and must be OCR'd,
 *  and cleaned.
 *
 *  This is mostly unimplemented.
 */
import {AgGridVue} from 'ag-grid-vue';
import 'ag-grid-enterprise';

import bookmark from '@/components/common/bookmark.vue';

export default {
  components: {
    AgGridVue,
    bookmark: bookmark,
  },
  data: function () {
    return {
      name: 'County Committee',
      loading: false,
      pageDetails: {
        userid: this.$root.user.userid,
        pagetitle: '',
        pagetype: 'County Committee',
        routename: this.$route.name,
        routeparams: this.$route.params,
        pagelocation: this.$route.path,
        token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}],
      },
      county: this.$route.params.county,
      countyResults: [],
      countyLoading: false,
      committeeLoading: false,
      committeeList: [],
      showModal: true,
      modalEmailSubmitted: false,
      modalName: '',
      modalEmail: '',
      // Leaflet options
      url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      zoom: 8,
      center: [0, 0],
      geocode: [0, 0],
      geojson: null,
      // Ag Grid options
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
  computed: {
    affiliationCount: function () {
      var dem = this.committeeList.filter((member) => member.affiliation === 'DEM').length;
      var rep = this.committeeList.filter((member) => member.affiliation === 'REP').length;

      return dem + ' DEM - ' + rep + ' REP';
    },
    pageTitle: function () {
      return this.county + ' County Committee';
    },
  },
  watch: {
    $route: function () {
      this.getCountyDetails();
      this.getCommitteeList();
    },
  },
  beforeMount: function () {
    this.gridOptions = {}
    ;(this.columnDefs = [
      {
        headerName: 'County',
        field: 'county',
        // Removed until implemented
        // This will allow list saving and exporting of
        // committee members
        headerCheckboxSelection: true,
        headerCheckboxSelectionFilteredOnly: true,
        checkboxSelection: true,
        width: 110,
        minWidth: 110,
      },
      {
        headerName: 'First Name',
        field: 'first_name',
        width: 110,
        minWidth: 110,
      },
      {
        headerName: 'Last Name',
        field: 'last_name',
        width: 120,
        minWidth: 120,
      },
      {
        headerName: 'Address',
        field: 'address',
        width: 200,
        minWidth: 200,
      },
      {
        headerName: 'City',
        field: 'address_city',
        width: 120,
        minWidth: 120,
      },
      {
        headerName: 'Zip',
        field: 'address_zip',
        width: 100,
        minWidth: 100,
        maxWidth: 100,
      },
      {
        headerName: 'Party',
        field: 'affiliation',
        width: 100,
        minWidth: 100,
        maxWidth: 100,
      },
      // Contact information is obscured server-side through the
      // through the nxsidx_obscure_email and nxsidx_obscure_phone_number routines
      {
        headerName: 'Phone',
        field: 'phone_number_obs',
        width: 140,
        minWidth: 140,
      },
      {
        headerName: 'Email',
        field: 'email_obs',
        width: 140,
        minWidth: 140,
      },
    ]),
        (this.context = {componentParent: this});
    this.defaultColDef = {
      resizable: true,
      sortable: true,
      filter: true,
      menuTabs: ['filterMenuTab'],
    };

    this.detailRowHeight = 250;
    this.groupDefaultExpanded = 1;

    this.rowSelection = 'multiple';
  },
  mounted: function () {
    this.getCountyDetails();
    this.getCommitteeList();

    this.gridApi = this.gridOptions.api;
    this.gridColumnApi = this.gridOptions.columnApi;
  },

  methods: {
    getCountyDetails: function () {
      this.countyLoading = true;
      var query = {
        county: this.county,
      };

      this.getRequestAsync(this.$root.baseURI + '/influencers-index/county.get', query)
          .then((response) => {
            this.countyResults = response[0];
            this.geojson = JSON.parse(response[0]['geojson']);
            this.geocode = [this.countyResults.latitude, this.countyResults.longitude];
            this.pageDetails.pagetitle = this.countyResults.county + 'County Committee';
            this.countyLoading = false;
          })
          .catch();
    },
    getCommitteeList: function () {
      this.committeeLoading = true;

      var query = {
        county: this.county,
      };

      this.getRequestAsync(this.$root.baseURI + '/influencers-index/get.committee-members', query)
          .then((response) => {
            this.committeeList = response;
            this.countyLoading = false;
          })
          .catch();
    },
    submitEmail: function(){
      var _this = this;
      var query = {
       name: this.modalName,
        email: this.modalEmail
      };

      var saveEmailRoute = '/user-favorites/email-signup';

      this.getRequestAsync(saveEmailRoute, query)
          .then(function () {
            this.modalEmailSubmitted = true;
          })
          .catch(() => {
            this.modalEmailSubmitted = true;
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
      return selectedData;
    },
  },
};
</script>
<style scoped>

.committee-modal{
  color: #fff;
}

.committee-header {
  color:#000;
}

::v-deep .modal-container {
  display: flex;
  justify-content: center;
  align-items: center;
}
::v-deep .modal-content {
  display: flex;
  flex-direction: column;
  margin: 0 1rem;
  padding: 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 0.25rem;
  background: #fff;
}
.modal__title {
  font-size: 1.5rem;
  font-weight: 700;
}
</style>