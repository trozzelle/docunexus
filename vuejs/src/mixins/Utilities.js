const alertDefault = {
  display: false,
  message: '',
  class: 'alert-primary',
  timeout: false,
}

export default {
  methods: {
    getBreakpoint: function(windowWidth) {
      if (windowWidth < '576') {
        return 'xs';
      } else if (windowWidth >= '576' && windowWidth < '768') {
        return 'sm';
      } else if (windowWidth >= '768' && windowWidth < '992') {
        return 'md';
      } else if (windowWidth >= '992' && windowWidth < '1200') {
        return 'lg';
      } else {
        return 'xl';
      }
    },
    /**
     *  Helper function to clear alerts from pages by resetting the alert to default, hidden values.
     *  This is necessary as the global vue object hierarchy is different building in webpack.
     *
     */
    clearParentAlert: function () {
      this.alert = JSON.parse(JSON.stringify(alertDefault))
    },
  },
}
