<template>
  <div id="nexus-index" class="container">
    <div v-if="!$root.loggedIn">
      <login></login>
    </div>
    <div v-else>
      <div class="row mt-3 mb-2 border-bottom">
        <div class="col-8">
          <h1 class="display-1"><i class="fas fa-fw text-primary" :class="{'fa-globe-americas': !loading, 'fa-circle-notch fa-spin': loading}"></i>
            County List</h1>
        </div>
        <div class="col-4">
          <router-link tag="button" type="button" to="/home" class="mt-1 btn btn-primary btn-sm float-right"><i
              class="fas fa-arrow-left"></i> Back to home
          </router-link>
        </div>
      </div>
      <div class="row">
        <l-map ref="map" style="height: 350px" :zoom="zoom" :center="center">
          <l-tile-layer :url="url"></l-tile-layer>
          <l-geo-json :geojson="geojson" :options="mapOptions" :options-style="styleMap"></l-geo-json>
        </l-map>
      </div>
      <div class="row mt-4">
        <div class="col-10 mx-auto">
          <table class="table" style="font-size: 1rem">
            <tbody>
            <tr v-for="(q, i) in countyListSplit" :key="i" class="county-list-table">
              <td v-for="(r,j) in q" :key="j" class="county-list-table">
                <!-- router-link does not have native disabled state -->
                <b-link :to="{ name: 'county-committee', params: {county: r.county_name} }" :disabled="!r.id">
                  {{ r.county_name }}
                </b-link>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
/**
 * County List component that serves as an entrypoint for the Influencer's Index.
 *
 *  Lists all of the counties in NYS and enabled linking to only those that have
 *  committee member information in the database.
 *
 *  geoJSON is now loaded locally and the map is dynamic according
 *  to what counties have committee members loaded.
 *
 */
import nys_counties_geo from './nys_counties_boundaries.json';
import { VueFinalModal, ModalsContainer } from 'vue-final-modal'


import 'leaflet/dist/leaflet.css';

import {Icon} from 'leaflet';

// Hack for empty icons with Leaflet.js. Need to investigate further.
delete Icon.Default.prototype._getIconUrl;
Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

export default {
  components: {
    VueFinalModal,
    ModalsContainer
  },
  data: function () {
    return {
      name: 'County List',
      loading: false,
      countyList: [],
      url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      zoom: 6,
      center: [43.1561681, -75.8449946],
      geojson: nys_counties_geo,
      showModal: true,
    };
  },
  computed: {
    countyListSplit: function () {
      return this.chunkArray(this.countyList, 10);
    },
    mapOptions: function () {
      return {
        onEachFeature: this.onEachFeature,
      };
    },
  },
  created: async function () {
    this.loading = true;

    this.getRequestAsync('/influencers-index/get.counties')
        .then((response) => {
          this.countyList = response;

          // Join additional fields from the request into the geoJSON object. In the future,
          // this can contain useful metadata like registered voters, population, etc.
          //
          // ID field is returned only if committee has members, null otherwise
          this.geojson.features.map((county) => {
            var matchCounty = this.countyList.find(
                (ct) => ct.county_name + ' County' === county.properties.county_name
            );
            county.properties = {...county.properties, ...matchCounty};
          });

          this.loading = false;
        })
        .catch();
  },
  methods: {
    getMapColors: function (county_id) {
      return county_id ? '#2c7fb8' : '#bdbdbd';
    },
    styleMap: function (feature) {
      return {
        fillColor: this.getMapColors(feature.properties.id),
        weight: 2,
        opacity: 1,
        color: 'white',
        dashArray: '3',
        fillOpacity: 0.7,
      };
    },
    onEachFeature: function (feature, layer) {
      // Add listener to each feature and navigate to county on click
      // Add tooltip to each feature with metadata
      var _this = this;
      // Only if committee has members
      if (feature.properties.id) {
        layer.on('click', function () {
          _this.$router.push({name: 'county-committee', params: {county: feature.properties.county_name}});
        });
        layer.bindTooltip(
            '<div>County: ' +
            feature.properties.county_name +
            '<br />' +
            'Records: ' +
            feature.properties.member_count,
            {permanent: false, sticky: true}
        );
      }
    },
    chunkArray: function (myArray, chunk_size) {
      var index = 0;
      var arrayLength = myArray.length;
      var tempArray = [];

      for (index = 0; index < arrayLength; index += chunk_size) {
        var myChunk = myArray.slice(index, index + chunk_size);
        tempArray.push(myChunk);
      }

      return tempArray;
    },
  },
};
</script>
<style scoped>

a.disabled {
  color: grey;
  pointer-events: none;
}

.table {
  margin: auto;
  width: unset;
}

tr.county-list-table {
  display: block;
  float: left;
}

td.county-list-table {
  display: block;
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