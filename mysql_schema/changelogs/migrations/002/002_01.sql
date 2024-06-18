create table if not exists stage.confirmations
(
	user_id int,
	time_stamp datetime,
	action  ENUM
);