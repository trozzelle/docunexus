drop view dcnxs_ny.voter_email_v
;

create view dcnxs_ny.voter_email_v
as select x.* from (
select trim(nys_voter_id) as nys_voter_id, trim(replace(replace(email,'\n',' '),'\t',' ')) 
as email
from dcnxs_ny.voter_data
) x  where length(email) > 5 and email like '%@%' and email like '%.%'
;

drop view dcnxs_ny.voter_phone_v
;
create view dcnxs_ny.voter_phone_v
as select x.* from (
 select trim(nys_voter_id) as nys_voter_id, right(REGEXP_REPLACE(telephone, '[\\D]+', ''),15)
as phone
from dcnxs_ny.voter_data
) x where length(phone) > 6
;

drop view dcnxs_ny.voter_zip5_v
;
create view dcnxs_ny.voter_zip5_v
as select x.* from (
 select trim(nys_voter_id) as nys_voter_id, left(REGEXP_REPLACE(residence_zip, '[\\D]+', ''),5)
as zip5
from dcnxs_ny.voter_data
) x where length(zip5) > 4
;

drop view dcnxs_ny.voter_last_name_v
;
create view dcnxs_ny.voter_last_name_v
as select x.* from (
 select trim(nys_voter_id) as nys_voter_id, cast(trim(replace(replace(replace(replace(replace(replace(upper(last_name),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
as char) as last_name
from dcnxs_ny.voter_data
) x  where length(last_name) > 1
;

drop view dcnxs_ny.voter_first_name_v
;

create view dcnxs_ny.voter_first_name_v
as select x.* from (
 select trim(nys_voter_id) as nys_voter_id, cast(trim(replace(replace(replace(replace(replace(replace(upper(first_name),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
as char) as first_name
from dcnxs_ny.voter_data
) x  where length(first_name) > 1
;


drop view dcnxs_ny.voter_full_name_v
;

create view dcnxs_ny.voter_full_name_v
as select x.* from (
 select trim(nys_voter_id) as nys_voter_id
, cast(trim(replace(replace(replace(replace(replace(replace(upper(
    concat(
        ifnull(first_name,' '),' '
        ,ifnull(middle_name,' '),' '
        ,ifnull(last_name,' '),' '
        ,ifnull(name_suffix,' ')
    )),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
as char) as full_name
from dcnxs_ny.voter_data
) x  where length(full_name) > 2
;

drop view dcnxs_ny.voter_residence_address_v
;

create view dcnxs_ny.voter_residence_address_v
as select x.* from (
 select trim(nys_voter_id) as nys_voter_id, cast(trim(replace(replace(replace(replace(replace(replace(upper(
concat(
    ifnull(residence_num,' '),' '
    ,ifnull(residence_halfnum,' '),' '
    ,ifnull(residence_aptnum,' '),' '
    ,ifnull(residence_pre_street_dir,' '),' '
    ,ifnull(residence_street_name,' '),' '
    ,ifnull(residence_post_street_dir,' '),' '
    ,ifnull(residence_city,' '),' NY '
    ,ifnull(residence_zip,' ')
    )
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
as char) as residence_address
from dcnxs_ny.voter_data
) x  where length(residence_address) > 10
;

drop view dcnxs_ny.voter_mailing_address_v
;

create view dcnxs_ny.voter_mailing_address_v
as select x.* from (
 select trim(nys_voter_id) as nys_voter_id, cast(trim(replace(replace(replace(replace(replace(replace(upper(
concat(
    ifnull(mailing_address_1,' '),' '
    ,ifnull(mailing_address_2,' '),' '
    ,ifnull(mailing_address_3,' '),' '
    ,ifnull(mailing_address_4,' ')
    )
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
as char) as mailing_address
from dcnxs_ny.voter_data
) x  where length(mailing_address) > 10
;

drop view dcnxs_ny.voter_previous_address_v
;

create view dcnxs_ny.voter_previous_address_v
as select x.* from (
 select trim(nys_voter_id) as nys_voter_id, cast(trim(replace(replace(replace(replace(replace(replace(upper(
previous_address
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
as char) as previous_address
from dcnxs_ny.voter_data
) x  where length(previous_address) > 10
;

drop view dcnxs_ny.union_test_v
;
create view dcnxs_ny.union_test_v
as 
select v.*
, concat('python3 -c"import sys;sys.path.insert(0,\\"../python-mysql\\");import dcnxs_fuzzy; fuzzy = dcnxs_fuzzy.get_fuzzy({''string1'':''',union_address,''',''string2'':''',residence_address,'''}); print(fuzzy);"') as test_cmd
from (
	select u.queueid, v1.nys_voter_id
	, u.union_address
	, a.residence_address
	from (
		select u.queueid
		,cast(trim(replace(replace(replace(replace(replace(replace(upper(u.FirstName),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
		 as char) as first_name
		,cast(trim(replace(replace(replace(replace(replace(replace(upper(u.LastName),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
		 as char) as last_name
		,right(REGEXP_REPLACE("Preferred Phone", '[\\D]+', ''),15) as phone
		,left(REGEXP_REPLACE(Zip5, '[\\D]+', ''),5) as zip5
		,cast(trim(replace(replace(replace(replace(replace(replace(upper(
		 concat(
			ifnull(u.Address,' '),' '
			,ifnull(u.City,' '),' '
			,ifnull(u.State,' '),' '
			,ifnull(u.Zip5,' ')
			)
		 ),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
		 as char) as union_address
		from dcnxs_ny.1_7_match u
	) u
	join dcnxs_ny.voter_last_name v1 on v1.last_name = u.last_name
	join dcnxs_ny.voter_first_name v2 on v2.nys_voter_id = v1.nys_voter_id and v2.first_name = u.first_name
	join dcnxs_ny.voter_zip5 v3 on v3.nys_voter_id = v1.nys_voter_id and v3.zip5 = u.zip5
    join dcnxs_ny.voter_phone v4 on v4.nys_voter_id = v1.nys_voter_id and v4.phone = u.phone
	join dcnxs_ny.voter_residence_address a on a.nys_voter_id = v1.nys_voter_id
	left join dcnxs_ny.voter_residence_address a2 on a2.nys_voter_id = v1.nys_voter_id and a2.residence_address = u.union_address
	where a2.nys_voter_id is null
) v
;
