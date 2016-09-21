# dc_elk
Analyze data collection logs via ELK docker

# usage
1. Extract logs. For example
   mkdir logs
   cd logs
   tar xf /xxx/dc.tar
   cd dc
   tar xzf spa.service_dc.tgz
   tar xzf spb.service_dc.tgz

2. Import logs (1.4GB logs requires 35-min)
   ./start.sh

3. Analyze logs in web browser
   http://host_ip:5601/

4. Cleanup
   ./shutdown.sh

