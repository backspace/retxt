Before do
  ExtractsAreaCodes.any_instance.stubs(:extract_area_code).returns('212')
end

After do
  ExtractsAreaCodes.any_instance.unstub(:extract_area_code)
end
