function NuralBreakDown( Input1, Input2 ) 
if ((Input1 >= 0 and Input1 < 1) and (Input2 >= 1 and Input2 < 2)) or ((Input1 >= 1 and Input1 < 2) and (Input2 >= 0 and Input2 < 1)) then 
return 1
end 

if ((Input1 >= 0 and Input1 < 1) and (Input2 >= 0 and Input2 < 1)) or ((Input1 >= 1 and Input1 < 2) and (Input2 >= 1 and Input2 < 2)) then 
return 0
end 

end 

