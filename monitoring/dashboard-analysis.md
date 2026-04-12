Step 1 → Check "Heap Usage %" 
         Above 85%? → GC is pausing threads → increase -Xmx

Step 2 → Check "GC Pause Time Rate"
         Spike at same time as slow tiles? → GC is the culprit

Step 3 → Check "Thread States — WAITING"
         High WAITING count? → MinIO is responding slowly
         → check MinIO health and network between containers

Step 4 → Check "Tomcat Busy Threads" (after fix)
         Busy = Max? → Thread pool exhausted
         → increase Tomcat maxThreads in server.xml

Step 5 → Check "CPU Usage %"
         Near 100%? → GeoServer is CPU-bound rendering tiles
         → scale up container CPU or reduce concurrent users

Step 6 → Check "Buffer Pool mapped"

        Step 1 → Check "Heap Usage %"  
                 Above 85%? → GC is pausing threads → increase -Xmx  

        Step 2 → Check "GC Pause Time Rate"  
                 Spike at same time as slow tiles? → GC is the culprit  

        Step 3 → Check "Thread States — WAITING"  
                 High WAITING count? → MinIO is responding slowly  
                 → check MinIO health and network between containers  

        Step 4 → Check "Tomcat Busy Threads" (after fix)  
                 Busy = Max? → Thread pool exhausted  
                 → increase Tomcat maxThreads in server.xml  

        Step 5 → Check "CPU Usage %"  
                 Near 100%? → GeoServer is CPU-bound rendering tiles  
                 → scale up container CPU or reduce concurrent users  

        Step 6 → Check "Buffer Pool mapped"  
                 Growing over days without dropping? → COG buffer leak  
                 → restart GeoServer and report to imageio-ext
