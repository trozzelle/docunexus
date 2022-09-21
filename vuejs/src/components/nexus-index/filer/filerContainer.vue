<template>
  <b-card id="filer-container" class="mb-2" no-body>
    <b-tabs class="shadow" card>
      <b-tab title="Summary" @click="setSummary">
        <b-card-title class="text-center">{{ filerDetails.committee_name }}</b-card-title>
        <b-row v-if="filerDetails.candidate_name">
          <b-col col="12" class="text-center">
            {{ filerDetails.candidate_name }} • {{ filerDetails.candidate_office }} <span
              v-if="filerDetails.candidate_district">• {{ filerDetails.candidate_district }}</span>
          </b-col>
        </b-row>
        <hr>
        <b-row class="mt-4">
          <b-col cols="4" class="text-right">
            Filer ID: {{ filerDetails.filer_id }} <span
              v-if="filerDetails.filer_previous_id">({{ filerDetails.filer_previous_id }})</span> <i id="filer_id_tip"
                                                                                                     class="fal fa-question-circle fa-sm"></i>
            <b-popover
                target="filer_id_tip"
                placement="topright"
                triggers="hover focus"
            >Tip
            </b-popover>
          </b-col>
          <b-col cols="4" class="text-center">
            Status: {{ filerDetails.filer_status }}
          </b-col>
          <b-col cols="4" class="text-left">
            Years Active: {{ this.cycleDates.yearsActive[0] }} - {{ this.cycleDates.yearsActive[1] }}
          </b-col>
        </b-row>
        <b-row class="mt-3">
          <b-col class="text-center">
            Subtype: {{ filerDetails.committee_type }}
          </b-col>
        </b-row>
        <b-row class="mt-4">
          <b-col cols="12">
            <h5>Transactions</h5>
            <hr class="mt-1 mb-0" width="20%" align="left"/>
            <b-card-group deck class="px-5">
              <b-card-body>
                <div class="media d-flex">
                  <div class="align-self-center">
                    <i class="fal fa-money-bill-wave fa-lg"></i>
                  </div>
                  <div class="media-body pl-5">
                    <h6 class="filer-card-summary-content">
                      {{ this.formatCurrency(this.fundraisingAggregates.totalContributions) }}
                    </h6>
                    <span class="filer-card-summary-label">Total Contributions</span>
                  </div>
                </div>
              </b-card-body>
              <b-card-body>
                <div class="media d-flex">
                  <div class="align-self-center">
                    <i class="fal fa-credit-card fa-lg"></i>
                  </div>
                  <div class="media-body pl-5">
                    <h6 class="filer-card-summary-content">
                      {{ this.formatCurrency(this.fundraisingAggregates.totalExpenditures) }}
                    </h6>
                    <span class="filer-card-summary-label">Total Expenses</span>
                  </div>
                </div>
              </b-card-body>
              <b-card-body>
                <div class="media d-flex">
                  <div class="align-self-center">
                    <i class="fal fa-gifts fa-lg"></i>
                  </div>
                  <div class="media-body pl-5">
                    <h6 class="filer-card-summary-content">
                      {{ this.formatCurrency(this.fundraisingAggregates.totalInkind) }}
                    </h6>
                    <span class="filer-card-summary-label">Total Inkind</span>
                  </div>
                </div>
              </b-card-body>
            </b-card-group>
            <b-row class="text-center">
              <b-col cols="6 text-right">
                Earliest Transaction: {{ this.cycleDates.earliest_transaction_date }}
              </b-col>
              <b-col cols="6 text-left">
                Latest Transaction: {{ this.cycleDates.last_transaction_date }}
              </b-col>
            </b-row>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <h5>Liabilities</h5>
            <hr width="20%" align="left"/>
            <b-row class="mt-1 text-center">
              <b-col>
                Total Loans: {{ this.formatCurrency(this.liabilityHistory.totalLoansReceived) }}
              </b-col>
              <b-col>
                Loans Repayed/Forgiven: {{ this.formatCurrency(this.liabilityHistory.totalRepayments) }}
              </b-col>
              <b-col>
                Total Outstanding: {{ this.formatCurrency(this.liabilityHistory.loansOutstanding) }}
              </b-col>
            </b-row>
          </b-col>
        </b-row>
      </b-tab>
      <b-tab title="Contributions" @click="setSelectedFiling('CONTRIBUTIONS')">
        <b-card-title class="text-center">Contributions Overview</b-card-title>
        <hr>
        <b-row class="mt-3">
          <b-col cols="12" class="text-center">
            Total Contributions: {{ this.formatCurrency(this.currentFiling.contributions) }}
          </b-col>
        </b-row>
        <hr width="40%"/>
        <b-row class="mt-3" cols="3">
          <b-col cols="4" class="text-right">
            Individual: {{ this.formatCurrency(this.currentFiling.contributions_ind_part) }}
          </b-col>
          <b-col cols="4" class="text-center">
            Corporate: {{ this.formatCurrency(this.currentFiling.contributions_corp) }}
          </b-col>
          <b-col cols="4" class="text-left">
            Other: {{ this.formatCurrency(this.currentFiling.contributions_other) }}
          </b-col>
        </b-row>
        <b-row class="mt-3" cols="3">
          <b-col cols="4" class="text-right">
            Inkind: {{ this.formatCurrency(this.currentFiling.contribution_inkind) }}
          </b-col>
          <b-col cols="4"></b-col>
          <b-col cols="4" class="text-left">
            Refunded: {{ this.formatCurrency(this.currentFiling.contributions_refunded) }}
          </b-col>

        </b-row>
        <b-row class="mt-3" cols="3">
          <b-col cols="4" class="text-right">
            Loans: {{ this.formatCurrency(this.currentFiling.loansReceived) }}
          </b-col>
          <b-col cols="4" class="text-center">
            Transfers In: {{ this.formatCurrency(this.currentFiling.transfers_in) }}
          </b-col>
          <b-col cols="4" class="text-left">
            Other: {{ this.formatCurrency(this.currentFiling.other_receipts) }}
          </b-col>
        </b-row>
        <hr width="40%"/>
        <b-row class="mt-3">
          <b-col cols="6" class="text-center">
            Cash Raised: {{ this.formatCurrency(this.currentFiling.net_raise) }}
          </b-col>
          <b-col cols="6" class="text-center">
            Estimated Cash on Hand: {{ this.formatCurrency(this.currentFiling.cash_on_hand) }}
          </b-col>
        </b-row>
        <b-form inline class="mt-3 justify-content-center">
          <label class="mr-3" for="contributions-form-filing-select">Filing</label>
          <b-form-select id="contributions-form-filing-select"
                         v-model="selectedFiling"
                         :options="availableFilings" class="mb-2 mr-sm-1 mb-sm-0"
                         @change="setSelectedFiling('CONTRIBUTIONS')">
          </b-form-select>
          <b-button class="ml-3">Go</b-button>
        </b-form>
      </b-tab>
      <b-tab title="Expenses" @click="setSelectedFiling('EXPENDITURES')">
        <b-card-title class="text-center">Expenditures Overview</b-card-title>
        <hr>
        <b-row class="mt-3">
          <b-col cols="12" class="text-center">
            Total Expenditures: {{ this.formatCurrency(this.currentFiling.expenditures) }}
          </b-col>
        </b-row>
        <hr width="40%"/>
        <b-row class="mt-3">
          <b-col cols="5" class="text-right">
            Disbursements: {{ this.formatCurrency(this.currentFiling.disbursements) }}
          </b-col>
          <b-col cols="2">

          </b-col>
          <b-col cols="5" class="text-left">
            Vendor Payments: {{ this.formatCurrency(this.currentFiling.subcontractor_payments) }}
          </b-col>
        </b-row>
        <b-row class="mt-3">
          <b-col cols="5" class="text-right">
            Contributions Refunded: {{ this.formatCurrency(this.currentFiling.contribution_refunded) }}
          </b-col>
          <b-col cols="2">

          </b-col>
          <b-col cols="5" class="text-left">
            Loans Repaid: {{ this.formatCurrency(this.currentFiling.loans_repayed) }}
          </b-col>
        </b-row>
        <b-row class="mt-3">
          <b-col cols="5" class="text-right">
            Liabilities Outstanding: {{ this.formatCurrency(this.currentFiling.liabilities_outstanding) }}
          </b-col>
          <b-col cols="2">

          </b-col>
          <b-col cols="5" class="text-left">
            Transfers Out: {{ this.formatCurrency(this.currentFiling.transfers_out) }}
          </b-col>
        </b-row>
        <hr width="40%"/>
        <b-row class="mt-3">
          <b-col cols="6" class="text-center">
            Cash Raised: {{ this.formatCurrency(this.currentFiling.net_raise) }}
          </b-col>
          <b-col cols="6" class="text-center">
            Estimated Cash on Hand: {{ this.formatCurrency(this.currentFiling.cash_on_hand) }}
          </b-col>
        </b-row>
        <b-form inline class="mt-3 justify-content-center">
          <label class="mr-3" for="contributions-form-filing-select">Filing</label>
          <b-form-select id="contributions-form-filing-select"
                         v-model="selectedFiling"
                         :options="availableFilings" class="mb-2 mr-sm-1 mb-sm-0"
                         @change="setSelectedFiling('EXPENDITURES')">
          </b-form-select>
          <b-button class="ml-3">Go</b-button>
        </b-form>
      </b-tab>
    </b-tabs>
  </b-card>
</template>
<script>/***
 *  Filer Container component for Filer Overview page. Aggregates and presents the filer summaries
 *  from the filer summaries tables. We do some of the aggregation in the DB and then the last mile
 *  calculations here.
 *
 *  @TODO finish implementing presentation
 *  @TODO test calculations for non-candidate committees. The net and cash on hand calcs for
 *  most filers are correct cross-referenced with the NYS BOE site but the not-as-common cases
 *  (expenditure refunds, loan repayments, housekeeping receipts/expenses, etc) are throwing it off
 *  for other committees. In-Kinds are not displaying properly.
 */
import dayjs from "dayjs";

export default {
  components: {},
  props: ['filerDetails', 'fundraisingDetails'],
  data: function () {
    return {
      name: 'Filer Container',
      fundraisingAggregates: {},
      liabilityHistory: {},
      cycleDates: {},
      yearsActive: [],
      availableFilings: {},
      currentFiling: {},
      selectedFiling: [0],
    };
  },
  computed: {},

  watch: {
    fundraisingDetails: {
      handler: 'initializePage',
      immediate: true,
    },
  },

  mounted: function () {
  },
  methods: {
    initializePage: function () {
      this.currentFiling = this.fundraisingDetails[0];
      this.calculateLiabilityHistory(this.fundraisingDetails);
      this.calculateAggregates(this.fundraisingDetails);
      this.calculateCycleDates(this.fundraisingDetails);
      this.setAvailableFilings(this.fundraisingDetails);
    },
    /***
     *  The following methods do last plusses and minuses. I moved
     *  most of the logic to the summary tables in the DB, which aggregate
     *  by schedule/filing, then filing/year.
     *
     */
    calculateAggregates: function (fundraisingDetails) {
      var totalContributions = fundraisingDetails.reduce((acc, filing) => {
        return acc + Number(filing.contributions);
      }, 0);

      var totalExpenditures = fundraisingDetails.reduce((acc, filing) => {
        return acc + Number(filing.expenditures);
      }, 0);

      var totalInkind = fundraisingDetails.reduce((acc, filing) => {
        return acc + Number(filing.contribution_inkind);
      }, 0);

      var fundraisingHistory = {totalContributions, totalExpenditures};

      this.fundraisingAggregates = {...fundraisingHistory};
    },

    calculateLiabilityHistory: function (fundraisingDetails) {
      var lastFiling = fundraisingDetails[fundraisingDetails.length - 1];

      var totalLoansReceived = fundraisingDetails.reduce((acc, filing) => {
        return acc + Number(filing.loans_received);
      }, 0);

      var totalRepayments = fundraisingDetails.reduce((acc, filing) => {
        return acc + Number(filing.loans_repayed);
      }, 0);

      var totalLoansForgiven = fundraisingDetails.reduce((acc, filing) => {
        return acc + Number(filing.liabilities_forgiven);
      }, 0);

      var loansOutstanding = totalLoansReceived - (totalRepayments + totalLoansForgiven);

      var loanHistory = {
        totalLoansReceived,
        totalRepayments,
        totalLoansForgiven,
        loansOutstanding,
      };

      this.liabilityHistory = {...loanHistory};
    },
    // The NYS data doesn't associate all of the filings in a year with a date. Most filings (pre/post primary/general,
    // january/july periodic) only change by a couple of days every year but special cases (a special election, off-cycle
    // reports, local/village elections, etc.) can occur at any time, so we need to infer the order of the filings
    // in order to get an accurate cash-on-hand calculation.
    calculateCycleDates: function (fundraisingDetails) {
      var dateArray = fundraisingDetails.map((filing) => {
        return [
          filing.election_year,
          this.$dayjs(filing.average_transaction_date),
          this.$dayjs(filing.earliest_transaction_date),
          this.$dayjs(filing.latest_transaction_date),
        ];
      });

      var yearsActive = dateArray.reduce(
          (acc, dates) => {
            return [Math.min(dates[0], acc[0]), Math.max(dates[0], acc[1])];
          },
          [Number.MAX_VALUE, Number.MIN_VALUE]
      );


      var e = dateArray.map((x) => x[2]);
      var l = dateArray.map((x) => x[3]);

      var earliest_transaction_date = e[0].$d;
      for (var i = 1; i < e.length; i++) {
        var d1 = (e[i].$d).getTime();
        if (d1 < earliest_transaction_date.getTime()) {
          earliest_transaction_date = e[i].$d;
        }
      }

      var last_transaction_date = l[0].$d;
      for (var j = 1; j < l.length; j++) {
        var d2 = (l[j].$d).getTime();
        console.log(l[j].$d);
        if (d2 > last_transaction_date.getTime()) {
          last_transaction_date = l[j].$d;
        }
      }

      earliest_transaction_date = this.$dayjs(earliest_transaction_date).format('MM/DD/YYYY');
      last_transaction_date = this.$dayjs(last_transaction_date).format('MM/DD/YYYY');

      this.minSelectedDate = this.$dayjs(earliest_transaction_date).format('YYYY-MM-DD');
      this.maxSelectedDate = this.$dayjs(last_transaction_date).format('YYYY-MM-DD');

      this.cycleDates = {yearsActive, earliest_transaction_date, last_transaction_date};
      this.yearsActive = [dayjs(earliest_transaction_date).format('YYYY'), dayjs(last_transaction_date).format('YYYY')];
    },
    // Set the array of available filings for the dropdown select
    setAvailableFilings: function (fundraisingDetails) {
      var availableFilings = fundraisingDetails.map(function (filing) {
        return {
          value: [filing.election_year, filing.filing_abbreviation],
          text: filing.election_year + ' ' + filing.filing_description,
        };
      });

      this.selectedFiling = availableFilings[0]['value'];
      this.availableFilings = availableFilings;
    },
    // When a filing is selected, let the parent know to request it from
    // the DB and update the grid data with the response.
    setSelectedFiling: function (type) {
      // This is kind of a kludge because we're immediately updating
      // the rendered filing. It's called on tab-over by the b-select

      var updatedFiling = this.fundraisingDetails.filter(
          (filing) =>
              filing.election_year == this.selectedFiling[0] &&
              filing.filing_abbreviation == this.selectedFiling[1]
      );

      this.currentFiling = updatedFiling[0];

      var selectedFiling = [this.selectedFiling[0], this.selectedFiling[1]];
      this.$emit('set-filing', selectedFiling, type);
    },
    // Tell the parent to switch the column defs from the summary view to
    // the individual transaction view
    setSummary: function () {
      this.$emit('set-summary');
    },
  },
};
</script>
<style scoped>

#filer-card-summary-label {
  font-size: .9rem;
}

#filer-card-summary-content {
  margin-bottom: 0;
}

</style>