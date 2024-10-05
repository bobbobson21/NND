
	nnd = {}
	nnd["Inputs"] = {} --the names of the inputs
	nnd["InputMap"] = {} --maps the base nurmerical inputs to anything else like other numbers or text or anything really
	nnd["OutputMap"] = {}
	
	nnd["ConnectionFunction"] = function( ... ) end --this function is ressponceible for sending the inputs to the nural network and then returning the output from it --i recommend you output the data in the nural network program to a file it can read from then use call in os.execute
	
	nnd["DisassemblyTable"] = {} --the how to perform Disassembly table
	nnd["DisassemblyDetail"] = 0 --how close is it to the nural network in terms of detail use 0 if working with ints or input maps
	nnd["DisassemblyMinRange"] = 0
	nnd["DisassemblyMaxRange"] = 1
	nnd["DisassemblyResultTable"] = {} --temporary storage for the results
	
function nnd:LoadDisassemblyTableFromExternalFile( FilePath )

	local FileContents = "";
	local File = io.open( FilePath ,"r") --load the output file so we can appstart it
if File ~= nil then
	FileContents = File:read( "*all" )
File:close()
end

	local Exe, Null = load( "return "..FileContents )
	local Results = Exe()  

	nnd["DisassemblyTable"] = Results
end

function nnd:EncodeDisassemblyResultTable( Inputs, Result )
if nnd["DisassemblyResultTable"][Result] == nil then nnd["DisassemblyResultTable"][Result] = {} end
	nnd["DisassemblyResultTable"][Result][#nnd["DisassemblyResultTable"][Result] +1] = Inputs;
end

function nnd:ParseThougthInputMap( ... )
	local InputValues = {...}
	
for z = 1, #InputValues do
if nnd["InputMap"][InputValues[z]] ~= nil then
	InputValues[z] = nnd["InputMap"][InputValues[z]]
   end
end

return table.unpack( InputValues )
end

function nnd:ParseThougthOutputMap( ... )
	local InputValues = {...}
	
for z = 1, #InputValues do
if nnd["OutputMap"][InputValues[z]] ~= nil then
	InputValues[z] = nnd["OutputMap"][InputValues[z]]
   end
end

return table.unpack( InputValues )
end

function nnd:RunDisassemblyCollectData() --collects the data from the nural network that can then be disassembled

	local Detail = 1 -nnd["DisassemblyDetail"]
	local StartPoint = nnd["DisassemblyMinRange"]
	local EndPoint = nnd["DisassemblyMaxRange"] *( 1 /Detail )

	local DisassemblyCodeStart = ""
	local DisassemblyCodeEnd = ""
	local DisassemblyCodeInputValues = ""

for K, V in ipairs( nnd["Inputs"] ) do
if DisassemblyCodeInputValues ~= "" then
	DisassemblyCodeInputValues = DisassemblyCodeInputValues..", "..tostring( V ).." *"..tostring( Detail )
else
	DisassemblyCodeInputValues = tostring( V ).." *"..tostring( Detail )
end
 
	DisassemblyCodeStart = DisassemblyCodeStart.." for "..V.." = "..StartPoint..", "..EndPoint.." do; "
	DisassemblyCodeEnd = DisassemblyCodeEnd.." end"
end

	local DisassemblyCodeExacute = "nnd:EncodeDisassemblyResultTable( {"..DisassemblyCodeInputValues.."}, nnd:ParseThougthOutputMap( nnd.ConnectionFunction( nnd:ParseThougthInputMap("..DisassemblyCodeInputValues..") ) ) )"

	local Exe, Null = load( DisassemblyCodeStart..DisassemblyCodeExacute..DisassemblyCodeEnd )
	local Results = Exe()  

end

function nnd:DisassemblyDataToDisassembly()
	local ReturnString = ""

if nnd["DisassemblyTable"]["InputStructName"] ~= nil then --MAKES STRUCT
	ReturnString = ReturnString..nnd["DisassemblyTable"]["InputStructTypeStart"]..nnd["DisassemblyTable"]["InputStructName"]..nnd["DisassemblyTable"]["InputStructTypeEnd"] --START
	ReturnString = ReturnString..nnd["DisassemblyTable"]["CodeBlockStart"]
	
for K, V in ipairs( nnd["Inputs"] ) do
	ReturnString = ReturnString..nnd["DisassemblyTable"]["InputStructValueStart"]..V..nnd["DisassemblyTable"]["InputStructValueEnd"] --ADD VARS
end

	ReturnString = ReturnString..nnd["DisassemblyTable"]["CodeBlockEnd"] --END OF STRUCT
end

	ReturnString = ReturnString..nnd["DisassemblyTable"]["FuncStart"] --MAKES FUNC
	
	local InputString = ""
for K, V in ipairs( nnd["Inputs"] ) do --DOSE FUNC INPUTS
	local Prefix = ""
if InputString ~= "" then Prefix = ", " end
	InputString = InputString..Prefix..nnd["DisassemblyTable"]["FuncInputPrefix"]..V
end
	ReturnString = ReturnString..InputString
	
	ReturnString = ReturnString..nnd["DisassemblyTable"]["FuncEnd"]
	ReturnString = ReturnString..nnd["DisassemblyTable"]["CodeBlockStart"] --CREATES CODE BLOCK FOR FUNC


	local CompactData = (nnd["DisassemblyTable"]["ConditionOr"] == nil)
	local CompactOutput = {}

for K, V in pairs( nnd["DisassemblyResultTable"] ) do --WRITES THE MAIN BODY OF CODE

	
	local Output = ""
	local ReturnData = K
	
for L, W in pairs( V ) do
for M, X in pairs( W ) do ---the 
	Output = Output..nnd["DisassemblyTable"]["ConditionStart"]..nnd["Inputs"][M]..nnd["DisassemblyTable"]["ConditionMore"]..tostring( X )..nnd["DisassemblyTable"]["ConditionAnd"]..nnd["Inputs"][M]..nnd["DisassemblyTable"]["ConditionLess"]..tostring(X +(1 -nnd["DisassemblyDetail"]))..nnd["DisassemblyTable"]["ConditionEnd"]
if M < #W then Output = Output..nnd["DisassemblyTable"]["ConditionAnd"] end
end

if CompactData == false then
	ReturnString = ReturnString..nnd["DisassemblyTable"]["IfStart"]..Output..nnd["DisassemblyTable"]["IfEnd"]..nnd["DisassemblyTable"]["CodeBlockStart"]..nnd["DisassemblyTable"]["ReturnValueStart"]..tostring(ReturnData)..nnd["DisassemblyTable"]["ReturnValueEnd"]..nnd["DisassemblyTable"]["CodeBlockEnd"]
   
else
if CompactOutput[ReturnData] == nil then CompactOutput[ReturnData] = {} end	
	CompactOutput[ReturnData][#CompactOutput[ReturnData]+1] = Output

      end
   end
end

for K, V in ipairs( CompactOutput ) do 

	local Output = ""
for L, W in pairs( V ) do
if Output ~= "" then
	Prefix = nnd["DisassemblyTable"]["ConditionEnd"].." "
if L < #V then Prefix = Prefix..nnd["DisassemblyTable"]["ConditionOr"] end
end

	Output = Output..Prefix..nnd["DisassemblyTable"]["ConditionStart"]
end


	ReturnString = ReturnString..nnd["DisassemblyTable"]["IfStart"]..Output..nnd["DisassemblyTable"]["IfEnd"]..nnd["DisassemblyTable"]["CodeBlockStart"]..nnd["DisassemblyTable"]["ReturnValueStart"]..tostring(K)..nnd["DisassemblyTable"]["ReturnValueEnd"]..nnd["DisassemblyTable"]["CodeBlockEnd"]
end

ReturnString = ReturnString..nnd["DisassemblyTable"]["CodeBlockEnd"] --FINISH

return ReturnString
end

function nnd:DisassemblyDataToDisassemblyOutToFile( File )

io.output( File )
io.write( nnd:DisassemblyDataToDisassembly() )
io.close()

io.output( io.stdout )

end

function nnd:TestFunction()

nnd:LoadDisassemblyTableFromExternalFile( "nndLuaDisassemblyBasic.txt" )

nnd["ConnectionFunction"] = function( ... )
		local InputValues = {...}
		local InputAsString = ""
		
for z = 1, #InputValues do
	InputAsString = InputAsString..tostring( InputValues[z] )..", "
end
	
print( "the inputs are: "..InputAsString )
	
io.write( "inset result: " )
	local UserInput = io.read()
	UserInput = tonumber( UserInput ) or UserInput;
	
return UserInput
end

io.write( "inset pramater length: " )
	local PamaLength = io.read()
	
for z = 1, tonumber( PamaLength ) or 2 do
	nnd["Inputs"][#nnd["Inputs"] +1] = "Input"..tostring( z )
end

nnd:RunDisassemblyCollectData()
nnd:DisassemblyDataToDisassemblyOutToFile( "nndtest.lua" )

end

nnd:TestFunction()