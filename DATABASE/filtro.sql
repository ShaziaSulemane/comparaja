CREATE PROCEDURE Filter (
	in column_to_test varchar(255),
    in val int,
    in operation varchar(255)
)
BEGIN
	drop table if exists products;
	create temporary table products (SELECT comparaja.products.id, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 1), ' ', -1), ':', '-1') as p,
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 2), ' ', -1), ':', '-1') as internet_download_speed_in_mbs, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 3), ' ', -1), ':', '-1') as internet_upload_speed_in_mbs, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 4), ' ', -1), ':', '-1') as tv_channels, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 5), ' ', -1), ':', '-1') as mobile_phone_count, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 6), ' ', -1), ':', '-1') as mobile_phone_data_in_gbps, 
		substring_index(replace(substring_index(substring_index (comparaja.products.data, ',', 7), ' ', -1), '\n}', ''), ':', -1) as price
	from comparaja.products inner join comparaja.verticals on comparaja.products.vertical_id = comparaja.verticals.id
	inner join comparaja.providers on comparaja.providers.id = comparaja.products.provider_id
	where comparaja.verticals.code = 'BB' and comparaja.providers.is_active = TRUE);

	select * from products where 
	case column_to_test
		when 'internet_download_speed_in_mbs' then 
			(select case operation
				when '=' then products.internet_download_speed_in_mbs = val
                when '<' then products.internet_download_speed_in_mbs < val
                when '>' then products.internet_download_speed_in_mbs > val
			end)
		when 'mobile_phone_count' then
			(select case operation
				when '=' then products.mobile_phone_count = val
                when '<' then products.mobile_phone_count < val
                when '>' then products.mobile_phone_count > val
			end)
		when 'price' then
			(select case operation
				when '=' then products.price = val
                when '<' then products.price < val
                when '>' then products.price > val
			end)
	end;
    
    
END