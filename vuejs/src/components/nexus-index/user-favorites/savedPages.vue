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
                        Pages
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
                    <h4 class="display-4"><i class="fas fa-empty-set"></i> You have no saved pages.</h4>
                </div>
                <div v-else>
                    <Favorites-List :records="savedPages" :page-type="pageType" @edit="editPage" @delete="deletePage"/>
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
      loading: true,
      queryFailure: false,
      editing: false,
      pageType: 'Saved Page',
      //New parameters
      savedPages: [],
      userid: this.$route.params.userid,
    }
  },
  mounted: function () {
    this.getSavedPages()
  },
  methods: {
    getSavedPages: function () {
      this.loading = true
      var query = {
        userid: this.$root.user.userid,
      }

      this.getRequestAsync(this.$root.baseURI+'/user-favorites/get.saved-pages', query)
        .then((response) => {
          var respData = response

          for (var i = 0; i < respData.length; i++) {
            respData[i] = this.renameKeys({ page_title: 'title', page_type: 'type' }, respData[i])
            respData[i].editing = false
            respData[i].deleting = false
            respData[i].restarting = false
          }
          this.savedPages = respData
          this.loading = false
        })
        .catch(() => {
          this.savedPages = []
          this.loading = false
        })
    },
    deletePage: function (params) {
      this.loading = true
      var query = {
        userid: this.$root.user.userid,
        saveid: params.saveid,
      }

      this.getRequestAsync(this.$root.baseURI+'/user-favorites/saved-page.delete', query)
        .then(() => {
          this.getSavedPages()
        })
        .catch(() => {
          this.loading = false
        })
    },
    editPage: function (params) {
      this.loading = true
      var query = {
        userid: this.$root.user.userid,
        pagetitle: params.title,
        saveid: params.saveid,
      }

      this.getRequestAsync(this.$root.baseURI+'/user-favorites/saved-page.edit', query)
        .then(() => {
          this.getSavedPages()
        })
        .catch(() => {})
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