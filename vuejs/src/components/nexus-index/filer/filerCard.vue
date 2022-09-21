<template>
  <b-card class="d-block shadow mb-2">
    <l-map
        v-if="showMap"
        :zoom="zoom"
        :center="geocode"
        :options="mapOptions"
        style="height: 200px"
        @update:center="centerUpdate"
        @update:zoom="zoomUpdate"
    >
      <l-tile-layer
          :url="url"
          :attribution="attribution"
      />
      <l-marker :lat-lng="geocode">
      </l-marker>
    </l-map>
    <b-card-body class="mb-0">
      <b-form-row class="mb-3 text-center">
        <b-col cols="12">
          {{ filerDetails.committee_address }}<br/>
          {{ filerDetails.committee_city }}, {{ filerDetails.committee_state }},
          {{ filerDetails.committee_zip }}<br/>
          <em>Registered Address</em>
        </b-col>
      </b-form-row>
      <b-row class="my-3">

      </b-row>
      <b-form-row class="my-3 text-center">
        <b-col cols="12" class="mt-3">
          <p class="mx-0 d-block" style="font-size:20px;">Treasurer Details</p>
          {{ filerDetails.treasurer_first_name }}
          {{ filerDetails.treasurer_middle_name }}
          {{ filerDetails.treasurer_last_name }}
        </b-col>
      </b-form-row>
      <b-form-row class="my-3 text-center">
        <b-col cols="12">
          {{ filerDetails.treasurer_address }}<br/>
          {{ filerDetails.treasurer_city }}, {{ filerDetails.treasurer_state }},
          {{ filerDetails.treasurer_zip }}
        </b-col>
      </b-form-row>
    </b-card-body>
  </b-card>
</template>
<script>
/**
 * Card component for filer overview which displays a map of the treasurers address and some other relevant information.
 *
 * Currently uses Leaflet. Mapbox may be used for shapefile/geojson features but, for right now, Leaflet is a quarter of the
 * size.
 *
 * TODO: Convert to leaflet instead of Mapbox to display geocoded filers, fallback to Mapbox API if geocode isn't in db.
 */
import 'leaflet/dist/leaflet.css';

import {latLng} from 'leaflet';
import {Icon} from 'leaflet';

delete Icon.Default.prototype._getIconUrl;
Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

export default {
  components: {},
  props: ['filerDetails'],
  data: function () {
    return {
      name: 'Filer Card',
      // Mapbox access token. It is, per their docs, left out in the open.
      accessToken:
          'pk.eyJ1IjoibmV4dXNpbmRleCIsImEiOiJja28zdTF3dDQwNG1wMzBtem1lMWgwbmVzIn0.mAa0p6lDbammPSgV9bejYA',
      geocodeLoading: false,
      geocode: [0, 0],
      //Leaflet
      zoom: 13,
      center: latLng(0, 0),
      url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      currentZoom: 9,
      currentCenter: latLng(0, 0),
      showParagraph: false,
      mapOptions: {
        zoomSnap: 0.5,
      },
      showMap: true,
    };
  },
  computed: {},
  watch: {
    filerDetails: {
      handler: 'initializePage',
      immediate: true,
    },
  },
  mounted: function () {
  },
  methods: {
    initializePage: function () {
      this.getFilerGeocode();
    },

    /**
     * Search DB to see if geo information is loaded in nxsidx_ny.nys_filer_data_geo.
     *
     * Currently, the 10,000 most recent filers are geocoded out of around 50,000 historical filers. All filers from
     * 2015 - 2021 are geocoded.
     *
     * If it isn't, fall back to API lookup.
     */
    getFilerGeocode: function () {

      var lookupID = this.filerDetails.candidate_id ? this.filerDetails.candidate_id : this.filerDetails.filer_id;
      if (lookupID.length > 0) {
        var query = {filerid: lookupID};

        this.getRequestAsync(this.$root.baseURI + '/filer/filer-geo.get', query)
            .then((response) => {
              this.geocode = [response[0].latitude, response[0].longitude];
              this.center = latLng(response[0].latitude, response[0].longitude);
              this.currentCenter = latLng(response[0].latitude, response[0].longitude);
            }).catch(() => {
          this.getAPIGeocode();
        });
      }
    },
    /**
     * Get geocode through Mapbox's terrific API. Returns fully cleaned and parsed address. We only use the lat-long.
     *
     * There are 50,000 free requests per month, so these is a decent fallback absent full local data
     */
    getAPIGeocode: function () {
      this.geocodeLoading = true;

      var _this = this;
      var url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/' +
          this.formatAddressURI(this.filerDetails) +
          '.json?access_token=' +
          this.accessToken;
      this.axios
          .get(url)
          .then(function (response) {
            if (response.data.error) {
              _this.$root.setAlert(true, response.data.error, 'alert-danger');
            } else {
              if (response.data.features.length) {
                // Mapbox formats in long-lat, which is reverse the standard
                _this.geocode = [
                  response.data.features[0].center[1],
                  response.data.features[0].center[0],
                ];

                _this.geocodeLoading = false;
              } else {
                _this.$root.setAlert(true, 'Error performing query', 'alert-danger');
              }
            }
          })
          .catch((error) => {
            _this.$root.setAlert(true, error, 'alert-danger');
          });
    },
    formatAddressURI: function (filerDetails) {
      var address =
          filerDetails.treasurer_address +
          ' ' +
          filerDetails.treasurer_city +
          ' ' +
          filerDetails.treasurer_state +
          ' ' +
          filerDetails.treasurer_zip;
      address = address.replace(/[^a-zA-Z0-9 _.~:]/g, '');

      var cleanAddress = encodeURI(address);

      return cleanAddress;
    },
    //Leaflet methods
    zoomUpdate(zoom) {
      this.currentZoom = zoom;
    },
    centerUpdate(center) {
      this.currentCenter = center;
    },
    showLongText() {
      this.showParagraph = !this.showParagraph;
    },
    innerClick() {
      alert('Click!');
    },
  },
};
</script>
<style scoped>
.basemap {
  width: 100%;
  height: 12.5rem;
  border-radius: 3px;
}

.card {
  line-height: 1.0;
}
</style>