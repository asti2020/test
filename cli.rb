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

def processValue(value) 
    if value.class == Hash
        scrub(value, value)
        return
    end

    if value.class == Array
        updatedRecords = [];
        value.each do |item|   
            updatedItem = processRecord(item)
            updatedRecords.push(updatedItem)
        end
        return updatedRecords
    end

    if value != nil
        if !!value  == value || value.class == String || value.class == Fixnum
            return processRecord(value)
        end             
    end
end

def processRecord(value)
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
            updatedVal = processValue value
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

