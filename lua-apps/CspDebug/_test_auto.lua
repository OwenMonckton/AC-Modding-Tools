assert(table.some(ac.INIConfig.load(__dirname .. "\\.test\\ext_config.ini", ac.INIFormat.ExtendedIncludes, {'@cars'}).sections, function (item, index, callbackData) return index == 'MODEL_REPLACEMENT_0HIDE_RIMS_0' end))
assert(table.some(ac.INIConfig.load(__dirname .. "\\.test\\ext_config.ini", ac.INIFormat.ExtendedIncludes, {'@cars'}).sections, function (item, index, callbackData) return index == 'MODEL_REPLACEMENT_0REPLACE_RIMS_0' end))
assert(not io.fileExists('.test\\ext_config.ini'))
assert(not io.open('.test\\ext_config.ini', 'r'))
os.setCurrentFolder(__dirname)
assert(io.fileExists('.test\\ext_config.ini'))
assert(3996 == io.fileSize('.test\\ext_config.ini'))
assert(not io.dirExists('.test\\ext_config.ini'))
assert(io.open('.test\\ext_config.ini', 'r'))
assert(not io.open('.test\\ext_config_ne.ini', 'r'))

local dnsResolved
web.resolveDNS('stackoverflow.com', function (err, ret) dnsResolved = true assert(ret) end)
setTimeout(function () assert(dnsResolved) end, 10)