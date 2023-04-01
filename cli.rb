#!/usr/bin/env ruby

require 'JSON'



inputFile = File.open("input.json")
inputData = JSON.parse(inputFile.read())
inputFile.close()

def sensitiveKeys
    sensativeKeysFile = File.open("sensative.txt")
    sensitiveKeysArr = sensativeKeysFile.read().split("\n")
    bySensitiveKeys = Hash[sensitiveKeysArr.collect { |item| [item, 1] } ]
    return bySensitiveKeys
end

def scrub (jsonBlock, updatedJson) 
    jsonBlock.each { | key, value|
        updatedVal = value 
        bySensitiveKeys = sensitiveKeys
        if bySensitiveKeys.has_key?(key)
            if value.class == Hash
                scrub(value, value)
                next
            end

            if value.class == Array
                

            if value != nil
                if !!value  == value 
                    updatedVal = "-"
                elsif updatedVal.class == String || updatedVal.class == Fixnum
                    updatedVal = value.to_s.gsub(/[a-z0-9]/i, "*")
                end                
            end
        end  

        updatedJson[key] = updatedVal; 
    }
end
    
    


outputJson = [];
inputData.each { |jsonBlock|
    updatedJson = {};
    scrub jsonBlock, updatedJson
    outputJson.push(updatedJson)
}

puts outputJson;






# # puts outputJson;

