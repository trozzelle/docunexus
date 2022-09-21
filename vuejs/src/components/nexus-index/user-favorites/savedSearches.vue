<template>
    <div class="container">
        <div v-if="!$root.loggedIn">
            <login></login>
        </div>
        <div v-else>
            <div class="row mt-3 mb-2 border-bottom">
                <div class="col-8">
                    <h1 class="display-1"><i class="fas fa-fw text-primary"
                        :class="{'fa-history': !loading, 'fa-circle-notch fa-spin': loading}"></i> Saved
                        Searches
                    </h1>
                </div>
                <div class="col-4">
                    <router-link tag="button" type="button" to="/home" class="mt-1 btn btn-primary btn-sm float-right"><i
                        class="fas fa-arrow-left"></i> Back to home
                    </router-link>
                </div>
            </div>
            <transition name="fade" mode="out-in">
                <div v-if="queryFailure">
                    <h4 class="display-4"><i class="fas fa-empty-set"></i> You have no saved searches.</h4>
                </div>
                <div v-else>
                    <Favorites-List :records="savedSearches" :page-type="pageType" @edit="editSearch" @delete="deleteSearch"/>
                </div>
            </transition>
        </div>
    </div>
</template>
<script>
import favoritesList from './favoritesList';

export default {
  components: {
    favoritesList,
  },
  data: function () {
    return {
      name: 'Saved Searches',
      loading: true,
      queryFailure: false,
      editing: false,
      pageType: 'Saved Search',
      //New parameters
      savedSearches: [],
      userid: this.$route.params.userid,
    }
  },
  mounted: function () {
    this.getSavedSearches()
  },
  methods: {
    getSavedSearches: function () {
      this.loading = true
      var query = {
        userid: this.$root.user.userid,
      }

      this.getRequestAsync(this.$root.baseURI+'/user-favorites/get.saved-searches', query)
        .then((response) => {
          var respData = response

          for (var i = 0; i < respData.length; i++) {
            respData[i] = this.renameKeys({ save_name: 'title' }, respData[i])
            respData[i].route_params = JSON.stringify({
              loadExistingSearch: true,
              userID: parseInt(this.$root.user.userid),
              saveID: parseInt(respData[i]['saveid']),
            })
            respData[i].route_name = 'donor'
            respData[i].type = 'Saved Search'
            respData[i].editing = false
            respData[i].deleting = false
          }
          this.savedSearches = respData
          this.loading = false
        })
        .catch(() => {
          this.savedSearches = []
          this.loading = false
        })
    },
    deleteSearch: function (params) {
      this.loading = true
      var query = {
        userid: this.$root.user.userid,
        saveid: params.saveid,
      }

      // @TODO handle empty responses gracefully, this is a kludge
      this.getRequestAsync(this.$root.baseURI+'/user-favorites/saved-search.delete', query)
        .then((response) => {
          this.getSavedSearches()
          this.loading = false
        })
        .catch(() => {
          this.getSavedSearches()
          this.loading = false
        })
    },
    editSearch: function (params) {
      this.loading = true
      var query = {
        userid: this.$root.user.userid,
        savename: params.title,
        saveid: params.saveid,
      }

      this.getRequestAsync(this.$root.baseURI+'/user-favorites/saved-search.edit', query)
        .then((response) => {
          this.getSavedSearches()
          this.loading = false
        })
        .catch(() => {
          this.getSavedSearches()
          this.loading = false
        })
    },
  },
}
</script>
<style scoped>
.mapped {
  background-color: #cce5ff;
}

.table thead th {
  vertical-align: top;
}

.mapping, .mapping select {
  width: 230px;
}

.custom-control-label {
  font-size: 1.25rem;
}

.custom-control-label::before,
.custom-control-label::after {
  top: .45rem;
  width: 1.25rem;
  height: 1.25rem;
}

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

</style>