<template>
  <button type="button" :disabled="saving || loading || alreadySaved"
          class="mt-1 btn btn-success"
          @click.prevent="savePage()">
    <span v-if="!saving && !loading"><i class="fas fa-arrow-down"></i> Bookmark</span>
    <span v-if="saving"><i class="fas fa-circle-notch fa-spin"></i> Saving</span>
    <span v-if="loading"><i class="fas fa-circle-notch fa-spin"></i> Loading</span>
  </button>
</template>
<script>
export default {
  props: ['pageDetails'],
  data: function () {
    return {
      queryDetails: this.pageDetails,
      alreadySaved: false,
      loading: false,
      saving: false,
    };
  },
  watch: {},
  mounted: function () {
    this.getBookmarkStatus();
  },
  methods: {
    savePage: function () {
      var query = {
        userid: this.$root.user.userid,
        pagetitle: this.pageDetails.pagetitle,
        pagetype: this.pageDetails.pagetype,
        routename: this.pageDetails.routename,
        routeparams: JSON.stringify(this.pageDetails.routeparams),
        pagelocation: this.pageDetails.pagelocation,
        token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}],
      };

      this.saving = true;
      this.getRequestAsync('/user-favorites/saved-page.save', query)
          // Call get bookmark status no matter what and rely on it to reset state
          .catch((error) => {
          })
          .finally(() => {
            this.getBookmarkStatus();
          });
    },
    // Temporarily disabled until async is optimized. Noticeably slower than the direct call below.
    // checkBookmarkStatus: function () {
    //   this.loading = true
    //
    //   var query = {
    //     userid: this.$root.user.userid,
    //     pagelocation: this.$parent.$route.path,
    //     token: [{ userid: this.$root.user.userid, token: this.$root.user.auth_token }],
    //   }
    //   this.getRequestAsync('/user-favorites/get.page-bookmark-status', query)
    //     .then((response) => {
    //       this.alreadySaved = true
    //       this.loading = false
    //     })
    //     .catch(() => {
    //       this.loading = false
    //     })
    // },
    //

    getBookmarkStatus: function () {
      this.loading = true;
      this.saving = false;

      var _this = this;
      var query = {userid: this.$root.user.userid, pagelocation: this.$parent.$route.path};
      var params = {
        query: query,
        token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}],
      };

      this.axios
          .get('/user-favorites/get.page-bookmark-status', {
            params: params,
          })
          .then(function (response) {
            _this.$root.handleTokenError(response.data);
            _this.loading = false;

            if (response.data.error) {
              _this.$root.setAlert(true, response.data.error, 'alert-danger');
              _this.alreadySaved = false;
              return;
            } else {
              if (response.data.length) {
                if (response.data.length > 0) {
                  _this.alreadySaved = true;
                }
                return;
              } else {
                _this.alreadySaved = false;
                return;
              }
            }
          })
          .catch((error) => {
            _this.alreadySaved = false;
            _this.loading = false;
            _this.$root.setAlert(true, error, 'alert-danger');
            return;
          });
    },
  },
};
</script>
<style scoped></style>
