/***
 *  API request module to abstract the requests out of the components.
 *
 *  I've tried to move everything to a standard pattern where search parameters
 *  are wrapped in a query object and a successful response is passed straight back
 *  to the component for handling.
 */

import axios from 'axios'

export default {
  methods: {
    getRequestAsync: function (route, query = {}) {
      var _this = this
      query.action = 'query'
      var params = {
        query: query,
        token: [{ userid: this.$root.user.userid, token: this.$root.user.auth_token }],
      }

      return new Promise((resolve, reject) => {
        axios
          .get(route, {
            params: params,
          })
          .then(function (response) {
            _this.$root.handleTokenError(response.data)
            if (response.data.error) {
              _this.$root.setAlert(true, response.data.error, 'alert-danger')
              reject()
            } else {
              if (response.data.length) {
                resolve(response.data)
              } else {
                // Empty response alerts disabled until I find a better solution. Many of the requests in the app
                // return an empty response by design.
                // _this.$root.setAlert(true, 'Error performing query', 'alert-danger')
                reject()
              }
            }
          })
          .catch((error) => {
            _this.$root.setAlert(true, error, 'alert-danger')
            reject()
          })
      })
    },
  },
}
