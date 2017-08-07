require 'webmock'
include WebMock::API

WebMock.enable!

WebMock.disable_net_connect!(allow_localhost: true)

stub_request(:any, /events.pagerduty.com/)

stub_request(:any, /dummy.s3.amazonaws.com/)

# stub_request(:any, /hub-cloud.browserstack.com/)

browserstack_mock_post1_reponse = '''
{"state":null,"sessionId":"6b04a40d32157861f90f4b624bbf40090fdb9477","hCode":21722156,"value":{"applicationCacheEnabled":false,"rotatable":false,"mobileEmulationEnabled":false,"networkConnectionEnabled":false,"chrome":{"chromedriverVersion":"2.30.477700 (0057494ad8732195794a7b32078424f92a5fce41)","userDataDir":"C:\\Windows\\proxy\\scoped_dir6792_23550"},"takesHeapSnapshot":true,"pageLoadStrategy":"normal","databaseEnabled":false,"handlesAlerts":true,"hasTouchScreen":false,"version":"59.0.3071.86","platform":"XP","browserConnectionEnabled":false,"nativeEvents":true,"acceptSslCerts":true,"webdriver.remote.sessionid":"6b04a40d32157861f90f4b624bbf40090fdb9477","locationContextEnabled":true,"webStorageEnabled":true,"browserName":"chrome","takesScreenshot":true,"javascriptEnabled":true,"cssSelectorsEnabled":true,"unexpectedAlertBehaviour":""},"class":"org.openqa.selenium.remote.Response","status":0}
'''

browserstack_mock_post2_reponse = '''
{"state":"success","sessionId":"6b04a40d32157861f90f4b624bbf40090fdb9477","hCode":6531147,"value":null,"class":"org.openqa.selenium.remote.Response","status":0}
''' 

browserstack_mock_delete_reponse = '''
{"state":"success", "status": 0}
'''

stub_request(:post, /hub-cloud.browserstack.com\/wd\/hub\/session$/).to_return(body: browserstack_mock_post1_reponse, headers: { 'Content-Type' => 'application/json' })
stub_request(:post, /hub-cloud.browserstack.com\/wd\/hub\/session\/(.+)\/url$/).to_return(body: browserstack_mock_post2_reponse, headers: { 'Content-Type' => 'application/json' })
stub_request(:delete, /hub-cloud.browserstack.com\/wd\/hub\/session\/(.+)$/).to_return(body: browserstack_mock_delete_reponse, headers: { 'Content-Type' => 'application/json' })
