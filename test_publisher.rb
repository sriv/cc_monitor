require 'webrick'

class Simple < WEBrick::HTTPServlet::AbstractServlet
  
  RESPONSE_TYPES = {0 => :building, 1 => :sleeping, 2 => :checking_modifications}
  BUILD_STATUS = {0 => "Success", 1 => "Failure", 2 => "Failure"}
  def do_GET(request, response)
    status, content_type, body = do_stuff_with(request)
    
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end
  
  def do_stuff_with(request)
    random_number = rand(2)
    random_response = RESPONSE_TYPES[random_number]
    status_code = BUILD_STATUS[random_number]
    xml_response = self.send(random_response, status_code)
    puts xml_response
    return 200, "text/xml", xml_response
  end
  
  def building(last_build_status)
    building = <<XML
    <Projects>
    <Project name="test project" activity="Building" 
    lastBuildStatus="#{last_build_status}" lastBuildLabel="#{rand(100)}" lastBuildTime="unknown" webUrl="http://www.com"/>
    </Projects>
XML
  end

  def sleeping(last_build_status)
    building = <<XML
    <Projects>
    <Project name="test project" activity="Sleeping" 
    lastBuildStatus="#{last_build_status}" lastBuildLabel="#{rand(100)}" lastBuildTime="unknown" webUrl="http://www.com"/>
    </Projects>
XML
  end
  
  def checking_modifications(last_build_status)
    building = <<XML
    <Projects>
    <Project name="test project" activity="Checking Modifications" 
    lastBuildStatus="#{last_build_status}" lastBuildLabel="#{rand(100)}" lastBuildTime="unknown" webUrl="http://www.com"/>
    </Projects>
XML
  end
end

server = WEBrick::HTTPServer.new(:Port => 3000)
server.mount "/simple", Simple
trap("INT"){ server.shutdown }

server.start