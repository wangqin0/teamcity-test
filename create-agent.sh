docker run -e SERVER_URL=""  \ 
    -v ./conf:/data/teamcity_agent/conf  \      
    teamcity-agent-cpp
