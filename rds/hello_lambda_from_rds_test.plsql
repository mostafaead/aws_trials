SET serveroutput ON;
DECLARE
  req utl_http.req;
  resp utl_http.resp;
  line VARCHAR2(1024);
BEGIN
  dbms_output.put_line('Test triggering lambda');
  utl_http.set_wallet('<wallet_path>', NULL);
  req := utl_http.begin_request('https://<vpc_endpoint_dns_name>/dev/lambdainvoker');
  utl_http.set_header(req, 'user-agent', 'mozilla/4.0');
  utl_http.set_header(req, 'x-apigw-api-id', '<generated-api-gateway-id>');
  resp := utl_http.get_response(req);
  BEGIN
    LOOP
      utl_http.read_line(resp, line, true);
      dbms_output.put_line(line);
    END LOOP;
    utl_http.end_response(resp);
  EXCEPTION
  WHEN utl_http.end_of_body THEN
    utl_http.end_response(resp);
  END;
END;
/