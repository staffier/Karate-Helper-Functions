-- Run this using a command similar to the following:
-- wrk -t1 -c100 -d30s -s ./src/test/java/benchmark.lua --timeout 60s http://localhost:8080 --latency

login = function()
    headers = {}
    headers["CorrelationId"] = "Performance-Test"
    body = [[
            {
              "userId": "1",
              "password": "1"
            }
           ]]
    return wrk.format("POST", "/login", headers, body)
end

createToken = function()
    headers = {}
    headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJGSVMiLCJleHAiOjE3MzkyMDgxMTN9.Sa4tIldLBbQCWA6Z0mPMZgPavTedy2T4iyA-XUmDwEQ"
    headers["CorrelationId"] = "Performance-Test"
    body = [[
           {
              "cardDetails": {
                "accountNumber": "4444333322221111",
                "cvv2": "123",
                "expirationDate": {
                  "month": "12",
                  "year": "2033"
                }
              },
              "accountHolderDetails": {
                "name": "string"
              },
              "addressDetails": {
                "city": "string",
                "country": "string",
                "zipCode": "string"
              }
            }
           ]]
    return wrk.format("POST", "/createToken", headers, body)
end

requests = {}
requests[0] = login;
requests[1] = createToken;
requests[2] = createToken;
requests[3] = createToken;

request = function()
    return requests[math.random(0, 3)]()
end

response = function(status, headers, body)
    --print('Status: ', status, 'Body: ', body)
    if status ~= 200 then
        io.write("------------------------------\n")
        io.write("Response with status: ".. status .."\n")
        io.write("------------------------------\n")
        io.write("[response] Body:\n")
        io.write(body .. "\n")
    end
end

done = function(summary, latency, requests)

    t = {
        lat_min = latency.min,
        lat_max = latency.max,
        lat_mean = latency.mean,
        lat_stdev = latency.stdev,
        duration = summary.duration,
        requests = summary.requests,
        bytes = summary.bytes
    }

    if summary.errors then
        t["err_con"] = summary.errors.connect
        t["err_read"] = summary.errors.read
        t["err_write"] = summary.errors.write
        t["err_status"] = summary.errors.status
        t["err_timeout"] = summary.errors.timeout
    end

end
