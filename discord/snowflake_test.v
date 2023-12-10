module discord

import time

fn test_snowflake() {
	me := Snowflake(1073325901825187841)
	assert me.raw_timestamp() == 1675971236426
	timestamp := me.timestamp()
	assert timestamp.year == 2023
	assert timestamp.month == 2
	assert timestamp.day == 9
	assert timestamp.hour == 19
	assert timestamp.minute == 33
	assert timestamp.second == 56
	assert timestamp.nanosecond == 426000000
}