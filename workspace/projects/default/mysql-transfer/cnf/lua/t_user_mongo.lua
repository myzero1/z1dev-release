-- t_user_mongo.lua
-- https://www.kancloud.cn/wj596/go-mysql-transfer/2112001
-- https://www.kancloud.cn/wj596/go-mysql-transfer/2112017

local ops = require("mongodbOps") --加载mongodb操作模块
local db = require("dbOps") --加载数据库操作模块

local row = ops.rawRow()  --当前数据库的一行数据,table类型
local action = ops.rawAction()  --当前数据库事件,包括：insert、update、delete

local result = {}  -- 定义一个table
for k, v in pairs(row) do
    if k ~="id" then -- 列名不为ID
        result[k] = v
    end
end

local id = row["id"] --获取ID列的值
result["_id"] = id -- _id为MongoDB的主键标识

if action == "delete" then -- 删除事件  -- 修改事件
    ops.DELETE("t_user",id) -- 删除，第一个参数为collection名称(string类型)，第二个参数为ID 
elseif action == "insert" then -- 新增事件
	-- SQL语句，不能直接使用表名，要使用(数据库名称.表名称)，如：ESEAP.T_AREA
	local sql = string.format("SELECT version FROM yii2advanced.migration  LIMIT 1")
	-- 执行SQL查询，返回一条查询结果，table类型;结构如：{"ID":"340100000000","NAME":"安徽省 合肥市"}
	local rs = db.selectOne(sql)

    result["migration_first"] = rs["version"]

    ops.INSERT("t_user",result) -- 新增，第一个参数为collection名称，string类型；第二个参数为要修改的数据，talbe类型
else -- 修改事件
	-- SQL语句，不能直接使用表名，要使用(数据库名称.表名称)，如：ESEAP.T_AREA
	local sql = string.format("SELECT username FROM yii2advanced.user WHERE id = '%s'",id)
	-- 执行SQL查询，返回一条查询结果，table类型;结构如：{"ID":"340100000000","NAME":"安徽省 合肥市"}
	local rs = db.selectOne(sql)
    
    result["username_form_sql"] = rs["username"]
    
    ops.UPDATE("t_user",id,result) -- 修改，第一个参数为collection名称，string类型；第二个参数为ID；第三个参数为要修改的数据，talbe类型
    -- ops.UPSERT("t_user",id,result) -- 修改或新增，第一个参数为collection名称，string类型；第二个参数为ID；第三个参数为要修改的数据，talbe类型
end 