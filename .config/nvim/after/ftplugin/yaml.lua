local go = vim.go

--[[
Schema		Description ~
failsafe	No additional highlighting.
json		Supports JSON-style numbers, booleans and null.
core		Supports more number, boolean and null styles.
pyyaml		In addition to core schema supports highlighting timestamps,
		but there are some differences in what is recognized as
		numbers and many additional boolean values not present in core
		schema.

Default schema is `core`.
--]]

g.yaml_schema = { 'pyyaml' }
