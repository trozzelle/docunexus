/***
 * Non AG-Grid helper methods, mostly formatters that would be better suited to
 * becoming global filters.
 */

import numeral from 'numeral'

const dayjs = require('dayjs');

export default {
  methods: {
    /**
     * Expects a string or number, returns value formatted as currency.
     * @param amount
     * @returns {string}
     */
    formatCurrency: function (amount) {
      return numeral(amount).format('$0,0.00')
    },

    /**
     * Expects datestring, returns string in MM/DD/YYYY format
     * @param datetime
     * @returns {string}
     */
    formatDate: function (datetime) {
      return this.$dayjs(datetime).format('MM/DD/YYYY')
    },

    /**
     * Expects datestring, returns string in MM/DD/YYYY HH:mm format
     * @param datetime
     * @returns {string}
     */
    formatDateHourMinute: function (datetime) {
      return this.$dayjs(datetime).format('MM/DD/YYYY HH:mm')
    },

    /**
     * Get the current date and time as a formatted string in MySQL YYYY/MM/DD HH:mm:ss format
     * @returns {string}
     */
    formattedNow: function () {
      return this.$dayjs(new Date()).format('YYYY/MM/DD HH:mm:ss')
    },

    /**
     * Takes an array of key-value pairs and renames the keys of an object where the
     * new key is a key in the array and the old key is its associated value in the array.
     * @param keysMap
     * @param obj
     * @returns {{}}
     */
    renameKeys: function (keysMap, obj) {
      return Object.keys(obj).reduce(
        (acc, key) => ({
          ...acc,
          ...{ [keysMap[key] || key]: obj[key] },
        }),
        {}
      )
    },
  },
}
