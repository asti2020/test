#!/usr/bin/env ruby

require 'JSON'

def sensitiveKeys
    sensativeKeysFile = File.open("sensative.txt")
    sensitiveKeysArr = sensativeKeysFile.read().split("\n")
    bySensitiveKeys = Hash[sensitiveKeysArr.collect { |item| [item, 1] } ]
    return bySensitiveKeys
end

def processRecord(value) 
    if value.class == Hash
        scrub(value)
        return
    end

    if value.class == Array
        updatedRecords = [];
        value.each do |item|   
            updatedItem = processValue(item)
            updatedRecords.push(updatedItem)
        end
        return updatedRecords
    end

    if value != nil
        if !!value  == value || value.class == String || value.class == Fixnum
            return processValue(value)
        end             
    end
end

def processValue(value)
        if !!value  == value 
            return "-"
        elsif value.class == String || value.class == Fixnum
            return value.to_s.gsub(/[a-z0-9]/i, "*") 
        end              

    return value
end

def scrub (jsonBlock, updatedJson) 
    jsonBlock.each { | key, value|
        updatedVal = value
        bySensitiveKeys = sensitiveKeys
        if bySensitiveKeys.has_key?(key)
            updatedVal = processRecord value
        end
        updatedJson[key] = updatedVal; 
    }
end

inputFile = File.open("input.json")
inputData = JSON.parse(inputFile.read())
inputFile.close()

outputJson = [];
inputData.each { |jsonBlock|
    updatedJson = {};
    scrub jsonBlock, updatedJson
    outputJson.push(updatedJson)
}

File.open("output.json","w") do |f|
    f.write(outputJson.to_json)
  end

