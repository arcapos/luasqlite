-- $NetBSD: sqlite.lua,v 1.3 2015/12/08 23:04:40 kamil Exp $

local sqlite = require 'sqlite'

print(sqlite._VERSION .. ' - ' .. sqlite._DESCRIPTION)
print(sqlite._COPYRIGHT)
print()

print('initialize sqlite')
sqlite.initialize()

print('this is sqlite ' .. sqlite.libversion() .. ' (' ..
    sqlite.libversion_number() .. ')')
print('sourceid ' .. sqlite.sourceid())

local db <close>, state = sqlite.open('/tmp/db.sqlite', sqlite.OPEN_CREATE |
    sqlite.OPEN_READWRITE)

if state ~= sqlite.OK then
	print('db open failed', state)
else
	err = db:exec('create table test (name varchar(32))')

	if err ~= sqlite.OK then
		print('table creation failed')
		print('error code ' .. db:errcode() .. ' msg ' .. db:errmsg())
	end

	db:exec("insert into test values('Balmer')")
	print('last command changed ' .. db:changes() .. ' rows')

	local stmt <close> = db:prepare("insert into test values(:name)")

	print('statement has ' .. stmt:bind_parameter_count() .. ' parameters')
	print('param 1 name: ' .. stmt:bind_parameter_name(1))
	print('param name is at index ' .. stmt:bind_parameter_index(':name'))

	stmt:bind(1, 'Hardmeier')
	stmt:step()
	stmt:reset()
	stmt:bind(1, 'Balmer')
	stmt:step()

	local s2 <close> = db:prepare('select name from test')

	while s2:step() == sqlite.ROW do
		print('name = ' .. s2:column(1))
	end

	local stmt <close> = db:prepare('drop table test')
	stmt:step()
end

print('shutdown sqlite')
sqlite.shutdown()
