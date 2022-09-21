// /***
//  * Some formatting utility methods for AG Grid.
//  *
//  */
//
// import numeral from 'numeral';
//
// export var donorNameGetter = function (params) {
//   var arr = ''
//   var out = ''
//
//   if (params.data.donor_organization_name) {
//     arr = params.data.donor_organization_name
//     out = arr
//   } else {
//     arr = [params.data.donor_first_name, params.data.donor_middle_name, params.data.donor_last_name]
//
//     for (var i = 0; i < arr.length; i++) {
//       out += (arr[i] || '') + ' '
//     }
//   }
//
//   return out.trim()
// }
//
// export var donorAddressGetter = function (params) {
//   var arr = [
//     params.data.donor_address,
//     params.data.donor_city,
//     params.data.donor_state,
//     params.data.donor_zip,
//   ]
//   var out = ''
//
//   for (var i = 0; i < arr.length; i++) {
//     out += (arr[i] || '') + ' '
//   }
//   out = out.trim()
//
//   return out
// }
//
// export var donorDateGetter = function (params) {
//     var out = params.data.transaction_date;
//   //var out = dayjs(params.data.transaction_date).format('MM/DD/YYYY')
//   return out;
// }
//
// export var currencyFormatter = function (params) {
//   var out = numeral(params.value).format('$0,0.00')
//   return out
// }
//
// export default {
//   methods: {},
// }

/***
 * Some formatting utility methods for AG Grid.
 *
 */

import numeral from 'numeral';
import dayjs from "dayjs";

export var donorNameGetter = function (params) {
	var arr = '';
	var out = '';

	if (params.data.donor_organization_name) {
		arr = params.data.donor_organization_name;
		out = arr;
	} else {
		arr = [params.data.donor_first_name, params.data.donor_middle_name, params.data.donor_last_name];

		for (var i = 0; i < arr.length; i++) {
			out += (arr[i] || '') + ' ';
		}
	}

	return out.trim();
};

export var gridNameGetter = function (nameArray) {
	var out = '';

	for (var i = 0; i < nameArray.length; i++) {
		out += (nameArray[i] || '') + ' ';
	}
	return out.trim();
};

export var donorAddressGetter = function (params) {
	var arr = [
		params.data.donor_address,
		params.data.donor_city,
		params.data.donor_state,
		params.data.donor_zip,
	];
	var out = '';

	for (var i = 0; i < arr.length; i++) {
		out += (arr[i] || '') + ' ';
	}
	out = out.trim();
	return out;
};

export var gridAddressGetter = function (addressArray) {
	var out = '';
	for (var i = 0; i < addressArray.length; i++) {
		out += (addressArray[i] || '') + ' ';
	}
	out = out.trim();
	return out;
};

export var gridDateGetter = function (date) {
	var out = dayjs(date);
	return out;
};

export var gridDateFormatter = function (date) {
	var out = dayjs(date).format('MM/DD/YYYY');
	return out;
};

export var gridCurrencyGetter = function (amount) {
	return Number(amount);
};

export var gridCurrencyFormatter = function (amount) {
	var out = numeral(amount).format('$0,0.00');
	return out;
};

export var gridNumberGetter = function (string) {
	return Number(string);
}

export default {
	methods: {},
};
